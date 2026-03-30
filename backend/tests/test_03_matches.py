"""
Test 3: Match CRUD — create, list, get, cancel for Quick and Dual Captain modes.
"""

from tests.conftest import get_auth_headers


class TestMatchCreate:
    """Match creation tests."""

    def test_create_quick_match(self, client, test_user):
        """POST /api/v1/matches/ — quick match with both team names."""
        headers = get_auth_headers(test_user)
        resp = client.post(
            "/api/v1/matches/",
            json={
                "match_type": "quick",
                "team_a_name": "Mumbai Indians",
                "team_b_name": "Chennai Kings",
                "venue": "Wankhede Stadium",
                "rules": {"overs_limit": 10, "tennis_ball": True},
            },
            headers=headers,
        )
        assert resp.status_code == 200, resp.text
        data = resp.json()
        assert data["team_a_name"] == "Mumbai Indians"
        assert data["team_b_name"] == "Chennai Kings"
        assert data["status"] == "created"
        assert data["host_user_id"] == test_user.id
        assert data["match_type"] == "quick"

    def test_create_dual_captain_match(self, client, test_user):
        """POST /api/v1/matches/ — dual_captain with only team_a_name."""
        headers = get_auth_headers(test_user)
        resp = client.post(
            "/api/v1/matches/",
            json={
                "match_type": "dual_captain",
                "team_a_name": "Royal Challengers",
                "rules": {"overs_limit": 6, "min_players_per_team": 3},
            },
            headers=headers,
        )
        assert resp.status_code == 200, resp.text
        data = resp.json()
        assert data["match_type"] == "dual_captain"
        assert data["team_b_name"] is None
        assert data["is_dual_captain"] is True

    def test_create_match_requires_auth(self, client):
        """Match creation without auth should fail."""
        resp = client.post(
            "/api/v1/matches/",
            json={"match_type": "quick", "team_a_name": "A", "team_b_name": "B"},
        )
        assert resp.status_code in (401, 403)

    def test_create_quick_match_requires_team_b(self, client, test_user):
        """Quick match without team_b_name should 422."""
        headers = get_auth_headers(test_user)
        resp = client.post(
            "/api/v1/matches/",
            json={"match_type": "quick", "team_a_name": "Only One Team"},
            headers=headers,
        )
        assert resp.status_code == 422


class TestMatchList:
    """Match listing and retrieval tests."""

    def _create_match(self, client, user, **overrides):
        """Helper to create a quick match."""
        headers = get_auth_headers(user)
        payload = {
            "match_type": "quick",
            "team_a_name": "Team A",
            "team_b_name": "Team B",
        }
        payload.update(overrides)
        resp = client.post("/api/v1/matches/", json=payload, headers=headers)
        assert resp.status_code == 200, resp.text
        return resp.json()

    def test_list_matches(self, client, test_user):
        """GET /api/v1/matches/ should return paginated match list."""
        self._create_match(client, test_user)
        resp = client.get("/api/v1/matches/")
        assert resp.status_code == 200
        data = resp.json()
        assert "matches" in data
        assert "total" in data
        assert data["total"] >= 1

    def test_list_my_matches(self, client, test_user, test_user_b):
        """GET /api/v1/matches/my should only return current user's matches."""
        self._create_match(client, test_user, team_a_name="User A Match")
        self._create_match(client, test_user_b, team_a_name="User B Match")
        headers = get_auth_headers(test_user)
        resp = client.get("/api/v1/matches/my", headers=headers)
        assert resp.status_code == 200
        data = resp.json()
        # Should contain user A's match
        names = [m["team_a_name"] for m in data["matches"]]
        assert "User A Match" in names

    def test_get_single_match(self, client, test_user):
        """GET /api/v1/matches/{id} should return match details."""
        match = self._create_match(client, test_user)
        resp = client.get(f"/api/v1/matches/{match['id']}")
        assert resp.status_code == 200
        data = resp.json()
        assert data["id"] == match["id"]

    def test_get_nonexistent_match(self, client):
        """GET /api/v1/matches/fake-id should 404."""
        resp = client.get("/api/v1/matches/nonexistent-match-id")
        assert resp.status_code == 404


class TestMatchCancel:
    """Match cancellation tests."""

    def test_cancel_own_match(self, client, test_user):
        """DELETE /api/v1/matches/{id} by host should succeed."""
        headers = get_auth_headers(test_user)
        match = client.post(
            "/api/v1/matches/",
            json={"match_type": "quick", "team_a_name": "A", "team_b_name": "B"},
            headers=headers,
        ).json()
        resp = client.delete(f"/api/v1/matches/{match['id']}", headers=headers)
        assert resp.status_code == 200

    def test_cancel_others_match_fails(self, client, test_user, test_user_b):
        """DELETE /api/v1/matches/{id} by non-host should fail."""
        headers_a = get_auth_headers(test_user)
        headers_b = get_auth_headers(test_user_b)
        match = client.post(
            "/api/v1/matches/",
            json={"match_type": "quick", "team_a_name": "A", "team_b_name": "B"},
            headers=headers_a,
        ).json()
        resp = client.delete(f"/api/v1/matches/{match['id']}", headers=headers_b)
        assert resp.status_code == 403
