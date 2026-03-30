from uuid import uuid4

from app.database import Base
from sqlalchemy import Column, DateTime, Integer, String
from sqlalchemy.sql import func


class OTPSession(Base):
    """OTP session for phone number verification."""

    __tablename__ = "otp_sessions"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid4()))
    phone_number = Column(String(15), nullable=False, index=True)

    # OTP information
    otp_code = Column(String(6), nullable=False)
    attempts = Column(Integer, default=0, nullable=False)

    # Expiration
    expires_at = Column(DateTime(timezone=True), nullable=False, index=True)

    # Timestamps
    created_at = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )

    def __repr__(self):
        return f"<OTPSession(id={self.id}, phone={self.phone_number}, attempts={self.attempts})>"

    def to_dict(self):
        """Convert OTP session to dictionary."""
        return {
            "id": self.id,
            "phone_number": self.phone_number,
            "attempts": self.attempts,
            "expires_at": self.expires_at.isoformat() if self.expires_at else None,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }

    @property
    def is_expired(self):
        """Check if OTP session has expired."""
        from datetime import datetime, timezone

        return datetime.now(timezone.utc) > self.expires_at

    def increment_attempts(self):
        """Increment attempt counter."""
        self.attempts += 1
