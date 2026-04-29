"""Public endpoints — no authentication required.

These endpoints allow unauthenticated viewers to see live match scores
via a shareable link.
"""

from typing import List, Optional

import structlog
from app.database import get_async_db
from app.models.ball import Ball
from app.models.innings import Innings
from app.models.match import Match
from app.models.players_in_match import PlayersInMatch
from app.services.redis_service import redis_service
from fastapi import APIRouter, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload
from fastapi import Depends

logger = structlog.get_logger()
router = APIRouter()


@router.get("/live/{match_id}")
async def get_live_score(
    match_id: str,
    db: AsyncSession = Depends(get_async_db),
):
    """Get live match score — no authentication required.

    This is the endpoint that powers shareable live score links.
    First checks Redis cache, then falls back to DB.
    """
    # Try Redis cache first
    cached = await redis_service.get_match_state(match_id)
    if cached:
        cached["source"] = "cache"
        return cached

    # Fall back to DB
    result = await db.execute(
        select(Match)
        .options(selectinload(Match.innings), selectinload(Match.players))
        .where(Match.id == match_id)
    )
    match = result.scalars().first()

    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    if match.status in ("created", "invited", "declined", "cancelled"):
        raise HTTPException(
            status_code=404, detail="Match is not available for viewing"
        )

    # Build innings data
    innings_data = []
    for inn in sorted(match.innings, key=lambda i: i.created_at):
        innings_data.append(
            {
                "id": inn.id,
                "batting_team": inn.batting_team,
                "runs": inn.runs,
                "wickets": inn.wickets,
                "overs": float(inn.overs_bowled),
                "overs_allocated": inn.overs_allocated,
                "is_completed": inn.is_completed,
                "run_rate": (
                    round(inn.runs / inn.overs_bowled, 2)
                    if inn.overs_bowled and inn.overs_bowled > 0
                    else 0
                ),
            }
        )

    # Build team rosters (names only, no user IDs for privacy)
    team_a_players = []
    team_b_players = []
    for p in match.players:
        name = (
            p.guest_name if p.is_guest else (p.user.full_name if p.user else "Unknown")
        )
        entry = {"role": p.role, "name": name}
        if p.team == "A":
            team_a_players.append(entry)
        else:
            team_b_players.append(entry)

    # Calculate target if 2nd innings
    target = None
    if len(innings_data) >= 2 and not innings_data[0].get("is_completed", True):
        pass  # first innings still going
    elif len(innings_data) >= 2:
        target = innings_data[0]["runs"] + 1

    response = {
        "match_id": match.id,
        "match_type": match.match_type,
        "status": match.status,
        "team_a_name": match.team_a_name,
        "team_b_name": match.team_b_name,
        "venue": match.venue,
        "toss_winner": match.toss_winner,
        "toss_decision": match.toss_decision,
        "result": match.result,
        "innings": innings_data,
        "target": target,
        "team_a": team_a_players,
        "team_b": team_b_players,
        "started_at": match.started_at.isoformat() if match.started_at else None,
        "source": "database",
    }

    # Cache for next request
    await redis_service.cache_match_state(match_id, response)

    return response


@router.get("/live/{match_id}/balls")
async def get_live_balls(
    match_id: str,
    innings_number: int = Query(1, ge=1, le=2),
    db: AsyncSession = Depends(get_async_db),
):
    """Get ball-by-ball data for a live match — no auth required.

    Returns last 30 balls by default (most recent first).
    """
    # Verify match exists and is viewable
    match_result = await db.execute(select(Match).where(Match.id == match_id))
    match = match_result.scalars().first()

    if not match:
        raise HTTPException(status_code=404, detail="Match not found")

    if match.status in ("created", "invited", "declined", "cancelled"):
        raise HTTPException(
            status_code=404, detail="Match is not available for viewing"
        )

    # Get the requested innings
    innings_result = await db.execute(
        select(Innings).where(Innings.match_id == match_id).order_by(Innings.created_at)
    )
    all_innings = innings_result.scalars().all()

    if innings_number > len(all_innings):
        raise HTTPException(status_code=404, detail="Innings not found")

    target_innings = all_innings[innings_number - 1]

    # Get balls
    balls_result = await db.execute(
        select(Ball)
        .where(Ball.innings_id == target_innings.id)
        .order_by(Ball.created_at.desc())
        .limit(30)
    )
    balls = balls_result.scalars().all()

    return {
        "match_id": match_id,
        "innings_id": target_innings.id,
        "innings_number": innings_number,
        "batting_team": target_innings.batting_team,
        "balls": [
            {
                "over_number": b.over_number,
                "ball_in_over": b.ball_in_over,
                "runs_off_bat": b.runs_off_bat,
                "extras_type": b.extras_type,
                "extras_runs": b.extras_runs,
                "total_runs": b.total_runs,
                "wicket_type": b.wicket_type,
                "is_legal": b.is_legal_delivery,
            }
            for b in reversed(balls)  # chronological order
        ],
    }
