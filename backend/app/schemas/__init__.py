# Import all schemas for easy access
from app.schemas.auth import (
    EmailLoginRequest,
    LogoutResponse,
    RefreshTokenRequest,
    RegisterRequest,
    TokenResponse,
    UserLoginResponse,
)
from app.schemas.ball import (
    BallBase,
    BallCreate,
    BallResponse,
    BallUpdate,
    ExtrasType,
    WicketType,
)
from app.schemas.innings import (
    BattingTeam,
    InningsBase,
    InningsCreate,
    InningsResponse,
    InningsUpdate,
)
from app.schemas.leaderboard import (
    LeaderboardEntry,
    LeaderboardFilter,
    LeaderboardResponse,
    LeaderboardType,
    TimePeriod,
)
from app.schemas.match import (
    AddPlayerRequest,
    MatchCreate,
    MatchInDB,
    MatchInviteAccept,
    MatchInviteRequest,
    MatchListResponse,
    MatchResponse,
    MatchResult,
    MatchRules,
    MatchStatus,
    MatchType,
    MatchUpdate,
    RulesApprovalResponse,
    RulesProposalRequest,
    ScorerPermission,
    TeamReadyRequest,
    TossDecision,
    TossUpdate,
)
from app.schemas.match_event import (
    EventType,
    MatchEventBase,
    MatchEventCreate,
    MatchEventResponse,
)
from app.schemas.notification import (
    NotificationBase,
    NotificationCreate,
    NotificationPriority,
    NotificationResponse,
    NotificationStatus,
    NotificationType,
    NotificationUpdate,
)
from app.schemas.otp import OTPCreate, OTPResponse, OTPVerify
from app.schemas.players_in_match import (
    MatchTeam,
    PlayerInMatchBase,
    PlayerInMatchCreate,
    PlayerInMatchResponse,
    PlayerInMatchUpdate,
    PlayerRole,
)
from app.schemas.profile import BattingStyle, BowlingStyle, DominantHand
from app.schemas.profile import PlayerRole as ProfilePlayerRole
from app.schemas.profile import (
    ProfileBase,
    ProfileCreate,
    ProfileResponse,
    ProfileStats,
    ProfileUpdate,
)
from app.schemas.search import MatchSearchResponse, SearchResponse, UserSearchResponse
from app.schemas.user import (
    UserBase,
    UserCreate,
    UserInDB,
    UserProfileResponse,
    UserResponse,
    UserRole,
    UserUpdate,
)

# Export all schemas
__all__ = [
    # User schemas
    "UserRole",
    "UserBase",
    "UserCreate",
    "UserUpdate",
    "UserInDB",
    "UserResponse",
    "UserProfileResponse",
    # Profile schemas
    "BattingStyle",
    "BowlingStyle",
    "DominantHand",
    "ProfilePlayerRole",
    "ProfileBase",
    "ProfileCreate",
    "ProfileUpdate",
    "ProfileStats",
    "ProfileResponse",
    # Match schemas
    "MatchType",
    "MatchStatus",
    "TossDecision",
    "ScorerPermission",
    "MatchRules",
    "MatchResult",
    "MatchCreate",
    "MatchUpdate",
    "TossUpdate",
    "MatchInviteRequest",
    "MatchInviteAccept",
    "AddPlayerRequest",
    "TeamReadyRequest",
    "RulesProposalRequest",
    "RulesApprovalResponse",
    "MatchInDB",
    "MatchResponse",
    "MatchListResponse",
    # Players in match schemas
    "MatchTeam",
    "PlayerRole",
    "PlayerInMatchBase",
    "PlayerInMatchCreate",
    "PlayerInMatchUpdate",
    "PlayerInMatchResponse",
    # Innings schemas
    "BattingTeam",
    "InningsBase",
    "InningsCreate",
    "InningsUpdate",
    "InningsResponse",
    # Ball schemas
    "ExtrasType",
    "WicketType",
    "BallBase",
    "BallCreate",
    "BallUpdate",
    "BallResponse",
    # Match event schemas
    "EventType",
    "MatchEventBase",
    "MatchEventCreate",
    "MatchEventResponse",
    # Notification schemas
    "NotificationType",
    "NotificationStatus",
    "NotificationPriority",
    "NotificationBase",
    "NotificationCreate",
    "NotificationUpdate",
    "NotificationResponse",
    # OTP schemas
    "OTPCreate",
    "OTPVerify",
    "OTPResponse",
    # Auth schemas
    "TokenResponse",
    "RefreshTokenRequest",
    "UserLoginResponse",
    "LogoutResponse",
    "RegisterRequest",
    "EmailLoginRequest",
    # Leaderboard schemas
    "LeaderboardType",
    "LeaderboardFilter",
    "TimePeriod",
    "LeaderboardEntry",
    "LeaderboardResponse",
    # Search schemas
    "UserSearchResponse",
    "MatchSearchResponse",
    "SearchResponse",
]
