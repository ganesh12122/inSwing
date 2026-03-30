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

    # Notification information
    notification_type = Column(
        Enum(
            "match_start",
            "wicket",
            "milestone",
            "mentioned",
            "comment",
            "system",
            name="notification_type",
        ),
        nullable=False,
        index=True,
    )

    # Notification payload (flexible JSON structure)
    payload = Column(
        JSON, nullable=False
    )  # Contains match_id, player_id, message, action_url, etc.

    # Read status
    read_at = Column(DateTime(timezone=True), nullable=True, index=True)

    # Timestamps
    created_at = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )

    # Relationships
    user = relationship("User", back_populates="notifications")

    def __repr__(self):
        return f"<Notification(id={self.id}, user={self.user_id}, type={self.notification_type})>"

    def to_dict(self):
        """Convert notification to dictionary."""
        return {
            "id": self.id,
            "user_id": self.user_id,
            "notification_type": self.notification_type,
            "payload": self.payload,
            "read_at": self.read_at.isoformat() if self.read_at else None,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }

    @property
    def is_read(self):
        """Check if notification has been read."""
        return self.read_at is not None

    def mark_as_read(self):
        """Mark notification as read."""
        from datetime import datetime

        self.read_at = datetime.utcnow()
