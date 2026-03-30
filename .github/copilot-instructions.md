# inSwing - Cricket Scoring Platform - Copilot Instructions

## Project Overview
inSwing is a **commercial-grade real-time cricket scoring and tournament management platform** targeting gully cricket players and semi-professional cricketers who want to bring professional-level match tracking to their games. The goal is to build a **product that generates revenue** with **zero investment** using open-source tools and free-tier deployments.

## Tech Stack
- **Backend**: Python FastAPI + SQLAlchemy ORM + Alembic migrations
- **Database**: PostgreSQL (migrating from MySQL for free Supabase/Neon hosting)
- **Cache**: Redis (Upstash free tier)
- **Frontend**: Flutter (Dart) with Riverpod state management
- **Auth**: Phone OTP + JWT tokens
- **Real-time**: WebSocket for live scoring
- **Deployment**: Railway/Render (backend), Vercel (web), Play Store/App Store (mobile)

## Architecture Rules

### Backend (FastAPI)
1. **Always use async/await** for all endpoint handlers
2. **Use Pydantic v2 schemas** for all request/response validation
3. **Use proper dependency injection** via FastAPI's `Depends()`
4. **All database operations** must use SQLAlchemy async sessions
5. **Use Alembic** for all schema changes — never use `create_all()` in production
6. **Error handling**: Use custom exception classes from `app/error_handlers.py`
7. **Logging**: Use `structlog` for all logging — never use `print()`
8. **Security**: Never hardcode secrets. Use `.env` files and `pydantic-settings`
9. **API versioning**: All routes under `/api/v1/`
10. **Testing**: Write pytest tests for every new endpoint

### Frontend (Flutter)
1. **State Management**: Use Riverpod with code generation (`@riverpod` annotations)
2. **Navigation**: Use `go_router` for all navigation
3. **Models**: Use `freezed` for immutable data classes with JSON serialization
4. **API calls**: Use `Dio` with interceptors for auth token management
5. **Offline-first**: All scoring data must work offline and sync when connected
6. **Theme**: Follow Material 3 design with the existing theme system
7. **Error handling**: Show user-friendly error messages via SnackBar/Dialog
8. **Code generation**: Run `dart run build_runner build` after model changes

### Database Conventions
- UUIDs (v4) for all primary keys
- `created_at` and `updated_at` timestamps on all tables
- Soft deletes where appropriate (use `is_active` flag)
- Foreign key constraints with proper `ON DELETE` behavior
- Indexes on all frequently queried columns

### Code Quality Rules
1. **No TODO comments** without a linked GitHub issue
2. **No hardcoded values** — use constants or config
3. **Type hints** on all Python functions
4. **Dart strict mode** — no `dynamic` types unless absolutely necessary
5. **DRY principle** — extract reusable logic into services/utils
6. **Single Responsibility** — one class/function per concern

## Working Rules for AI Assistant

### Before Writing Any Code
1. **ALWAYS explore the full project structure** before making changes
2. **Read related files** to understand existing patterns and conventions
3. **Check for existing implementations** to avoid duplication
4. **Understand the data flow** end-to-end (DB → API → Flutter)

### While Coding
1. **Fix errors completely** — never leave partial fixes
2. **Run tests** after every significant change
3. **Update both backend schemas AND Flutter models** when changing data structures
4. **Maintain backward compatibility** for API changes
5. **Use filesystem + grep tools** to find all usages before refactoring

### After Coding
1. **Verify no regressions** — check related functionality
2. **Update documentation** if behavior changes
3. **Run linters** (pylint for Python, dart analyze for Flutter)
4. **Commit with conventional commit messages** (feat:, fix:, refactor:, docs:)

## Business Context
- **Target Users**: Gully cricket players, club cricketers, local tournament organizers
- **Revenue Model**: Freemium (free basic, paid premium features)
- **Key Differentiator**: Professional-grade scoring for informal matches
- **Zero Investment**: Use only free tiers and open-source tools
- **Deployment**: Must support free hosting (Railway, Render, Supabase, Vercel)

## File Organization
```
backend/
  app/
    api/          # Route handlers (thin controllers)
    auth/         # Authentication logic
    models/       # SQLAlchemy ORM models
    schemas/      # Pydantic validation schemas
    services/     # Business logic layer (TO BE ADDED)
    database.py   # DB connection
    settings.py   # Config from env vars
    main.py       # FastAPI app entry point

flutter/
  lib/
    models/       # Freezed data models
    providers/    # Riverpod state management
    routes/       # GoRouter configuration
    screens/      # UI screens
    services/     # API & storage services
    theme/        # App theme
    utils/        # Constants & helpers
    widgets/      # Reusable UI components
```
