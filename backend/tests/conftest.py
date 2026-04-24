"""
Test configuration and fixtures for inSwing backend automated testing.

Uses an in-memory SQLite database so tests run without external dependencies
(no PostgreSQL, no Redis needed). Each test gets a fresh database.
"""

import os
import sys

# Ensure backend is on the Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

import pytest
from app.auth.jwt import create_access_token
from app.database import Base, get_async_db, get_db
from app.main import app
from app.models.ball import Ball
from app.models.innings import Innings
from app.models.match import Match
from app.models.match_event import MatchEvent
from app.models.notification import Notification
from app.models.otp_session import OTPSession
from app.models.players_in_match import PlayersInMatch
from app.models.profile import Profile
from app.models.user import User
from fastapi.testclient import TestClient
from sqlalchemy import create_engine, event
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import Session, sessionmaker

# ============================================================================
# DATABASE SETUP — In-memory SQLite for fast isolated tests
# ============================================================================

SQLALCHEMY_TEST_URL = "sqlite:///./test.db"

test_engine = create_engine(
    SQLALCHEMY_TEST_URL,
    connect_args={"check_same_thread": False},
)

test_async_engine = create_async_engine(
    "sqlite+aiosqlite:///./test.db",
    connect_args={"check_same_thread": False},
)

TestingAsyncSessionLocal = async_sessionmaker(
    test_async_engine,
    class_=AsyncSession,
    autocommit=False,
    autoflush=False,
    expire_on_commit=False,
)


# Enable foreign keys for SQLite (disabled by default)
@event.listens_for(test_engine, "connect")
def set_sqlite_pragma(dbapi_connection, connection_record):
    cursor = dbapi_connection.cursor()
    cursor.execute("PRAGMA foreign_keys=ON")
    cursor.close()


TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=test_engine)


# ============================================================================
# FIXTURES
# ============================================================================


@pytest.fixture(scope="function")
def db_session():
    """Create a fresh database for each test."""
    Base.metadata.create_all(bind=test_engine)
    session = TestingSessionLocal()
    try:
        yield session
    finally:
        session.close()
        Base.metadata.drop_all(bind=test_engine)


@pytest.fixture(scope="function")
def client(db_session):
    """FastAPI test client with overridden database dependency."""

    def override_get_db():
        try:
            yield db_session
        finally:
            pass

    async def override_get_async_db():
        async with TestingAsyncSessionLocal() as session:
            yield session

    app.dependency_overrides[get_db] = override_get_db
    app.dependency_overrides[get_async_db] = override_get_async_db
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()


@pytest.fixture
def test_user(db_session: Session) -> User:
    """Create a test user (Captain A / Host)."""
    user = User(
        phone_number="+919876543210",
        full_name="Virat Kohli",
        role="player",
        is_active=True,
    )
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    return user


@pytest.fixture
def test_user_b(db_session: Session) -> User:
    """Create a second test user (Captain B / Opponent)."""
    user = User(
        phone_number="+919876543211",
        full_name="Rohit Sharma",
        role="player",
        is_active=True,
    )
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    return user


@pytest.fixture
def test_user_c(db_session: Session) -> User:
    """Create a third test user (extra player)."""
    user = User(
        phone_number="+919876543212",
        full_name="Jasprit Bumrah",
        role="player",
        is_active=True,
    )
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    return user


@pytest.fixture
def admin_user(db_session: Session) -> User:
    """Create an admin user."""
    user = User(
        phone_number="+919876543299",
        full_name="Admin User",
        role="admin",
        is_active=True,
    )
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    return user


def get_auth_headers(user: User) -> dict:
    """Generate Bearer token headers for a user."""
    token = create_access_token(data={"sub": user.id})
    return {"Authorization": f"Bearer {token}"}
    return {"Authorization": f"Bearer {token}"}
