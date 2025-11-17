from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from enum import Enum


class ExtrasType(str, Enum):
    wide = "wide"
    no_ball = "no_ball"
    bye = "bye"
    legbye = "legbye"


class WicketType(str, Enum):
    bowled = "bowled"
    caught = "caught"
    runout = "runout"
    lbw = "lbw"
    stumped = "stumped"
    hit_wicket = "hit_wicket"


class BallBase(BaseModel):
    over_number: int = Field(..., ge=1, le=50)
    ball_in_over: int = Field(..., ge=1, le=10)  # Can be >6 for wides/no-balls
    batsman_id: Optional[str] = None
    non_striker_id: Optional[str] = None
    bowler_id: Optional[str] = None
    runs_off_bat: int = Field(0, ge=0, le=6)
    extras_type: Optional[ExtrasType] = None
    extras_runs: int = Field(0, ge=0, le=5)
    wicket_type: Optional[WicketType] = None
    dismissal_info: Optional[dict] = None
    client_event_id: Optional[str] = Field(None, max_length=100)
    ball_metadata: Optional[dict] = None


class BallCreate(BallBase):
    """Schema for creating a new ball record."""
    pass


class BallUpdate(BaseModel):
    """Schema for updating ball record (for undo functionality)."""
    runs_off_bat: Optional[int] = Field(None, ge=0, le=6)
    extras_type: Optional[ExtrasType] = None
    extras_runs: Optional[int] = Field(None, ge=0, le=5)
    wicket_type: Optional[WicketType] = None
    dismissal_info: Optional[dict] = None
    ball_metadata: Optional[dict] = None


class BallResponse(BaseModel):
    """Schema for ball response."""
    id: str
    innings_id: str
    over_number: int
    ball_in_over: int
    batsman_id: Optional[str] = None
    non_striker_id: Optional[str] = None
    bowler_id: Optional[str] = None
    runs_off_bat: int
    extras_type: Optional[ExtrasType] = None
    extras_runs: int
    wicket_type: Optional[WicketType] = None
    dismissal_info: Optional[dict] = None
    client_event_id: Optional[str] = None
    ball_metadata: Optional[dict] = None
    created_at: datetime
    
    class Config:
        from_attributes = True
    
    @property
    def total_runs(self) -> int:
        """Calculate total runs from this ball."""
        return self.runs_off_bat + self.extras_runs
    
    @property
    def is_legal_delivery(self) -> bool:
        """Check if this is a legal delivery (not wide or no-ball)."""
        return self.extras_type not in ['wide', 'no_ball']