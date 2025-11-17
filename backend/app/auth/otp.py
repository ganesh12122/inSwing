import random
import string
from datetime import datetime, timedelta
from typing import Optional
import structlog

from app.settings import settings

logger = structlog.get_logger()


def generate_otp(length: int = None) -> str:
    """Generate a random OTP code."""
    if length is None:
        length = settings.OTP_LENGTH
    
    # Generate numeric OTP
    otp = ''.join(random.choices(string.digits, k=length))
    logger.info("OTP generated", length=length)
    return otp


def generate_expires_at(minutes: int = None) -> datetime:
    """Generate expiration time for OTP."""
    if minutes is None:
        minutes = settings.OTP_EXPIRE_MINUTES
    
    return datetime.utcnow() + timedelta(minutes=minutes)


def is_valid_phone_number(phone: str) -> bool:
    """Validate phone number format."""
    if not phone:
        return False
    
    # Remove spaces and common separators
    phone = phone.replace(' ', '').replace('-', '').replace('(', '').replace(')', '')
    
    # Check if it starts with + and has valid length
    if phone.startswith('+'):
        return len(phone) >= 8 and len(phone) <= 15 and phone[1:].isdigit()
    else:
        return len(phone) >= 7 and len(phone) <= 14 and phone.isdigit()


def format_phone_number(phone: str) -> str:
    """Format phone number to standard format."""
    if not phone:
        return phone
    
    # Remove all non-digit characters except +
    formatted = ''.join(c for c in phone if c.isdigit() or c == '+')
    
    # Add + if not present and number doesn't start with 0
    if not formatted.startswith('+') and not formatted.startswith('0'):
        formatted = '+' + formatted
    
    return formatted


def validate_otp_code(code: str, expected_length: int = None) -> bool:
    """Validate OTP code format."""
    if expected_length is None:
        expected_length = settings.OTP_LENGTH
    
    if not code:
        return False
    
    # Check if it's all digits and correct length
    return code.isdigit() and len(code) == expected_length