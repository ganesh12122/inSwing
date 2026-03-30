# 🐛 inSwing — Current Issues & Technical Debt

> This document tracks all known issues found during the project analysis on March 30, 2026.
> Each issue is tagged with severity and mapped to the development phase where it will be fixed.

---

## 🔴 CRITICAL (Must Fix Before Any Deployment)

### C-01: MySQL Dialect Used Instead of PostgreSQL

- **Location**: All files in `backend/app/models/`
- **Issue**: Every model uses `from sqlalchemy.dialects.mysql import CHAR as MySQLCHAR` and `MySQLCHAR(36)` for UUIDs
- **Impact**: Cannot deploy to Neon/Supabase (PostgreSQL)
- **Fix**: Replace with `from sqlalchemy.dialects.postgresql import UUID` or use `String(36)`
- **Phase**: Phase 1

### C-02: Synchronous Database Operations

- **Location**: `backend/app/database.py`
- **Issue**: Uses `create_engine()` (sync) instead of `create_async_engine()`. All "async" endpoints are actually blocking.
- **Impact**: WebSocket connections will block, poor performance under load
- **Fix**: Migrate to `AsyncSession` + `async_sessionmaker`
- **Phase**: Phase 1

### C-03: Hardcoded Secrets in Source Code

- **Location**: `backend/app/settings.py` lines 17-25
- **Issue**: Database password `Ganesh@15` and JWT secret key hardcoded as defaults
- **Impact**: Security vulnerability if repo is public
- **Fix**: Remove defaults, require `.env` file, fail fast if missing
- **Phase**: Phase 1

### C-04: `create_all()` Used in Production Lifespan

- **Location**: `backend/app/main.py` line 32
- **Issue**: `Base.metadata.create_all(bind=engine)` runs on every app start
- **Impact**: Conflicts with Alembic migrations, can corrupt schema
- **Fix**: Remove `create_all()`, use Alembic exclusively
- **Phase**: Phase 1

### C-05: Missing `settings` Import in auth.py

- **Location**: `backend/app/api/auth.py`
- **Issue**: Uses `settings.OTP_MAX_ATTEMPTS` but never imports `settings`
- **Impact**: Runtime crash on login endpoint
- **Fix**: Add `from app.settings import settings`
- **Phase**: Phase 1

### C-06: Broken Authorization — `require_host_role`

- **Location**: `backend/app/dependencies.py` line 88
- **Issue**: `require_host_role` allows ANY `player` to pass — should check if user is the match HOST
- **Impact**: Any logged-in user can modify any match (toss, scoring, cancellation)
- **Fix**: Change to per-match host check, not role-based
- **Phase**: Phase 1

---

## 🟡 MAJOR (Fix Before Public Launch)

### M-01: Search API Uses Wrong Column Names

- **Location**: `backend/app/api/search.py`
- **Issue**: References `User.name`, `User.phone`, `Match.title`, `Match.location` — actual columns are `User.full_name`, `User.phone_number`, `Match.venue`
- **Impact**: Search endpoints will crash
- **Phase**: Phase 1

### M-02: Leaderboard Uses MySQL-Specific Functions

- **Location**: `backend/app/api/leaderboards.py`
- **Issue**: `func.timestampdiff(text('SECOND'), ...)` is MySQL-only syntax
- **Impact**: Won't work on PostgreSQL
- **Phase**: Phase 1

### M-03: No Service Layer (Fat Controllers)

- **Location**: All `backend/app/api/*.py` files
- **Issue**: Business logic is directly in route handlers (some 400+ lines)
- **Impact**: Untestable, unmaintainable, code duplication
- **Fix**: Extract to `app/services/` layer
- **Phase**: Phase 1

### M-04: Flutter Models Don't Match Backend Schemas

- **Issue**: Flutter `User` model has `name` field, backend has `full_name`. Multiple field mismatches.
- **Impact**: JSON deserialization will fail
- **Phase**: Phase 2

### M-05: No Rate Limiting

- **Location**: `backend/app/settings.py` has config, but no middleware
- **Impact**: Vulnerable to DDoS, brute force OTP attacks
- **Phase**: Phase 2

### M-06: OTP Not Actually Sent

- **Location**: `backend/app/api/auth.py` line 103
- **Issue**: OTP is logged to console, no SMS integration
- **Impact**: Auth flow doesn't work for real users
- **Phase**: Phase 2

### M-07: Conflicting Requirements Files

- **Location**: Root `requirements.txt` vs `backend/requirements.txt`
- **Issue**: Different versions, different packages (PyMySQL vs mysqlclient)
- **Impact**: Confusion during deployment
- **Phase**: Phase 1

### M-08: No Tests

- **Location**: `backend/test_backend.py` is a manual script, not pytest
- **Impact**: Zero confidence in code correctness
- **Phase**: Phase 1

---

## 🟢 MINOR (Fix When Convenient)

### m-01: Duplicate Health Check Endpoints

- Two health checks: one at root `/health` and one at `/api/v1/health`

### m-02: No Pagination Standardization

- Different endpoints use different pagination patterns

### m-03: `get_optional_current_user` Not Properly Implemented

- Silently fails instead of returning None for unauthenticated users

### m-04: `overs_bowled` Float Representation

- Using float (4.3) for overs is fragile — should use integer ball count

### m-05: No Input Sanitization

- No XSS protection on user-provided strings (names, bios)

### m-06: WebSocket Token in URL Path

- JWT token exposed in WebSocket URL — should use query param or initial handshake message

### m-07: No Database Connection Pool Health Check

- Health endpoint doesn't verify DB/Redis connectivity

### m-08: Flutter `flutter_easyrefresh` is Deprecated

- Should use built-in `RefreshIndicator` or newer package

### m-09: No App Icon or Splash Screen

- Using default Flutter icons

### m-10: Deep Linking Commented Out

- `uni_links` dependency removed, no deep linking support
