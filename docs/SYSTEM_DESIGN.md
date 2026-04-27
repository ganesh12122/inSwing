# inSwing — System Design Document

> **Version**: 1.0 | **Last Updated**: 2026-04-27  
> **Status**: Production Architecture (Pre-Launch)  
> **Target Scale**: 10K DAU (launch), 100K DAU (6 months), 500K DAU (12 months)

---

## 1. Executive Summary

inSwing is a **real-time cricket scoring and tournament management platform** targeting gully/street cricket players and semi-professional cricketers in India. The system must handle:

- **Ball-by-ball live scoring** with sub-500ms propagation
- **Offline-first mobile experience** with conflict-free sync
- **Concurrent live matches** (100+ simultaneous during peak hours)
- **Zero-investment deployment** using free/cheap cloud tiers initially, scaling to paid as revenue grows

---

## 2. High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐   │
│  │ Android  │  │   iOS    │  │ Flutter  │  │ React Frontend   │   │
│  │   App    │  │   App    │  │   Web    │  │  (Admin/Stats)   │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────┬───────────┘   │
│       │              │             │               │               │
│       └──────────────┴─────────────┴───────────────┘               │
│                         │                                           │
│              REST API + WebSocket                                   │
└────────────────────────┬────────────────────────────────────────────┘
                         │
┌────────────────────────┴────────────────────────────────────────────┐
│                      API GATEWAY / LOAD BALANCER                    │
│              (Railway/Render + Cloudflare CDN/Proxy)                │
└────────────────────────┬────────────────────────────────────────────┘
                         │
┌────────────────────────┴────────────────────────────────────────────┐
│                       APPLICATION LAYER                             │
│  ┌────────────────────────────────────────────────────────────┐     │
│  │              FastAPI Backend (Python 3.11+)                │     │
│  │                                                            │     │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────────┐  │     │
│  │  │Auth Svc  │ │Match Svc │ │Score Svc │ │Notif. Svc   │  │     │
│  │  │(JWT+OTP) │ │(CRUD+WS) │ │(Ball-by- │ │(Push+InApp) │  │     │
│  │  │          │ │          │ │ ball)     │ │             │  │     │
│  │  └──────────┘ └──────────┘ └──────────┘ └─────────────┘  │     │
│  │                                                            │     │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────────┐  │     │
│  │  │User Svc  │ │Leader-   │ │Search Svc│ │WebSocket    │  │     │
│  │  │(Profile) │ │board Svc │ │          │ │Manager      │  │     │
│  │  └──────────┘ └──────────┘ └──────────┘ └─────────────┘  │     │
│  └────────────────────────────────────────────────────────────┘     │
└────────────────────────┬──────────────┬─────────────────────────────┘
                         │              │
          ┌──────────────┴──┐    ┌──────┴────────────┐
          │   DATA LAYER    │    │   CACHE/PUBSUB    │
          │                 │    │                    │
          │  PostgreSQL 16  │    │   Redis 7.0       │
          │  (Neon/Supabase)│    │  (Upstash)        │
          │                 │    │                    │
          │  - Users        │    │  - Session cache   │
          │  - Matches      │    │  - Match state     │
          │  - Balls        │    │  - Pub/Sub events  │
          │  - Profiles     │    │  - Rate limiting   │
          │  - Innings      │    │  - Leaderboard     │
          │  - Notifications│    │    cache           │
          └─────────────────┘    └────────────────────┘
```

---

## 3. Component Deep-Dive

### 3.1 Client Layer

| Platform | Technology | Distribution | Offline Support |
|----------|-----------|-------------|-----------------|
| Android | Flutter + Riverpod | Play Store | SQLite + Hive |
| iOS | Flutter + Riverpod | App Store | SQLite + Hive |
| Web | Flutter Web | Vercel | Service Worker |
| Admin | React + TypeScript | Vercel | N/A |

**Offline-First Architecture:**
```
┌──────────────────────────────────────┐
│           Flutter Client             │
│  ┌─────────┐    ┌────────────────┐   │
│  │ Riverpod│    │ Local DB       │   │
│  │  State  │◄──►│ (SQLite/Hive)  │   │
│  └────┬────┘    └───────┬────────┘   │
│       │                 │            │
│  ┌────▼────┐    ┌───────▼────────┐   │
│  │ API     │    │ Sync Queue     │   │
│  │ Client  │◄──►│ (Offline Ops)  │   │
│  │ (Dio)   │    └────────────────┘   │
│  └────┬────┘                         │
└───────┼──────────────────────────────┘
        │
   REST/WebSocket
        │
   ┌────▼────┐
   │ Backend │
   └─────────┘
```

**Sync Strategy:**
1. All scoring operations are queued locally with `client_event_id` (UUID)
2. Queue replays when connectivity is restored
3. Server uses `client_event_id` for idempotent writes (no duplicate balls)
4. Conflict resolution: **last-writer-wins** with timestamp ordering
5. Match state is always reconstructable from ball-by-ball data

### 3.2 Application Layer (FastAPI Backend)

**Framework**: FastAPI 0.104.1 with full async/await  
**Runtime**: Python 3.11+ on Uvicorn ASGI server  
**Workers**: 4 Uvicorn workers in production (adjustable by CPU cores)

**Module Architecture:**
```
backend/app/
├── api/               # Thin route handlers (controllers)
│   ├── auth.py        # Phone OTP + JWT authentication
│   ├── users.py       # User CRUD, profile management
│   ├── matches.py     # Match lifecycle (16 endpoints)
│   ├── balls.py       # Ball-by-ball scoring + innings
│   ├── leaderboards.py# Batting/bowling stats aggregation
│   ├── notifications.py # Push + in-app notifications
│   ├── search.py      # Full-text user/match search
│   └── websocket.py   # Real-time connection manager
├── models/            # SQLAlchemy ORM models (11 tables)
├── schemas/           # Pydantic v2 request/response validation
├── auth/              # JWT token creation/verification
├── database.py        # Async engine + session factory
├── dependencies.py    # Auth dependency injection
├── settings.py        # Environment-based configuration
├── error_handlers.py  # Centralized exception handling
└── logging_config.py  # Structlog structured logging
```

**Key API Endpoints:**

| Category | Method | Path | Purpose |
|----------|--------|------|---------|
| Auth | POST | /api/v1/auth/register | Register new user |
| Auth | POST | /api/v1/auth/login | Email/password login |
| Auth | POST | /api/v1/auth/request-otp | Send OTP to phone |
| Auth | POST | /api/v1/auth/verify-otp | Verify OTP + get JWT |
| Match | POST | /api/v1/matches/ | Create match |
| Match | GET | /api/v1/matches/my | User's matches |
| Match | POST | /api/v1/matches/{id}/invite | Invite opponent captain |
| Match | POST | /api/v1/matches/{id}/accept | Accept invitation |
| Match | PUT | /api/v1/matches/{id}/toss | Record toss |
| Match | PUT | /api/v1/matches/{id}/status | Update match status |
| Scoring | POST | /api/v1/matches/{id}/innings | Create innings |
| Scoring | POST | /api/v1/innings/{id}/balls | Record ball (idempotent) |
| Teams | POST | /api/v1/matches/{id}/team/players | Add player to team |
| Teams | GET | /api/v1/matches/{id}/teams | Get both team rosters |
| Social | GET | /api/v1/leaderboards/batting | Batting leaderboard |
| Social | GET | /api/v1/leaderboards/bowling | Bowling leaderboard |
| Realtime | WS | /api/v1/ws/{token} | WebSocket live updates |

### 3.3 Database Layer (PostgreSQL 16)

**Primary Store**: PostgreSQL 16 (Neon serverless for free tier, Supabase as alternative)

**Schema Overview (11 tables):**

```
                    ┌──────────────┐
                    │    users     │
                    │──────────────│
                    │ id (UUID PK) │
                    │ phone_number │
                    │ full_name    │
                    │ role         │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
      ┌───────▼──┐  ┌─────▼──────┐  ┌──▼──────────┐
      │ profiles │  │  matches   │  │notifications│
      │──────────│  │────────────│  │─────────────│
      │total_runs│  │host_user_id│  │user_id (FK) │
      │wickets   │  │opp_capt_id │  │type         │
      │avg       │  │status      │  │message      │
      │strike_rt │  │rules (JSON)│  │read         │
      └──────────┘  │venue       │  └─────────────┘
                    └──────┬─────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
    ┌─────────▼──┐  ┌──────▼───────┐  ┌▼────────────┐
    │players_in_ │  │   innings    │  │match_events │
    │   match    │  │──────────────│  │─────────────│
    │────────────│  │match_id (FK) │  │match_id(FK) │
    │match_id FK │  │batting_team  │  │event_type   │
    │user_id FK  │  │total_runs    │  │description  │
    │team (A/B)  │  │total_wickets │  │ball_id (FK) │
    │role        │  │total_overs   │  └─────────────┘
    │is_guest    │  └──────┬───────┘
    └────────────┘         │
                    ┌──────▼───────┐
                    │    balls     │
                    │──────────────│
                    │innings_id FK │
                    │batsman_id FK │
                    │bowler_id FK  │
                    │runs_scored   │
                    │is_wicket     │
                    │extras_type   │
                    │client_event_ │
                    │   id (UUID)  │
                    └──────────────┘
```

**Data Integrity Rules:**
- UUID v4 for all primary keys (distributed-safe, non-guessable)
- `created_at` / `updated_at` auto-timestamps on all tables
- Foreign key constraints with `ON DELETE CASCADE` for match children
- `client_event_id` UNIQUE constraint on balls for idempotent writes
- JSON columns for flexible metadata (rules, result, dismissal_info)
- Indexes on: `user_id`, `match_id`, `status`, `phone_number`, `team`

**Connection Pooling:**
- Async driver: `asyncpg` (PostgreSQL) / `aiosqlite` (dev)
- Pool size: 10 connections (configurable)
- Max overflow: 20
- Pool recycle: 300 seconds
- Pre-ping enabled for stale connection detection

### 3.4 Cache & Pub/Sub Layer (Redis 7.0)

**Provider**: Upstash Redis (free tier: 10K commands/day, 256MB)

**Caching Strategy:**

| Data | TTL | Purpose |
|------|-----|---------|
| JWT session tokens | 1 hour | Avoid DB lookup per request |
| Match state cache | 5 minutes | Reduce DB reads for live matches |
| Leaderboard data | 15 minutes | Heavy aggregation query result |
| User profile cache | 30 minutes | Frequently accessed profile data |
| Rate limit counters | 1 minute | API abuse prevention |

**Pub/Sub Channels:**

| Channel Pattern | Publisher | Subscribers | Payload |
|----------------|-----------|-------------|---------|
| `match:{id}:updates` | Score Service | WebSocket clients | Ball data, score update |
| `match:{id}:events` | Score Service | WebSocket clients | Wickets, milestones, boundaries |
| `user:{id}:notifications` | Notification Service | Client app | Push notification payload |
| `leaderboard:{type}` | Leaderboard Service | Dashboard clients | Updated rankings |

**Redis Data Flow (Live Scoring):**
```
Scorer App                     Backend              Redis           Viewers
    │                            │                    │                │
    │ POST /balls (ball data)    │                    │                │
    │──────────────────────────► │                    │                │
    │                            │ Store in DB        │                │
    │                            │──────────────►     │                │
    │                            │                    │                │
    │                            │ PUBLISH to channel │                │
    │                            │───────────────────►│                │
    │                            │                    │                │
    │                            │                    │ Broadcast      │
    │                            │                    │───────────────►│
    │                            │                    │  (WebSocket)   │
    │ 200 OK                     │                    │                │
    │◄────────────────────────── │                    │                │
```

### 3.5 WebSocket Architecture

**Connection Manager** (in-memory, single-process):

```python
class ConnectionManager:
    active_connections: Dict[str, WebSocket]     # user_id → ws
    match_connections: Dict[str, Set[str]]        # match_id → {user_ids}
```

**Message Types:**

| Type | Direction | Payload |
|------|-----------|---------|
| `ping` / `pong` | Client ↔ Server | Keep-alive |
| `subscribe_match` | Client → Server | `{match_id}` |
| `unsubscribe_match` | Client → Server | `{match_id}` |
| `ball_update` | Server → Client | Ball data + score |
| `wicket` | Server → Client | Wicket details |
| `match_status` | Server → Client | Status change |
| `notification` | Server → Client | In-app notification |

**Scaling Plan (when single-process is insufficient):**
1. Phase 1 (launch): Single Uvicorn process with in-memory ConnectionManager
2. Phase 2 (>10K concurrent): Redis Pub/Sub as message bus between workers
3. Phase 3 (>50K concurrent): Dedicated WebSocket service (separate from REST API)

---

## 4. Data Flow Diagrams

### 4.1 Match Lifecycle (Dual Captain Mode)

```
Host Captain                                    Opponent Captain
    │                                                │
    │ 1. POST /matches (create match)                │
    │───────────────►                                │
    │                                                │
    │ 2. POST /matches/{id}/invite                   │
    │───────────────► Notification ──────────────────►│
    │                                                │
    │                 3. POST /matches/{id}/accept    │
    │◄─────────────── ◄─────────────────────────────│
    │                                                │
    │ 4. POST /matches/{id}/team/players (add team)  │
    │───────────────►                                │
    │                 5. POST .../team/players        │
    │                 ◄──────────────────────────────│
    │                                                │
    │ 6. PUT /matches/{id}/team/ready                │
    │───────────────►                                │
    │                 7. PUT .../team/ready           │
    │                 ◄──────────────────────────────│
    │                 (status → teams_ready)          │
    │                                                │
    │ 8. POST /matches/{id}/rules/propose            │
    │───────────────► Notification ──────────────────►│
    │                                                │
    │                 9. POST .../rules/approve       │
    │◄─────────────── ◄─────────────────────────────│
    │                 (status → rules_approved)       │
    │                                                │
    │ 10. PUT /matches/{id}/toss                     │
    │───────────────► (status → toss_done)           │
    │                                                │
    │ 11. PUT /matches/{id}/status (live)            │
    │───────────────► (scoring begins)               │
    │                                                │
    │ Ball-by-ball scoring via POST /innings/{id}/balls
    │ ──────────────► WebSocket broadcast ───────────►│
    │                                                │
    │ 12. PUT /matches/{id}/status (finished)        │
    │───────────────► (match complete)               │
```

### 4.2 Ball Recording Flow

```
┌─────────────────────────────────────────────────────────────┐
│ Client generates client_event_id (UUID) locally             │
│ Queues ball operation in offline queue                      │
└──────────────────────────┬──────────────────────────────────┘
                           │
                    POST /innings/{id}/balls
                    {client_event_id, runs, is_wicket, ...}
                           │
┌──────────────────────────▼──────────────────────────────────┐
│ Server: Check client_event_id exists?                       │
│   YES → Return existing ball (idempotent, 200 OK)           │
│   NO  → Validate batsman/bowler in match                    │
│       → Create Ball record                                  │
│       → Update Innings stats (total_runs, wickets, overs)   │
│       → Create MatchEvent (boundary, wicket, milestone)     │
│       → Commit transaction                                  │
│       → Publish to Redis: match:{id}:updates                │
│       → Return new ball (201 Created)                       │
└──────────────────────────┬──────────────────────────────────┘
                           │
                    Redis Pub/Sub
                           │
              ┌────────────┴────────────┐
              │                         │
      ┌───────▼────────┐      ┌────────▼───────┐
      │ WebSocket      │      │ Push           │
      │ broadcast to   │      │ notification   │
      │ match viewers  │      │ to followers   │
      └────────────────┘      └────────────────┘
```

---

## 5. Security Architecture

### 5.1 Authentication Flow

```
Phone Number ──► OTP via SMS (MSG91/Firebase)
                       │
                 Verify OTP
                       │
              ┌────────▼────────┐
              │  JWT Token Pair  │
              │  ┌─────────────┐ │
              │  │Access Token │ │  Expiry: 1 hour
              │  │(in memory)  │ │
              │  └─────────────┘ │
              │  ┌─────────────┐ │
              │  │Refresh Token│ │  Expiry: 30 days
              │  │(secure stor)│ │
              │  └─────────────┘ │
              └──────────────────┘
```

### 5.2 Security Measures

| Layer | Measure | Implementation |
|-------|---------|---------------|
| Transport | HTTPS everywhere | Cloudflare SSL / Let's Encrypt |
| API | Rate limiting | Redis-based per-IP + per-user limits |
| Auth | JWT + OTP | python-jose + passlib[bcrypt] |
| Auth | Token rotation | Refresh token flow with blacklisting |
| Input | Validation | Pydantic v2 schemas on all endpoints |
| SQL | Injection prevention | SQLAlchemy ORM parameterized queries |
| CORS | Origin whitelist | FastAPI CORSMiddleware |
| Headers | Host validation | TrustedHostMiddleware |
| Secrets | Environment isolation | pydantic-settings (.env files) |
| Passwords | Hashing | bcrypt (passlib) |
| IDs | Non-guessable | UUID v4 for all primary keys |
| Logging | Structured | structlog (no PII in logs) |

### 5.3 OWASP Top 10 Coverage

| # | Risk | Mitigation |
|---|------|-----------|
| A01 | Broken Access Control | Role-based deps (require_host_role, is_captain checks) |
| A02 | Cryptographic Failures | bcrypt password hashing, JWT with HS256, HTTPS |
| A03 | Injection | SQLAlchemy parameterized queries, Pydantic validation |
| A04 | Insecure Design | Idempotent ball recording, offline-first sync |
| A05 | Security Misconfiguration | Docs disabled in production, strict CORS, .env config |
| A06 | Vulnerable Components | Pinned dependency versions, regular updates |
| A07 | Auth Failures | OTP expiry + max attempts, JWT rotation, token blacklist |
| A08 | Data Integrity | client_event_id dedup, FK constraints, transactions |
| A09 | Logging Failures | structlog on every request, error tracking |
| A10 | SSRF | No user-controlled URL fetching in backend |

---

## 6. Scalability Plan

### 6.1 Scaling Phases

| Phase | Users | Infrastructure | Cost |
|-------|-------|---------------|------|
| **Launch** | 0–10K DAU | Single backend instance, Neon free tier, Upstash free | $0/month |
| **Growth** | 10K–50K DAU | 2 backend instances, Neon Pro, Upstash Pro | ~$25/month |
| **Scale** | 50K–100K DAU | 4 backend instances, Redis cluster, CDN | ~$100/month |
| **Enterprise** | 100K+ DAU | Kubernetes, read replicas, dedicated Redis | ~$300+/month |

### 6.2 Bottleneck Analysis

| Bottleneck | Trigger | Solution |
|-----------|---------|---------|
| DB connections | >50 concurrent queries | Connection pooling (asyncpg pool) |
| WebSocket memory | >10K concurrent WS connections | Dedicated WS service + Redis Pub/Sub |
| Leaderboard queries | Complex aggregation on large dataset | Redis-cached with 15-min TTL |
| Ball writes | >100 balls/sec during peak | Write-ahead queue + batch commits |
| Search performance | Full-text on large user base | PostgreSQL full-text search → Meilisearch |
| SMS costs | OTP at scale | Rate limiting + Firebase free tier → paid SMS |

### 6.3 Database Scaling Path

```
Phase 1: Single PostgreSQL (Neon serverless)
    └── Phase 2: Connection pooler (PgBouncer)
         └── Phase 3: Read replica for leaderboards/search
              └── Phase 4: Partitioned tables (partition by match date)
                   └── Phase 5: Citus/sharding (if needed at 1M+ DAU)
```

---

## 7. Reliability & Observability

### 7.1 Health Monitoring

| Check | Frequency | Alert Threshold |
|-------|-----------|----------------|
| `/health` HTTP | 30 seconds | 2 consecutive failures |
| Database ping | In health check | Connection refused |
| Redis ping | In health check (planned) | Connection timeout |
| WebSocket connections | Metric counter | >80% of max connections |
| API response time | Per request (logged) | P95 > 2 seconds |

### 7.2 Logging Strategy

```
Request → structlog → JSON → stdout → Railway/Render log aggregator
```

**Log Fields (per request):**
- `request_id` (UUID) — correlate all logs for one request
- `method`, `path`, `status_code`, `duration_seconds`
- `user_id` (if authenticated)
- `error_type`, `error_message` (if error)

### 7.3 Error Handling

```
┌─────────────────────────────────────────────┐
│ Custom Exception Classes                     │
│  └── InSwingException (base)                │
│       ├── NotFoundException (404)            │
│       ├── UnauthorizedException (401)        │
│       ├── ForbiddenException (403)           │
│       ├── ValidationException (422)          │
│       └── DatabaseException (500)            │
│                                              │
│ Global Exception Handler                     │
│  └── Catches unhandled exceptions            │
│  └── Returns structured JSON error response  │
│  └── Logs with full traceback                │
│  └── Never exposes internal details to client│
└─────────────────────────────────────────────┘
```

---

## 8. Deployment Architecture

```
                    ┌──────────────┐
                    │  Cloudflare  │
                    │  (CDN/Proxy) │
                    └──────┬───────┘
                           │
              ┌────────────┴────────────┐
              │                         │
   ┌──────────▼──────────┐  ┌──────────▼──────────┐
   │   Vercel            │  │ Railway / Render     │
   │   (Flutter Web +    │  │ (FastAPI Backend)    │
   │    React Admin)     │  │                      │
   │                     │  │ ┌──────────────────┐ │
   │ Static assets +     │  │ │ Uvicorn (4 wkrs) │ │
   │ Edge functions      │  │ │ Python 3.11      │ │
   └─────────────────────┘  │ └──────────────────┘ │
                             └──────────┬───────────┘
                                        │
                    ┌───────────────────┴───────────────────┐
                    │                                       │
          ┌─────────▼─────────┐             ┌──────────────▼──┐
          │ Neon PostgreSQL   │             │ Upstash Redis   │
          │ (Serverless)      │             │ (Global Edge)   │
          │                   │             │                 │
          │ Auto-scaling      │             │ REST + Redis    │
          │ Built-in pooler   │             │ protocol        │
          │ Point-in-time     │             │ Auto-scaling    │
          │ recovery          │             │                 │
          └───────────────────┘             └─────────────────┘
```

---

## 9. Technology Decision Matrix

| Decision | Chosen | Alternatives Considered | Rationale |
|----------|--------|------------------------|-----------|
| Backend Framework | FastAPI | Django, Express.js | Native async, auto OpenAPI, WebSocket support |
| Database | PostgreSQL | MySQL, MongoDB | ACID, JSON support, free serverless (Neon) |
| ORM | SQLAlchemy 2.0 | Tortoise, Django ORM | Async support, mature, Alembic migrations |
| Cache | Redis (Upstash) | Memcached, DragonflyDB | Pub/Sub support, persistence, free tier |
| Mobile | Flutter | React Native, Kotlin | Single codebase, Dart performance, offline support |
| State Mgmt | Riverpod | Bloc, Provider | Code generation, testability, async-first |
| Auth | JWT + OTP | Session-based, OAuth | Stateless, mobile-first, no third-party dependency |
| Deployment | Railway/Render | AWS, GCP, Heroku | Free tier, simple, auto-deploy from GitHub |
| DB Hosting | Neon | Supabase, PlanetScale | Serverless auto-scaling, generous free tier |
| CDN | Cloudflare | AWS CloudFront | Free tier, DDoS protection, edge caching |

---

## 10. Future Architecture Considerations

### 10.1 Service Extraction Path (when monolith becomes limiting)

```
Current Monolith:
[Auth + Match + Score + Notification + Search + Leaderboard]
                         │
                         ▼
Phase 2: Extract high-frequency services:
[Auth] [Match+Score] [Notification] [Search+Leaderboard]
                         │
                         ▼
Phase 3: Full microservices (only if needed at 500K+ DAU):
[Auth] [Match] [Score] [Notification] [Search] [Leaderboard] [Analytics]
```

### 10.2 Planned Enhancements

| Feature | Architecture Impact | Priority |
|---------|-------------------|----------|
| Tournament mode | New tables + bracket logic | High |
| Live commentary | WebSocket + text streaming | Medium |
| Video highlights | Object storage (R2) integration | Medium |
| ML player ratings | Async batch processing (Celery) | Low |
| Social feed | Event sourcing pattern | Medium |
| Monetization (Premium) | Stripe/Razorpay integration | High |

---

## Appendix A: Environment Variables

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `DATABASE_URL` | Yes | PostgreSQL connection string | `postgresql+asyncpg://user:pass@host/db` |
| `SECRET_KEY` | Yes | JWT signing key (min 32 chars) | Random string |
| `REDIS_URL` | Yes | Redis connection string | `redis://default:pass@host:port` |
| `ENVIRONMENT` | No | Runtime environment | `production` / `development` |
| `DEBUG` | No | Enable debug mode | `false` |
| `CORS_ORIGINS` | No | Allowed origins (comma-separated) | `https://inswing.app` |
| `ALLOWED_HOSTS` | No | Trusted hosts | `inswing.app,api.inswing.app` |
| `OTP_PROVIDER` | No | SMS provider | `firebase` / `msg91` |
| `LOG_LEVEL` | No | Logging verbosity | `INFO` |

## Appendix B: API Rate Limits (Planned)

| Endpoint Pattern | Limit | Window | Scope |
|-----------------|-------|--------|-------|
| `POST /auth/*` | 10 | 1 minute | Per IP |
| `POST /matches/*/balls` | 30 | 1 minute | Per user |
| `GET /leaderboards/*` | 60 | 1 minute | Per user |
| `GET /search/*` | 30 | 1 minute | Per user |
| `WS /ws/*` | 5 connections | - | Per user |
| All other endpoints | 120 | 1 minute | Per user |
