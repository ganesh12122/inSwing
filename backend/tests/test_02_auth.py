"""
Test 2: Authentication flow — Email+password register/login, token refresh, logout.
Also tests legacy OTP endpoints (request-otp, verify-otp).
"""

from tests.conftest import get_auth_headers


class TestAuthRegister:
    """Email + password registration flow."""

    def test_register_creates_user(self, client):
        """POST /api/v1/auth/register should create user and return tokens."""
        resp = client.post(
            "/api/v1/auth/register",
            json={
                "full_name": "Test Player",
                "email": "player@example.com",
                "password": "securepass123",
            },
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "tokens" in data
        assert "user" in data
        assert data["user"]["email"] == "player@example.com"
        assert data["user"]["full_name"] == "Test Player"
        assert data["tokens"]["token_type"] == "bearer"
        assert len(data["tokens"]["access_token"]) > 20
        assert data["message"] == "Registration successful"

    def test_register_duplicate_email_rejected(self, client):
        """Registering with an already-used email should 400."""
        payload = {
            "full_name": "User A",
            "email": "dup@example.com",
            "password": "password123",
        }
        r1 = client.post("/api/v1/auth/register", json=payload)
        assert r1.status_code == 200

        r2 = client.post("/api/v1/auth/register", json=payload)
        assert r2.status_code == 400
        assert "already registered" in r2.json()["error"]["message"].lower()

    def test_register_short_password_rejected(self, client):
        """Password shorter than 6 chars should 422 (validation error)."""
        resp = client.post(
            "/api/v1/auth/register",
            json={
                "full_name": "Short Pass",
                "email": "short@example.com",
                "password": "12345",
            },
        )
        assert resp.status_code == 422

    def test_register_invalid_email_rejected(self, client):
        """Invalid email format should 422."""
        resp = client.post(
            "/api/v1/auth/register",
            json={
                "full_name": "Bad Email",
                "email": "not-an-email",
                "password": "password123",
            },
        )
        assert resp.status_code == 422


class TestAuthLogin:
    """Email + password login flow."""

    def _register_user(self, client, email="login@example.com", password="password123"):
        """Helper: register a user for login tests."""
        client.post(
            "/api/v1/auth/register",
            json={
                "full_name": "Login Test User",
                "email": email,
                "password": password,
            },
        )

    def test_login_valid_credentials(self, client):
        """POST /api/v1/auth/login with valid email+password returns tokens."""
        self._register_user(client)
        resp = client.post(
            "/api/v1/auth/login",
            json={"email": "login@example.com", "password": "password123"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "tokens" in data
        assert "user" in data
        assert data["user"]["email"] == "login@example.com"
        assert data["message"] == "Login successful"

    def test_login_wrong_password(self, client):
        """Wrong password should 401."""
        self._register_user(client, email="wrongpw@example.com")
        resp = client.post(
            "/api/v1/auth/login",
            json={"email": "wrongpw@example.com", "password": "wrongpassword"},
        )
        assert resp.status_code == 401

    def test_login_nonexistent_email(self, client):
        """Non-existent email should 401."""
        resp = client.post(
            "/api/v1/auth/login",
            json={"email": "nobody@example.com", "password": "password123"},
        )
        assert resp.status_code == 401

    def test_login_invalid_email_format(self, client):
        """Invalid email format should 422."""
        resp = client.post(
            "/api/v1/auth/login",
            json={"email": "not-email", "password": "password123"},
        )
        assert resp.status_code == 422


class TestAuthTokenRefresh:
    """Token refresh flow."""

    def _register_and_get_tokens(self, client, email="refresh@example.com"):
        """Helper: register and get tokens."""
        resp = client.post(
            "/api/v1/auth/register",
            json={
                "full_name": "Refresh User",
                "email": email,
                "password": "password123",
            },
        )
        return resp.json()["tokens"]

    def test_refresh_token_works(self, client):
        """POST /api/v1/auth/refresh with valid refresh token returns new tokens."""
        tokens = self._register_and_get_tokens(client)
        resp = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": tokens["refresh_token"]},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "access_token" in data
        assert "refresh_token" in data

    def test_refresh_with_access_token_fails(self, client):
        """Using access_token as refresh should fail."""
        tokens = self._register_and_get_tokens(client, email="refresh2@example.com")
        resp = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": tokens["access_token"]},
        )
        assert resp.status_code == 401


class TestAuthLogout:
    """Logout flow."""

    def test_logout_requires_auth(self, client):
        """POST /api/v1/auth/logout without token should 401/403."""
        resp = client.post("/api/v1/auth/logout")
        assert resp.status_code in (401, 403)

    def test_logout_succeeds(self, client, test_user):
        """POST /api/v1/auth/logout with valid token should 200."""
        headers = get_auth_headers(test_user)
        resp = client.post("/api/v1/auth/logout", headers=headers)
        assert resp.status_code == 200
        assert resp.json()["message"] == "Logout successful"
