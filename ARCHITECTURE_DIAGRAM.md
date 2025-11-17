# inSwing System Architecture

## High-Level Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                    CLIENT LAYER                                          │
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                         │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐                      │
│  │   Flutter App   │    │   Flutter App   │    │   Web Client    │                      │
│  │   (Android)     │    │   (iOS)         │    │   (React/Web)   │                      │
│  └────────┬────────┘    └────────┬────────┘    └────────┬────────┘                      │
│           │                       │                       │                              │
│           └───────────────────────┴───────────────────────┘                              │
│                       │                    │                                            │
│                       ▼                    ▼                                            │
│              ┌─────────────────┐  ┌─────────────────┐                                   │
│              │   Riverpod      │  │   Offline       │                                   │
│              │   State Mgmt    │  │   Queue         │                                   │
│              └────────┬────────┘  └────────┬────────┘                                   │
│                       │                    │                                            │
│                       ▼                    ▼                                            │
│              ┌─────────────────┐  ┌─────────────────┐                                   │
│              │   WebSocket     │  │   SQLite        │                                   │
│              │   Client        │  │   Storage       │                                   │
│              └────────┬────────┘  └────────┬────────┘                                   │
└───────────────────────┼───────────────────────┼──────────────────────────────────────────┘
                        │                       │
                        │                       │
┌───────────────────────┼───────────────────────┼──────────────────────────────────────────┐
│                       ▼                       ▼                         API GATEWAY       │
│  ┌─────────────────────────────────────────────────────────────────┐                      │
│  │                    LOAD BALANCER                              │                      │
│  │                 (Nginx/Cloudflare)                             │                      │
│  └────────────────────────┬──────────────────────────────────────────┘                      │
│                           │                                                             │
│                           ▼                                                             │
│  ┌─────────────────────────────────────────────────────────────────┐                      │
│  │                    FASTAPI BACKEND                            │                      │
│  │                                                                 │                      │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │                      │
│  │  │   Auth Router   │  │  Match Router   │  │  User Router    │ │                      │
│  │  │   /api/v1/auth  │  │  /api/v1/matches│  │  /api/v1/users  │ │                      │
│  │  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘ │                      │
│  │           │                    │                    │          │                      │
│  │  ┌────────┴────────┐  ┌────────┴────────┐  ┌────────┴────────┐ │                      │
│  │  │  Auth Service   │  │  Match Service  │  │  User Service   │ │                      │
│  │  │  JWT + OTP      │  │  Match Logic    │  │  Profile Mgmt   │ │                      │
│  │  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘ │                      │
│  │           │                    │                    │          │                      │
│  │  ┌────────┴────────┐  ┌────────┴────────┐  ┌────────┴────────┐ │                      │
│  │  │  Pydantic       │  │  SQLAlchemy     │  │  Redis          │ │                      │
│  │  │  Schemas        │  │  ORM Models     │  │  Pub/Sub        │ │                      │
│  │  └─────────────────┴──────────────────────┴─────────────────┘ │                      │
│  │                                                                 │                      │
│  │  ┌─────────────────────────────────────────────────────────────┐ │                      │
│  │  │              WebSocket Manager                             │ │                      │
│  │  │         Real-time Connection Handler                       │ │                      │
│  │  └────────────────────────┬──────────────────────────────────┘ │                      │
│  │                           │                                     │                      │
│  │                           ▼                                     │                      │
│  │  ┌─────────────────────────────────────────────────────────────┐ │                      │
│  │  │              Middleware Layer                              │ │                      │
│  │  │  Rate Limiting • JWT Auth • Error Handling • CORS          │ │                      │
│  │  └────────────────────────┬──────────────────────────────────┘ │                      │
│  └───────────────────────────┼─────────────────────────────────────┘                      │
│                              │                                                           │
└──────────────────────────────┼───────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────┼───────────────────────────────────────────────────────────┐
│                              │                              DATA LAYER                   │
│  ┌───────────────────────────┴──────────────┐                                           │
│  │           MySQL 8.0 Database              │                                           │
│  │                                             │                                           │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐   │                                           │
│  │  │  users  │  │matches  │  │ innings │   │                                           │
│  │  │  table  │  │  table  │  │  table  │   │                                           │
│  │  └─────────┘  └─────────┘  └─────────┘   │                                           │
│  │                                             │                                           │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐   │                                           │
│  │  │  balls  │  │profiles │  │notifications│                                           │
│  │  │  table  │  │  table  │  │  table  │   │                                           │
│  │  └─────────┘  └─────────┘  └─────────┘   │                                           │
│  └────────────────────────┬──────────────────┘                                           │
│                           │                                                             │
│                           ▼                                                             │
│  ┌─────────────────────────┴──────────────────┐                                          │
│  │          Redis 7.0 Cache/PubSub           │                                          │
│  │                                             │                                          │
│  │  ┌──────────────┐  ┌──────────────┐      │                                          │
│  │  │  Session     │  │  Real-time   │      │                                          │
│  │  │  Storage     │  │  Pub/Sub     │      │                                          │
│  │  │  (TTL)       │  │  Channels    │      │                                          │
│  │  └──────────────┘  └──────────────┘      │                                          │
│  │                                             │                                          │
│  │  ┌──────────────┐  ┌──────────────┐      │                                          │
│  │  │  Rate Limit  │  │  Leaderboard │      │                                          │
│  │  │  Tracking    │  │  Cache       │      │                                          │
│  │  └──────────────┘  └──────────────┘      │                                          │
│  └────────────────────────────────────────────┘                                          │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

## Detailed Data Flow

### 1. Authentication Flow
```
User → Flutter App → Request OTP → FastAPI → OTP Service → SMS Provider
  ↑                                    ↓
  └────── Verify OTP ←── JWT Token ←───┘
```

### 2. Match Creation Flow
```
Host → Create Match → FastAPI → Match Service → MySQL (matches table)
  ↓                                        ↓
  └────── Success Response ←───────────────┘
```

### 3. Real-Time Scoring Flow
```
Scorer → Record Ball → Flutter App → WebSocket → FastAPI → Ball Service
  ↓                                                    ↓
  ├────── Local Storage ←── Offline Queue ←──────────┤
  ↓                                                    ↓
  └────── Real-time Update ←── Redis Pub/Sub ←────── MySQL (balls table)
         Broadcast to All Clients
```

### 4. Offline Sync Flow
```
Offline Mode → Queue Balls → Back Online → Sync Request → FastAPI
  ↑                                                            ↓
  └────── Confirmed State ←── Conflict Resolution ←───────────┘
```

## Component Details

### Flutter Frontend Components

#### State Management (Riverpod)
```
┌─────────────────────────────────────────────────────────┐
│                   Providers                             │
├─────────────────────────────────────────────────────────┤
│ AuthProvider     → User authentication state           │
│ MatchProvider    → Match data and operations         │
│ ScoringProvider  → Ball-by-ball scoring logic        │
│ WebSocketProvider→ Real-time connection management    │
│ OfflineProvider  → Offline queue and sync            │
│ NotificationProvider → Push notification handling     │
└─────────────────────────────────────────────────────────┘
```

#### Local Storage (SQLite/Hive)
```
┌─────────────────────────────────────────────────────────┐
│                  Storage Schema                         │
├─────────────────────────────────────────────────────────┤
│ queued_balls     → Pending ball updates                │
│ matches          → Cached match data                   │
│ users           → User profiles                        │
│ settings        → App preferences                      │
│ sync_state      → Sync status and timestamps         │
└─────────────────────────────────────────────────────────┘
```

### FastAPI Backend Services

#### Authentication Service
```python
class AuthService:
    ├── verify_otp()           # OTP verification
    ├── generate_tokens()      # JWT token creation
    ├── refresh_token()        # Token refresh
    ├── validate_session()     # Session validation
    └── revoke_token()         # Token revocation
```

#### Match Service
```python
class MatchService:
    ├── create_match()         # Match creation
    ├── add_player()           # Player addition
    ├── record_toss()          # Toss recording
    ├── update_status()        # Status updates
    ├── get_match_details()    # Match retrieval
    └── list_matches()         # Match listing
```

#### Scoring Service
```python
class ScoringService:
    ├── record_ball()          # Ball recording
    ├── calculate_score()      # Score calculation
    ├── update_innings()       # Innings updates
    ├── validate_ball()        # Ball validation
    ├── undo_ball()            # Ball undo
    └── generate_events()      # Event generation
```

#### WebSocket Service
```python
class WebSocketService:
    ├── connect()              # Connection handling
    ├── broadcast_update()     # Update broadcasting
    ├── handle_disconnect()    # Disconnection cleanup
    ├── subscribe_to_match()   # Match subscription
    └── publish_to_redis()     # Redis publishing
```

## Data Storage Strategy

### MySQL Database
```sql
-- Primary Tables
users           → User accounts and profiles
matches         → Match information and settings
innings         → Innings data and statistics
balls           → Ball-by-ball records
events          → Match events and highlights

-- Relationship Tables
players_in_match → Player match assignments
notifications    → User notifications
otp_sessions    → OTP verification sessions
```

### Redis Cache
```
Key Patterns:
├── session:{user_id}        → User session data (TTL: 1h)
├── match:{match_id}:live    → Live match cache (TTL: 5m)
├── leaderboard:{type}      → Leaderboard cache (TTL: 15m)
├── rate_limit:{ip}          → Rate limit tracking (TTL: 1m)
└── ws:{match_id}:*          → WebSocket connection tracking
```

## Security Architecture

### Authentication & Authorization
```
┌─────────────────────────────────────────────────────────┐
│                  Security Layers                        │
├─────────────────────────────────────────────────────────┤
│ 1. JWT Tokens     → Access & refresh tokens            │
│ 2. Rate Limiting  → API request throttling           │
│ 3. Input Validation → Pydantic schema validation       │
│ 4. SQL Injection  → ORM parameterized queries          │
│ 5. CORS Policy    → Cross-origin request control       │
│ 6. HTTPS Only     → Encrypted communication           │
│ 7. Data Privacy   → Phone number masking              │
│ 8. Audit Logging  → Security event tracking           │
└─────────────────────────────────────────────────────────┘
```

### Data Privacy
- Phone numbers never exposed in public APIs
- User location only shared during active matches
- Profile visibility controlled by user settings
- Data retention policies for GDPR compliance

## Performance Optimization

### Caching Strategy
```
Level 1: Application Cache (Redis)
├── Session data (1 hour TTL)
├── Match summaries (5 minutes TTL)
├── Leaderboards (15 minutes TTL)
└── User profiles (30 minutes TTL)

Level 2: Database Optimization
├── Query result caching
├── Connection pooling
├── Index optimization
└── Read replica scaling

Level 3: Client-side Caching
├── Offline data storage
├── Image caching
├── API response caching
└── Background sync
```

### Scaling Considerations
```
Horizontal Scaling:
├── Load balancer → Multiple API servers
├── Database read replicas
├── Redis cluster
└── CDN for static assets

Vertical Scaling:
├── Connection pooling
├── Query optimization
├── Background job processing
└── Caching layers
```

## Monitoring & Observability

### Metrics Collection
```
Application Metrics:
├── API response times
├── Error rates
├── Active connections
└── Database query performance

Business Metrics:
├── Match completion rate
├── User engagement
├── Scoring accuracy
└── Offline sync success rate

Infrastructure Metrics:
├── CPU/Memory usage
├── Disk I/O
├── Network throughput
└── Service availability
```

### Logging Strategy
```
Structured Logging:
├── Request/Response logs
├── Error stack traces
├── User activity logs
├── Security event logs
└── Performance metrics

Log Levels:
├── ERROR → Critical failures
├── WARN  → Warning conditions
├── INFO  → General information
├── DEBUG → Detailed debugging
└── TRACE → Full request tracing
```

## Deployment Architecture

### Development Environment
```
Local Development:
├── Docker Compose stack
├── Hot reload for FastAPI
├── Flutter development server
└── Local MySQL + Redis
```

### Production Environment
```
Production Deployment:
├── Container orchestration (Kubernetes/Docker Swarm)
├── Load balancer with SSL termination
├── Database with read replicas
├── Redis cluster for caching
├── CDN for static assets
├── Monitoring with Prometheus/Grafana
└── Log aggregation with ELK stack
```