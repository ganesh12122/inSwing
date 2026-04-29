import os
import sys
from contextlib import asynccontextmanager

import structlog
from fastapi import FastAPI, Request, Response
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from starlette.middleware.base import BaseHTTPMiddleware

# Add the backend directory to Python path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Ensure all models are registered with SQLAlchemy for Alembic
import app.models  # noqa: F401
from app.api import api_router
from app.database import async_engine, engine
from app.error_handlers import register_exception_handlers
from app.logging_config import RequestLoggingMiddleware, configure_logging
from app.services.redis_service import redis_service
from app.settings import settings
from sqlalchemy import text

# Configure logging
configure_logging()
logger = structlog.get_logger()


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan events."""
    # Startup
    logger.info("Starting inSwing backend application")

    # Connect Redis
    await redis_service.connect()

    # Auto-create tables for SQLite dev mode (no Alembic migration needed)
    if settings.DATABASE_URL.startswith("sqlite"):
        from app.database import Base, engine

        Base.metadata.create_all(bind=engine)
        logger.info("SQLite tables created automatically (dev mode)")

    yield
    # Shutdown
    await redis_service.disconnect()
    logger.info("Shutting down inSwing backend application")


# Create FastAPI app
app = FastAPI(
    title="inSwing Cricket Scoring API",
    description="Real-time cricket scoring and tournament management platform",
    version="1.0.0",
    docs_url="/docs" if settings.ENVIRONMENT.lower() != "production" else None,
    redoc_url="/redoc" if settings.ENVIRONMENT.lower() != "production" else None,
    openapi_url=(
        "/openapi.json" if settings.ENVIRONMENT.lower() != "production" else None
    ),
    lifespan=lifespan,
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=["*"],
    expose_headers=["*"],
    max_age=3600,  # 1 hour cache for preflight requests
)

# Add trusted host middleware
app.add_middleware(TrustedHostMiddleware, allowed_hosts=settings.ALLOWED_HOSTS)

# Add request logging middleware
app.add_middleware(RequestLoggingMiddleware)


# Rate limiting middleware
class RateLimitMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Skip rate limiting for health checks, docs, and WebSocket
        if request.url.path in ("/health", "/docs", "/redoc", "/openapi.json", "/"):
            return await call_next(request)
        if request.url.path.startswith("/api/v1/ws"):
            return await call_next(request)
        # Skip when Redis is not available (dev/test without Redis)
        if not redis_service.available:
            return await call_next(request)

        client_ip = request.client.host if request.client else "unknown"
        allowed, count = await redis_service.check_rate_limit(
            client_ip, settings.RATE_LIMIT_PER_MINUTE, 60
        )

        if not allowed:
            return Response(
                content='{"detail":"Rate limit exceeded. Try again later."}',
                status_code=429,
                media_type="application/json",
                headers={"Retry-After": "60"},
            )

        response = await call_next(request)
        response.headers["X-RateLimit-Limit"] = str(settings.RATE_LIMIT_PER_MINUTE)
        response.headers["X-RateLimit-Remaining"] = str(
            max(0, settings.RATE_LIMIT_PER_MINUTE - count)
        )
        return response


app.add_middleware(RateLimitMiddleware)

# Register exception handlers
register_exception_handlers(app)

# Include all API routers
app.include_router(api_router, prefix="/api/v1")


@app.get("/")
async def root():
    """Root endpoint with API information."""
    return {
        "message": "Welcome to inSwing Cricket Scoring API",
        "version": "1.0.0",
        "docs": "/docs",
        "health": "/health",
    }


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    db_ok = True
    try:
        async with async_engine.connect() as connection:
            await connection.execute(text("SELECT 1"))
    except Exception:
        db_ok = False

    return {
        "status": "healthy" if db_ok else "degraded",
        "service": "inSwing-backend",
        "version": "1.0.0",
        "database": "up" if db_ok else "down",
        "redis": "up" if redis_service.available else "down",
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app", host="0.0.0.0", port=8000, reload=settings.DEBUG, log_level="info"
    )
