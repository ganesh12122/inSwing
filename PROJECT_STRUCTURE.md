# inSwing Project Structure

```
inSwing/
├── flutter/                          # Flutter frontend application
│   ├── lib/
│   │   ├── main.dart                 # App entry point
│   │   ├── config/                   # App configuration
│   │   │   ├── app_config.dart       # Environment configs
│   │   │   ├── constants.dart        # App constants
│   │   │   └── theme.dart            # App theme
│   │   ├── models/                   # Data models
│   │   │   ├── user.dart             # User model
│   │   │   ├── match.dart            # Match model
│   │   │   ├── innings.dart          # Innings model
│   │   │   ├── ball.dart             # Ball model
│   │   │   ├── player.dart           # Player model
│   │   │   └── notification.dart     # Notification model
│   │   ├── providers/                # Riverpod providers
│   │   │   ├── auth_provider.dart    # Authentication state
│   │   │   ├── match_provider.dart   # Match state management
│   │   │   ├── scoring_provider.dart # Scoring logic
│   │   │   ├── websocket_provider.dart # Real-time connection
│   │   │   └── offline_provider.dart # Offline queue management
│   │   ├── screens/                  # UI screens
│   │   │   ├── auth/                 # Authentication screens
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── otp_screen.dart
│   │   │   │   └── profile_setup.dart
│   │   │   ├── home/                 # Home screen
│   │   │   │   └── home_screen.dart
│   │   │   ├── matches/              # Match screens
│   │   │   │   ├── match_list.dart
│   │   │   │   ├── match_detail.dart
│   │   │   │   ├── create_match.dart
│   │   │   │   └── join_match.dart
│   │   │   ├── scoring/              # Scoring interface
│   │   │   │   ├── scoring_screen.dart
│   │   │   │   ├── scorecard.dart
│   │   │   │   ├── player_selection.dart
│   │   │   │   └── toss_screen.dart
│   │   │   ├── profile/              # Profile screens
│   │   │   │   ├── profile_screen.dart
│   │   │   │   ├── edit_profile.dart
│   │   │   │   └── stats_screen.dart
│   │   │   └── leaderboard/          # Leaderboards
│   │   │       └── leaderboard_screen.dart
│   │   ├── widgets/                  # Reusable widgets
│   │   │   ├── common/               # Common widgets
│   │   │   │   ├── loading_widget.dart
│   │   │   │   ├── error_widget.dart
│   │   │   │   └── button.dart
│   │   │   ├── scoring/              # Scoring widgets
│   │   │   │   ├── score_display.dart
│   │   │   │   ├── ball_buttons.dart
│   │   │   │   └── over_summary.dart
│   │   │   └── match/                # Match widgets
│   │   │       ├── match_card.dart
│   │   │       └── player_card.dart
│   │   ├── services/                 # Business logic
│   │   │   ├── api_service.dart      # HTTP client
│   │   │   ├── websocket_service.dart # WebSocket management
│   │   │   ├── auth_service.dart     # Authentication
│   │   │   ├── match_service.dart    # Match operations
│   │   │   ├── scoring_service.dart  # Scoring logic
│   │   │   ├── offline_service.dart  # Offline queue
│   │   │   └── notification_service.dart # Push notifications
│   │   ├── utils/                    # Utility functions
│   │   │   ├── validators.dart       # Input validation
│   │   │   ├── formatters.dart       # Data formatting
│   │   │   ├── constants.dart        # App constants
│   │   │   └── helpers.dart          # Helper functions
│   │   └── localization/             # i18n support
│   │       ├── app_localizations.dart
│   │       └── l10n/                   # Language files
│   ├── test/                         # Unit tests
│   │   ├── unit/
│   │   ├── widget/
│   │   └── integration/
│   ├── web/                          # Web-specific files
│   ├── android/                      # Android-specific
│   ├── ios/                          # iOS-specific
│   ├── assets/                       # Static assets
│   │   ├── images/
│   │   ├── icons/
│   │   └── fonts/
│   ├── pubspec.yaml                  # Flutter dependencies
│   └── .env                          # Environment variables
│
├── backend/                          # FastAPI backend
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                   # FastAPI app entry
│   │   ├── config.py                 # App configuration
│   │   ├── database.py               # Database connection
│   │   ├── redis.py                  # Redis connection
│   │   ├── models/                   # SQLAlchemy models
│   │   │   ├── __init__.py
│   │   │   ├── user.py               # User model
│   │   │   ├── profile.py            # Profile model
│   │   │   ├── match.py              # Match model
│   │   │   ├── innings.py            # Innings model
│   │   │   ├── ball.py               # Ball model
│   │   │   ├── player_in_match.py    # Player in match model
│   │   │   ├── match_event.py        # Match event model
│   │   │   ├── notification.py       # Notification model
│   │   │   └── otp_session.py        # OTP session model
│   │   ├── schemas/                  # Pydantic schemas
│   │   │   ├── __init__.py
│   │   │   ├── user.py               # User schemas
│   │   │   ├── match.py              # Match schemas
│   │   │   ├── innings.py            # Innings schemas
│   │   │   ├── ball.py               # Ball schemas
│   │   │   ├── auth.py               # Auth schemas
│   │   │   └── websocket.py          # WebSocket schemas
│   │   ├── api/                      # API routers
│   │   │   ├── __init__.py
│   │   │   ├── auth.py               # Authentication endpoints
│   │   │   ├── users.py              # User management
│   │   │   ├── matches.py            # Match operations
│   │   │   ├── innings.py            # Innings operations
│   │   │   ├── balls.py              # Ball recording
│   │   │   ├── leaderboards.py       # Statistics
│   │   │   ├── highlights.py         # Social features
│   │   │   ├── admin.py              # Admin endpoints
│   │   │   └── websocket.py          # WebSocket handlers
│   │   ├── services/                 # Business logic
│   │   │   ├── __init__.py
│   │   │   ├── auth_service.py       # Authentication logic
│   │   │   ├── match_service.py      # Match operations
│   │   │   ├── scoring_service.py    # Scoring calculations
│   │   │   ├── websocket_service.py    # Real-time logic
│   │   │   ├── notification_service.py # Push notifications
│   │   │   ├── otp_service.py        # OTP verification
│   │   │   └── leaderboard_service.py # Statistics calculations
│   │   ├── utils/                    # Utility functions
│   │   │   ├── __init__.py
│   │   │   ├── security.py           # Security utilities
│   │   │   ├── validators.py         # Input validation
│   │   │   ├── formatters.py         # Data formatting
│   │   │   ├── constants.py          # App constants
│   │   │   └── helpers.py            # Helper functions
│   │   ├── middleware/               # Custom middleware
│   │   │   ├── __init__.py
│   │   │   ├── auth.py               # JWT validation
│   │   │   ├── rate_limit.py         # Rate limiting
│   │   │   └── error_handler.py      # Global error handling
│   │   └── websocket/                # WebSocket management
│   │       ├── __init__.py
│   │       ├── connection_manager.py   # Connection handling
│   │       └── message_handler.py    # Message processing
│   ├── alembic/                      # Database migrations
│   │   ├── alembic.ini               # Alembic config
│   │   ├── env.py                    # Migration environment
│   │   └── versions/                 # Migration files
│   ├── tests/                        # Backend tests
│   │   ├── unit/
│   │   ├── integration/
│   │   └── conftest.py               # Test configuration
│   ├── requirements.txt              # Python dependencies
│   ├── requirements-dev.txt          # Dev dependencies
│   ├── Dockerfile                    # Container definition
│   ├── .env.example                  # Environment template
│   └── docker-compose.yml            # Local development
│
├── migrations/                       # Database migrations
│   ├── 001_create_users.sql        # Users table
│   ├── 002_create_profiles.sql       # Profiles table
│   ├── 003_create_matches.sql      # Matches table
│   ├── 004_create_innings.sql      # Innings table
│   ├── 005_create_balls.sql        # Balls table
│   ├── 006_create_players_in_match.sql # Players in match
│   ├── 007_create_match_events.sql # Match events
│   ├── 008_create_notifications.sql # Notifications
│   ├── 009_create_otp_sessions.sql # OTP sessions
│   ├── 010_create_indexes.sql      # Performance indexes
│   └── 011_create_foreign_keys.sql # Relationships
│
├── scripts/                        # Utility scripts
│   ├── setup.sh                    # Initial setup script
│   ├── deploy.sh                   # Deployment script
│   ├── backup.sh                   # Database backup
│   └── seed_data.sql               # Sample data
│
├── docs/                           # Documentation
│   ├── API.md                      # API documentation
│   ├── DATABASE.md                 # Database schema
│   ├── DEPLOYMENT.md               # Deployment guide
│   ├── TESTING.md                  # Testing guide
│   └── ARCHITECTURE.md             # Architecture overview
│
├── docker/                         # Docker configurations
│   ├── nginx.conf                  # Nginx config
│   ├── redis.conf                  # Redis config
│   └── mysql.cnf                   # MySQL config
│
├── .github/                        # GitHub Actions
│   └── workflows/
│       ├── test.yml                # CI/CD pipeline
│       └── deploy.yml              # Deployment pipeline
│
├── .gitignore                      # Git ignore rules
├── README.md                       # Project overview
└── LICENSE                         # License file
```

## Key Design Decisions:

1. **Monorepo Structure**: Single repository for easier coordination between frontend and backend
2. **Separation of Concerns**: Clear boundaries between models, services, and API layers
3. **Offline-First**: Dedicated offline service and queue management in Flutter
4. **Real-Time Architecture**: WebSocket service with Redis Pub/Sub for scalability
5. **Database Migrations**: Separate migration files for better version control
6. **Testing Strategy**: Unit, integration, and widget tests for comprehensive coverage
7. **Containerization**: Docker support for consistent deployment environments
8. **CI/CD Ready**: GitHub Actions workflows for automated testing and deployment