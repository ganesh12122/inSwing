from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class OTPCreate(BaseModel):
    """Schema for OTP creation request."""
    phone_number: str = Field(..., pattern=r'^\+?[1-9]\d{1,14}$', description="Phone number in E.164 format")


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