from uuid import uuid4

from app.database import Base
from sqlalchemy import (
    JSON,
    Boolean,
    Column,
    DateTime,
    Enum,
    Float,
    ForeignKey,
    Integer,
    String,
    Text,
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func


class Match(Base):
    """Cricket match model with all match-related information."""

    __tablename__ = "matches"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid4()))
    host_user_id = Column(
        String(36),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    # Match information
    match_type = Column(
        Enum("quick", "friendly", "tournament", name="match_type"),
        default="quick",
        nullable=False,
    )
    team_a_name = Column(String(100), nullable=False)
    team_b_name = Column(String(100), nullable=False)

    # Venue information
    venue = Column(String(255), nullable=True)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)

    # Scheduling
    scheduled_at = Column(DateTime(timezone=True), nullable=True, index=True)

    # Match status
    status = Column(
        Enum(
            "created", "toss_done", "live", "finished", "cancelled", name="match_status"
        ),
        default="created",
        nullable=False,
        index=True,
    )

    # Match rules (JSON configuration)
    rules = Column(
        JSON,
        nullable=False,
        default=lambda: {
            "overs_limit": 20,
            "powerplay_overs": 6,
            "wide_ball_runs": 1,
            "no_ball_runs": 1,
            "free_hit": True,
            "super_over": False,
        },
    )

    # Match result (JSON with final scores and winner)
    result = Column(JSON, nullable=True)

    # Toss information
    toss_winner = Column(Enum("A", "B", name="toss_winner"), nullable=True)
    toss_decision = Column(Enum("bat", "bowl", name="toss_decision"), nullable=True)

    # Timestamps
    created_at = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    updated_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )
    started_at = Column(DateTime(timezone=True), nullable=True)
    finished_at = Column(DateTime(timezone=True), nullable=True)

    # Relationships
    host = relationship(
        "User", back_populates="hosted_matches", foreign_keys=[host_user_id]
    )
    players = relationship(
        "PlayersInMatch", back_populates="match", cascade="all, delete-orphan"
    )
    innings = relationship(
        "Innings", back_populates="match", cascade="all, delete-orphan"
    )
    events = relationship(
        "MatchEvent", back_populates="match", cascade="all, delete-orphan"
    )

    def __repr__(self):
        return f"<Match(id={self.id}, teams={self.team_a_name} vs {self.team_b_name}, status={self.status})>"

    def to_dict(self):
        """Convert match to dictionary."""
        return {
            "id": self.id,
            "host_user_id": self.host_user_id,
            "match_type": self.match_type,
            "team_a_name": self.team_a_name,
            "team_b_name": self.team_b_name,
            "venue": self.venue,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "scheduled_at": (
                self.scheduled_at.isoformat() if self.scheduled_at else None
            ),
            "status": self.status,
            "rules": self.rules,
            "result": self.result,
            "toss_winner": self.toss_winner,
            "toss_decision": self.toss_decision,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
            "started_at": self.started_at.isoformat() if self.started_at else None,
            "finished_at": self.finished_at.isoformat() if self.finished_at else None,
        }

    @property
    def current_innings(self):
        """Get the current active innings."""
        for innings in self.innings:
            if not innings.is_completed:
                return innings
        return None
