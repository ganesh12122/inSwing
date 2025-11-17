from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_, and_
from typing import List, Optional
from datetime import datetime
import structlog

from app.database import get_db
from app.dependencies import get_current_user, require_host_role, get_optional_current_user
from app.models.user import User
from app.models.match import Match
from app.models.players_in_match import PlayersInMatch
from app.models.profile import Profile
from app.schemas import (
    MatchCreate,
    MatchResponse,
    MatchUpdate,
    TossUpdate,
    MatchListResponse,
    MatchStatus,
    MatchType
)

logger = structlog.get_logger()
router = APIRouter()


@router.post("/", response_model=MatchResponse)
async def create_match(
    match_data: MatchCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role)
):
    """Create a new cricket match."""
    # Create match
    match = Match(
        host_user_id=current_user.id,
        match_type=match_data.match_type,
        team_a_name=match_data.team_a_name,
        team_b_name=match_data.team_b_name,
        venue=match_data.venue,
        latitude=match_data.latitude,
        longitude=match_data.longitude,
        scheduled_at=match_data.scheduled_at,
        status=MatchStatus.created,
        rules=match_data.rules.dict()
    )
    
    db.add(match)
    db.commit()
    db.refresh(match)
    
    # Add host as player in team A by default
    host_player = PlayersInMatch(
        match_id=match.id,
        user_id=current_user.id,
        team="A",
        role="allrounder"
    )
    db.add(host_player)
    db.commit()
    
    logger.info("Match created successfully", 
                match_id=match.id, 
                host_id=current_user.id,
                teams=f"{match.team_a_name} vs {match.team_b_name}")
    
    return match


@router.get("/", response_model=MatchListResponse)
async def list_matches(
    status: Optional[MatchStatus] = Query(None),
    match_type: Optional[MatchType] = Query(None),
    user_id: Optional[str] = Query(None),
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_current_user)
):
    """List matches with optional filtering."""
    query = db.query(Match)
    
    # Apply filters
    if status:
        query = query.filter(Match.status == status)
    
    if match_type:
        query = query.filter(Match.match_type == match_type)
    
    if user_id:
        # Filter matches where user is participating
        user_matches = db.query(PlayersInMatch.match_id).filter(
            PlayersInMatch.user_id == user_id
        ).subquery()
        query = query.filter(Match.id.in_(user_matches))
    
    # Order by creation date (newest first)
    query = query.order_by(Match.created_at.desc())
    
    # Pagination
    total = query.count()
    matches = query.offset((page - 1) * per_page).limit(per_page).all()
    
    logger.info("Matches listed", 
                status=status, 
                match_type=match_type,
                user_id=user_id,
                page=page,
                per_page=per_page,
                total=total,
                current_user_id=current_user.id if current_user else None)
    
    return MatchListResponse(
        matches=matches,
        total=total,
        page=page,
        per_page=per_page
    )


@router.get("/{match_id}", response_model=MatchResponse)
async def get_match(
    match_id: str,
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_current_user)
):
    """Get match details by ID."""
    match = db.query(Match).filter(Match.id == match_id).first()
    
    if not match:
        logger.warning("Match not found", match_id=match_id, user_id=current_user.id if current_user else None)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Match not found"
        )
    
    logger.info("Match retrieved", match_id=match_id, user_id=current_user.id if current_user else None)
    
    return match


@router.put("/{match_id}/toss", response_model=MatchResponse)
async def record_toss(
    match_id: str,
    toss_data: TossUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role)
):
    """Record toss result for a match."""
    match = db.query(Match).filter(Match.id == match_id).first()
    
    if not match:
        logger.warning("Match not found for toss", match_id=match_id, user_id=current_user.id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Match not found"
        )
    
    # Check if user is the host
    if match.host_user_id != current_user.id:
        logger.warning("Unauthorized toss update", 
                      match_id=match_id, 
                      user_id=current_user.id,
                      host_id=match.host_user_id)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the match host can record the toss"
        )
    
    # Update toss information
    match.toss_winner = toss_data.toss_winner
    match.toss_decision = toss_data.toss_decision
    match.status = MatchStatus.toss_done
    
    db.commit()
    db.refresh(match)
    
    logger.info("Toss recorded", 
                match_id=match_id, 
                winner=toss_data.toss_winner,
                decision=toss_data.toss_decision,
                user_id=current_user.id)
    
    return match


@router.put("/{match_id}/status", response_model=MatchResponse)
async def update_match_status(
    match_id: str,
    status: MatchStatus,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role)
):
    """Update match status."""
    match = db.query(Match).filter(Match.id == match_id).first()
    
    if not match:
        logger.warning("Match not found for status update", match_id=match_id, user_id=current_user.id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Match not found"
        )
    
    # Check if user is the host
    if match.host_user_id != current_user.id:
        logger.warning("Unauthorized status update", 
                      match_id=match_id, 
                      user_id=current_user.id,
                      host_id=match.host_user_id)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the match host can update status"
        )
    
    # Update timestamps based on status
    if status == MatchStatus.live and match.status != MatchStatus.live:
        match.started_at = datetime.utcnow()
    elif status == MatchStatus.finished and match.status != MatchStatus.finished:
        match.finished_at = datetime.utcnow()
    
    match.status = status
    
    db.commit()
    db.refresh(match)
    
    logger.info("Match status updated", 
                match_id=match_id, 
                new_status=status,
                user_id=current_user.id)
    
    return match


@router.delete("/{match_id}", response_model=dict)
async def cancel_match(
    match_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role)
):
    """Cancel a match."""
    match = db.query(Match).filter(Match.id == match_id).first()
    
    if not match:
        logger.warning("Match not found for cancellation", match_id=match_id, user_id=current_user.id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Match not found"
        )
    
    # Check if user is the host
    if match.host_user_id != current_user.id:
        logger.warning("Unauthorized match cancellation", 
                      match_id=match_id, 
                      user_id=current_user.id,
                      host_id=match.host_user_id)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the match host can cancel the match"
        )
    
    # Check if match can be cancelled
    if match.status in [MatchStatus.finished]:
        logger.warning("Cannot cancel finished match", match_id=match_id, user_id=current_user.id)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot cancel a finished match"
        )
    
    match.status = MatchStatus.cancelled
    
    db.commit()
    
    logger.info("Match cancelled", match_id=match_id, user_id=current_user.id)
    
    return {"message": "Match cancelled successfully"}


@router.post("/{match_id}/players", response_model=dict)
async def add_player_to_match(
    match_id: str,
    player_data: dict,  # {user_id: str, team: str, role: str}
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role)
):
    """Add a player to a match."""
    match = db.query(Match).filter(Match.id == match_id).first()
    
    if not match:
        logger.warning("Match not found for player addition", match_id=match_id, user_id=current_user.id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Match not found"
        )
    
    # Check if user is the host
    if match.host_user_id != current_user.id:
        logger.warning("Unauthorized player addition", 
                      match_id=match_id, 
                      user_id=current_user.id,
                      host_id=match.host_user_id)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the match host can add players"
        )
    
    # Validate player data
    user_id = player_data.get("user_id")
    team = player_data.get("team")
    role = player_data.get("role", "batsman")
    
    if not user_id or team not in ["A", "B"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid player data"
        )
    
    # Check if user exists
    player_user = db.query(User).filter(User.id == user_id).first()
    if not player_user:
        logger.warning("Player user not found", user_id=user_id, match_id=match_id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Player user not found"
        )
    
    # Check if player is already in match
    existing_player = db.query(PlayersInMatch).filter(
        PlayersInMatch.match_id == match_id,
        PlayersInMatch.user_id == user_id
    ).first()
    
    if existing_player:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Player is already in this match"
        )
    
    # Add player to match
    player_in_match = PlayersInMatch(
        match_id=match_id,
        user_id=user_id,
        team=team,
        role=role
    )
    
    db.add(player_in_match)
    db.commit()
    
    logger.info("Player added to match", 
                match_id=match_id, 
                user_id=user_id,
                team=team,
                role=role,
                host_id=current_user.id)
    
    return {"message": "Player added successfully"}


@router.delete("/{match_id}/players/{player_id}", response_model=dict)
async def remove_player_from_match(
    match_id: str,
    player_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role)
):
    """Remove a player from a match."""
    match = db.query(Match).filter(Match.id == match_id).first()
    
    if not match:
        logger.warning("Match not found for player removal", match_id=match_id, user_id=current_user.id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Match not found"
        )
    
    # Check if user is the host
    if match.host_user_id != current_user.id:
        logger.warning("Unauthorized player removal", 
                      match_id=match_id, 
                      user_id=current_user.id,
                      host_id=match.host_user_id)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the match host can remove players"
        )
    
    # Find player in match
    player_in_match = db.query(PlayersInMatch).filter(
        PlayersInMatch.match_id == match_id,
        PlayersInMatch.user_id == player_id
    ).first()
    
    if not player_in_match:
        logger.warning("Player not found in match", user_id=player_id, match_id=match_id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Player not found in this match"
        )
    
    # Remove player
    db.delete(player_in_match)
    db.commit()
    
    logger.info("Player removed from match", 
                match_id=match_id, 
                user_id=player_id,
                host_id=current_user.id)
    
    return {"message": "Player removed successfully"}