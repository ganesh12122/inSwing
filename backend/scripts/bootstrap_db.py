import os
import subprocess
import sys

from sqlalchemy import create_engine, inspect, text

HEAD_REVISION = "005_user_auth_schema_sync"
POSTGRES_BASE_REVISION = "003_postgresql"
DUAL_CAPTAIN_REVISION = "004_dual_captain"
PRE_POSTGRES_REVISION = "002_comprehensive_schema"


def run_alembic(*args: str) -> None:
    subprocess.run(["alembic", *args], check=True)


def infer_revision(engine) -> str | None:
    inspector = inspect(engine)
    tables = set(inspector.get_table_names())

    if "users" not in tables:
        return None

    user_columns = {column["name"] for column in inspector.get_columns("users")}
    if "password_hash" in user_columns:
        return HEAD_REVISION

    if "matches" in tables:
        match_columns = {column["name"] for column in inspector.get_columns("matches")}
        if "opponent_captain_id" in match_columns:
            return DUAL_CAPTAIN_REVISION

    return POSTGRES_BASE_REVISION


def current_revision(engine) -> str | None:
    inspector = inspect(engine)
    if not inspector.has_table("alembic_version"):
        return None

    with engine.connect() as connection:
        result = connection.execute(
            text("SELECT version_num FROM alembic_version LIMIT 1")
        )
        return result.scalar_one_or_none()


def main() -> int:
    database_url = os.environ["DATABASE_URL"]
    engine = create_engine(database_url)

    inferred = infer_revision(engine)
    current = current_revision(engine)

    if inferred is None:
        print(
            "Blank PostgreSQL database detected; stamping pre-PostgreSQL revision and upgrading."
        )
        run_alembic("stamp", PRE_POSTGRES_REVISION)
        run_alembic("upgrade", "head")
        return 0

    if current != inferred:
        print(f"Repairing Alembic revision state from {current!r} to {inferred!r}.")
        run_alembic("stamp", inferred)

    if inferred != HEAD_REVISION:
        print(f"Upgrading database from {inferred} to {HEAD_REVISION}.")
        run_alembic("upgrade", "head")
    else:
        print("Database schema already matches head revision.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
