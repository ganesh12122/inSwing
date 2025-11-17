from pydantic import BaseModel, Field, validator
from typing import Optional, List
from datetime import datetime
from enum import Enum


class BattingStyle(str, Enum):
    right_handed = "right-handed"
    left_handed = "left-handed"


class BowlingStyle(str, Enum):
    fast = "fast"
    spin = "spin"
    pace = "pace"
    none = "none"


class DominantHand(str, Enum):
    right = "right"
    left = "left"


class PlayerRole(str, Enum):
    batsman = "batsman"
    bowler = "bowler"
    allrounder = "allrounder"
    wicketkeeper = "wicketkeeper"


class ProfileBase(BaseModel):
    batting_style: Optional[BattingStyle] = None
    bowling_style: Optional[BowlingStyle] = None
    dominant_hand: Optional[DominantHand] = None
    teams: Optional[List[str]] = Field(None, max_items=10)
    achievements: Optional[List[str]] = Field(None, max_items=20)


class ProfileCreate(ProfileBase):
    """Schema for creating a new player profile."""
    pass


class ProfileUpdate(BaseModel):
    """Schema for updating player profile."""
    batting_style: Optional[BattingStyle] = None
    bowling_style: Optional[BowlingStyle] = None
    dominant_hand: Optional[DominantHand] = None
    teams: Optional[List[str]] = Field(None, max_items=10)
    achievements: Optional[List[str]] = Field(None, max_items=20)


class ProfileStats(BaseModel):
    """Schema for player statistics."""
    total_matches: int = Field(0, ge=0)
    total_runs: int = Field(0, ge=0)
    total_wickets: int = Field(0, ge=0)
    total_balls_faced: int = Field(0, ge=0)
    total_balls_bowled: int = Field(0, ge=0)
    total_runs_conceded: int = Field(0, ge=0)
    average_runs: float = Field(0.0, ge=0)
    strike_rate: float = Field(0.0, ge=0)  # Runs per 100 balls
    economy_rate: float = Field(0.0, ge=0)  # Runs per over
    bowling_average: float = Field(0.0, ge=0)


class ProfileResponse(ProfileBase, ProfileStats):
    """Schema for profile response."""
    id: str
    user_id: str
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True