from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_
from typing import List, Optional
import structlog

from app.database import get_db
from app.dependencies import get_current_user, get_optional_current_user, require_admin_role
from app.models.user import User
from app.models.profile import Profile
from app.schemas import (
    UserCreate,
    UserResponse,
    UserUpdate,
    UserProfileResponse,
    ProfileCreate,
    ProfileUpdate,
    ProfileResponse
)

logger = structlog.get_logger()
router = APIRouter()


@router.post("/", response_model=UserResponse)
async def create_user(
    user_data: UserCreate,
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_current_user)
):
    """
    Create a new user.
    Only admins can create users directly. Regular users should use auth/login.
    """
    if current_user and current_user.role != "admin":
        logger.warning("Non-admin user attempted to create user", user_id=current_user.id)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can create users directly"
        )
    
    # Check if user already exists
    existing_user = db.query(User).filter(
        or_(
            User.phone_number == user_data.phone_number,
            User.email == user_data.email
        )
    ).first()
    
    if existing_user:
        if existing_user.phone_number == user_data.phone_number:
            logger.warning("User creation failed - phone number exists", phone=user_data.phone_number)
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="User with this phone number already exists"
            )
        if existing_user.email == user_data.email:
            logger.warning("User creation failed - email exists", email=user_data.email)
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="User with this email already exists"
            )
    
    # Create user
    user = User(
        phone_number=user_data.phone_number,
        email=user_data.email,
        full_name=user_data.full_name,
        bio=user_data.bio,
        role="player",  # Default role
        is_active=True,
        is_verified=False
    )
    
    db.add(user)
    db.commit()
    db.refresh(user)
    
    # Create default profile
    profile = Profile(user_id=user.id)
    db.add(profile)
    db.commit()
    
    logger.info("User created successfully", user_id=user.id, phone=user.phone_number)
    
    return user


@router.get("/{user_id}/profile", response_model=UserProfileResponse)
async def get_user_profile(
    user_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get user profile with statistics."""
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        logger.warning("User not found", requested_user_id=user_id, current_user_id=current_user.id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    
    logger.info("User profile retrieved", user_id=user_id, requested_by=current_user.id)
    
    return UserProfileResponse(
        user=user,
        profile=profile
    )


@router.put("/{user_id}/profile", response_model=UserResponse)
async def update_user_profile(
    user_id: str,
    user_update: UserUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update user profile information."""
    # Check permissions
    if current_user.id != user_id and current_user.role != "admin":
        logger.warning("Unauthorized profile update attempt", 
                      current_user_id=current_user.id, 
                      target_user_id=user_id)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You can only update your own profile"
        )
    
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        logger.warning("User not found for update", user_id=user_id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Update fields if provided
    if user_update.email is not None:
        # Check if email is already taken by another user
        existing_user = db.query(User).filter(
            User.email == user_update.email,
            User.id != user_id
        ).first()
        
        if existing_user:
            logger.warning("Email already taken", email=user_update.email, user_id=user_id)
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already taken by another user"
            )
        
        user.email = user_update.email
    
    if user_update.full_name is not None:
        user.full_name = user_update.full_name
    
    if user_update.bio is not None:
        user.bio = user_update.bio
    
    if user_update.avatar_url is not None:
        user.avatar_url = user_update.avatar_url
    
    db.commit()
    db.refresh(user)
    
    logger.info("User profile updated", user_id=user_id, updated_by=current_user.id)
    
    return user


@router.get("/search", response_model=List[UserProfileResponse])
async def search_users(
    name: Optional[str] = Query(None, min_length=1, max_length=100),
    phone: Optional[str] = Query(None, min_length=7, max_length=15),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Search users by name or phone number."""
    query = db.query(User)
    
    if name:
        # Search by name (case-insensitive partial match)
        query = query.filter(User.full_name.ilike(f"%{name}%"))
    
    if phone:
        # Search by phone (partial match)
        query = query.filter(User.phone_number.ilike(f"%{phone}%"))
    
    if not name and not phone:
        logger.warning("Empty search query", user_id=current_user.id)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Please provide either name or phone number to search"
        )
    
    users = query.filter(User.is_active == True).limit(limit).all()
    
    # Get profiles for users
    user_ids = [user.id for user in users]
    profiles = db.query(Profile).filter(Profile.user_id.in_(user_ids)).all()
    profile_map = {profile.user_id: profile for profile in profiles}
    
    results = []
    for user in users:
        results.append(UserProfileResponse(
            user=user,
            profile=profile_map.get(user.id)
        ))
    
    logger.info("User search completed", 
                query_name=name, 
                query_phone=phone, 
                result_count=len(results),
                user_id=current_user.id)
    
    return results