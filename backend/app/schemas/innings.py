from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from enum import Enum


class BattingTeam(str, Enum):
    A = "A"
    B = "B"


class InningsBase(BaseModel):
    batting_team: BattingTeam
    overs_allocated: int = Field(20, ge=1, le=50)


class InningsCreate(InningsBase):
    """Schema for creating a new innings."""
    pass


class InningsUpdate(BaseModel):
    """Schema for updating innings (e.g., marking as completed)."""
    is_completed: bool = True


class InningsResponse(BaseModel):
    """Schema for innings response."""
    id: str
    match_id: str
    batting_team: BattingTeam
    overs_allocated: int
    runs: int
    wickets: int
    extras: int
    overs_bowled: float
    is_completed: bool
    completed_at: Optional[datetime] = None
    notes: Optional[dict] = None
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
    
    @property
    def run_rate(self) -> float:
        """Calculate current run rate."""
        if self.overs_bowled > 0:
            return round(self.runs / self.overs_bowled, 2)
        return 0.0
    
    @property
    def current_over_balls(self) -> int:
        """Get balls in current over (0-5)."""
        return int((self.overs_bowled % 1) * 10)