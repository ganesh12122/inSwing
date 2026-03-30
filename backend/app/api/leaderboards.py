from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from sqlalchemy import func, desc, case, and_, extract
from typing import List, Optional
from datetime import datetime, timedelta
import structlog

from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.models.match import Match
from app.models.innings import Innings
from app.models.ball import Ball
from app.models.players_in_match import PlayersInMatch
from app.schemas import (
    LeaderboardEntry,
    LeaderboardResponse,
    LeaderboardType,
    TimePeriod
)

logger = structlog.get_logger()
router = APIRouter()


@router.get("/batting", response_model=LeaderboardResponse)
async def get_batting_leaderboard(
    period: TimePeriod = Query(TimePeriod.ALL_TIME, description="Time period for leaderboard"),
    limit: int = Query(50, ge=1, le=200, description="Number of entries to return"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get batting leaderboard with top run scorers."""
    
    # Build time filter
    time_filter = _build_time_filter(period)
    
    # Query for batting statistics
    batting_stats = db.query(
        User.id,
        User.full_name,
        User.avatar_url,
        func.sum(Ball.runs_off_bat).label('total_runs'),
        func.count(Ball.id).filter(Ball.runs_off_bat > 0).label('balls_faced'),
        func.count(case((Ball.runs_off_bat == 4, 1))).label('fours'),
        func.count(case((Ball.runs_off_bat == 6, 1))).label('sixes'),
        func.avg(Ball.runs_off_bat).label('strike_rate')
    ).join(
        Ball, Ball.batsman_id == User.id
    ).join(
        Innings, Innings.id == Ball.innings_id
    ).join(
        Match, Match.id == Innings.match_id
    ).filter(
        and_(
            Match.status == 'finished',
            time_filter
        )
    ).group_by(
        User.id, User.full_name, User.avatar_url
    ).having(
        func.sum(Ball.runs_off_bat) > 0
    ).order_by(
        desc('total_runs')
    ).limit(limit).all()
    
    entries = []
    for i, stat in enumerate(batting_stats, 1):
        strike_rate = float(stat.strike_rate) * 100 if stat.strike_rate else 0.0
        
        entries.append(LeaderboardEntry(
            rank=i,
            user_id=stat.id,
            user_name=stat.full_name,
            user_avatar=stat.avatar_url,
            primary_stat=int(stat.total_runs),
            secondary_stat=f"{strike_rate:.1f}",
            tertiary_stat=f"{stat.fours}/{stat.sixes}",
            additional_stats={
                "balls_faced": int(stat.balls_faced),
                "fours": int(stat.fours),
                "sixes": int(stat.sixes)
            }
        ))
    
    logger.info("Batting leaderboard retrieved", 
                period=period,
                limit=limit,
                entries_count=len(entries),
                user_id=current_user.id)
    
    return LeaderboardResponse(
        type=LeaderboardType.BATTING,
        period=period,
        entries=entries,
        generated_at=datetime.utcnow()
    )


@router.get("/bowling", response_model=LeaderboardResponse)
async def get_bowling_leaderboard(
    period: TimePeriod = Query(TimePeriod.ALL_TIME, description="Time period for leaderboard"),
    limit: int = Query(50, ge=1, le=200, description="Number of entries to return"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get bowling leaderboard with best bowling figures."""
    
    time_filter = _build_time_filter(period)
    
    # Query for bowling statistics
    bowling_stats = db.query(
        User.id,
        User.full_name,
        User.avatar_url,
        func.count(Ball.id).filter(Ball.wicket_type.isnot(None)).label('wickets'),
        func.sum(Ball.runs_off_bat + Ball.extras_runs).label('runs_conceded'),
        func.count(Ball.id).filter(Ball.extras_type.is_(None)).label('balls_bowled'),
        func.count(case((Ball.extras_type == 'wide', 1))).label('wides'),
        func.count(case((Ball.extras_type == 'no_ball', 1))).label('no_balls')
    ).join(
        Ball, Ball.bowler_id == User.id
    ).join(
        Innings, Innings.id == Ball.innings_id
    ).join(
        Match, Match.id == Innings.match_id
    ).filter(
        and_(
            Match.status == 'finished',
            time_filter
        )
    ).group_by(
        User.id, User.full_name, User.avatar_url
    ).having(
        func.count(Ball.id).filter(Ball.wicket_type.isnot(None)) > 0
    ).order_by(
        desc('wickets'),
        'runs_conceded'  # Fewer runs conceded is better
    ).limit(limit).all()
    
    entries = []
    for i, stat in enumerate(bowling_stats, 1):
        # Calculate economy rate
        overs_bowled = stat.balls_bowled / 6 if stat.balls_bowled else 0
        economy = (stat.runs_conceded / overs_bowled) if overs_bowled > 0 else 0.0
        
        entries.append(LeaderboardEntry(
            rank=i,
            user_id=stat.id,
            user_name=stat.full_name,
            user_avatar=stat.avatar_url,
            primary_stat=int(stat.wickets),
            secondary_stat=f"{economy:.1f}",
            tertiary_stat=f"{stat.runs_conceded}/{int(stat.wickets)}",
            additional_stats={
                "runs_conceded": int(stat.runs_conceded),
                "balls_bowled": int(stat.balls_bowled),
                "wides": int(stat.wides),
                "no_balls": int(stat.no_balls)
            }
        ))
    
    logger.info("Bowling leaderboard retrieved", 
                period=period,
                limit=limit,
                entries_count=len(entries),
                user_id=current_user.id)
    
    return LeaderboardResponse(
        type=LeaderboardType.BOWLING,
        period=period,
        entries=entries,
        generated_at=datetime.utcnow()
    )


@router.get("/matches-hosted", response_model=LeaderboardResponse)
async def get_matches_hosted_leaderboard(
    period: TimePeriod = Query(TimePeriod.ALL_TIME, description="Time period for leaderboard"),
    limit: int = Query(50, ge=1, le=200, description="Number of entries to return"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get leaderboard for most matches hosted."""
    
    time_filter = _build_time_filter(period)
    
    # PostgreSQL-compatible: use EXTRACT(EPOCH FROM ...) instead of TIMESTAMPDIFF
    hosted_stats = db.query(
        User.id,
        User.full_name,
        User.avatar_url,
        func.count(Match.id).label('matches_hosted'),
        func.avg(
            extract('epoch', Match.finished_at) - extract('epoch', Match.created_at)
        ).label('avg_match_duration_seconds')
    ).join(
        Match, Match.host_user_id == User.id
    ).filter(
        and_(
            Match.status == 'finished',
            time_filter
        )
    ).group_by(
        User.id, User.full_name, User.avatar_url
    ).having(
        func.count(Match.id) > 0
    ).order_by(
        desc('matches_hosted')
    ).limit(limit).all()
    
    entries = []
    for i, stat in enumerate(hosted_stats, 1):
        avg_duration_minutes = (float(stat.avg_match_duration_seconds) / 60) if stat.avg_match_duration_seconds else 0
        
        entries.append(LeaderboardEntry(
            rank=i,
            user_id=stat.id,
            user_name=stat.full_name,
            user_avatar=stat.avatar_url,
            primary_stat=int(stat.matches_hosted),
            secondary_stat=f"{avg_duration_minutes:.0f}m",
            tertiary_stat="Host",
            additional_stats={
                "avg_match_duration_minutes": round(avg_duration_minutes, 1)
            }
        ))
    
    logger.info("Matches hosted leaderboard retrieved", 
                period=period,
                limit=limit,
                entries_count=len(entries),
                user_id=current_user.id)
    
    return LeaderboardResponse(
        type=LeaderboardType.MATCHES_HOSTED,
        period=period,
        entries=entries,
        generated_at=datetime.utcnow()
    )


@router.get("/player-rating", response_model=LeaderboardResponse)
async def get_player_rating_leaderboard(
    period: TimePeriod = Query(TimePeriod.ALL_TIME, description="Time period for leaderboard"),
    limit: int = Query(50, ge=1, le=200, description="Number of entries to return"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get leaderboard based on player performance (matches played + runs + wickets)."""
    
    time_filter = _build_time_filter(period)
    
    # Query for player participation and performance
    # Note: User model has no 'rating' column — calculate a simple composite score
    player_stats = db.query(
        User.id,
        User.full_name,
        User.avatar_url,
        func.count(func.distinct(PlayersInMatch.match_id)).label('matches_played'),
        func.coalesce(func.sum(Ball.runs_off_bat), 0).label('total_runs'),
        func.count(Ball.id).filter(Ball.wicket_type.isnot(None)).label('wickets_taken')
    ).join(
        PlayersInMatch, PlayersInMatch.user_id == User.id
    ).join(
        Match, Match.id == PlayersInMatch.match_id
    ).outerjoin(
        Innings, Innings.match_id == Match.id
    ).outerjoin(
        Ball, and_(Ball.batsman_id == User.id, Ball.innings_id == Innings.id)
    ).filter(
        and_(
            Match.status == 'finished',
            time_filter
        )
    ).group_by(
        User.id, User.full_name, User.avatar_url
    ).having(
        func.count(func.distinct(PlayersInMatch.match_id)) > 0
    ).order_by(
        desc('matches_played'),
        desc('total_runs')
    ).limit(limit).all()
    
    entries = []
    for i, stat in enumerate(player_stats, 1):
        total_runs = int(stat.total_runs) if stat.total_runs else 0
        wickets = int(stat.wickets_taken) if stat.wickets_taken else 0
        matches = int(stat.matches_played)
        
        # Simple performance score: runs + (wickets * 25) + (matches * 10)
        perf_score = total_runs + (wickets * 25) + (matches * 10)
        
        entries.append(LeaderboardEntry(
            rank=i,
            user_id=stat.id,
            user_name=stat.full_name,
            user_avatar=stat.avatar_url,
            primary_stat=perf_score,
            secondary_stat=f"{matches} matches",
            tertiary_stat=f"{total_runs}r/{wickets}w",
            additional_stats={
                "matches_played": matches,
                "total_runs": total_runs,
                "wickets_taken": wickets
            }
        ))
    
    logger.info("Player rating leaderboard retrieved", 
                period=period,
                limit=limit,
                entries_count=len(entries),
                user_id=current_user.id)
    
    return LeaderboardResponse(
        type=LeaderboardType.PLAYER_RATING,
        period=period,
        entries=entries,
        generated_at=datetime.utcnow()
    )


def _build_time_filter(period: TimePeriod):
    """Build SQL time filter based on period. PostgreSQL compatible."""
    now = datetime.utcnow()
    if period == TimePeriod.WEEK:
        cutoff = now - timedelta(days=7)
        return Match.finished_at >= cutoff
    elif period == TimePeriod.MONTH:
        cutoff = now - timedelta(days=30)
        return Match.finished_at >= cutoff
    elif period == TimePeriod.YEAR:
        cutoff = now - timedelta(days=365)
        return Match.finished_at >= cutoff
    else:  # ALL_TIME
        return True  # No time filter
