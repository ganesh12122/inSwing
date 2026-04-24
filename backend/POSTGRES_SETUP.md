# Dedicated PostgreSQL Setup (Local)

This project now includes a dedicated local PostgreSQL profile for development and staging-like testing.

## Files

- `backend/docker-compose.postgres.yml`
- `backend/.env.postgres.local`
- `backend/.env.example`

## 1. Start PostgreSQL

From `backend/`:

```powershell
docker compose -f docker-compose.postgres.yml up -d
```

## 2. Configure backend environment

Use the dedicated profile:

```powershell
Copy-Item .env.postgres.local .env -Force
```

If needed, update `DATABASE_URL` in `.env`.

## 3. Run migrations

```powershell
..\.venv\Scripts\python.exe -m alembic upgrade head
```

## 4. Run backend

```powershell
..\.venv\Scripts\python.exe -m uvicorn app.main:app --reload --port 8000
```

## 5. Verify health

- `GET http://localhost:8000/health`
- Expected response includes `database: "up"`

## Notes

- For production, set `ENVIRONMENT=production`, strong `SECRET_KEY`, explicit `ALLOWED_HOSTS`, and explicit `CORS_ORIGINS`.
- Never use default passwords in deployed environments.
