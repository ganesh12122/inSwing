# inSwing Production Rescue Plan

## Product Intent Locked From Founder Interview

- V1 mandatory flows:
  - Signup/login with email/password
  - Profile completion with professional cricketer identity
  - Quick match creation + full ball-by-ball scoring
  - Dual-captain invite and accept flow
  - Live score share link for spectators
  - Player career stats dashboard
- Target delivery: 4 weeks
- Scale target: 50-200 concurrent live matches
- Region priority: India
- Quality rule: reliability and correctness over speed

## Delivery Strategy

### Phase 1: Backend Hardening (Week 1)

- Enforce production-safe config (hosts, CORS, secrets, environment)
- Move local dev/staging to dedicated PostgreSQL profile
- Close known auth/match flow conflicts and route ambiguities
- Add migration safety checks in CI
- Add runtime health checks for DB and Redis

### Phase 2: Core API Reliability (Week 2)

- Stabilize end-to-end flows:
  - register/login/profile
  - quick match create/start/score/finish
  - dual captain invite/accept/rules/team readiness
- Add idempotency for scoring actions
- Add pagination and filtering contracts for dashboard/search
- Add soft-delete and recovery workflow for matches (30 days)

### Phase 3: Frontend Rebuild in `frontend/` (Week 2-3)

- Stack: React + TypeScript + Vite + Tailwind + TanStack Query
- Build mobile-first responsive PWA shell
- Screens:
  - Auth
  - Profile Setup
  - Dashboard
  - Match Studio (quick + dual)
  - Ball-by-ball Scoring Console
  - Public Live Score page
- Integrate API client with token refresh handling

### Phase 4: Launch Readiness (Week 4)

- Observability: Sentry + structured logs + uptime checks
- Performance/load test for 50-200 concurrent matches
- Security checks (JWT secret policy, CORS, host headers, rate limits)
- Rollback plan and release checklist

## Immediate Next Sprint Tasks

1. Complete backend move to SQLAlchemy async sessions and async engine.
2. Remove or deprecate legacy OTP routes from primary auth path.
3. Finalize profile schema for professional cricket identity fields.
4. Implement quick match + scoring API contract tests against PostgreSQL.
5. Implement frontend auth/profile/dashboard with real API integration.

## Done In This Rescue Start

- Added production-oriented settings validation
- Hardened trusted hosts and CORS handling
- Added DB-aware health check response
- Fixed conflicting duplicate auth login route (`/auth/login` vs OTP)
- Added dedicated PostgreSQL local profile and setup docs
- Created fresh React frontend foundation in `frontend/`
