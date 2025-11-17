from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class TokenResponse(BaseModel):
    """Schema for JWT token response."""
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int  # seconds


class RefreshTokenRequest(BaseModel):
    """Schema for refresh token request."""
    refresh_token: str


class UserLoginResponse(BaseModel):
    """Schema for user login response."""
    user: dict  # User data
    tokens: TokenResponse
    message: str = "Login successful"


class LogoutResponse(BaseModel):
    """Schema for logout response."""
    message: str = "Logout successful"