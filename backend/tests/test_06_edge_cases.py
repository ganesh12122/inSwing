"""
Test 6: Authorization and edge case tests — role checks, invalid data,
boundary conditions.
"""

from tests.conftest import get_auth_headers


class TestAuthorizationChecks:
    """Role-based access control tests."""

    def test_expired_token_rejected(self, client):
        """Expired/invalid JWT should be rejected."""
        headers = {"Authorization": "Bearer invalid.fake.token"}
        resp = client.get("/api/v1/matches/my", headers=headers)
        assert resp.status_code in (401, 403)

    def test_malformed_auth_header(self, client):
        """Malformed Authorization header should 401/403."""
        headers = {"Authorization": "NotBearer sometoken"}
        resp = client.get("/api/v1/matches/my", headers=headers)
        assert resp.status_code in (401, 403)

    def test_inactive_user_blocked(self, client, db_session):
        """Inactive user should be blocked."""
        from app.models.user import User

        user = User(
            phone_number="+919876500000",
            full_name="Inactive Player",
            role="player",
            is_active=False,
        )
        db_session.add(user)
        db_session.commit()
        db_session.refresh(user)

        headers = get_auth_headers(user)
        resp = client.get("/api/v1/matches/my", headers=headers)
        assert resp.status_code == 403


class TestEdgeCases:
    """Edge case and boundary condition tests."""

    def test_create_match_empty_team_name(self, client, test_user):
        """Empty team name should be rejected."""
        headers = get_auth_headers(test_user)
        resp = client.post(
            "/api/v1/matches/",
            json={"match_type": "quick", "team_a_name": "", "team_b_name": "B"},
            headers=headers,
        )
        assert resp.status_code == 422

    def test_create_match_very_long_team_name(self, client, test_user):
        """Very long team name (>100 chars) should be rejected."""
        headers = get_auth_headers(test_user)
        resp = client.post(
            "/api/v1/matches/",
            json={
                "match_type": "quick",
                "team_a_name": "A" * 101,
                "team_b_name": "B",
            },
            headers=headers,
        )
        assert resp.status_code == 422

    def test_invalid_toss_winner(self, client, test_user):
        """Toss winner must be 'A' or 'B'."""
        headers = get_auth_headers(test_user)
        match = client.post(
            "/api/v1/matches/",
            json={"match_type": "quick", "team_a_name": "A", "team_b_name": "B"},
            headers=headers,
        ).json()
        resp = client.put(
            f"/api/v1/matches/{match['id']}/toss",
            json={"toss_winner": "C", "toss_decision": "bat"},
            headers=headers,
        )
        assert resp.status_code == 422

    def test_invalid_match_rules(self, client, test_user):
        """Invalid rules (e.g., overs_limit=0) should be rejected."""
        headers = get_auth_headers(test_user)
        resp = client.post(
            "/api/v1/matches/",
            json={
                "match_type": "quick",
                "team_a_name": "A",
                "team_b_name": "B",
                "rules": {"overs_limit": 0},
            },
            headers=headers,
        )
        assert resp.status_code == 422

    def test_overs_limit_max_boundary(self, client, test_user):
        """Overs limit above 50 should be rejected."""
        headers = get_auth_headers(test_user)
        resp = client.post(
            "/api/v1/matches/",
            json={
                "match_type": "quick",
                "team_a_name": "A",
                "team_b_name": "B",
                "rules": {"overs_limit": 51},
            },
            headers=headers,
        )
        assert resp.status_code == 422

    def test_add_player_without_name_or_id(self, client, test_user, test_user_b):
        """Adding player without user_id or guest_name should 422."""
        headers_h = get_auth_headers(test_user)
        headers_o = get_auth_headers(test_user_b)
        match = client.post(
            "/api/v1/matches/",
            json={
                "match_type": "dual_captain",
                "team_a_name": "Team",
                "rules": {"overs_limit": 6, "min_players_per_team": 2},
            },
            headers=headers_h,
        ).json()
        client.post(
            f"/api/v1/matches/{match['id']}/invite",
            json={"opponent_user_id": test_user_b.id},
            headers=headers_h,
        )
        client.post(
            f"/api/v1/matches/{match['id']}/accept",
            json={"team_b_name": "Opp"},
            headers=headers_o,
        )
        resp = client.post(
            f"/api/v1/matches/{match['id']}/team/players",
            json={"role": "batsman"},  # missing both user_id and guest_name
            headers=headers_h,
        )
        # The endpoint does manual validation → 400, not Pydantic 422
        assert resp.status_code in (400, 422)


class TestConcurrentOperations:
    """Tests for concurrent/conflicting operations."""

    def test_double_accept_fails(self, client, test_user, test_user_b):
        """Accepting an already accepted invitation should fail."""
        headers_h = get_auth_headers(test_user)
        headers_o = get_auth_headers(test_user_b)
        match = client.post(
            "/api/v1/matches/",
            json={"match_type": "dual_captain", "team_a_name": "Team"},
            headers=headers_h,
        ).json()
        client.post(
            f"/api/v1/matches/{match['id']}/invite",
            json={"opponent_user_id": test_user_b.id},
            headers=headers_h,
        )
        # First accept
        r1 = client.post(
            f"/api/v1/matches/{match['id']}/accept",
            json={"team_b_name": "Team B"},
            headers=headers_o,
        )
        assert r1.status_code == 200
        # Second accept should fail (status is no longer 'invited')
        r2 = client.post(
            f"/api/v1/matches/{match['id']}/accept",
            json={"team_b_name": "Team B Again"},
            headers=headers_o,
        )
        assert r2.status_code == 400

    def test_invite_already_invited_match(self, client, test_user, test_user_b):
        """Inviting again after already invited should fail."""
        headers_h = get_auth_headers(test_user)
        match = client.post(
            "/api/v1/matches/",
            json={"match_type": "dual_captain", "team_a_name": "Team"},
            headers=headers_h,
        ).json()
        r1 = client.post(
            f"/api/v1/matches/{match['id']}/invite",
            json={"opponent_user_id": test_user_b.id},
            headers=headers_h,
        )
        assert r1.status_code == 200
        # Second invite should fail (status is no longer 'created')
        r2 = client.post(
            f"/api/v1/matches/{match['id']}/invite",
            json={"opponent_user_id": test_user_b.id},
            headers=headers_h,
        )
        assert r2.status_code == 400
