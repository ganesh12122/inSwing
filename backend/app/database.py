import structlog
from app.settings import settings
from sqlalchemy import create_engine, event
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

logger = structlog.get_logger()


def _build_async_database_url(database_url: str) -> str:
    """Return an async-driver SQLAlchemy URL for the configured database."""
    if database_url.startswith("sqlite") and "+aiosqlite" not in database_url:
        return database_url.replace("sqlite:///", "sqlite+aiosqlite:///", 1)
    if database_url.startswith("postgresql+psycopg2"):
        return database_url.replace("postgresql+psycopg2", "postgresql+asyncpg", 1)
    if database_url.startswith("postgresql://"):
        return database_url.replace("postgresql://", "postgresql+asyncpg://", 1)
    return database_url


class Base(DeclarativeBase):
    """Base class for all SQLAlchemy ORM models."""

    pass


# Build sync and async engines depending on database type
_is_sqlite = settings.DATABASE_URL.startswith("sqlite")
_async_database_url = _build_async_database_url(settings.DATABASE_URL)

if _is_sqlite:
    # SQLite doesn't support pool_size / pool_pre_ping etc.
    engine = create_engine(
        settings.DATABASE_URL,
        connect_args={"check_same_thread": False},
        echo=settings.DEBUG,
    )

    async_engine = create_async_engine(
        _async_database_url,
        connect_args={"check_same_thread": False},
        echo=settings.DEBUG,
    )

    # Enable WAL mode & foreign keys for SQLite
    @event.listens_for(engine, "connect")
    def _set_sqlite_pragma(dbapi_connection, connection_record):  # type: ignore
        cursor = dbapi_connection.cursor()
        cursor.execute("PRAGMA journal_mode=WAL")
        cursor.execute("PRAGMA foreign_keys=ON")
        cursor.close()

    logger.info("Using SQLite database", url=settings.DATABASE_URL)
else:
    engine = create_engine(
        settings.DATABASE_URL,
        pool_pre_ping=True,
        pool_recycle=300,
        pool_size=10,
        max_overflow=20,
        echo=settings.DEBUG,
    )

    async_engine = create_async_engine(
        _async_database_url,
        pool_pre_ping=True,
        pool_recycle=300,
        pool_size=10,
        max_overflow=20,
        echo=settings.DEBUG,
    )
    logger.info("Using PostgreSQL database")

# Create session factory
SessionLocal = sessionmaker(
    autocommit=False, autoflush=False, bind=engine, class_=Session
)

AsyncSessionLocal = async_sessionmaker(
    bind=async_engine,
    class_=AsyncSession,
    autocommit=False,
    autoflush=False,
    expire_on_commit=False,
)


def get_db():
    """Dependency to get database session."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


async def get_async_db():
    """Dependency to get async database session."""
    async with AsyncSessionLocal() as db:
        yield db
        yield db
