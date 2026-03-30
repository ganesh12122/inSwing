from datetime import datetime
from typing import List, Optional

import structlog
from app.database import get_db
from app.dependencies import get_current_user, require_host_role
from app.models.ball import Ball
from app.models.innings import Innings
from app.models.match import Match
from app.models.players_in_match import PlayersInMatch
from app.models.user import User
from app.schemas import BallCreate, BallResponse, BallUpdate, InningsResponse
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import and_, or_  # noqa: F401 - may be used in query filters
from sqlalchemy.orm import Session

logger = structlog.get_logger()
router = APIRouter()


@router.post("/{match_id}/innings", response_model=InningsResponse)
async def create_innings(
    match_id: str,
    innings_data: dict,  # {batting_team: str, overs_allocated: int}
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role),
):
    """Create a new innings for a match."""
    match = db.query(Match).filter(Match.id == match_id).first()

    if not match:
        logger.warning(
            "Match not found for innings creation",
            match_id=match_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Match not found"
        )

    # Check if user is the host
    if match.host_user_id != current_user.id:
        logger.warning(
            "Unauthorized innings creation",
            match_id=match_id,
            user_id=current_user.id,
            host_id=match.host_user_id,
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the match host can create innings",
        )

    # Validate batting team
    batting_team = innings_data.get("batting_team")
    overs_allocated = innings_data.get("overs_allocated", 20)

    if batting_team not in ["A", "B"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid batting team. Must be 'A' or 'B'",
        )

    if overs_allocated < 1 or overs_allocated > 50:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Overs allocated must be between 1 and 50",
        )

    # Check if match is ready for innings
    if match.status not in ["toss_done", "live"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Match must have toss completed before creating innings",
        )

    # Create innings
    innings = Innings(
        match_id=match_id,
        batting_team=batting_team,
        overs_allocated=overs_allocated,
        runs=0,
        wickets=0,
        extras=0,
        overs_bowled=0.0,
        is_completed=False,
    )

    db.add(innings)
    db.commit()
    db.refresh(innings)

    # Update match status to live if this is the first innings
    if match.status == "toss_done":
        match.status = "live"
        match.started_at = datetime.utcnow()
        db.commit()

    logger.info(
        "Innings created successfully",
        innings_id=innings.id,
        match_id=match_id,
        batting_team=batting_team,
        user_id=current_user.id,
    )

    return innings


@router.get("/{match_id}/innings", response_model=List[InningsResponse])
async def get_innings(
    match_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get all innings for a match."""
    match = db.query(Match).filter(Match.id == match_id).first()

    if not match:
        logger.warning(
            "Match not found for innings retrieval",
            match_id=match_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Match not found"
        )

    innings = (
        db.query(Innings)
        .filter(Innings.match_id == match_id)
        .order_by(Innings.created_at)
        .all()
    )

    logger.info(
        "Innings retrieved",
        match_id=match_id,
        innings_count=len(innings),
        user_id=current_user.id,
    )

    return innings


@router.post("/{match_id}/innings/{innings_id}/ball", response_model=BallResponse)
async def record_ball(
    match_id: str,
    innings_id: str,
    ball_data: BallCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role),
):
    """Record a ball in the innings (idempotent with client_event_id)."""
    # Validate match and innings
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        logger.warning(
            "Match not found for ball recording",
            match_id=match_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Match not found"
        )

    innings = (
        db.query(Innings)
        .filter(Innings.id == innings_id, Innings.match_id == match_id)
        .first()
    )

    if not innings:
        logger.warning(
            "Innings not found for ball recording",
            innings_id=innings_id,
            match_id=match_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Innings not found"
        )

    # Check if user is the host
    if match.host_user_id != current_user.id:
        logger.warning(
            "Unauthorized ball recording",
            match_id=match_id,
            user_id=current_user.id,
            host_id=match.host_user_id,
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the match host can record balls",
        )

    # Check if innings is active
    if innings.is_completed:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot record balls in completed innings",
        )

    # Check for idempotency (client_event_id)
    if ball_data.client_event_id:
        existing_ball = (
            db.query(Ball)
            .filter(
                Ball.innings_id == innings_id,
                Ball.client_event_id == ball_data.client_event_id,
            )
            .first()
        )

        if existing_ball:
            logger.info(
                "Ball already recorded (idempotent)",
                client_event_id=ball_data.client_event_id,
                existing_ball_id=existing_ball.id,
            )
            return existing_ball

    # Validate players are in the match
    if ball_data.batsman_id:
        batsman_in_match = (
            db.query(PlayersInMatch)
            .filter(
                PlayersInMatch.match_id == match_id,
                PlayersInMatch.user_id == ball_data.batsman_id,
            )
            .first()
        )

        if not batsman_in_match:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Batsman is not in this match",
            )

    if ball_data.bowler_id:
        bowler_in_match = (
            db.query(PlayersInMatch)
            .filter(
                PlayersInMatch.match_id == match_id,
                PlayersInMatch.user_id == ball_data.bowler_id,
            )
            .first()
        )

        if not bowler_in_match:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Bowler is not in this match",
            )

    # Create ball record
    ball = Ball(
        innings_id=innings_id,
        over_number=ball_data.over_number,
        ball_in_over=ball_data.ball_in_over,
        batsman_id=ball_data.batsman_id,
        non_striker_id=ball_data.non_striker_id,
        bowler_id=ball_data.bowler_id,
        runs_off_bat=ball_data.runs_off_bat,
        extras_type=ball_data.extras_type,
        extras_runs=ball_data.extras_runs,
        wicket_type=ball_data.wicket_type,
        dismissal_info=ball_data.dismissal_info,
        client_event_id=ball_data.client_event_id,
        ball_metadata=ball_data.ball_metadata,
    )

    db.add(ball)

    # Update innings statistics
    innings.runs += ball.total_runs
    innings.extras += ball_data.extras_runs

    # Update overs bowled (only for legal deliveries)
    if ball.is_legal_delivery:
        # Calculate new overs bowled
        total_balls = int(innings.overs_bowled) * 6 + innings.current_over_balls + 1
        innings.overs_bowled = total_balls // 6 + (total_balls % 6) / 10

    # Update wickets if there's a wicket
    if ball_data.wicket_type:
        innings.wickets += 1

    # Check if innings is completed
    if innings.wickets >= 10 or innings.overs_bowled >= innings.overs_allocated:
        innings.is_completed = True
        innings.completed_at = datetime.utcnow()

    db.commit()
    db.refresh(ball)

    logger.info(
        "Ball recorded successfully",
        ball_id=ball.id,
        innings_id=innings_id,
        match_id=match_id,
        over=f"{ball.over_number}.{ball.ball_in_over}",
        runs=ball.total_runs,
        wicket=bool(ball.wicket_type),
        user_id=current_user.id,
    )

    return ball


@router.get("/{match_id}/innings/{innings_id}/balls", response_model=List[BallResponse])
async def get_balls(
    match_id: str,
    innings_id: str,
    over: Optional[int] = Query(None, ge=1, le=50),
    limit: int = Query(100, ge=1, le=500),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get balls in an innings with optional filtering."""
    # Validate match and innings
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        logger.warning(
            "Match not found for balls retrieval",
            match_id=match_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Match not found"
        )

    innings = (
        db.query(Innings)
        .filter(Innings.id == innings_id, Innings.match_id == match_id)
        .first()
    )

    if not innings:
        logger.warning(
            "Innings not found for balls retrieval",
            innings_id=innings_id,
            match_id=match_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Innings not found"
        )

    # Query balls
    query = db.query(Ball).filter(Ball.innings_id == innings_id)

    if over:
        query = query.filter(Ball.over_number == over)

    balls = query.order_by(Ball.created_at.desc()).limit(limit).all()

    logger.info(
        "Balls retrieved",
        match_id=match_id,
        innings_id=innings_id,
        over=over,
        limit=limit,
        count=len(balls),
        user_id=current_user.id,
    )

    return balls


@router.put(
    "/{match_id}/innings/{innings_id}/balls/{ball_id}", response_model=BallResponse
)
async def update_ball(
    match_id: str,
    innings_id: str,
    ball_id: str,
    ball_update: BallUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_host_role),
):
    """Update a ball record (for undo functionality)."""
    # Validate match and innings
    match = db.query(Match).filter(Match.id == match_id).first()
    if not match:
        logger.warning(
            "Match not found for ball update",
            match_id=match_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Match not found"
        )

    innings = (
        db.query(Innings)
        .filter(Innings.id == innings_id, Innings.match_id == match_id)
        .first()
    )

    if not innings:
        logger.warning(
            "Innings not found for ball update",
            innings_id=innings_id,
            match_id=match_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Innings not found"
        )

    # Find the ball
    ball = (
        db.query(Ball).filter(Ball.id == ball_id, Ball.innings_id == innings_id).first()
    )

    if not ball:
        logger.warning(
            "Ball not found for update", ball_id=ball_id, user_id=current_user.id
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Ball not found"
        )

    # Check if user is the host
    if match.host_user_id != current_user.id:
        logger.warning(
            "Unauthorized ball update",
            match_id=match_id,
            user_id=current_user.id,
            host_id=match.host_user_id,
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the match host can update balls",
        )

    # Store old values for recalculation
    old_runs = ball.total_runs
    old_extras = ball.extras_runs
    old_wicket = bool(ball.wicket_type)
    old_legal = ball.is_legal_delivery

    # Update ball fields
    if ball_update.runs_off_bat is not None:
        ball.runs_off_bat = ball_update.runs_off_bat

    if ball_update.extras_type is not None:
        ball.extras_type = ball_update.extras_type

    if ball_update.extras_runs is not None:
        ball.extras_runs = ball_update.extras_runs

    if ball_update.wicket_type is not None:
        ball.wicket_type = ball_update.wicket_type

    if ball_update.dismissal_info is not None:
        ball.dismissal_info = ball_update.dismissal_info

    if ball_update.ball_metadata is not None:
        ball.ball_metadata = ball_update.ball_metadata

    # Recalculate innings statistics
    runs_diff = ball.total_runs - old_runs
    extras_diff = ball.extras_runs - old_extras

    innings.runs += runs_diff
    innings.extras += extras_diff

    # Handle wicket changes
    wicket_diff = (1 if ball.wicket_type else 0) - (1 if old_wicket else 0)
    innings.wickets += wicket_diff

    db.commit()
    db.refresh(ball)

    logger.info(
        "Ball updated successfully",
        ball_id=ball_id,
        innings_id=innings_id,
        match_id=match_id,
        runs_diff=runs_diff,
        extras_diff=extras_diff,
        wicket_diff=wicket_diff,
        user_id=current_user.id,
    )

    return ball
