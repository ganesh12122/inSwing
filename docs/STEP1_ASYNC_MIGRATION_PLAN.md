# Step 1: Async SQLAlchemy Migration Plan

## Objective
Migrate backend database access from synchronous SQLAlchemy sessions to asynchronous sessions (`AsyncSession`) while preserving API behavior.

## Scope
- `backend/app/database.py`
- `backend/app/dependencies.py`
- `backend/app/api/*.py`
- `backend/alembic/env.py` (compatibility checks)
- test suite updates if required

## Migration Sequence
1. Database core and dependency injection.
2. Auth and user dependency path.
3. Users + search APIs.
4. Matches + balls APIs.
5. Notifications + leaderboards APIs.
6. Final test sweep and warning cleanup.

## Technical Rules
- Use `create_async_engine` and `async_sessionmaker`.
- Replace `db.query(...)` with `select(...)` + `await db.execute(...)`.
- Use `result.scalars().first()` / `all()` / `one_or_none()` as appropriate.
- Keep transactions explicit: `await db.commit()`, `await db.refresh(...)`.
- Avoid mixed sync/async DB access in request handlers.

## Validation Gates
- Run `pytest -q` after each module batch.
- No endpoint behavior regressions.
- Keep route contracts unchanged.

## Known Risks
- `MissingGreenlet` if any sync query path remains.
- Relationship loading behavior differences.
- Query semantics changes in complex filters.

## Exit Criteria
- All API modules use `AsyncSession`.
- Test suite passes.
- Health endpoint remains stable with DB connectivity.
