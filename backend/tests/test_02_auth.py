"""
Test 2: Authentication flow — OTP login, token verify, refresh, logout.
"""

from tests.conftest import get_auth_headers


class TestAuthLogin:
    """OTP request flow."""

    def test_login_sends_otp(self, client):
        """POST /api/v1/auth/login with valid phone should create user + OTP."""
        resp = client.post(
            "/api/v1/auth/login",
            json={"phone_number": "+919999000001"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "session_id" in data
        assert data["attempts_remaining"] == 3
        assert data["expires_in"] > 0

    def test_login_invalid_phone_rejected(self, client):
        """POST /api/v1/auth/login with bad phone should 400/422."""
        resp = client.post(
            "/api/v1/auth/login",
            json={"phone_number": "invalid"},
        )
        assert resp.status_code in (400, 422)

    def test_login_duplicate_returns_existing_session(self, client):
        """Calling login twice for same phone should reuse the OTP session."""
        phone = "+919999000002"
        r1 = client.post("/api/v1/auth/login", json={"phone_number": phone})
        r2 = client.post("/api/v1/auth/login", json={"phone_number": phone})
        assert r1.status_code == 200
        assert r2.status_code == 200
        # Second call should return same session_id
        assert r1.json()["session_id"] == r2.json()["session_id"]


class TestAuthVerifyOTP:
    """OTP verification and token issuance."""

    def _get_otp_session(self, client, db_session, phone="+919999000010"):
        """Helper: create login → get OTP code from DB."""
        resp = client.post("/api/v1/auth/login", json={"phone_number": phone})
        session_id = resp.json()["session_id"]
        from app.models.otp_session import OTPSession

        otp = db_session.query(OTPSession).filter(OTPSession.id == session_id).first()
        return session_id, otp.otp_code

    def test_verify_valid_otp(self, client, db_session):
        """Valid OTP should return JWT tokens and user data."""
        session_id, otp_code = self._get_otp_session(client, db_session)
        resp = client.post(
            "/api/v1/auth/verify-otp",
            json={"session_id": session_id, "otp_code": otp_code},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "tokens" in data
        assert "user" in data
        assert data["tokens"]["token_type"] == "bearer"
        assert len(data["tokens"]["access_token"]) > 20
        assert len(data["tokens"]["refresh_token"]) > 20

    def test_verify_wrong_otp(self, client, db_session):
        """Wrong OTP code should 400."""
        session_id, _ = self._get_otp_session(client, db_session, phone="+919999000011")
        resp = client.post(
            "/api/v1/auth/verify-otp",
            json={"session_id": session_id, "otp_code": "000000"},
        )
        assert resp.status_code == 400

    def test_verify_invalid_session(self, client):
        """Non-existent session_id should 400."""
        resp = client.post(
            "/api/v1/auth/verify-otp",
            json={"session_id": "nonexistent-id", "otp_code": "123456"},
        )
        assert resp.status_code == 400


class TestAuthTokenRefresh:
    """Token refresh flow."""

    def _login_user(self, client, db_session, phone="+919999000020"):
        """Helper: full login → verify → get tokens."""
        r1 = client.post("/api/v1/auth/login", json={"phone_number": phone})
        session_id = r1.json()["session_id"]
        from app.models.otp_session import OTPSession

        otp = db_session.query(OTPSession).filter(OTPSession.id == session_id).first()
        r2 = client.post(
            "/api/v1/auth/verify-otp",
            json={"session_id": session_id, "otp_code": otp.otp_code},
        )
        return r2.json()["tokens"]

    def test_refresh_token_works(self, client, db_session):
        """POST /api/v1/auth/refresh with valid refresh token returns new tokens."""
        tokens = self._login_user(client, db_session)
        resp = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": tokens["refresh_token"]},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "access_token" in data
        assert "refresh_token" in data

    def test_refresh_with_access_token_fails(self, client, db_session):
        """Using access_token as refresh should fail."""
        tokens = self._login_user(client, db_session, phone="+919999000021")
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
