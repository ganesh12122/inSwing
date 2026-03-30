from uuid import uuid4

from app.database import Base
from sqlalchemy import JSON, Column, DateTime, Enum, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func


class MatchEvent(Base):
    """Match events for feed, highlights, and social features."""

    __tablename__ = "match_events"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid4()))
    match_id = Column(
        String(36),
        ForeignKey("matches.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    # Event information
    event_type = Column(
        Enum(
            "boundary",
            "wicket",
            "milestone",
            "highlight",
            "comment",
            "innings_change",
            "toss",
            name="event_type",
        ),
        nullable=False,
        index=True,
    )

    # Event metadata (flexible JSON structure)
    meta = Column(
        JSON, nullable=False
    )  # Contains player_id, runs, description, timestamp, etc.

    # Social features
    likes_count = Column(Integer, default=0, nullable=False)
    comments_count = Column(Integer, default=0, nullable=False)

    # Timestamps
    created_at = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False  # type: ignore
    )

    # Relationships
    match = relationship("Match", back_populates="events")

    def __repr__(self):
        return (
            f"<MatchEvent(id={self.id}, match={self.match_id}, type={self.event_type})>"
        )

    def to_dict(self):
        """Convert match event to dictionary."""
        return {
            "id": self.id,
            "match_id": self.match_id,
            "event_type": self.event_type,
            "meta": self.meta,
            "likes_count": self.likes_count,
            "comments_count": self.comments_count,
            "created_at": self.created_at.isoformat() if self.created_at else None,  # type: ignore[truthy-bool]
        }
