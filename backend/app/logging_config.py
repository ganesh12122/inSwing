import structlog
import logging
import sys
from datetime import datetime
from typing import Any, Dict


def configure_logging():
    """Configure structured logging for the application."""
    
    # Configure standard logging
    logging.basicConfig(
        format="%(message)s",
        stream=sys.stdout,
        level=logging.INFO,
    )
    
    # Configure structlog
    structlog.configure(
        processors=[
            structlog.stdlib.filter_by_level,
            structlog.stdlib.add_logger_name,
            structlog.stdlib.add_log_level,
            structlog.stdlib.PositionalArgumentsFormatter(),
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.processors.StackInfoRenderer(),
            structlog.processors.format_exc_info,
            structlog.processors.UnicodeDecoder(),
            structlog.processors.JSONRenderer()
        ],
        context_class=dict,
        logger_factory=structlog.stdlib.LoggerFactory(),
        wrapper_class=structlog.stdlib.BoundLogger,
        cache_logger_on_first_use=True,
    )


def get_logger(name: str = None):
    """Get a structured logger instance."""
    return structlog.get_logger(name)


class RequestLoggingMiddleware:
    """Middleware for logging HTTP requests and responses."""
    
    def __init__(self, app):
        self.app = app
        self.logger = get_logger("request")
    
    async def __call__(self, scope, receive, send):
        if scope["type"] != "http":
            await self.app(scope, receive, send)
            return
        
        # Log request
        request_id = self._generate_request_id()
        start_time = datetime.utcnow()
        
        self.logger.info(
            "Request started",
            request_id=request_id,
            method=scope["method"],
            path=scope["path"],
            query_string=scope.get("query_string", b"").decode(),
            client=scope.get("client"),
        )
        
        # Wrap the send function to capture response
        async def wrapped_send(message):
            if message["type"] == "http.response.start":
                # Log response
                duration = (datetime.utcnow() - start_time).total_seconds()
                self.logger.info(
                    "Request completed",
                    request_id=request_id,
                    status_code=message["status"],
                    duration_seconds=duration,
                )
            
            await send(message)
        
        try:
            await self.app(scope, receive, wrapped_send)
        except Exception as e:
            duration = (datetime.utcnow() - start_time).total_seconds()
            self.logger.error(
                "Request failed",
                request_id=request_id,
                error=str(e),
                duration_seconds=duration,
            )
            raise
    
    def _generate_request_id(self) -> str:
        """Generate a unique request ID."""
        import uuid
        return str(uuid.uuid4())


class DatabaseQueryLogger:
    """Logger for database queries."""
    
    def __init__(self):
        self.logger = get_logger("database")
    
    def log_query(self, query: str, duration: float, **kwargs):
        """Log a database query."""
        self.logger.info(
            "Database query executed",
            query=query,
            duration_seconds=duration,
            **kwargs
        )
    
    def log_slow_query(self, query: str, duration: float, threshold: float = 1.0, **kwargs):
        """Log a slow database query."""
        if duration > threshold:
            self.logger.warning(
                "Slow database query detected",
                query=query,
                duration_seconds=duration,
                threshold_seconds=threshold,
                **kwargs
            )


# Global database query logger instance
db_logger = DatabaseQueryLogger()