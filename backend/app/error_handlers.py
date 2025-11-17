from fastapi import HTTPException, Request, status
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from sqlalchemy.exc import SQLAlchemyError
from pydantic import ValidationError
import structlog
from typing import Any, Dict
import traceback

logger = structlog.get_logger("error_handler")


class AppException(Exception):
    """Base exception class for application-specific errors."""
    
    def __init__(self, message: str, status_code: int = status.HTTP_400_BAD_REQUEST, details: Dict[str, Any] = None):
        self.message = message
        self.status_code = status_code
        self.details = details or {}
        super().__init__(self.message)


class AuthenticationException(AppException):
    """Exception for authentication-related errors."""
    
    def __init__(self, message: str = "Authentication failed", details: Dict[str, Any] = None):
        super().__init__(message, status.HTTP_401_UNAUTHORIZED, details)


class AuthorizationException(AppException):
    """Exception for authorization-related errors."""
    
    def __init__(self, message: str = "Access denied", details: Dict[str, Any] = None):
        super().__init__(message, status.HTTP_403_FORBIDDEN, details)


class ResourceNotFoundException(AppException):
    """Exception for resource not found errors."""
    
    def __init__(self, message: str = "Resource not found", details: Dict[str, Any] = None):
        super().__init__(message, status.HTTP_404_NOT_FOUND, details)


class ValidationException(AppException):
    """Exception for validation errors."""
    
    def __init__(self, message: str = "Validation failed", details: Dict[str, Any] = None):
        super().__init__(message, status.HTTP_422_UNPROCESSABLE_ENTITY, details)


class ConflictException(AppException):
    """Exception for resource conflict errors."""
    
    def __init__(self, message: str = "Resource conflict", details: Dict[str, Any] = None):
        super().__init__(message, status.HTTP_409_CONFLICT, details)


def create_error_response(message: str, status_code: int, details: Dict[str, Any] = None) -> Dict[str, Any]:
    """Create a standardized error response."""
    return {
        "error": {
            "message": message,
            "status_code": status_code,
            "details": details or {},
            "timestamp": logger._context.get("timestamp", "unknown")
        }
    }


async def app_exception_handler(request: Request, exc: AppException) -> JSONResponse:
    """Handle application-specific exceptions."""
    logger.error(
        "Application exception occurred",
        error_type=type(exc).__name__,
        message=exc.message,
        status_code=exc.status_code,
        details=exc.details,
        path=request.url.path,
        method=request.method
    )
    
    return JSONResponse(
        status_code=exc.status_code,
        content=create_error_response(exc.message, exc.status_code, exc.details)
    )


async def http_exception_handler(request: Request, exc: HTTPException) -> JSONResponse:
    """Handle HTTP exceptions."""
    logger.warning(
        "HTTP exception occurred",
        status_code=exc.status_code,
        detail=exc.detail,
        path=request.url.path,
        method=request.method
    )
    
    return JSONResponse(
        status_code=exc.status_code,
        content=create_error_response(exc.detail, exc.status_code)
    )


async def validation_exception_handler(request: Request, exc: RequestValidationError) -> JSONResponse:
    """Handle request validation exceptions."""
    logger.warning(
        "Request validation failed",
        errors=exc.errors(),
        path=request.url.path,
        method=request.method
    )
    
    # Format validation errors for better readability
    formatted_errors = []
    for error in exc.errors():
        formatted_errors.append({
            "field": " -> ".join(str(loc) for loc in error["loc"]),
            "message": error["msg"],
            "type": error["type"]
        })
    
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content=create_error_response(
            "Request validation failed",
            status.HTTP_422_UNPROCESSABLE_ENTITY,
            {"validation_errors": formatted_errors}
        )
    )


async def pydantic_validation_exception_handler(request: Request, exc: ValidationError) -> JSONResponse:
    """Handle Pydantic validation exceptions."""
    logger.warning(
        "Pydantic validation failed",
        errors=exc.errors(),
        path=request.url.path,
        method=request.method
    )
    
    # Format validation errors
    formatted_errors = []
    for error in exc.errors():
        formatted_errors.append({
            "field": " -> ".join(str(loc) for loc in error["loc"]),
            "message": error["msg"],
            "type": error["type"]
        })
    
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content=create_error_response(
            "Data validation failed",
            status.HTTP_422_UNPROCESSABLE_ENTITY,
            {"validation_errors": formatted_errors}
        )
    )


async def sqlalchemy_exception_handler(request: Request, exc: SQLAlchemyError) -> JSONResponse:
    """Handle SQLAlchemy database exceptions."""
    logger.error(
        "Database error occurred",
        error_type=type(exc).__name__,
        error_message=str(exc),
        path=request.url.path,
        method=request.method,
        traceback=traceback.format_exc()
    )
    
    # Determine appropriate status code based on error type
    status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
    message = "Database error occurred"
    
    if "IntegrityError" in type(exc).__name__:
        status_code = status.HTTP_409_CONFLICT
        message = "Database constraint violation"
    elif "OperationalError" in type(exc).__name__:
        status_code = status.HTTP_503_SERVICE_UNAVAILABLE
        message = "Database connection error"
    
    return JSONResponse(
        status_code=status_code,
        content=create_error_response(message, status_code, {"database_error": str(exc)})
    )


async def general_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    """Handle unexpected exceptions."""
    logger.error(
        "Unexpected exception occurred",
        error_type=type(exc).__name__,
        error_message=str(exc),
        path=request.url.path,
        method=request.method,
        traceback=traceback.format_exc()
    )
    
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content=create_error_response(
            "An unexpected error occurred",
            status.HTTP_500_INTERNAL_SERVER_ERROR,
            {"error_type": type(exc).__name__, "error_message": str(exc)}
        )
    )


def register_exception_handlers(app):
    """Register all exception handlers with the FastAPI app."""
    
    # Application-specific exceptions
    app.add_exception_handler(AppException, app_exception_handler)
    app.add_exception_handler(AuthenticationException, app_exception_handler)
    app.add_exception_handler(AuthorizationException, app_exception_handler)
    app.add_exception_handler(ResourceNotFoundException, app_exception_handler)
    app.add_exception_handler(ValidationException, app_exception_handler)
    app.add_exception_handler(ConflictException, app_exception_handler)
    
    # Framework exceptions
    app.add_exception_handler(HTTPException, http_exception_handler)
    app.add_exception_handler(RequestValidationError, validation_exception_handler)
    app.add_exception_handler(ValidationError, pydantic_validation_exception_handler)
    app.add_exception_handler(SQLAlchemyError, sqlalchemy_exception_handler)
    
    # General exception handler (should be last)
    app.add_exception_handler(Exception, general_exception_handler)
    
    logger.info("Exception handlers registered successfully")