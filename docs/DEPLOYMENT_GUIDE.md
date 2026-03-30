# 🚀 inSwing — Deployment Guide (Zero Investment)

## Overview

Every service in this guide is **100% free** for our scale. No credit card required for most.

---

## 1. Database — Neon PostgreSQL

### Why Neon?

- Free tier: 0.5GB storage, always-on
- Serverless (scales to zero, no idle costs)
- PostgreSQL compatible (industry standard)

### Setup

1. Go to [neon.tech](https://neon.tech)
2. Sign up with GitHub
3. Create project: `inswing-prod`
4. Copy connection string:
   ```
   postgresql://user:pass@ep-xxx.us-east-2.aws.neon.tech/inswing?sslmode=require
   ```
5. Set in `.env`:
   ```
   DATABASE_URL=postgresql+asyncpg://user:pass@ep-xxx.us-east-2.aws.neon.tech/inswing?sslmode=require
   ```

### Tips

- Use **branching** for staging environment (free)
- Enable **connection pooling** for better performance
- Set `pool_size=5` (free tier limit)

---

## 2. Backend — Railway or Render

### Option A: Railway

1. Go to [railway.app](https://railway.app)
2. Connect GitHub repo
3. Set root directory: `backend/`
4. Add environment variables from `.env`
5. Deploy command: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`

**Free tier:** 500 hrs/month, 512MB RAM, 1GB disk

### Option B: Render

1. Go to [render.com](https://render.com)
2. Create "Web Service"
3. Connect GitHub repo, set root to `backend/`
4. Build command: `pip install -r requirements.txt`
5. Start command: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`

**Free tier:** 750 hrs/month, spins down after 15 min idle

### Environment Variables to Set

```
DATABASE_URL=postgresql+asyncpg://...
SECRET_KEY=<generate-strong-key>
REDIS_URL=redis://...@...:6379
DEBUG=False
CORS_ORIGINS=["https://inswing.vercel.app","https://your-domain.com"]
OTP_EXPIRE_MINUTES=10
OTP_MAX_ATTEMPTS=3
```

---

## 3. Cache — Upstash Redis

### Setup

1. Go to [upstash.com](https://upstash.com)
2. Create Redis database: `inswing-cache`
3. Copy REST URL and token
4. Set in `.env`:
   ```
   REDIS_URL=rediss://default:xxx@xxx.upstash.io:6379
   ```

**Free tier:** 10K commands/day, 256MB

---

## 4. File Storage — Cloudflare R2

### Setup

1. Go to [cloudflare.com](https://cloudflare.com)
2. Create R2 bucket: `inswing-uploads`
3. Generate API token with R2 permissions
4. Use S3-compatible SDK in Python:
   ```python
   import boto3
   s3 = boto3.client('s3',
       endpoint_url='https://xxx.r2.cloudflarestorage.com',
       aws_access_key_id='...',
       aws_secret_access_key='...'
   )
   ```

**Free tier:** 10GB storage, 10M requests/month

---

## 5. Web Hosting — Vercel

### Setup (Flutter Web)

1. Build Flutter web: `flutter build web`
2. Deploy to Vercel:
   ```bash
   npm i -g vercel
   cd flutter/build/web
   vercel --prod
   ```

**Free tier:** Unlimited deployments, automatic HTTPS

---

## 6. SMS/OTP — Firebase Authentication

### Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create project: `inswing`
3. Enable Phone Authentication
4. Add your app (Android/iOS/Web)

**Free tier:** 10K verifications/month

### Alternative: MSG91

- 1000 free SMS/month
- India-specific, cheaper for scale

---

## 7. Push Notifications — Firebase Cloud Messaging (FCM)

### Setup

1. Same Firebase project
2. Enable Cloud Messaging
3. Add `firebase_messaging` to Flutter
4. Configure server key for backend

**Free tier:** Unlimited push notifications

---

## 8. CI/CD — GitHub Actions

### Setup

Create `.github/workflows/backend-ci.yml`:

```yaml
name: Backend CI
on:
  push:
    branches: [main]
    paths: ["backend/**"]
  pull_request:
    branches: [main]
    paths: ["backend/**"]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: inswing_test
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
        ports: ["5432:5432"]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: |
          cd backend
          pip install -r requirements.txt
          pytest --tb=short
        env:
          DATABASE_URL: postgresql+asyncpg://test:test@localhost:5432/inswing_test
```

**Free tier:** 2000 minutes/month

---

## 9. Error Tracking — Sentry

### Setup

1. Go to [sentry.io](https://sentry.io)
2. Create project: `inswing-backend` (Python/FastAPI)
3. Create project: `inswing-flutter` (Flutter)
4. Add SDK:
   ```python
   # Backend
   import sentry_sdk
   sentry_sdk.init(dsn="https://xxx@sentry.io/xxx")
   ```

**Free tier:** 5K events/month

---

## 10. Analytics — PostHog

### Setup

1. Go to [posthog.com](https://posthog.com)
2. Create project
3. Add to Flutter:
   ```dart
   // Track events
   PostHog.capture('match_created', properties: {'type': 'quick'});
   ```

**Free tier:** 1M events/month

---

## Production Checklist

- [ ] PostgreSQL on Neon (with connection pooling)
- [ ] Backend on Railway/Render (with health checks)
- [ ] Redis on Upstash (for caching)
- [ ] R2 on Cloudflare (for file uploads)
- [ ] Web on Vercel (Flutter web build)
- [ ] Firebase Auth (phone OTP)
- [ ] Firebase FCM (push notifications)
- [ ] GitHub Actions (CI/CD pipeline)
- [ ] Sentry (error tracking)
- [ ] PostHog (analytics)
- [ ] Custom domain (optional, Cloudflare free DNS)
- [ ] SSL certificates (automatic via providers)
- [ ] Environment variables secured
- [ ] Rate limiting enabled
- [ ] CORS restricted to production domains
- [ ] Debug mode disabled
- [ ] Secret key rotated from development value
