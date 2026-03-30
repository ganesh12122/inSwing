# 🏗️ inSwing — Architecture Guide

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     CLIENT LAYER                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Android  │  │   iOS    │  │   Web    │  │ Desktop  │   │
│  │  App     │  │   App    │  │   App    │  │   App    │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
│       │              │              │              │         │
│       └──────────────┴──────┬───────┴──────────────┘         │
│                             │                                 │
│              ┌──────────────┴──────────────┐                 │
│              │     Flutter App (Dart)       │                 │
│              │  Riverpod + GoRouter + Dio   │                 │
│              │  Hive (offline) + WebSocket  │                 │
│              └──────────────┬──────────────┘                 │
└─────────────────────────────┼───────────────────────────────┘
                              │ HTTPS / WSS
┌─────────────────────────────┼───────────────────────────────┐
│                     API GATEWAY                              │
│              ┌──────────────┴──────────────┐                 │
│              │     FastAPI Application      │                 │
│              │   CORS + Rate Limiting +     │                 │
│              │   Auth Middleware + Logging   │                 │
│              └──────────────┬──────────────┘                 │
└─────────────────────────────┼───────────────────────────────┘
                              │
┌─────────────────────────────┼───────────────────────────────┐
│                   SERVICE LAYER                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Auth    │  │  Match   │  │ Scoring  │  │ Stats    │   │
│  │ Service  │  │ Service  │  │ Service  │  │ Service  │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
│       │              │              │              │         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Notif.   │  │Tournament│  │ Search   │  │Leaderbd. │   │
│  │ Service  │  │ Service  │  │ Service  │  │ Service  │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
└───────┼──────────────┼──────────────┼──────────────┼─────────┘
        │              │              │              │
┌───────┼──────────────┼──────────────┼──────────────┼─────────┐
│       │         DATA LAYER          │              │         │
│  ┌────┴─────────────────────────────┴──────────────┴────┐   │
│  │            SQLAlchemy ORM (Async)                     │   │
│  │            Alembic Migrations                         │   │
│  └──────────────────────┬───────────────────────────────┘   │
│                         │                                    │
│  ┌──────────────────────┼───────────────────────────────┐   │
│  │                      │                                │   │
│  │  ┌──────────┐  ┌─────┴────┐  ┌──────────┐           │   │
│  │  │PostgreSQL│  │  Redis   │  │Cloudflare│           │   │
│  │  │  (Neon)  │  │(Upstash) │  │   R2     │           │   │
│  │  │  Data    │  │  Cache   │  │  Files   │           │   │
│  │  └──────────┘  └──────────┘  └──────────┘           │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Backend Architecture

### Directory Structure

```
backend/
├── alembic/                  # Database migrations
│   ├── versions/             # Migration scripts
│   └── env.py                # Alembic configuration
├── app/
│   ├── main.py               # FastAPI app entry point
│   ├── settings.py           # Environment configuration
│   ├── database.py           # DB connection & session
│   ├── dependencies.py       # FastAPI dependency injection
│   ├── error_handlers.py     # Exception handlers
│   ├── logging_config.py     # Structured logging setup
│   ├── api/                  # Route handlers (thin controllers)
│   │   ├── __init__.py       # Router aggregation
│   │   ├── auth.py           # Login, OTP, token refresh
│   │   ├── users.py          # User CRUD, profiles
│   │   ├── matches.py        # Match CRUD, toss, status
│   │   ├── balls.py          # Ball-by-ball scoring, innings
│   │   ├── leaderboards.py   # Batting/bowling rankings
│   │   ├── notifications.py  # Push notification management
│   │   ├── search.py         # User & match search
│   │   └── websocket.py      # Real-time scoring updates
│   ├── auth/                 # Auth utilities
│   │   ├── jwt.py            # Token creation & verification
│   │   └── otp.py            # OTP generation & validation
│   ├── models/               # SQLAlchemy ORM models
│   │   ├── user.py           # User table
│   │   ├── profile.py        # Player profile & stats
│   │   ├── match.py          # Match table
│   │   ├── innings.py        # Innings table
│   │   ├── ball.py           # Ball-by-ball records
│   │   ├── players_in_match.py # Match roster
│   │   ├── match_event.py    # Match events log
│   │   ├── notification.py   # Notifications table
│   │   └── otp_session.py    # OTP sessions
│   ├── schemas/              # Pydantic validation schemas
│   │   ├── user.py, profile.py, match.py, ball.py, ...
│   │   ├── auth.py           # Token schemas
│   │   ├── leaderboard.py    # Leaderboard schemas
│   │   └── search.py         # Search schemas
│   └── services/             # Business logic layer (TO BE BUILT)
│       ├── match_service.py
│       ├── scoring_service.py
│       ├── stats_service.py
│       ├── notification_service.py
│       └── tournament_service.py
├── tests/                    # Pytest tests (TO BE BUILT)
├── requirements.txt
├── Dockerfile
└── docker-compose.yml
```

### API Route Map

```
/api/v1/
├── /auth
│   ├── POST /login              # Send OTP to phone
│   ├── POST /verify-otp         # Verify OTP → JWT tokens
│   ├── POST /refresh            # Refresh access token
│   └── POST /logout             # Invalidate tokens
├── /users
│   ├── POST /                   # Create user (admin)
│   ├── GET  /{user_id}/profile  # Get user profile
│   ├── PUT  /{user_id}/profile  # Update profile
│   └── GET  /search             # Search users
├── /matches
│   ├── POST /                   # Create match
│   ├── GET  /                   # List matches (filtered)
│   ├── GET  /{match_id}         # Match details
│   ├── PUT  /{match_id}/toss    # Record toss
│   ├── PUT  /{match_id}/status  # Update status
│   ├── DELETE /{match_id}       # Cancel match
│   ├── POST /{match_id}/players # Add player
│   ├── POST /{match_id}/innings # Create innings
│   ├── GET  /{match_id}/innings # Get all innings
│   ├── POST /{match_id}/innings/{id}/ball   # Record ball
│   ├── GET  /{match_id}/innings/{id}/balls  # Get balls
│   └── PUT  /{match_id}/innings/{id}/ball/{id}/undo  # Undo ball
├── /leaderboards
│   ├── GET  /batting            # Batting leaderboard
│   ├── GET  /bowling            # Bowling leaderboard
│   └── GET  /matches-hosted     # Hosting leaderboard
├── /notifications
│   ├── GET  /                   # Get notifications
│   ├── GET  /unread-count       # Unread count
│   ├── POST /                   # Create notification
│   ├── PUT  /{id}/read          # Mark as read
│   ├── PUT  /mark-all-read      # Mark all read
│   └── DELETE /{id}             # Delete notification
├── /search
│   ├── GET  /users              # Search users
│   └── GET  /matches            # Search matches
└── /ws
    └── WS  /{token}             # WebSocket connection
```

### Request/Response Flow

```
Client Request
     │
     ▼
[CORS Middleware]
     │
     ▼
[Request Logging Middleware]
     │
     ▼
[Rate Limiting Middleware] (TO BE ADDED)
     │
     ▼
[Route Handler (api/)]
     │
     ├── [Auth Dependency] → JWT verification
     │
     ├── [DB Dependency] → AsyncSession
     │
     ▼
[Service Layer] (TO BE ADDED)
     │
     ▼
[SQLAlchemy ORM]
     │
     ▼
[PostgreSQL / Redis]
     │
     ▼
[Pydantic Response Schema]
     │
     ▼
Client Response (JSON)
```

## Frontend Architecture

### Directory Structure

```
flutter/lib/
├── main.dart                 # App entry point
├── models/                   # Freezed data models
│   ├── user_model.dart       # User, UserProfile, PlayerStats
│   └── match_model.dart      # Match, Innings, Ball, PlayerInMatch
├── providers/                # Riverpod state management
│   ├── auth_provider.dart    # Authentication state
│   ├── matches_provider.dart # Match list state
│   ├── match_scoring_provider.dart # Live scoring state
│   ├── create_match_provider.dart  # Match creation state
│   ├── connectivity_provider.dart  # Network state
│   ├── offline_sync_provider.dart  # Offline queue
│   └── player_stats_provider.dart  # Player stats
├── routes/
│   └── app_router.dart       # GoRouter configuration
├── screens/                  # UI screens
│   ├── auth/                 # Login, OTP verification
│   ├── home/                 # Match list, tabs
│   ├── match/                # Create, detail, scoring
│   ├── player/               # Player profile
│   ├── profile/              # My profile
│   ├── scoring/              # Scoring UI
│   └── settings/             # App settings
├── services/
│   ├── api_service.dart      # Dio HTTP client
│   └── storage_service.dart  # Hive + SecureStorage
├── theme/
│   └── app_theme.dart        # Material 3 theme
├── utils/
│   └── constants.dart        # App constants
└── widgets/
    └── common/               # Reusable widgets
        ├── app_button.dart
        ├── app_text_field.dart
        ├── error_widget.dart
        ├── loading_widget.dart
        └── match_card_widget.dart
```

### State Management Flow

```
[UI Widget (ConsumerWidget)]
     │
     ▼
[Riverpod Provider (@riverpod)]
     │
     ├── reads → [ApiService] → HTTP/WebSocket → Backend
     │
     ├── reads → [StorageService] → Hive (offline data)
     │
     └── watches → [Other Providers] (reactive updates)
     │
     ▼
[State (Freezed immutable class)]
     │
     ▼
[UI rebuilds automatically]
```

### Offline-First Architecture

```
[User Action (record ball)]
     │
     ├── Online? ─── YES ──→ [API Call] → [Update Local Cache]
     │                                          │
     │                                          ▼
     │                                   [WebSocket Broadcast]
     │
     └── Online? ─── NO ──→ [Save to Offline Queue (Hive)]
                                     │
                                     ▼
                              [Connectivity Change]
                                     │
                                     ▼
                              [Sync Queue → API]
                                     │
                                     ▼
                              [Clear Queue]
```

## Database Schema (Entity Relationship)

```
┌──────────┐     ┌──────────────┐     ┌──────────┐
│  users   │────→│players_in_   │←────│ matches  │
│          │     │   match      │     │          │
│ id (PK)  │     │ user_id (FK) │     │ id (PK)  │
│ phone    │     │ match_id(FK) │     │ host_id  │
│ name     │     │ team (A/B)   │     │ team_a   │
│ email    │     │ role         │     │ team_b   │
│ role     │     └──────────────┘     │ status   │
│ is_active│                          │ rules    │
└────┬─────┘                          └────┬─────┘
     │                                     │
     │  1:1                                │ 1:N
     ▼                                     ▼
┌──────────┐                          ┌──────────┐
│ profiles │                          │ innings  │
│          │                          │          │
│ user_id  │                          │ match_id │
│ batting  │                          │ team     │
│ bowling  │                          │ runs     │
│ stats... │                          │ wickets  │
└──────────┘                          │ overs    │
                                      └────┬─────┘
     ┌──────────┐                          │ 1:N
     │  notifs  │                          ▼
     │          │                     ┌──────────┐
     │ user_id  │                     │  balls   │
     │ title    │                     │          │
     │ message  │                     │innings_id│
     │ status   │                     │batsman_id│
     └──────────┘                     │bowler_id │
                                      │runs_bat  │
     ┌──────────┐                     │extras    │
     │otp_sess. │                     │wicket    │
     │          │                     └──────────┘
     │ phone    │
     │ otp_code │                     ┌──────────┐
     │ expires  │                     │match_    │
     └──────────┘                     │ events   │
                                      │          │
                                      │ match_id │
                                      │ type     │
                                      │ data     │
                                      └──────────┘
```

## Security Architecture

```
[Client]
   │
   │ Phone Number
   ▼
[POST /auth/login] ──→ Generate OTP ──→ SMS (MSG91/Firebase)
   │
   │ OTP Code
   ▼
[POST /auth/verify-otp]
   │
   ├── Verify OTP
   ├── Create/Get User
   ├── Generate JWT Access Token (60 min)
   └── Generate JWT Refresh Token (7 days)
   │
   │ Access Token (Bearer)
   ▼
[All Protected Endpoints]
   │
   ├── HTTPBearer extracts token
   ├── verify_token() checks signature + expiry
   ├── get_current_user() loads user from DB
   └── Role checks (player/admin/host)
   │
   │ Token Expired?
   ▼
[POST /auth/refresh]
   │
   ├── Verify refresh token
   └── Issue new access + refresh tokens
```

## Deployment Architecture

```
┌─────────────────────────────────────────────────┐
│                 PRODUCTION                       │
│                                                  │
│  ┌──────────┐     ┌──────────────┐              │
│  │ Vercel   │     │Railway/Render│              │
│  │ (Web)    │────→│  (Backend)   │              │
│  └──────────┘     └──────┬───────┘              │
│                          │                       │
│  ┌──────────┐     ┌──────┴───────┐              │
│  │Play Store│     │              │              │
│  │App Store │     │    ┌─────────┴──────┐       │
│  │(Mobile)  │─────┤    │  Neon          │       │
│  └──────────┘     │    │  PostgreSQL    │       │
│                   │    └────────────────┘       │
│                   │                              │
│                   │    ┌────────────────┐       │
│                   │    │  Upstash       │       │
│                   ├───→│  Redis         │       │
│                   │    └────────────────┘       │
│                   │                              │
│                   │    ┌────────────────┐       │
│                   └───→│  Cloudflare R2 │       │
│                        │  (Files)       │       │
│                        └────────────────┘       │
│                                                  │
│  ┌──────────┐     ┌────────────────┐            │
│  │ GitHub   │────→│ GitHub Actions │            │
│  │ (Code)   │     │ (CI/CD)        │            │
│  └──────────┘     └────────────────┘            │
│                                                  │
│  ┌──────────┐     ┌────────────────┐            │
│  │ Sentry   │     │ PostHog        │            │
│  │(Errors)  │     │(Analytics)     │            │
│  └──────────┘     └────────────────┘            │
└─────────────────────────────────────────────────┘
```
