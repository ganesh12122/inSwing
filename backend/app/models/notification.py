from uuid import uuid4

from app.database import Base
from sqlalchemy import JSON, Column, DateTime, Enum, ForeignKey, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func


class Notification(Base):
    """User notifications for various events."""

    __tablename__ = "notifications"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid4()))
    user_id = Column(
        String(36),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    # Notification content
    title = Column(String(200), nullable=False)
    message = Column(String(1000), nullable=False)

    # Notification type and metadata
    type = Column(
        Enum(
            "match_invitation",
            "match_update",
            "match_reminder",
            "system",
            "achievement",
            name="notification_type",
        ),
        nullable=False,
        index=True,
    )
    data = Column(
        JSON, nullable=True
    )  # Flexible payload (match_id, player_id, action_url, etc.)

    # Priority and status
    priority = Column(
        Enum("low", "medium", "high", name="notification_priority"),
        default="medium",
        nullable=False,
    )
    status = Column(
        Enum("unread", "read", name="notification_status"),
        default="unread",
        nullable=False,
        index=True,
    )

    # Read and expiration tracking
    read_at = Column(DateTime(timezone=True), nullable=True)
    expires_at = Column(DateTime(timezone=True), nullable=True)

    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)  # type: ignore
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)  # type: ignore

    # Relationships
    user = relationship("User", back_populates="notifications")

    def __repr__(self):
        return f"<Notification(id={self.id}, user={self.user_id}, type={self.type})>"

    def to_dict(self):
        """Convert notification to dictionary."""
        return {
            "id": self.id,
            "user_id": self.user_id,
            "title": self.title,
            "message": self.message,
            "type": self.type,
            "data": self.data,
            "priority": self.priority,
            "status": self.status,
            "read_at": self.read_at.isoformat() if self.read_at else None,  # type: ignore[truthy-bool]
            "expires_at": self.expires_at.isoformat() if self.expires_at else None,  # type: ignore[truthy-bool]
            "created_at": self.created_at.isoformat() if self.created_at else None,  # type: ignore[truthy-bool]
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,  # type: ignore[truthy-bool]
        }

    @property
    def is_read(self):
        """Check if notification has been read."""
        return self.status == "read"

    def mark_as_read(self):
        """Mark notification as read."""
        from datetime import datetime

        self.status = "read"
        self.read_at = datetime.utcnow()
