from pydantic import BaseModel, Field
from typing import Optional, Dict, Any
from datetime import datetime
from enum import Enum


class NotificationType(str, Enum):
    """Types of notifications."""
    match_invitation = "match_invitation"
    match_update = "match_update"
    match_reminder = "match_reminder"
    system = "system"
    achievement = "achievement"


class NotificationStatus(str, Enum):
    """Status of notifications."""
    UNREAD = "unread"
    READ = "read"


class NotificationPriority(str, Enum):
    """Priority levels for notifications."""
    low = "low"
    medium = "medium"
    high = "high"


class NotificationBase(BaseModel):
    """Base schema for notifications."""
    title: str = Field(..., min_length=1, max_length=200)
    message: str = Field(..., min_length=1, max_length=1000)
    type: NotificationType
    data: Optional[Dict[str, Any]] = None
    priority: NotificationPriority = NotificationPriority.medium
    expires_at: Optional[datetime] = None


class NotificationCreate(NotificationBase):
    """Schema for creating a notification."""
    user_id: str


class NotificationUpdate(BaseModel):
    """Schema for updating a notification."""
    title: Optional[str] = Field(None, min_length=1, max_length=200)
    message: Optional[str] = Field(None, min_length=1, max_length=1000)
    type: Optional[NotificationType] = None
    data: Optional[Dict[str, Any]] = None
    priority: Optional[NotificationPriority] = None
    expires_at: Optional[datetime] = None


class NotificationResponse(NotificationBase):
    """Schema for notification response."""
    id: str
    user_id: str
    status: NotificationStatus
    read_at: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True