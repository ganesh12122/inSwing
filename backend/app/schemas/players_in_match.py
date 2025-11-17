from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from enum import Enum


class MatchTeam(str, Enum):
    A = "A"
    B = "B"


class PlayerRole(str, Enum):
    batsman = "batsman"
    bowler = "bowler"
    allrounder = "allrounder"
    wicketkeeper = "wicketkeeper"


class PlayerInMatchBase(BaseModel):
    user_id: str
    team: MatchTeam
    role: PlayerRole = PlayerRole.batsman


class PlayerInMatchCreate(PlayerInMatchBase):
    """Schema for adding a player to a match."""
    pass


class PlayerInMatchUpdate(BaseModel):
    """Schema for updating player role in match."""
    role: PlayerRole


class PlayerInMatchResponse(BaseModel):
    """Schema for player in match response."""
    id: str
    match_id: str
    user_id: str
    team: MatchTeam
    role: PlayerRole
    joined_at: datetime
    
    class Config:
        from_attributes = True