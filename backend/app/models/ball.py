from uuid import uuid4

from app.database import Base
from sqlalchemy import JSON, Column, DateTime, Enum, Float, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func


class Ball(Base):
    """Ball-by-ball record for cricket scoring."""

    __tablename__ = "balls"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid4()))
    innings_id = Column(
        String(36),
        ForeignKey("innings.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    # Ball identification
    over_number = Column(Integer, nullable=False, index=True)
    ball_in_over = Column(Integer, nullable=False)  # 1-6 (or more for wides/no-balls)

    # Players involved
    batsman_id = Column(
        String(36),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )
    non_striker_id = Column(
        String(36),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )
    bowler_id = Column(
        String(36),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )

    # Scoring information
    runs_off_bat = Column(Integer, default=0, nullable=False)
    extras_type = Column(
        Enum("wide", "no_ball", "bye", "legbye", name="extras_type"), nullable=True
    )
    extras_runs = Column(Integer, default=0, nullable=False)

    # Wicket information
    wicket_type = Column(
        Enum(
            "bowled",
            "caught",
            "runout",
            "lbw",
            "stumped",
            "hit_wicket",
            name="wicket_type",
        ),
        nullable=True,
    )
    dismissal_info = Column(JSON, nullable=True)  # Detailed dismissal information

    # Additional metadata
    client_event_id = Column(
        String(100), nullable=True, index=True
    )  # For offline sync idempotency
    ball_metadata = Column("metadata", JSON, nullable=True)  # Additional ball metadata

    # Timestamps
    created_at = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )

    # Relationships
    innings = relationship("Innings", back_populates="balls")
    batsman = relationship("User", foreign_keys=[batsman_id])
    non_striker = relationship("User", foreign_keys=[non_striker_id])
    bowler = relationship("User", foreign_keys=[bowler_id])

    def __repr__(self):
        return f"<Ball(id={self.id}, innings={self.innings_id}, over={self.over_number}.{self.ball_in_over})>"

    def to_dict(self):
        """Convert ball to dictionary."""
        return {
            "id": self.id,
            "innings_id": self.innings_id,
            "over_number": self.over_number,
            "ball_in_over": self.ball_in_over,
            "batsman_id": self.batsman_id,
            "non_striker_id": self.non_striker_id,
            "bowler_id": self.bowler_id,
            "runs_off_bat": self.runs_off_bat,
            "extras_type": self.extras_type,
            "extras_runs": self.extras_runs,
            "wicket_type": self.wicket_type,
            "dismissal_info": self.dismissal_info,
            "client_event_id": self.client_event_id,
            "metadata": self.metadata,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }

    @property
    def total_runs(self):
        """Calculate total runs from this ball."""
        return self.runs_off_bat + self.extras_runs

    @property
    def is_legal_delivery(self):
        """Check if this is a legal delivery (not wide or no-ball)."""
        return self.extras_type not in ["wide", "no_ball"]
