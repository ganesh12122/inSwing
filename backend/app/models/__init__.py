# Import all models to ensure they're registered with SQLAlchemy
from app.models.user import User
from app.models.profile import Profile
from app.models.match import Match
from app.models.players_in_match import PlayersInMatch
from app.models.innings import Innings
from app.models.ball import Ball
from app.models.match_event import MatchEvent
from app.models.notification import Notification
from app.models.otp_session import OTPSession

# Export all models
__all__ = [
    "User",
    "Profile", 
    "Match",
    "PlayersInMatch",
    "Innings",
    "Ball",
    "MatchEvent",
    "Notification",
    "OTPSession"
]