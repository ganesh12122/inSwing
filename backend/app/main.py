import os
import sys
from contextlib import asynccontextmanager

import structlog
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware

# Add the backend directory to Python path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Ensure all models are registered with SQLAlchemy for Alembic
import app.models  # noqa: F401
from app.api import api_router
from app.database import engine
from app.error_handlers import register_exception_handlers
from app.logging_config import RequestLoggingMiddleware, configure_logging
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

    # Auto-create tables for SQLite dev mode (no Alembic migration needed)
    if settings.DATABASE_URL.startswith("sqlite"):
        from app.database import Base, engine

        Base.metadata.create_all(bind=engine)
        logger.info("SQLite tables created automatically (dev mode)")

    yield
    # Shutdown
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
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))
    except Exception:
        db_ok = False

    return {
        "status": "healthy" if db_ok else "degraded",
        "service": "inSwing-backend",
        "version": "1.0.0",
        "database": "up" if db_ok else "down",
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app", host="0.0.0.0", port=8000, reload=settings.DEBUG, log_level="info"
    )
