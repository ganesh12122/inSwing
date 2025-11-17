from pydantic import BaseModel, Field
from typing import Optional, Dict, Any
from datetime import datetime
from enum import Enum


class EventType(str, Enum):
    boundary = "boundary"
    wicket = "wicket"
    milestone = "milestone"
    highlight = "highlight"
    comment = "comment"
    innings_change = "innings_change"
    toss = "toss"


class MatchEventBase(BaseModel):
    event_type: EventType
    meta: Dict[str, Any] = Field(..., description="Event metadata including player_id, runs, description, etc.")


class MatchEventCreate(MatchEventBase):
    """Schema for creating a new match event."""
    pass


class MatchEventResponse(BaseModel):
    """Schema for match event response."""
    id: str
    match_id: str
    event_type: EventType
    meta: Dict[str, Any]
    likes_count: int
    comments_count: int
    created_at: datetime
    
    class Config:
        from_attributes = True