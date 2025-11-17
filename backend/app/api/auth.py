from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import datetime, timedelta
from typing import Optional
import structlog

from app.database import get_db
from app.auth import (
    create_access_token, 
    create_refresh_token, 
    verify_token,
    generate_otp, 
    generate_expires_at,
    is_valid_phone_number,
    format_phone_number,
    validate_otp_code
)
from app.models.user import User
from app.models.otp_session import OTPSession
from app.schemas import (
    OTPCreate, 
    OTPVerify, 
    OTPResponse,
    TokenResponse,
    RefreshTokenRequest,
    UserLoginResponse,
    LogoutResponse,
    UserCreate,
    UserResponse
)
from app.dependencies import get_current_user, get_current_user_id

logger = structlog.get_logger()
router = APIRouter()


@router.post("/login", response_model=OTPResponse)
async def login(otp_request: OTPCreate, db: Session = Depends(get_db)):
    """
    Initiate login by sending OTP to phone number.
    Creates or updates user if phone number is valid.
    """
    phone = format_phone_number(otp_request.phone_number)
    
    if not is_valid_phone_number(phone):
        logger.warning("Invalid phone number format", phone=phone)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid phone number format"
        )
    
    # Check if user exists, create if not
    user = db.query(User).filter(User.phone_number == phone).first()
    if not user:
        # Create new user
        user = User(
            phone_number=phone,
            full_name=f"User {phone[-4:]}",  # Default name
            role="player"
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        logger.info("New user created", user_id=user.id, phone=phone)
    
    # Check for existing active OTP session
    existing_otp = db.query(OTPSession).filter(
        OTPSession.phone_number == phone,
        OTPSession.expires_at > datetime.utcnow()
    ).first()
    
    if existing_otp:
        # Check if max attempts reached
        if existing_otp.attempts >= settings.OTP_MAX_ATTEMPTS:
            logger.warning("Max OTP attempts reached", phone=phone, attempts=existing_otp.attempts)
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail="Maximum OTP attempts reached. Please try again later."
            )
        
        # Return existing OTP info
        logger.info("Existing OTP session returned", phone=phone, attempts=existing_otp.attempts)
        return OTPResponse(
            session_id=existing_otp.id,
            message="OTP already sent to your phone",
            expires_in=int((existing_otp.expires_at - datetime.utcnow()).total_seconds()),
            attempts_remaining=settings.OTP_MAX_ATTEMPTS - existing_otp.attempts
        )
    
    # Generate new OTP
    otp_code = generate_otp()
    expires_at = generate_expires_at()
    
    # Create new OTP session
    otp_session = OTPSession(
        phone_number=phone,
        otp_code=otp_code,
        expires_at=expires_at
    )
    db.add(otp_session)
    db.commit()
    
    # In a real implementation, you would send the OTP via SMS here
    # For now, we'll log it for development
    logger.info("OTP generated", phone=phone, otp_code=otp_code, expires_at=expires_at)
    
    return OTPResponse(
        session_id=otp_session.id,
        message="OTP sent to your phone",
        expires_in=int((expires_at - datetime.utcnow()).total_seconds()),
        attempts_remaining=settings.OTP_MAX_ATTEMPTS
    )


@router.post("/verify-otp", response_model=UserLoginResponse)
async def verify_otp(otp_verify: OTPVerify, db: Session = Depends(get_db)):
    """
    Verify OTP code and return JWT tokens.
    """
    phone = format_phone_number(otp_verify.phone_number)
    
    if not validate_otp_code(otp_verify.otp_code):
        logger.warning("Invalid OTP format", phone=phone)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid OTP format"
        )
    
    # Find active OTP session
    otp_session = db.query(OTPSession).filter(
        OTPSession.phone_number == phone,
        OTPSession.expires_at > datetime.utcnow()
    ).first()
    
    if not otp_session:
        logger.warning("No active OTP session found", phone=phone)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No active OTP session found or OTP expired"
        )
    
    # Check if max attempts reached
    if otp_session.attempts >= settings.OTP_MAX_ATTEMPTS:
        logger.warning("Max OTP attempts reached", phone=phone, attempts=otp_session.attempts)
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Maximum OTP attempts reached"
        )
    
    # Verify OTP code
    if otp_session.otp_code != otp_verify.otp_code:
        otp_session.increment_attempts()
        db.commit()
        
        logger.warning("Invalid OTP code", phone=phone, attempts=otp_session.attempts)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid OTP code. {settings.OTP_MAX_ATTEMPTS - otp_session.attempts} attempts remaining."
        )
    
    # OTP verified successfully
    user = db.query(User).filter(User.phone_number == phone).first()
    if not user:
        logger.error("User not found after OTP verification", phone=phone)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="User not found"
        )
    
    # Delete OTP session
    db.delete(otp_session)
    db.commit()
    
    # Create JWT tokens
    access_token = create_access_token(data={"sub": user.id})
    refresh_token = create_refresh_token(data={"sub": user.id})
    
    logger.info("OTP verified successfully", user_id=user.id, phone=phone)
    
    return UserLoginResponse(
        user=user.to_dict(),
        tokens=TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            token_type="bearer",
            expires_in=settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
        )
    )


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(refresh_request: RefreshTokenRequest):
    """
    Refresh expired access token using refresh token.
    """
    # Verify refresh token
    payload = verify_token(refresh_request.refresh_token, token_type="refresh")
    
    if not payload:
        logger.warning("Invalid or expired refresh token")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired refresh token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    user_id = payload.get("sub")
    if not user_id:
        logger.warning("Refresh token missing user ID")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token payload",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Create new tokens
    access_token = create_access_token(data={"sub": user_id})
    new_refresh_token = create_refresh_token(data={"sub": user_id})
    
    logger.info("Token refreshed", user_id=user_id)
    
    return TokenResponse(
        access_token=access_token,
        refresh_token=new_refresh_token,
        token_type="bearer",
        expires_in=settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
    )


@router.post("/logout", response_model=LogoutResponse)
async def logout(current_user_id: str = Depends(get_current_user_id)):
    """
    Logout user (invalidate tokens).
    In a real implementation, you might want to blacklist tokens.
    """
    logger.info("User logged out", user_id=current_user_id)
    
    return LogoutResponse(message="Logout successful")


# Import settings at the bottom to avoid circular imports
from app.settings import settings