from pydantic import BaseModel, EmailStr, Field, validator
from typing import Optional, List
from datetime import datetime
from enum import Enum

# Import ProfileResponse to avoid circular imports
from app.schemas.profile import ProfileResponse


class UserRole(str, Enum):
    player = "player"
    admin = "admin"


class UserBase(BaseModel):
    phone_number: str = Field(..., pattern=r'^\+?[1-9]\d{1,14}$', description="Phone number in E.164 format")
    email: Optional[EmailStr] = None
    full_name: str = Field(..., min_length=1, max_length=255)
    bio: Optional[str] = Field(None, max_length=1000)


class UserCreate(UserBase):
    """Schema for creating a new user."""
    pass


class UserUpdate(BaseModel):
    """Schema for updating user information."""
    email: Optional[EmailStr] = None
    full_name: Optional[str] = Field(None, min_length=1, max_length=255)
    bio: Optional[str] = Field(None, max_length=1000)
    avatar_url: Optional[str] = Field(None, max_length=500)


class UserInDB(UserBase):
    """Schema for user data from database."""
    id: str
    role: UserRole
    is_active: bool
    is_verified: bool
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True


class UserResponse(UserInDB):
    """Schema for user responses."""
    pass


class UserProfileResponse(BaseModel):
    """Schema for user profile response including user and profile data."""
    user: UserResponse
    profile: Optional['ProfileResponse'] = None
    
    class Config:
        from_attributes = True