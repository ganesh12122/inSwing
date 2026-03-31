from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class OTPCreate(BaseModel):
    """Schema for OTP creation request."""

    phone_number: str = Field(
        ..., description="Phone number (raw digits or E.164 format)"
    )


class OTPVerify(BaseModel):
    """Schema for OTP verification request."""

    session_id: str
    otp_code: str = Field(..., min_length=4, max_length=6)


class OTPResponse(BaseModel):
    """Schema for OTP response."""

    session_id: str
    message: str = "OTP sent successfully"
    expires_in: int  # seconds until OTP expires
    attempts_remaining: int = 3  # remaining OTP attempts
    otp_code: Optional[str] = None  # Only returned in DEBUG mode (dev convenience)
