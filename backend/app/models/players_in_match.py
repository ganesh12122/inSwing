from uuid import uuid4

from app.database import Base
from sqlalchemy import Boolean, Column, DateTime, Enum, ForeignKey, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func


class PlayersInMatch(Base):
    """Junction table for players participating in matches.

    Supports both registered app users and guest players (non-app users).
    Each captain adds players to their own team in dual-captain mode.
    """

    __tablename__ = "players_in_match"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid4()))
    match_id = Column(
        String(36),
        ForeignKey("matches.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    # Nullable for guest players who don't have an app account
    user_id = Column(
        String(36),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=True,
        index=True,
    )

    # Player role in this specific match
    team = Column(Enum("A", "B", name="match_team"), nullable=False, index=True)
    role = Column(
        Enum(
            "captain", "batsman", "bowler", "allrounder", "wicketkeeper",
            name="player_role_v2",
        ),
        default="batsman",
        nullable=False,
    )

    # === GUEST PLAYER SUPPORT ===
    is_guest = Column(Boolean, default=False, nullable=False)
    guest_name = Column(String(255), nullable=True)  # Name for non-app users

    # === WHO ADDED THIS PLAYER ===
    added_by = Column(
        String(36),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )

    # Join timestamp
    joined_at = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )

    # === RELATIONSHIPS ===
    match = relationship("Match", back_populates="players")
    user = relationship(
        "User",
        back_populates="match_participations",
        foreign_keys=[user_id],
    )
    added_by_user = relationship(
        "User",
        foreign_keys=[added_by],
    )

    def __repr__(self):
        player_name = self.guest_name if self.is_guest else f"user:{self.user_id}"
        return f"<PlayersInMatch(id={self.id}, match={self.match_id}, player={player_name}, team={self.team})>"

    def to_dict(self):
        """Convert player in match to dictionary."""
        return {
            "id": self.id,
            "match_id": self.match_id,
            "user_id": self.user_id,
            "team": self.team,
            "role": self.role,
            "is_guest": self.is_guest,
            "guest_name": self.guest_name,
            "added_by": self.added_by,
            "joined_at": self.joined_at.isoformat() if self.joined_at else None,
        }

    @property
    def display_name(self) -> str:
        """Get display name - guest_name for guests, requires user load for app users."""
        if self.is_guest:
            return self.guest_name or "Unknown Player"
        if self.user:
            return self.user.full_name
        return "Unknown Player"
