from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from enum import Enum


class MatchTeam(str, Enum):
    A = "A"
    B = "B"


class PlayerRole(str, Enum):
    captain = "captain"
    batsman = "batsman"
    bowler = "bowler"
    allrounder = "allrounder"
    wicketkeeper = "wicketkeeper"


class PlayerInMatchBase(BaseModel):
    user_id: Optional[str] = None
    team: MatchTeam
    role: PlayerRole = PlayerRole.batsman
    is_guest: bool = False
    guest_name: Optional[str] = None


class PlayerInMatchCreate(BaseModel):
    """Schema for adding a player to a match.

    For registered users: provide user_id.
    For guest players: provide guest_name (is_guest auto-set to True).
    """
    user_id: Optional[str] = None
    guest_name: Optional[str] = Field(None, min_length=1, max_length=255)
    team: MatchTeam
    role: PlayerRole = PlayerRole.batsman


class PlayerInMatchUpdate(BaseModel):
    """Schema for updating player role in match."""
    role: PlayerRole


class PlayerInMatchResponse(BaseModel):
    """Schema for player in match response."""
    id: str
    match_id: str
    user_id: Optional[str] = None
    team: MatchTeam
    role: PlayerRole
    is_guest: bool = False
    guest_name: Optional[str] = None
    added_by: Optional[str] = None
    joined_at: datetime

    # Enriched fields (populated by API)
    display_name: Optional[str] = None

    class Config:
        from_attributes = True
