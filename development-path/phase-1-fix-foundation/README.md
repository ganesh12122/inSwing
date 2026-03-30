# 🔧 Phase 1: Fix Foundation

> **Status:** 🔴 NOT STARTED
> **Timeline:** Week 1-2
> **Goal:** Make the codebase correct, secure, and deployable

---

## Steps

### Step 1.1: PostgreSQL Migration

- [ ] Replace all `MySQLCHAR(36)` with PostgreSQL-compatible `String(36)` or `UUID`
- [ ] Remove `from sqlalchemy.dialects.mysql import CHAR as MySQLCHAR` from all models
- [ ] Update `settings.py` DATABASE_URL default to PostgreSQL format
- [ ] Update `requirements.txt`: remove `mysqlclient`/`PyMySQL`, keep `asyncpg`
- [ ] Update Alembic `env.py` for async PostgreSQL
- [ ] Create new Alembic migration for PostgreSQL schema
- [ ] Test all models create correctly on PostgreSQL

**Files to modify:**

- `backend/app/models/user.py`
- `backend/app/models/profile.py`
- `backend/app/models/match.py`
- `backend/app/models/innings.py`
- `backend/app/models/ball.py`
- `backend/app/models/players_in_match.py`
- `backend/app/models/match_event.py`
- `backend/app/models/notification.py`
- `backend/app/models/otp_session.py`
- `backend/app/settings.py`
- `backend/requirements.txt`
- `backend/alembic/env.py`

---

### Step 1.2: Async Database

- [ ] Replace `create_engine()` with `create_async_engine()`
- [ ] Replace `sessionmaker` with `async_sessionmaker`
- [ ] Replace `Session` with `AsyncSession` everywhere
- [ ] Update `get_db()` to yield `AsyncSession`
- [ ] Update all route handlers to use `await` for DB queries
- [ ] Update all `db.query()` to `await db.execute(select(...))`
- [ ] Test all endpoints work with async sessions

**Files to modify:**

- `backend/app/database.py`
- `backend/app/dependencies.py`
- `backend/app/api/auth.py`
- `backend/app/api/users.py`
- `backend/app/api/matches.py`
- `backend/app/api/balls.py`
- `backend/app/api/leaderboards.py`
- `backend/app/api/notifications.py`
- `backend/app/api/search.py`
- `backend/app/api/websocket.py`

---

### Step 1.3: Fix Broken Code

- [ ] Add `from app.settings import settings` to `auth.py`
- [ ] Fix `search.py` column references (`User.name` → `User.full_name`, etc.)
- [ ] Fix `leaderboards.py` MySQL-specific functions for PostgreSQL
- [ ] Fix `require_host_role` to actually check match ownership
- [ ] Fix `get_optional_current_user` to properly handle unauthenticated requests
- [ ] Remove duplicate health check endpoints

**Files to modify:**

- `backend/app/api/auth.py`
- `backend/app/api/search.py`
- `backend/app/api/leaderboards.py`
- `backend/app/dependencies.py`
- `backend/app/api/__init__.py`

---

### Step 1.4: Security Hardening

- [ ] Remove all hardcoded passwords/secrets from `settings.py`
- [ ] Make SECRET_KEY, DATABASE_URL, etc. required (no defaults)
- [ ] Update `.env.example` to remove real credentials
- [ ] Ensure `.gitignore` covers all sensitive files
- [ ] Add input validation/sanitization
- [ ] Remove `create_all()` from `main.py` lifespan

**Files to modify:**

- `backend/app/settings.py`
- `backend/app/main.py`
- `backend/.env.example`
- `.gitignore`

---

### Step 1.5: Service Layer

- [ ] Create `backend/app/services/` directory
- [ ] Extract `auth_service.py` from `api/auth.py`
- [ ] Extract `match_service.py` from `api/matches.py`
- [ ] Extract `scoring_service.py` from `api/balls.py`
- [ ] Extract `stats_service.py` from `api/leaderboards.py`
- [ ] Extract `notification_service.py` from `api/notifications.py`
- [ ] Slim down route handlers to just validation + service calls

**Files to create:**

- `backend/app/services/__init__.py`
- `backend/app/services/auth_service.py`
- `backend/app/services/match_service.py`
- `backend/app/services/scoring_service.py`
- `backend/app/services/stats_service.py`
- `backend/app/services/notification_service.py`

---

### Step 1.6: Testing

- [ ] Create proper `backend/tests/` directory structure
- [ ] Add `conftest.py` with test database fixtures
- [ ] Write tests for auth endpoints (login, verify-otp, refresh)
- [ ] Write tests for match CRUD
- [ ] Write tests for scoring (record ball, innings)
- [ ] Write tests for leaderboards
- [ ] Write tests for service layer functions
- [ ] Ensure all tests pass on CI

**Files to create:**

- `backend/tests/__init__.py`
- `backend/tests/conftest.py`
- `backend/tests/test_auth.py`
- `backend/tests/test_matches.py`
- `backend/tests/test_scoring.py`
- `backend/tests/test_leaderboards.py`
- `backend/tests/test_services.py`

---

### Step 1.7: Cleanup Requirements

- [ ] Consolidate root and backend `requirements.txt`
- [ ] Remove unused packages (`celery`, `PyMySQL`, `aioredis`)
- [ ] Add missing packages (`asyncpg`, `slowapi`)
- [ ] Pin all versions
- [ ] Add `requirements-dev.txt` for test dependencies

**Files to modify:**

- `backend/requirements.txt`
- Root `requirements.txt` (remove or redirect)

---

## Completion Checklist

- [ ] All models use PostgreSQL-compatible types
- [ ] Database operations are truly async
- [ ] No hardcoded secrets in source code
- [ ] `create_all()` removed, Alembic only
- [ ] All broken imports/references fixed
- [ ] Service layer exists and is used
- [ ] All API endpoints work correctly
- [ ] Test suite passes with 80%+ coverage
- [ ] Requirements cleaned up
- [ ] Can connect to Neon PostgreSQL

## Estimated Effort

- **1.1 PostgreSQL Migration**: 2-3 hours
- **1.2 Async Database**: 4-6 hours
- **1.3 Fix Broken Code**: 2-3 hours
- **1.4 Security Hardening**: 1-2 hours
- **1.5 Service Layer**: 4-6 hours
- **1.6 Testing**: 4-6 hours
- **1.7 Cleanup**: 1-2 hours
- **Total: ~18-28 hours**
