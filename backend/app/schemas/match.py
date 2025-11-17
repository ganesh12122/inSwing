from pydantic import BaseModel, Field, validator
from typing import Optional, Dict, Any
from datetime import datetime
from enum import Enum


class MatchType(str, Enum):
    quick = "quick"
    friendly = "friendly"
    tournament = "tournament"


class MatchStatus(str, Enum):
    created = "created"
    toss_done = "toss_done"
    live = "live"
    finished = "finished"
    cancelled = "cancelled"


class TossDecision(str, Enum):
    bat = "bat"
    bowl = "bowl"


class MatchRules(BaseModel):
    """Match rules configuration."""
    overs_limit: int = Field(20, ge=1, le=50)
    powerplay_overs: int = Field(6, ge=0, le=10)
    wide_ball_runs: int = Field(1, ge=1, le=2)
    no_ball_runs: int = Field(1, ge=1, le=2)
    free_hit: bool = True
    super_over: bool = False


class MatchResult(BaseModel):
    """Match result information."""
    winner: str  # 'A' or 'B'
    winning_margin: int
    winning_type: str  # 'runs' or 'wickets'
    mvp: Optional[str] = None  # User ID of MVP
    final_scores: Dict[str, Any]


class MatchBase(BaseModel):
    match_type: MatchType = MatchType.quick
    team_a_name: str = Field(..., min_length=1, max_length=100)
    team_b_name: str = Field(..., min_length=1, max_length=100)
    venue: Optional[str] = Field(None, max_length=255)
    latitude: Optional[float] = Field(None, ge=-90, le=90)
    longitude: Optional[float] = Field(None, ge=-180, le=180)
    scheduled_at: Optional[datetime] = None
    rules: MatchRules = Field(default_factory=MatchRules)


class MatchCreate(MatchBase):
    """Schema for creating a new match."""
    pass


class MatchUpdate(BaseModel):
    """Schema for updating match information."""
    team_a_name: Optional[str] = Field(None, min_length=1, max_length=100)
    team_b_name: Optional[str] = Field(None, min_length=1, max_length=100)
    venue: Optional[str] = Field(None, max_length=255)
    latitude: Optional[float] = Field(None, ge=-90, le=90)
    longitude: Optional[float] = Field(None, ge=-180, le=180)
    scheduled_at: Optional[datetime] = None
    rules: Optional[MatchRules] = None


class TossUpdate(BaseModel):
    """Schema for updating toss result."""
    toss_winner: str = Field(..., pattern="^[AB]$")  # 'A' or 'B'
    toss_decision: TossDecision


class MatchInDB(MatchBase):
    """Schema for match data from database."""
    id: str
    host_user_id: str
    status: MatchStatus
    toss_winner: Optional[str] = None
    toss_decision: Optional[TossDecision] = None
    result: Optional[MatchResult] = None
    created_at: datetime
    updated_at: datetime
    started_at: Optional[datetime] = None
    finished_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True


class MatchResponse(MatchInDB):
    """Schema for match responses."""
    pass


class MatchListResponse(BaseModel):
    """Schema for match list responses."""
    matches: list[MatchResponse]
    total: int
    page: int
    per_page: int