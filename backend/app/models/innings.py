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
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func


class Innings(Base):
    """Innings model for cricket match innings."""

    __tablename__ = "innings"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid4()))
    match_id = Column(
        String(36),
        ForeignKey("matches.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    # Innings information
    batting_team = Column(Enum("A", "B", name="batting_team"), nullable=False)
    overs_allocated = Column(Integer, nullable=False, default=20)

    # Denormalized statistics for quick access
    runs = Column(Integer, default=0, nullable=False)
    wickets = Column(Integer, default=0, nullable=False)
    extras = Column(Integer, default=0, nullable=False)
    overs_bowled = Column(
        Float, default=0.0, nullable=False
    )  # 4.3 means 4 overs and 3 balls

    # Status
    is_completed = Column(Boolean, default=False, nullable=False, index=True)
    completed_at = Column(DateTime(timezone=True), nullable=True)

    # Additional information
    notes = Column(JSON, nullable=True)  # Store additional innings metadata

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

    # Relationships
    match = relationship("Match", back_populates="innings")
    balls = relationship("Ball", back_populates="innings", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Innings(id={self.id}, match={self.match_id}, team={self.batting_team}, runs={self.runs}/{self.wickets})>"

    def to_dict(self):
        """Convert innings to dictionary."""
        return {
            "id": self.id,
            "match_id": self.match_id,
            "batting_team": self.batting_team,
            "overs_allocated": self.overs_allocated,
            "runs": self.runs,
            "wickets": self.wickets,
            "extras": self.extras,
            "overs_bowled": self.overs_bowled,
            "is_completed": self.is_completed,
            "completed_at": (
                self.completed_at.isoformat() if self.completed_at else None
            ),
            "notes": self.notes,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }

    @property
    def run_rate(self):
        """Calculate current run rate."""
        if self.overs_bowled > 0:
            return round(self.runs / self.overs_bowled, 2)
        return 0.0

    @property
    def current_over_balls(self):
        """Get balls in current over (0-5)."""
        return int((self.overs_bowled % 1) * 10)
