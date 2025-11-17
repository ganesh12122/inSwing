from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from datetime import datetime
from enum import Enum


class LeaderboardType(str, Enum):
    """Types of leaderboards."""
    batting = "batting"
    bowling = "bowling"
    matches_hosted = "matches_hosted"
    player_rating = "player_rating"


class LeaderboardFilter(str, Enum):
    """Filter options for leaderboards."""
    week = "week"
    month = "month"
    year = "year"
    all_time = "all_time"


class TimePeriod(str, Enum):
    """Time period for leaderboards."""
    WEEK = "week"
    MONTH = "month"
    YEAR = "year"
    ALL_TIME = "all_time"


class LeaderboardEntry(BaseModel):
    """Individual leaderboard entry."""
    rank: int
    user_id: str
    user_name: str
    user_avatar: Optional[str] = None
    primary_stat: float  # Main statistic (runs, wickets, rating, etc.)
    secondary_stat: str  # Secondary statistic (strike rate, economy, etc.)
    tertiary_stat: str  # Tertiary statistic (4s/6s, extras, etc.)
    additional_stats: Dict[str, Any] = {}  # Additional statistics


class LeaderboardResponse(BaseModel):
    """Response schema for leaderboard data."""
    type: LeaderboardType
    period: TimePeriod
    entries: List[LeaderboardEntry]
    generated_at: datetime