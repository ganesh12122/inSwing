# Phase 1: Fix Foundation — Progress Tracker

## Status: 🔥 IN PROGRESS

## Completed Tasks

### ✅ 1.1 PostgreSQL Migration
- [x] Removed `MySQLCHAR(36)` from all 9 model files → replaced with `String(36)`
- [x] Removed `from sqlalchemy.dialects.mysql import CHAR as MySQLCHAR` from all models
- [x] Updated `settings.py` — removed hardcoded MySQL credentials, changed default to PostgreSQL URL
- [x] Updated `requirements.txt` — removed `mysqlclient`, `aioredis`, `uuid`; added `psycopg2-binary`
- [x] Updated `.env.example` — PostgreSQL connection string template, removed real passwords
- [x] Updated `alembic.ini` — PostgreSQL connection URL
- [x] Created `003_postgresql_migration.py` — fresh PostgreSQL-compatible migration
- [x] Updated `docker-compose.yml` (both root and backend) — PostgreSQL 16 Alpine
- [x] Updated `Dockerfile` — `libpq-dev` instead of `default-libmysqlclient-dev`

### ✅ 1.2 Security Hardening
- [x] Removed hardcoded `DB_PASSWORD=Ganesh@15` from `settings.py`
- [x] Removed hardcoded `SECRET_KEY` — now requires setting via `.env`
- [x] Removed individual `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` (single `DATABASE_URL` is cleaner)
- [x] Removed individual `REDIS_HOST`, `REDIS_PORT` (single `REDIS_URL`)
- [x] Set `DEBUG=False` as default (must explicitly enable)
- [x] Cleaned `.env.example` — no real credentials

### ✅ 1.3 Remove `create_all()` anti-pattern
- [x] Removed `Base.metadata.create_all(bind=engine)` from `main.py` lifespan
- [x] Removed `init_db()` and `get_db_session()` from `database.py`
- [x] Added `import app.models` in `main.py` to ensure model registration for Alembic
- [x] Updated `database.py` to use `DeclarativeBase` instead of deprecated `declarative_base()`

### ✅ 1.4 Fix Broken Code
- [x] `auth.py` — moved `from app.settings import settings` to top (was at bottom, fragile)
- [x] `search.py` — fixed `User.name` → `User.full_name`, `User.phone` → `User.phone_number`, `Match.title` → removed (doesn't exist), `Match.location` → `Match.venue`, added missing `case` import
- [x] `leaderboards.py` — fixed `User.name` → `User.full_name`, `User.profile_picture_url` → `User.avatar_url`, removed `User.rating` (doesn't exist), replaced MySQL `TIMESTAMPDIFF` → PostgreSQL `EXTRACT(EPOCH FROM ...)`, `Match.completed_at` → `Match.finished_at`, `Match.status == 'completed'` → `'finished'`
- [x] `notifications.py` — fixed `current_user.name` → `current_user.full_name` (2 occurrences)
- [x] `dependencies.py` — fixed `require_host_role` (was allowing any player, now properly documents that host check is per-endpoint), fixed `get_optional_current_user` (added `auto_error=False` via `optional_security`)

### ✅ 1.5 Fix Notification Model/Schema Mismatch
- [x] Updated `notification.py` model — added `title`, `message`, `type`, `data`, `priority`, `status`, `expires_at`, `updated_at` columns to match schema expectations

## Remaining Tasks

### 🔲 1.6 Service Layer (Phase 1 scope: extract most critical logic)
- [ ] Create `app/services/` directory
- [ ] Extract match scoring logic from `balls.py` controller
- [ ] Extract user management logic from `users.py` controller

### 🔲 1.7 Testing Foundation
- [ ] Update `test_backend.py` with PostgreSQL-compatible tests
- [ ] Create `tests/` directory with proper structure
- [ ] Add pytest fixtures for database sessions

### 🔲 1.8 Linting & Cleanup
- [ ] Run `pylint` on all files
- [ ] Remove `__pycache__` directories from git
- [ ] Verify all imports resolve correctly

## Files Modified
| File | Change |
|------|--------|
| `app/models/user.py` | String(36) migration |
| `app/models/profile.py` | String(36) migration |
| `app/models/match.py` | String(36) migration |
| `app/models/innings.py` | String(36) migration |
| `app/models/ball.py` | String(36) migration |
| `app/models/players_in_match.py` | String(36) migration |
| `app/models/match_event.py` | String(36) migration |
| `app/models/notification.py` | String(36) + expanded schema |
| `app/models/otp_session.py` | String(36) + removed unused imports |
| `app/database.py` | DeclarativeBase, removed create_all helpers |
| `app/settings.py` | PostgreSQL URL, removed hardcoded secrets |
| `app/main.py` | Removed create_all(), added model import |
| `app/dependencies.py` | Fixed require_host_role, optional auth |
| `app/api/auth.py` | Fixed settings import |
| `app/api/search.py` | Fixed wrong column names |
| `app/api/leaderboards.py` | PostgreSQL functions, fixed columns |
| `app/api/notifications.py` | Fixed current_user.name |
| `requirements.txt` | PostgreSQL deps, removed MySQL/deprecated |
| `.env.example` | PostgreSQL template, no real passwords |
| `alembic.ini` | PostgreSQL URL |
| `alembic/versions/003_*` | New PostgreSQL migration |
| `docker-compose.yml` | PostgreSQL 16 Alpine |
| `Dockerfile` | libpq-dev instead of MySQL |
