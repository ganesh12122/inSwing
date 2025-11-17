from datetime import datetime, timedelta
from typing import Optional, Union
from jose import JWTError, jwt
import structlog

from app.settings import settings

logger = structlog.get_logger()


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    """Create JWT access token."""
    to_encode = data.copy()
    
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire, "type": "access"})
    
    try:
        encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
        logger.info("Access token created", user_id=data.get("sub"), expires_at=expire)
        return encoded_jwt
    except Exception as e:
        logger.error("Failed to create access token", error=str(e))
        raise


def create_refresh_token(data: dict, expires_delta: Optional[timedelta] = None):
    """Create JWT refresh token."""
    to_encode = data.copy()
    
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
    
    to_encode.update({"exp": expire, "type": "refresh"})
    
    try:
        encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
        logger.info("Refresh token created", user_id=data.get("sub"), expires_at=expire)
        return encoded_jwt
    except Exception as e:
        logger.error("Failed to create refresh token", error=str(e))
        raise


def verify_token(token: str, token_type: str = "access") -> Optional[dict]:
    """Verify JWT token and return payload."""
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        
        # Check token type
        if payload.get("type") != token_type:
            logger.warning("Token type mismatch", expected=token_type, actual=payload.get("type"))
            return None
        
        # Check expiration
        exp = payload.get("exp")
        if exp is None:
            logger.warning("Token missing expiration")
            return None
        
        if datetime.utcnow() > datetime.fromtimestamp(exp):
            logger.warning("Token expired", user_id=payload.get("sub"))
            return None
        
        logger.info("Token verified", user_id=payload.get("sub"), token_type=token_type)
        return payload
        
    except JWTError as e:
        logger.warning("JWT verification failed", error=str(e))
        return None
    except Exception as e:
        logger.error("Token verification error", error=str(e))
        return None


def decode_token(token: str) -> Optional[dict]:
    """Decode JWT token without verification (for debugging)."""
    try:
        return jwt.decode(token, options={"verify_signature": False})
    except Exception as e:
        logger.error("Failed to decode token", error=str(e))
        return None


def get_user_id_from_token(token: str) -> Optional[str]:
    """Extract user ID from JWT token."""
    payload = verify_token(token)
    if payload:
        return payload.get("sub")
    return None