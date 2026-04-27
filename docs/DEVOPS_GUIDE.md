# inSwing — DevOps & Deployment Guide

> **Version**: 1.0 | **Last Updated**: 2026-04-27  
> **Target**: Zero-investment production deployment with free-tier services

---

## 1. Infrastructure Overview

### 1.1 Service Map

| Component | Service | Tier | Limits | Monthly Cost |
|-----------|---------|------|--------|-------------|
| **Backend API** | Railway / Render | Free | 500-750 hrs/mo, 512MB RAM | $0 |
| **Database** | Neon PostgreSQL | Free | 0.5 GB storage, 1 compute | $0 |
| **Cache/Pub-Sub** | Upstash Redis | Free | 10K commands/day, 256MB | $0 |
| **Web Hosting** | Vercel | Free | Unlimited deploys, 100GB BW | $0 |
| **CDN/Proxy** | Cloudflare | Free | Unlimited BW, DDoS protection | $0 |
| **SMS/OTP** | Firebase Auth | Free | 10K verifications/month | $0 |
| **Push Notifications** | Firebase Cloud Messaging | Free | Unlimited | $0 |
| **CI/CD** | GitHub Actions | Free | 2000 minutes/month | $0 |
| **File Storage** | Cloudflare R2 | Free | 10GB, 10M requests/month | $0 |
| **Domain** | Any registrar | Paid | - | ~$10/year |
| **Monitoring** | Better Stack / Grafana Cloud | Free | Basic alerting | $0 |
| **Error Tracking** | Sentry | Free | 5K errors/month | $0 |

**Total Launch Cost: $0/month** (+ ~$10/year for domain)

---

## 2. Local Development Setup

### 2.1 Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Python | 3.11+ | Backend runtime |
| Node.js | 18+ | Frontend tooling |
| Flutter | 3.19+ | Mobile/web client |
| Docker | 24+ | Local PostgreSQL + Redis |
| Git | 2.40+ | Version control |

### 2.2 Quick Start

```powershell
# 1. Clone repository
git clone https://github.com/your-org/inswing.git
cd inswing

# 2. Start infrastructure (PostgreSQL + Redis)
docker compose up -d

# 3. Backend setup
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt

# 4. Configure environment
cp .env.example .env
# Edit .env with your local settings

# 5. Run database migrations
alembic upgrade head

# 6. Start backend server
uvicorn app.main:app --reload --port 8000

# 7. Verify
# API docs: http://localhost:8000/docs
# Health: http://localhost:8000/health
```

### 2.3 Docker Compose (Local Development)

```yaml
# docker-compose.yml (root)
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: inswing_dev
      POSTGRES_USER: inswing
      POSTGRES_PASSWORD: inswing_dev_pass
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U inswing"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7.0-alpine
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

volumes:
  pgdata:
  redis_data:
```

### 2.4 Environment Variables (.env)

```env
# Database
DATABASE_URL=postgresql+psycopg2://inswing:inswing_dev_pass@localhost:5432/inswing_dev

# Redis
REDIS_URL=redis://localhost:6379/0

# Auth
SECRET_KEY=your-development-secret-key-min-32-chars-long
ACCESS_TOKEN_EXPIRE_MINUTES=60
REFRESH_TOKEN_EXPIRE_DAYS=30

# App
ENVIRONMENT=development
DEBUG=true
CORS_ORIGINS=http://localhost:3000,http://localhost:5173
ALLOWED_HOSTS=localhost,127.0.0.1

# OTP (dev mode skips actual SMS)
OTP_PROVIDER=dev
```

---

## 3. Database Operations

### 3.1 Alembic Migrations

```powershell
# Create a new migration
alembic revision --autogenerate -m "description_of_change"

# Apply all pending migrations
alembic upgrade head

# Rollback last migration
alembic downgrade -1

# View migration history
alembic history

# View current version
alembic current

# Generate SQL without applying (for review)
alembic upgrade head --sql > migration_review.sql
```

### 3.2 Migration Workflow

```
1. Modify SQLAlchemy model in backend/app/models/
2. Run: alembic revision --autogenerate -m "add_xyz_column"
3. Review generated migration in alembic/versions/
4. Test locally: alembic upgrade head
5. Run test suite: pytest
6. Commit migration file with code changes
7. Deploy → migration runs automatically on startup
```

### 3.3 Database Backup (Production)

Neon PostgreSQL provides:
- **Point-in-time recovery**: Automatic, up to 7 days
- **Branching**: Create database branches for testing migrations
- **Snapshot export**: Manual pg_dump via connection string

```powershell
# Manual backup (if needed)
pg_dump $DATABASE_URL --format=custom -f backup_$(Get-Date -Format 'yyyyMMdd').dump

# Restore
pg_restore --dbname=$DATABASE_URL backup.dump
```

---

## 4. CI/CD Pipeline

### 4.1 GitHub Actions Workflow

```yaml
# .github/workflows/backend-ci.yml
name: Backend CI/CD

on:
  push:
    branches: [main, develop]
    paths: ['backend/**']
  pull_request:
    branches: [main]
    paths: ['backend/**']

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'

      - name: Install dependencies
        working-directory: backend
        run: pip install -r requirements.txt

      - name: Run linter
        working-directory: backend
        run: |
          pip install ruff
          ruff check app/

      - name: Run tests
        working-directory: backend
        run: |
          pytest -q --tb=short
        env:
          DATABASE_URL: sqlite:///./test.db
          SECRET_KEY: test-secret-key-for-ci-pipeline-only
          ENVIRONMENT: testing

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Railway deployment (auto-detected from Dockerfile)
      - name: Deploy to Railway
        uses: bervProject/railway-deploy@main
        with:
          railway_token: ${{ secrets.RAILWAY_TOKEN }}
          service: inswing-backend
```

### 4.2 Flutter CI/CD

```yaml
# .github/workflows/flutter-ci.yml
name: Flutter CI/CD

on:
  push:
    branches: [main]
    paths: ['flutter/**']
  pull_request:
    paths: ['flutter/**']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          cache: true

      - name: Get dependencies
        working-directory: flutter
        run: flutter pub get

      - name: Run analyzer
        working-directory: flutter
        run: flutter analyze

      - name: Run tests
        working-directory: flutter
        run: flutter test

      - name: Build web
        working-directory: flutter
        run: flutter build web --release

      # Deploy Flutter web to Vercel
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          working-directory: flutter/build/web
```

---

## 5. Production Deployment

### 5.1 Backend Deployment (Railway)

**Setup Steps:**
1. Connect GitHub repo to Railway
2. Set root directory: `backend/`
3. Railway auto-detects Dockerfile
4. Add environment variables in Railway dashboard
5. Enable auto-deploy on push to `main`

**Railway Configuration:**
```
Root Directory: backend
Build Command: (uses Dockerfile)
Start Command: uvicorn app.main:app --host 0.0.0.0 --port $PORT --workers 4
Health Check: /health
Region: us-west1 (closest to India traffic via CDN)
```

**Required Environment Variables (Railway):**
```
DATABASE_URL=postgresql+asyncpg://user:pass@neon-host/inswing_prod
REDIS_URL=redis://default:pass@upstash-host:port
SECRET_KEY=<generated-64-char-secret>
ENVIRONMENT=production
DEBUG=false
CORS_ORIGINS=https://inswing.app,https://www.inswing.app
ALLOWED_HOSTS=api.inswing.app,inswing.app
```

### 5.2 Database Setup (Neon PostgreSQL)

1. Create account at [neon.tech](https://neon.tech)
2. Create project → "inswing-prod"
3. Copy connection string (use `pooled` endpoint for production)
4. Run initial migration:
   ```powershell
   DATABASE_URL="postgresql+psycopg2://..." alembic upgrade head
   ```
5. Enable connection pooling (PgBouncer built into Neon)

### 5.3 Redis Setup (Upstash)

1. Create account at [upstash.com](https://upstash.com)
2. Create Redis database → Region: Mumbai (ap-south-1)
3. Copy Redis URL (REST-based, works with standard redis-py)
4. Set `REDIS_URL` in Railway environment

### 5.4 Domain & CDN (Cloudflare)

```
DNS Setup:
  inswing.app          → Vercel (Flutter web)     CNAME
  api.inswing.app      → Railway backend          CNAME
  www.inswing.app      → Vercel redirect          CNAME

Cloudflare Settings:
  SSL: Full (Strict)
  Always Use HTTPS: On
  Minimum TLS: 1.2
  Auto Minify: JS, CSS, HTML
  Caching: Standard
  DDoS Protection: On (automatic)
```

### 5.5 Dockerfile (Production)

```dockerfile
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev gcc && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create non-root user
RUN adduser --disabled-password --gecos '' appuser && \
    chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

# Start with multiple workers
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
```

---

## 6. Monitoring & Alerting

### 6.1 Health Check Dashboard

| Service | Check | Endpoint | Frequency |
|---------|-------|----------|-----------|
| Backend API | HTTP 200 | `https://api.inswing.app/health` | 30s |
| Database | SELECT 1 | Via health endpoint | 30s |
| Redis | PING | Via health endpoint (planned) | 60s |
| Flutter Web | HTTP 200 | `https://inswing.app` | 60s |

### 6.2 Key Metrics to Monitor

| Metric | Source | Alert Threshold |
|--------|--------|----------------|
| API response time (P95) | structlog | > 2 seconds |
| Error rate (5xx) | structlog | > 5% of requests |
| DB connection pool usage | SQLAlchemy metrics | > 80% |
| WebSocket connections | ConnectionManager | > 1000 |
| Redis command rate | Upstash dashboard | > 8K/day (80% of free limit) |
| Neon storage usage | Neon dashboard | > 400MB (80% of free limit) |

### 6.3 Alerting Channels

```
Health Check Failure → Better Stack → Slack/Discord webhook → Team notification
Error Spike          → Sentry       → Email + Slack alert
Resource Warning     → Dashboard    → Weekly review
```

### 6.4 Structured Logging

All logs are JSON-formatted via structlog:
```json
{
  "event": "Request completed",
  "request_id": "uuid",
  "method": "POST",
  "path": "/api/v1/matches/",
  "status_code": 200,
  "duration_seconds": 0.045,
  "user_id": "uuid",
  "logger": "request",
  "level": "info",
  "timestamp": "2026-04-27T12:00:00.000Z"
}
```

---

## 7. Scaling Playbook

### 7.1 When to Scale

| Signal | Action |
|--------|--------|
| P95 response time > 1s consistently | Add backend worker / upgrade instance |
| DB connection pool exhausted | Increase pool_size or switch to PgBouncer |
| Redis 10K cmd/day limit hit | Upgrade to Upstash Pro ($10/mo) |
| Neon storage > 400MB | Upgrade to Neon Pro ($19/mo) |
| WebSocket memory > 300MB | Extract WS to separate service |
| Railway free hours exhausted | Move to Railway Pro ($5/mo) |

### 7.2 Scaling Checklist

```
□ Enable Cloudflare caching rules for GET endpoints
□ Add Redis caching for leaderboard + search queries  
□ Enable Neon connection pooling (built-in PgBouncer)
□ Set up database read replica for analytics queries
□ Extract WebSocket to dedicated service
□ Add horizontal auto-scaling (Railway Pro or Render)
□ Configure rate limiting via Redis
□ Set up CDN for static assets (profile images, etc.)
```

### 7.3 Cost Scaling Trajectory

```
$0/mo  ──► $25/mo ──► $100/mo ──► $300/mo
  │          │           │           │
  │          │           │           └── 100K+ DAU: Dedicated infra
  │          │           └── 50K DAU: Multi-instance + read replicas
  │          └── 10K DAU: Paid tiers for DB + Redis + hosting
  └── Launch: Free tiers everywhere
```

---

## 8. Disaster Recovery

### 8.1 Backup Strategy

| Data | Method | Frequency | Retention |
|------|--------|-----------|-----------|
| PostgreSQL | Neon auto-backup | Continuous (PITR) | 7 days |
| Redis cache | Ephemeral (rebuild from DB) | N/A | N/A |
| Application code | Git (GitHub) | Every push | Forever |
| Environment vars | Encrypted in CI/CD secrets | On change | Version controlled |
| User-uploaded files | Cloudflare R2 replication | Automatic | 30 days |

### 8.2 Recovery Procedures

**Database Recovery:**
```
1. Go to Neon console → Project → Branches
2. Create branch from point-in-time before incident
3. Verify data on branch
4. Promote branch to production OR apply fix-forward migration
```

**Backend Service Recovery:**
```
1. Railway/Render auto-restarts on crash
2. If deployment broke: revert to previous commit
3. If persistent: check health endpoint, review error logs
4. Rollback: git revert <bad-commit> && git push
```

**Full Outage Recovery:**
```
1. Verify DNS (Cloudflare) is resolving correctly
2. Check Railway/Render service status
3. Check Neon PostgreSQL status page
4. Check Upstash Redis status
5. If provider outage: wait OR failover to backup provider
6. Post-incident: write postmortem, update runbook
```

---

## 9. Security Operations

### 9.1 Secret Rotation Schedule

| Secret | Rotation | Method |
|--------|----------|--------|
| SECRET_KEY (JWT) | Every 90 days | Generate new, deploy, old tokens auto-expire |
| DATABASE_URL password | Every 90 days | Rotate in Neon, update Railway env |
| REDIS_URL password | Every 90 days | Rotate in Upstash, update Railway env |
| GitHub deploy token | Every 180 days | Regenerate in GitHub Actions secrets |

### 9.2 Security Checklist (Pre-Launch)

```
□ All secrets in environment variables (never in code)
□ HTTPS enforced everywhere (Cloudflare Full Strict)
□ CORS origins restricted to production domains
□ API docs disabled in production
□ Rate limiting configured
□ OTP max attempts enforced (3 per session)
□ JWT token expiry set (1 hour access, 30 day refresh)
□ SQL injection protection verified (parameterized queries)
□ Input validation on all endpoints (Pydantic schemas)
□ Non-root Docker user
□ Dependency vulnerability scan (pip-audit / safety)
□ No PII in logs
```

---

## 10. Release Process

### 10.1 Git Branching Strategy

```
main (production)
  │
  ├── develop (staging / integration)
  │     │
  │     ├── feature/match-commentary
  │     ├── feature/tournament-mode
  │     └── fix/otp-expiry-bug
  │
  └── hotfix/critical-auth-fix (emergency only)
```

### 10.2 Release Workflow

```
1. Feature branch → develop (PR + review + tests pass)
2. develop accumulates features for release
3. develop → main (release PR + final review)
4. main push triggers:
   - Backend CI → test → deploy to Railway
   - Flutter CI → test → build → deploy to Vercel
   - Alembic migration runs automatically on startup
5. Verify health check + smoke test
6. Tag release: git tag v1.x.x
```

### 10.3 Conventional Commits

```
feat: add tournament bracket system
fix: resolve OTP expiry race condition
refactor: migrate matches.py to async sessions
docs: update system design document
test: add dual captain lifecycle tests
chore: upgrade SQLAlchemy to 2.1.0
perf: cache leaderboard queries in Redis
```

---

## Appendix: Quick Reference Commands

```powershell
# === Local Development ===
docker compose up -d                    # Start postgres + redis
cd backend; ..\.venv\Scripts\Activate.ps1
uvicorn app.main:app --reload           # Start dev server
pytest -q                               # Run tests
alembic upgrade head                    # Apply migrations

# === Database ===
alembic revision --autogenerate -m "msg" # Create migration
alembic downgrade -1                     # Rollback
alembic history                          # View history

# === Production ===
railway up                               # Deploy to Railway
railway logs                             # View production logs
railway env set KEY=VALUE                # Set env var

# === Debugging ===
curl https://api.inswing.app/health      # Health check
railway logs --tail 100                  # Tail production logs
```
