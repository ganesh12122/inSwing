from fastapi import APIRouter

from app.api import auth, users, matches, balls, leaderboards, notifications, search, websocket

# Create main API router
api_router = APIRouter()

# Include all sub-routers with their respective prefixes
api_router.include_router(auth.router, prefix="/auth", tags=["Authentication"])
api_router.include_router(users.router, prefix="/users", tags=["Users"])
api_router.include_router(matches.router, prefix="/matches", tags=["Matches"])
api_router.include_router(balls.router, prefix="/matches", tags=["Scoring"])
api_router.include_router(leaderboards.router, prefix="/leaderboards", tags=["Leaderboards"])
api_router.include_router(notifications.router, prefix="/notifications", tags=["Notifications"])
api_router.include_router(search.router, prefix="/search", tags=["Search"])
api_router.include_router(websocket.router, prefix="/ws", tags=["WebSocket"])

# Health check endpoint
@api_router.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "service": "inSwing API"}

# API info endpoint
@api_router.get("/info")
async def api_info():
    """Get API information."""
    return {
        "name": "inSwing Cricket Scoring API",
        "version": "1.0.0",
        "description": "Real-time cricket scoring and tournament management platform",
        "endpoints": {
            "authentication": "/api/v1/auth",
            "users": "/api/v1/users",
            "matches": "/api/v1/matches",
            "scoring": "/api/v1/matches/{match_id}/innings",
            "leaderboards": "/api/v1/leaderboards",
            "notifications": "/api/v1/notifications",
            "search": "/api/v1/search",
            "websocket": "/api/v1/ws/{token}"
        }
    }