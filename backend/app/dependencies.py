from typing import Optional, Generator
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
import structlog

from app.database import get_db
from app.auth import verify_token, get_user_id_from_token
from app.models.user import User
from app.schemas.user import UserRole

logger = structlog.get_logger()

# Security scheme for JWT tokens
security = HTTPBearer()


def get_current_user_id(credentials: HTTPAuthorizationCredentials = Depends(security)) -> str:
    """Get current user ID from JWT token."""
    token = credentials.credentials
    user_id = get_user_id_from_token(token)
    
    if not user_id:
        logger.warning("Invalid or expired token")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    return user_id


def get_current_user(
    db: Session = Depends(get_db),
    user_id: str = Depends(get_current_user_id)
) -> User:
    """Get current user from database."""
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        logger.warning("User not found", user_id=user_id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    if not user.is_active:
        logger.warning("Inactive user attempted access", user_id=user_id)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User account is inactive"
        )
    
    logger.info("Current user retrieved", user_id=user_id, role=user.role)
    return user


def get_current_active_user(current_user: User = Depends(get_current_user)) -> User:
    """Get current active user (alias for get_current_user)."""
    return current_user


def require_role(required_role: UserRole):
    """Dependency factory for role-based authorization."""
    def role_checker(current_user: User = Depends(get_current_user)) -> User:
        if current_user.role != required_role:
            logger.warning("Insufficient permissions", 
                         user_id=current_user.id, 
                         user_role=current_user.role, 
                         required_role=required_role)
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"This action requires {required_role} role"
            )
        return current_user
    return role_checker


def require_host_role(current_user: User = Depends(get_current_user)) -> User:
    """Require host or admin role."""
    if current_user.role not in [UserRole.player, UserRole.admin]:
        logger.warning("Host role required", user_id=current_user.id, user_role=current_user.role)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This action requires host privileges"
        )
    return current_user


def require_admin_role(current_user: User = Depends(get_current_user)) -> User:
    """Require admin role."""
    if current_user.role != UserRole.admin:
        logger.warning("Admin role required", user_id=current_user.id, user_role=current_user.role)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This action requires admin privileges"
        )
    return current_user


def get_optional_current_user(
    db: Session = Depends(get_db),
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(security)
) -> Optional[User]:
    """Get current user if authenticated, None otherwise."""
    if not credentials:
        return None
    
    try:
        user_id = get_user_id_from_token(credentials.credentials)
        if user_id:
            user = db.query(User).filter(User.id == user_id).first()
            if user and user.is_active:
                return user
    except Exception as e:
        logger.debug("Optional user authentication failed", error=str(e))
    
    return None