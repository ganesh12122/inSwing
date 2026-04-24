from typing import Optional

import structlog
from app.auth import get_user_id_from_token
from app.database import get_async_db
from app.models.user import User
from app.schemas.user import UserRole
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

logger = structlog.get_logger()

# Security scheme for JWT tokens
security = HTTPBearer()
optional_security = HTTPBearer(auto_error=False)


def get_current_user_id(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> str:
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


async def get_current_user(
    db: AsyncSession = Depends(get_async_db),
    user_id: str = Depends(get_current_user_id),
) -> User:
    """Get current user from database."""
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()

    if not user:
        logger.warning("User not found", user_id=user_id)
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )

    if not user.is_active:  # type: ignore[truthy-bool]
        logger.warning("Inactive user attempted access", user_id=user_id)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="User account is inactive"
        )

    return user


async def get_current_active_user(
    current_user: User = Depends(get_current_user),
) -> User:
    """Get current active user (alias for get_current_user)."""
    return current_user


def require_role(required_role: UserRole):
    """Dependency factory for role-based authorization."""

    async def role_checker(current_user: User = Depends(get_current_user)) -> User:
        if current_user.role != required_role:  # type: ignore[truthy-bool]
            logger.warning(
                "Insufficient permissions",
                user_id=current_user.id,
                user_role=current_user.role,
                required_role=required_role,
            )
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"This action requires {required_role} role",
            )
        return current_user

    return role_checker


async def require_host_role(current_user: User = Depends(get_current_user)) -> User:
    """
    Require any authenticated active user (match host check is done per-endpoint).

    Note: This verifies the user is authenticated and active.
    Individual endpoints must verify match.host_user_id == current_user.id
    for host-specific actions.
    """
    return current_user


async def require_admin_role(current_user: User = Depends(get_current_user)) -> User:
    """Require admin role."""
    if current_user.role != UserRole.admin:  # type: ignore[truthy-bool]
        logger.warning(
            "Admin role required", user_id=current_user.id, user_role=current_user.role
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This action requires admin privileges",
        )
    return current_user


async def get_optional_current_user(
    db: AsyncSession = Depends(get_async_db),
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(optional_security),
) -> Optional[User]:
    """Get current user if authenticated, None otherwise."""
    if not credentials:
        return None

    try:
        user_id = get_user_id_from_token(credentials.credentials)
        if user_id:
            result = await db.execute(select(User).where(User.id == user_id))
            user = result.scalars().first()
            if user and user.is_active:  # type: ignore[truthy-bool]
                return user
    except Exception as e:
        logger.debug("Optional user authentication failed", error=str(e))

    return None
