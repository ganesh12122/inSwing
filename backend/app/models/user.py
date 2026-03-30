from uuid import uuid4

from app.database import Base
from sqlalchemy import Boolean, Column, DateTime, Enum, String, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func


class User(Base):
    """User model for authentication and basic profile information."""

    __tablename__ = "users"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid4()))
    phone_number = Column(String(15), unique=True, nullable=False, index=True)
    email = Column(String(255), unique=True, nullable=True, index=True)
    full_name = Column(String(255), nullable=False)
    avatar_url = Column(String(500), nullable=True)
    bio = Column(Text, nullable=True)
    role = Column(
        Enum("player", "admin", name="user_role"), default="player", nullable=False
    )
    is_active = Column(Boolean, default=True, nullable=False)
    is_verified = Column(Boolean, default=False, nullable=False)
    created_at = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False  # type: ignore
    )
    updated_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),  # type: ignore
        onupdate=func.now(),  # type: ignore
        nullable=False,
    )

    # Relationships
    profile = relationship(
        "Profile", back_populates="user", uselist=False, cascade="all, delete-orphan"
    )
    hosted_matches = relationship(
        "Match", back_populates="host", foreign_keys="Match.host_user_id"
    )
    opponent_matches = relationship(
        "Match",
        back_populates="opponent_captain",
        foreign_keys="Match.opponent_captain_id",
    )
    match_participations = relationship(
        "PlayersInMatch",
        back_populates="user",
        foreign_keys="PlayersInMatch.user_id",
    )
    notifications = relationship("Notification", back_populates="user")

    def __repr__(self):
        return f"<User(id={self.id}, phone={self.phone_number}, name={self.full_name})>"

    def to_dict(self):
        """Convert user to dictionary."""
        return {
            "id": self.id,
            "phone_number": self.phone_number,
            "email": self.email,
            "full_name": self.full_name,
            "avatar_url": self.avatar_url,
            "bio": self.bio,
            "role": self.role,
            "is_active": self.is_active,
            "is_verified": self.is_verified,
            "created_at": self.created_at.isoformat() if self.created_at else None,  # type: ignore[union-attr]
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,  # type: ignore[union-attr]
        }
