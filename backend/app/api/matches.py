from datetime import datetime
from typing import Optional

import structlog
from app.database import get_db
from app.dependencies import (
    get_current_user,
    get_optional_current_user,
    require_host_role,
)
from app.models.match import Match
from app.models.notification import Notification
from app.models.players_in_match import PlayersInMatch
from app.models.user import User
from app.schemas import (
    MatchCreate,
    MatchListResponse,
    MatchResponse,
    MatchStatus,
    MatchType,
    TossUpdate,
)
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import or_
from sqlalchemy.orm import Session

logger = structlog.get_logger()
router = APIRouter()


# ============================================================================
# MATCH CREATION
# ============================================================================


@router.post("/", response_model=MatchResponse)
async def create_match(
    match_data: MatchCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role),
):
    """Create a new cricket match.

    - Quick/Friendly: Both team names required, host manages everything.
    - Dual Captain: Only team_a_name required, invitation flow starts.
    """
    match = Match(
        host_user_id=current_user.id,
        match_type=match_data.match_type.value,
        team_a_name=match_data.team_a_name,
        team_b_name=match_data.team_b_name,
        venue=match_data.venue,
        latitude=match_data.latitude,
        longitude=match_data.longitude,
        scheduled_at=match_data.scheduled_at,
        status="created",
        rules=match_data.rules.model_dump(),
        min_players_per_team=match_data.rules.min_players_per_team,
    )

    db.add(match)
    db.commit()
    db.refresh(match)

    # Add host as captain in team A
    host_player = PlayersInMatch(
        match_id=match.id,
        user_id=current_user.id,
        team="A",
        role="captain",
        is_guest=False,
        added_by=current_user.id,
    )
    db.add(host_player)
    db.commit()

    logger.info(
        "Match created",
        match_id=match.id,
        match_type=match.match_type,
        host_id=current_user.id,
        team_a=match.team_a_name,
    )

    return MatchResponse.from_match(match)


# ============================================================================
# MATCH LISTING & RETRIEVAL
# ============================================================================


@router.get("/", response_model=MatchListResponse)
async def list_matches(
    status: Optional[MatchStatus] = Query(None),
    match_type: Optional[MatchType] = Query(None),
    user_id: Optional[str] = Query(None),
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_current_user),
):
    """List matches with optional filtering."""
    query = db.query(Match)

    if status:
        query = query.filter(Match.status == status.value)

    if match_type:
        query = query.filter(Match.match_type == match_type.value)

    if user_id:
        # Filter matches where user is host, opponent, or player
        user_match_ids = (
            db.query(PlayersInMatch.match_id)
            .filter(PlayersInMatch.user_id == user_id)
            .subquery()
        )
        query = query.filter(
            or_(
                Match.id.in_(user_match_ids),
                Match.host_user_id == user_id,
                Match.opponent_captain_id == user_id,
            )
        )

    query = query.order_by(Match.created_at.desc())

    total = query.count()
    matches = query.offset((page - 1) * per_page).limit(per_page).all()

    logger.info(
        "Matches listed",
        total=total,
        page=page,
        current_user_id=current_user.id if current_user else None,
    )

    return MatchListResponse(
        matches=[MatchResponse.from_match(m) for m in matches],
        total=total,
        page=page,
        per_page=per_page,
    )


@router.get("/my", response_model=MatchListResponse)
async def my_matches(
    status: Optional[MatchStatus] = Query(None),
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get all matches where current user is host, opponent captain, or player."""
    user_match_ids = (
        db.query(PlayersInMatch.match_id)
        .filter(PlayersInMatch.user_id == current_user.id)
        .subquery()
    )
    query = db.query(Match).filter(
        or_(
            Match.id.in_(user_match_ids),
            Match.host_user_id == current_user.id,
            Match.opponent_captain_id == current_user.id,
        )
    )

    if status:
        query = query.filter(Match.status == status.value)

    query = query.order_by(Match.created_at.desc())

    total = query.count()
    matches = query.offset((page - 1) * per_page).limit(per_page).all()

    return MatchListResponse(
        matches=[MatchResponse.from_match(m) for m in matches],
        total=total,
        page=page,
        per_page=per_page,
    )


@router.get("/{match_id}", response_model=MatchResponse)
async def get_match(
    match_id: str,
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_current_user),
):
    """Get match details by ID."""
    match = db.query(Match).filter(Match.id == match_id).first()

    if not match:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Match not found",
        )

    return MatchResponse.from_match(match)


# ============================================================================
# INVITATION FLOW (Dual Captain)
# ============================================================================


@router.post("/{match_id}/invite", response_model=MatchResponse)
async def invite_opponent(
    match_id: str,
    invite_data: dict,  # {opponent_user_id: str, message?: str}
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Invite an opponent captain to a dual-captain match.

    Body: {"opponent_user_id": "uuid", "message": "optional message"}
    """
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    if match.host_user_id != current_user.id:
        raise HTTPException(
            status_code=403, detail="Only the host can send invitations"
        )

    if match.match_type != "dual_captain":
        raise HTTPException(
            status_code=400, detail="Invitations are only for dual_captain matches"
        )

    if match.status != "created":
        raise HTTPException(
            status_code=400, detail=f"Cannot invite in '{match.status}' status"
        )

    opponent_id = invite_data.get("opponent_user_id")
    if not opponent_id:
        raise HTTPException(status_code=400, detail="opponent_user_id is required")

    if opponent_id == current_user.id:
        raise HTTPException(status_code=400, detail="You cannot invite yourself")

    # Check opponent exists
    opponent = db.query(User).filter(User.id == opponent_id).first()
    if not opponent:
        raise HTTPException(status_code=404, detail="Opponent user not found")

    # Update match
    match.opponent_captain_id = opponent_id
    match.invitation_message = invite_data.get("message")
    match.invited_at = datetime.utcnow()
    match.status = "invited"

    # Create notification for opponent
    notification = Notification(
        user_id=opponent_id,
        title="Match Invitation",
        message=f"{current_user.full_name} invited you to a match — {match.team_a_name} vs ?",
        type="match_invitation",
        data={
            "match_id": match.id,
            "host_name": current_user.full_name,
            "team_a_name": match.team_a_name,
        },
        priority="high",
    )
    db.add(notification)

    db.commit()
    db.refresh(match)

    logger.info(
        "Match invitation sent",
        match_id=match.id,
        host_id=current_user.id,
        opponent_id=opponent_id,
    )

    return MatchResponse.from_match(match)


@router.post("/{match_id}/accept", response_model=MatchResponse)
async def accept_invitation(
    match_id: str,
    accept_data: dict,  # {team_b_name: str}
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Accept a match invitation and set team B name.

    Body: {"team_b_name": "Team Name"}
    """
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    if match.opponent_captain_id != current_user.id:
        raise HTTPException(status_code=403, detail="You are not the invited opponent")

    if match.status != "invited":
        raise HTTPException(
            status_code=400, detail=f"Cannot accept in '{match.status}' status"
        )

    team_b_name = accept_data.get("team_b_name")
    if not team_b_name or len(team_b_name.strip()) == 0:
        raise HTTPException(status_code=400, detail="team_b_name is required")

    # Update match
    match.team_b_name = team_b_name.strip()
    match.accepted_at = datetime.utcnow()
    match.status = "accepted"

    # Add opponent as captain in team B
    opponent_player = PlayersInMatch(
        match_id=match.id,
        user_id=current_user.id,
        team="B",
        role="captain",
        is_guest=False,
        added_by=current_user.id,
    )
    db.add(opponent_player)

    # Notify host
    notification = Notification(
        user_id=match.host_user_id,
        title="Invitation Accepted!",
        message=f"{current_user.full_name} accepted your match invitation with team '{team_b_name}'",
        type="match_update",
        data={
            "match_id": match.id,
            "opponent_name": current_user.full_name,
            "team_b_name": team_b_name,
        },
        priority="high",
    )
    db.add(notification)

    db.commit()
    db.refresh(match)

    logger.info(
        "Match invitation accepted",
        match_id=match.id,
        opponent_id=current_user.id,
        team_b_name=team_b_name,
    )

    return MatchResponse.from_match(match)


@router.post("/{match_id}/decline", response_model=dict)
async def decline_invitation(
    match_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Decline a match invitation."""
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    if match.opponent_captain_id != current_user.id:
        raise HTTPException(status_code=403, detail="You are not the invited opponent")

    if match.status != "invited":
        raise HTTPException(
            status_code=400, detail=f"Cannot decline in '{match.status}' status"
        )

    match.status = "declined"
    match.declined_at = datetime.utcnow()

    # Notify host
    notification = Notification(
        user_id=match.host_user_id,
        title="Invitation Declined",
        message=f"{current_user.full_name} declined your match invitation",
        type="match_update",
        data={"match_id": match.id, "opponent_name": current_user.full_name},
        priority="medium",
    )
    db.add(notification)

    db.commit()

    logger.info(
        "Match invitation declined", match_id=match.id, opponent_id=current_user.id
    )

    return {"message": "Invitation declined"}


# ============================================================================
# TEAM MANAGEMENT
# ============================================================================


@router.post("/{match_id}/team/players", response_model=dict)
async def add_player_to_team(
    match_id: str,
    player_data: dict,  # {user_id?: str, guest_name?: str, role?: str}
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Add a player to the captain's own team.

    Body: {"user_id": "uuid"} for app users OR {"guest_name": "Player Name"} for guests.
    Optional: {"role": "batsman|bowler|allrounder|wicketkeeper"}
    """
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    # Determine which team this captain manages
    team = _get_captain_team(match, current_user.id)
    if team is None:
        raise HTTPException(
            status_code=403, detail="You are not a captain in this match"
        )

    # Check match is in a state that allows adding players
    allowed_statuses = [
        "created",
        "accepted",
        "teams_ready",
        "rules_proposed",
        "rules_approved",
    ]
    if match.status not in allowed_statuses:
        raise HTTPException(
            status_code=400,
            detail=f"Cannot add players in '{match.status}' status",
        )

    user_id = player_data.get("user_id")
    guest_name = player_data.get("guest_name")
    role = player_data.get("role", "batsman")

    if not user_id and not guest_name:
        raise HTTPException(
            status_code=400, detail="Provide either user_id or guest_name"
        )

    # Check max players
    current_team_count = (
        db.query(PlayersInMatch)
        .filter(PlayersInMatch.match_id == match_id, PlayersInMatch.team == team)
        .count()
    )
    max_players = (match.rules or {}).get("max_players_per_team", 11)
    if current_team_count >= max_players:
        raise HTTPException(
            status_code=400,
            detail=f"Team already has {current_team_count}/{max_players} players",
        )

    is_guest = guest_name is not None

    if user_id:
        # Check user exists
        player_user = db.query(User).filter(User.id == user_id).first()
        if not player_user:
            raise HTTPException(status_code=404, detail="Player user not found")

        # Check if already in match
        existing = (
            db.query(PlayersInMatch)
            .filter(
                PlayersInMatch.match_id == match_id, PlayersInMatch.user_id == user_id
            )
            .first()
        )
        if existing:
            raise HTTPException(
                status_code=400, detail="Player is already in this match"
            )

    # Add player
    player_in_match = PlayersInMatch(
        match_id=match_id,
        user_id=user_id if not is_guest else None,
        team=team,
        role=role,
        is_guest=is_guest,
        guest_name=guest_name,
        added_by=current_user.id,
    )
    db.add(player_in_match)

    # Reset team readiness when roster changes
    if team == "A":
        match.host_team_ready = False
    else:
        match.opponent_team_ready = False

    db.commit()

    logger.info(
        "Player added to team",
        match_id=match_id,
        team=team,
        user_id=user_id,
        guest_name=guest_name,
        is_guest=is_guest,
        added_by=current_user.id,
    )

    return {"message": "Player added successfully", "team": team}


@router.delete("/{match_id}/team/players/{player_id}", response_model=dict)
async def remove_player_from_team(
    match_id: str,
    player_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Remove a player from the captain's own team.

    player_id is the PlayersInMatch record ID (not the user ID).
    """
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    team = _get_captain_team(match, current_user.id)
    if team is None:
        raise HTTPException(
            status_code=403, detail="You are not a captain in this match"
        )

    player_in_match = (
        db.query(PlayersInMatch)
        .filter(PlayersInMatch.id == player_id, PlayersInMatch.match_id == match_id)
        .first()
    )
    if not player_in_match:
        raise HTTPException(status_code=404, detail="Player not found in this match")

    if player_in_match.team != team:
        raise HTTPException(
            status_code=403, detail="You can only remove players from your own team"
        )

    # Cannot remove yourself (captain)
    if player_in_match.role == "captain":
        raise HTTPException(
            status_code=400, detail="Cannot remove the captain from the team"
        )

    db.delete(player_in_match)

    # Reset team readiness
    if team == "A":
        match.host_team_ready = False
    else:
        match.opponent_team_ready = False

    db.commit()

    logger.info(
        "Player removed from team",
        match_id=match_id,
        player_record_id=player_id,
        removed_by=current_user.id,
    )

    return {"message": "Player removed successfully"}


@router.put("/{match_id}/team/ready", response_model=MatchResponse)
async def mark_team_ready(
    match_id: str,
    ready_data: dict = None,  # {ready: bool}
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Mark a captain's team as ready (or unready).

    Body: {"ready": true} (defaults to true if omitted)
    """
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    team = _get_captain_team(match, current_user.id)
    if team is None:
        raise HTTPException(
            status_code=403, detail="You are not a captain in this match"
        )

    is_ready = (ready_data or {}).get("ready", True)

    # Check minimum players
    team_count = (
        db.query(PlayersInMatch)
        .filter(PlayersInMatch.match_id == match_id, PlayersInMatch.team == team)
        .count()
    )
    if is_ready and team_count < match.min_players_per_team:
        raise HTTPException(
            status_code=400,
            detail=f"Need at least {match.min_players_per_team} players (have {team_count})",
        )

    if team == "A":
        match.host_team_ready = is_ready
    else:
        match.opponent_team_ready = is_ready

    # Auto-transition to teams_ready if both are ready
    if match.host_team_ready and match.opponent_team_ready:
        if match.status in ("accepted", "teams_ready"):
            match.status = "teams_ready"
    elif match.status == "teams_ready":
        # One team became unready
        match.status = "accepted"

    db.commit()
    db.refresh(match)

    logger.info(
        "Team readiness updated",
        match_id=match_id,
        team=team,
        ready=is_ready,
        both_ready=match.host_team_ready and match.opponent_team_ready,
    )

    return MatchResponse.from_match(match)


@router.get("/{match_id}/teams", response_model=dict)
async def get_teams(
    match_id: str,
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_current_user),
):
    """Get both teams' player lists for a match."""
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    players = db.query(PlayersInMatch).filter(PlayersInMatch.match_id == match_id).all()

    team_a = []
    team_b = []

    for p in players:
        player_data = {
            "id": p.id,
            "user_id": p.user_id,
            "team": p.team,
            "role": p.role,
            "is_guest": p.is_guest,
            "guest_name": p.guest_name,
            "display_name": (
                p.guest_name
                if p.is_guest
                else (p.user.full_name if p.user else "Unknown")
            ),
            "added_by": p.added_by,
            "joined_at": p.joined_at.isoformat() if p.joined_at else None,
        }
        if p.team == "A":
            team_a.append(player_data)
        else:
            team_b.append(player_data)

    return {
        "team_a": {
            "name": match.team_a_name,
            "players": team_a,
            "count": len(team_a),
            "ready": match.host_team_ready,
        },
        "team_b": {
            "name": match.team_b_name,
            "players": team_b,
            "count": len(team_b),
            "ready": match.opponent_team_ready,
        },
        "min_players": match.min_players_per_team,
    }


# ============================================================================
# RULES NEGOTIATION
# ============================================================================


@router.post("/{match_id}/rules/propose", response_model=MatchResponse)
async def propose_rules(
    match_id: str,
    rules_data: dict,  # {rules: {...}}
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Propose rules for the match. Other captain must approve or counter.

    Body: {"rules": {overs_limit, powerplay_overs, ...}}
    """
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    if not match.is_captain(current_user.id):
        raise HTTPException(status_code=403, detail="Only captains can propose rules")

    allowed_statuses = ["accepted", "teams_ready", "rules_proposed"]
    if match.status not in allowed_statuses:
        raise HTTPException(
            status_code=400,
            detail=f"Cannot propose rules in '{match.status}' status",
        )

    rules = rules_data.get("rules")
    if not rules:
        raise HTTPException(status_code=400, detail="rules object is required")

    match.proposed_rules = rules
    match.rules_proposed_by = current_user.id
    match.status = "rules_proposed"

    # Proposer auto-approves their own proposal
    if current_user.id == match.host_user_id:
        match.host_rules_approved = True
        match.opponent_rules_approved = False
    else:
        match.opponent_rules_approved = True
        match.host_rules_approved = False

    # Notify the other captain
    other_captain_id = (
        match.opponent_captain_id
        if current_user.id == match.host_user_id
        else match.host_user_id
    )
    if other_captain_id:
        notification = Notification(
            user_id=other_captain_id,
            title="Rules Proposed",
            message=f"{current_user.full_name} proposed match rules — review and approve",
            type="match_update",
            data={"match_id": match.id, "proposed_rules": rules},
            priority="medium",
        )
        db.add(notification)

    db.commit()
    db.refresh(match)

    logger.info(
        "Rules proposed",
        match_id=match.id,
        proposed_by=current_user.id,
    )

    return MatchResponse.from_match(match)


@router.post("/{match_id}/rules/approve", response_model=MatchResponse)
async def approve_rules(
    match_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Approve the currently proposed rules."""
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    if not match.is_captain(current_user.id):
        raise HTTPException(status_code=403, detail="Only captains can approve rules")

    if match.status != "rules_proposed":
        raise HTTPException(status_code=400, detail="No rules proposal to approve")

    if match.rules_proposed_by == current_user.id:
        raise HTTPException(
            status_code=400, detail="You already approved (you proposed these rules)"
        )

    # Set approval
    if current_user.id == match.host_user_id:
        match.host_rules_approved = True
    else:
        match.opponent_rules_approved = True

    # Both approved → finalize rules
    if match.host_rules_approved and match.opponent_rules_approved:
        match.rules = match.proposed_rules  # Lock in the agreed rules
        match.status = "rules_approved"
        match.proposed_rules = None
        match.rules_proposed_by = None

        # Notify both captains
        for captain_id in [match.host_user_id, match.opponent_captain_id]:
            if captain_id:
                notification = Notification(
                    user_id=captain_id,
                    title="Rules Agreed! ✅",
                    message="Both captains have approved the match rules. Ready for toss!",
                    type="match_update",
                    data={"match_id": match.id},
                    priority="high",
                )
                db.add(notification)

    db.commit()
    db.refresh(match)

    logger.info(
        "Rules approved",
        match_id=match.id,
        approved_by=current_user.id,
        all_approved=match.rules_agreed,
    )

    return MatchResponse.from_match(match)


@router.post("/{match_id}/rules/counter", response_model=MatchResponse)
async def counter_rules(
    match_id: str,
    rules_data: dict,  # {rules: {...}}
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Counter-propose different rules. Same as propose but from the other captain."""
    # Counter-proposal is just a new proposal from the other captain
    return await propose_rules(match_id, rules_data, db, current_user)


@router.get("/{match_id}/rules", response_model=dict)
async def get_rules(
    match_id: str,
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_current_user),
):
    """Get current rules and approval status."""
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    return {
        "final_rules": match.rules,
        "proposed_rules": match.proposed_rules,
        "rules_proposed_by": match.rules_proposed_by,
        "host_rules_approved": match.host_rules_approved,
        "opponent_rules_approved": match.opponent_rules_approved,
        "rules_agreed": match.rules_agreed,
        "status": match.status,
    }


# ============================================================================
# TOSS & STATUS
# ============================================================================


@router.put("/{match_id}/toss", response_model=MatchResponse)
async def record_toss(
    match_id: str,
    toss_data: TossUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Record toss result for a match."""
    match = db.query(Match).filter(Match.id == match_id).first()

    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    # For dual captain: either captain can record toss after rules are approved
    if match.is_dual_captain:
        if not match.is_captain(current_user.id):
            raise HTTPException(
                status_code=403, detail="Only captains can record the toss"
            )
        if match.status not in ("rules_approved", "teams_ready"):
            raise HTTPException(
                status_code=400,
                detail=f"Cannot record toss in '{match.status}' status (rules must be approved first)",
            )
    else:
        # Quick match: only host
        if match.host_user_id != current_user.id:
            raise HTTPException(
                status_code=403, detail="Only the match host can record the toss"
            )

    match.toss_winner = toss_data.toss_winner
    match.toss_decision = toss_data.toss_decision.value
    match.status = "toss_done"

    db.commit()
    db.refresh(match)

    logger.info(
        "Toss recorded",
        match_id=match_id,
        winner=toss_data.toss_winner,
        decision=toss_data.toss_decision.value,
    )

    return MatchResponse.from_match(match)


@router.put("/{match_id}/status", response_model=MatchResponse)
async def update_match_status(
    match_id: str,
    new_status: MatchStatus,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Update match status (with validation)."""
    match = db.query(Match).filter(Match.id == match_id).first()

    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    # Permission check — captain or host
    if match.is_dual_captain:
        if not match.is_captain(current_user.id):
            raise HTTPException(
                status_code=403, detail="Only captains can update match status"
            )
    else:
        if match.host_user_id != current_user.id:
            raise HTTPException(
                status_code=403, detail="Only the match host can update status"
            )

    # Update timestamps based on status
    if new_status == MatchStatus.live and match.status != "live":
        match.started_at = datetime.utcnow()
    elif new_status == MatchStatus.finished and match.status != "finished":
        match.finished_at = datetime.utcnow()

    match.status = new_status.value

    db.commit()
    db.refresh(match)

    logger.info(
        "Match status updated",
        match_id=match_id,
        new_status=new_status.value,
        user_id=current_user.id,
    )

    return MatchResponse.from_match(match)


# ============================================================================
# CANCEL MATCH
# ============================================================================


@router.delete("/{match_id}", response_model=dict)
async def cancel_match(
    match_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Cancel a match. Either captain can cancel in dual_captain mode."""
    match = db.query(Match).filter(Match.id == match_id).first()

    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    # Permission check
    if match.is_dual_captain:
        if not match.is_captain(current_user.id):
            raise HTTPException(
                status_code=403, detail="Only captains can cancel the match"
            )
    else:
        if match.host_user_id != current_user.id:
            raise HTTPException(
                status_code=403, detail="Only the match host can cancel the match"
            )

    if match.status == "finished":
        raise HTTPException(status_code=400, detail="Cannot cancel a finished match")

    if match.status == "cancelled":
        raise HTTPException(status_code=400, detail="Match is already cancelled")

    match.status = "cancelled"

    # Notify the other captain
    if match.is_dual_captain:
        other_captain_id = (
            match.opponent_captain_id
            if current_user.id == match.host_user_id
            else match.host_user_id
        )
        if other_captain_id:
            notification = Notification(
                user_id=other_captain_id,
                title="Match Cancelled",
                message=f"{current_user.full_name} cancelled the match: {match.team_a_name} vs {match.team_b_name or '?'}",
                type="match_update",
                data={"match_id": match.id},
                priority="high",
            )
            db.add(notification)

    db.commit()

    logger.info("Match cancelled", match_id=match_id, user_id=current_user.id)

    return {"message": "Match cancelled successfully"}


# ============================================================================
# LEGACY ENDPOINTS (backward compatible — delegates to new team management)
# ============================================================================


@router.post("/{match_id}/players", response_model=dict)
async def add_player_to_match(
    match_id: str,
    player_data: dict,  # {user_id: str, team: str, role: str}
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role),
):
    """Add a player to a match (legacy endpoint for quick matches).

    For dual_captain matches, use POST /matches/{id}/team/players instead.
    """
    match = db.query(Match).filter(Match.id == match_id).first()

    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    if match.host_user_id != current_user.id:
        raise HTTPException(
            status_code=403, detail="Only the match host can add players"
        )

    user_id = player_data.get("user_id")
    team = player_data.get("team")
    role = player_data.get("role", "batsman")

    if not user_id or team not in ["A", "B"]:
        raise HTTPException(status_code=400, detail="Invalid player data")

    player_user = db.query(User).filter(User.id == user_id).first()
    if not player_user:
        raise HTTPException(status_code=404, detail="Player user not found")

    existing_player = (
        db.query(PlayersInMatch)
        .filter(PlayersInMatch.match_id == match_id, PlayersInMatch.user_id == user_id)
        .first()
    )
    if existing_player:
        raise HTTPException(status_code=400, detail="Player is already in this match")

    player_in_match = PlayersInMatch(
        match_id=match_id,
        user_id=user_id,
        team=team,
        role=role,
        is_guest=False,
        added_by=current_user.id,
    )

    db.add(player_in_match)
    db.commit()

    logger.info(
        "Player added to match (legacy)",
        match_id=match_id,
        user_id=user_id,
        team=team,
        role=role,
    )

    return {"message": "Player added successfully"}


@router.delete("/{match_id}/players/{player_id}", response_model=dict)
async def remove_player_from_match(
    match_id: str,
    player_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role),
):
    """Remove a player from a match (legacy endpoint)."""
    match = db.query(Match).filter(Match.id == match_id).first()

    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    if match.host_user_id != current_user.id:
        raise HTTPException(
            status_code=403, detail="Only the match host can remove players"
        )

    player_in_match = (
        db.query(PlayersInMatch)
        .filter(
            PlayersInMatch.match_id == match_id, PlayersInMatch.user_id == player_id
        )
        .first()
    )
    if not player_in_match:
        raise HTTPException(status_code=404, detail="Player not found in this match")

    db.delete(player_in_match)
    db.commit()

    logger.info(
        "Player removed from match (legacy)",
        match_id=match_id,
        user_id=player_id,
    )

    return {"message": "Player removed successfully"}


# ============================================================================
# HELPER FUNCTIONS
# ============================================================================


def _get_captain_team(match: Match, user_id: str) -> Optional[str]:
    """Determine which team a captain manages.

    Returns 'A' for host, 'B' for opponent, None if not a captain.
    For quick matches, host manages both teams (returns 'A').
    """
    if user_id == match.host_user_id:
        return "A"
    if user_id == match.opponent_captain_id:
        return "B"
    # For quick matches, host is the only captain
    if not match.is_dual_captain and user_id == match.host_user_id:
        return "A"
    return None
