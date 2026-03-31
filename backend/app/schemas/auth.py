from pydantic import BaseModel, Field, EmailStr
from typing import Optional
from datetime import datetime


class RegisterRequest(BaseModel):
    """Schema for user registration."""
    full_name: str = Field(..., min_length=2, max_length=100)
    email: EmailStr
    password: str = Field(..., min_length=6, max_length=128)
    phone_number: Optional[str] = None  # Optional for now


class EmailLoginRequest(BaseModel):
    """Schema for email + password login."""
    email: EmailStr
    password: str = Field(..., min_length=1)


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