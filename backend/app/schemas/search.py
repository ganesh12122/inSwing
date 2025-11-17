from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

from app.schemas.user import UserResponse
from app.schemas.match import MatchResponse


class UserSearchResponse(BaseModel):
    """Schema for user search results."""
    id: str
    name: str
    phone: str
    profile_picture_url: Optional[str] = None
    bio: Optional[str] = None
    rating: float = Field(default=0.0, ge=0.0, le=5.0)
    is_active: bool = True
    created_at: datetime
    
    class Config:
        from_attributes = True


class MatchSearchResponse(BaseModel):
    """Schema for match search results."""
    id: str
    title: str
    location: Optional[str] = None
    team_a_name: str
    team_b_name: str
    match_type: str
    status: str
    host_user_id: str
    host_name: str
    created_at: datetime
    scheduled_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True


class SearchResponse(BaseModel):
    """Schema for combined search results."""
    users: List[UserSearchResponse] = Field(default_factory=list)
    matches: List[MatchSearchResponse] = Field(default_factory=list)
    query: str
    total_results: int = 0
    
    class Config:
        from_attributes = True