"""
Test 4: Full Dual Captain lifecycle — invite → accept → add players
        → mark ready → propose rules → approve rules → toss → live.
"""

from tests.conftest import get_auth_headers


class TestDualCaptainInvitation:
    """Invitation flow tests."""

    def _create_dual_match(self, client, host):
        """Helper: create a dual captain match."""
        headers = get_auth_headers(host)
        resp = client.post(
            "/api/v1/matches/",
            json={
                "match_type": "dual_captain",
                "team_a_name": "Mumbai Indians",
                "rules": {"overs_limit": 6, "min_players_per_team": 2},
            },
            headers=headers,
        )
        assert resp.status_code == 200, resp.text
        return resp.json()

    def test_invite_opponent(self, client, test_user, test_user_b):
        """Host can invite opponent captain."""
        match = self._create_dual_match(client, test_user)
        headers = get_auth_headers(test_user)
        resp = client.post(
            f"/api/v1/matches/{match['id']}/invite",
            json={
                "opponent_user_id": test_user_b.id,
                "message": "Let's play gully cricket!",
            },
            headers=headers,
        )
        assert resp.status_code == 200, resp.text
        data = resp.json()
        assert data["status"] == "invited"
        assert data["opponent_captain_id"] == test_user_b.id

    def test_invite_to_non_dual_match_fails(self, client, test_user, test_user_b):
        """Cannot invite to a quick match."""
        headers = get_auth_headers(test_user)
        match = client.post(
            "/api/v1/matches/",
            json={"match_type": "quick", "team_a_name": "A", "team_b_name": "B"},
            headers=headers,
        ).json()
        resp = client.post(
            f"/api/v1/matches/{match['id']}/invite",
            json={"opponent_user_id": test_user_b.id},
            headers=headers,
        )
        assert resp.status_code == 400

    def test_accept_invitation(self, client, test_user, test_user_b):
        """Opponent can accept invitation with team name."""
        match = self._create_dual_match(client, test_user)
        # Invite
        client.post(
            f"/api/v1/matches/{match['id']}/invite",
            json={"opponent_user_id": test_user_b.id},
            headers=get_auth_headers(test_user),
        )
        # Accept
        resp = client.post(
            f"/api/v1/matches/{match['id']}/accept",
            json={"team_b_name": "Chennai Super Kings"},
            headers=get_auth_headers(test_user_b),
        )
        assert resp.status_code == 200, resp.text
        data = resp.json()
        assert data["status"] == "accepted"
        assert data["team_b_name"] == "Chennai Super Kings"

    def test_decline_invitation(self, client, test_user, test_user_b):
        """Opponent can decline invitation."""
        match = self._create_dual_match(client, test_user)
        client.post(
            f"/api/v1/matches/{match['id']}/invite",
            json={"opponent_user_id": test_user_b.id},
            headers=get_auth_headers(test_user),
        )
        resp = client.post(
            f"/api/v1/matches/{match['id']}/decline",
            headers=get_auth_headers(test_user_b),
        )
        assert resp.status_code == 200, resp.text
        data = resp.json()
        assert data.get("status") == "declined" or "declined" in str(data)

    def test_wrong_user_cannot_accept(
        self, client, test_user, test_user_b, test_user_c
    ):
        """Only the invited opponent can accept."""
        match = self._create_dual_match(client, test_user)
        client.post(
            f"/api/v1/matches/{match['id']}/invite",
            json={"opponent_user_id": test_user_b.id},
            headers=get_auth_headers(test_user),
        )
        # User C tries to accept
        resp = client.post(
            f"/api/v1/matches/{match['id']}/accept",
            json={"team_b_name": "Impostor Team"},
            headers=get_auth_headers(test_user_c),
        )
        assert resp.status_code == 403


class TestDualCaptainTeamManagement:
    """Team player management tests."""

    def _setup_accepted_match(self, client, host, opponent):
        """Helper: create + invite + accept → match in 'accepted' state."""
        headers_h = get_auth_headers(host)
        headers_o = get_auth_headers(opponent)
        match = client.post(
            "/api/v1/matches/",
            json={
                "match_type": "dual_captain",
                "team_a_name": "Host Team",
                "rules": {"overs_limit": 6, "min_players_per_team": 2},
            },
            headers=headers_h,
        ).json()
        client.post(
            f"/api/v1/matches/{match['id']}/invite",
            json={"opponent_user_id": opponent.id},
            headers=headers_h,
        )
        client.post(
            f"/api/v1/matches/{match['id']}/accept",
            json={"team_b_name": "Opponent Team"},
            headers=headers_o,
        )
        return match["id"]

    def test_add_guest_player(self, client, test_user, test_user_b):
        """Host captain can add a guest player to their team."""
        match_id = self._setup_accepted_match(client, test_user, test_user_b)
        resp = client.post(
            f"/api/v1/matches/{match_id}/team/players",
            json={"guest_name": "Guest Player 1", "role": "batsman"},
            headers=get_auth_headers(test_user),
        )
        assert resp.status_code == 200, resp.text

    def test_add_registered_player(self, client, test_user, test_user_b, test_user_c):
        """Host captain can add a registered user to their team."""
        match_id = self._setup_accepted_match(client, test_user, test_user_b)
        resp = client.post(
            f"/api/v1/matches/{match_id}/team/players",
            json={"user_id": test_user_c.id, "role": "bowler"},
            headers=get_auth_headers(test_user),
        )
        assert resp.status_code == 200, resp.text

    def test_opponent_adds_to_their_team(self, client, test_user, test_user_b):
        """Opponent captain can add players to Team B."""
        match_id = self._setup_accepted_match(client, test_user, test_user_b)
        resp = client.post(
            f"/api/v1/matches/{match_id}/team/players",
            json={"guest_name": "Opponent Guest", "role": "all_rounder"},
            headers=get_auth_headers(test_user_b),
        )
        assert resp.status_code == 200, resp.text

    def test_get_teams(self, client, test_user, test_user_b):
        """GET /api/v1/matches/{id}/teams returns team A and B rosters."""
        match_id = self._setup_accepted_match(client, test_user, test_user_b)
        # Add a player to each team
        client.post(
            f"/api/v1/matches/{match_id}/team/players",
            json={"guest_name": "Player A1"},
            headers=get_auth_headers(test_user),
        )
        client.post(
            f"/api/v1/matches/{match_id}/team/players",
            json={"guest_name": "Player B1"},
            headers=get_auth_headers(test_user_b),
        )
        resp = client.get(f"/api/v1/matches/{match_id}/teams")
        assert resp.status_code == 200, resp.text
        data = resp.json()
        assert "team_a" in data
        assert "team_b" in data


class TestDualCaptainFullLifecycle:
    """End-to-end dual captain lifecycle: create → invite → accept
    → add players → mark ready → propose rules → approve → toss → live."""

    def test_full_lifecycle(self, client, test_user, test_user_b, test_user_c):
        """Complete dual captain match lifecycle."""
        headers_host = get_auth_headers(test_user)
        headers_opp = get_auth_headers(test_user_b)

        # 1. CREATE MATCH
        r = client.post(
            "/api/v1/matches/",
            json={
                "match_type": "dual_captain",
                "team_a_name": "Mumbai Indians",
                "venue": "Wankhede",
                "rules": {"overs_limit": 6, "min_players_per_team": 2},
            },
            headers=headers_host,
        )
        assert r.status_code == 200, f"Create failed: {r.text}"
        match_id = r.json()["id"]
        assert r.json()["status"] == "created"

        # 2. INVITE OPPONENT
        r = client.post(
            f"/api/v1/matches/{match_id}/invite",
            json={"opponent_user_id": test_user_b.id, "message": "Let's play!"},
            headers=headers_host,
        )
        assert r.status_code == 200, f"Invite failed: {r.text}"
        assert r.json()["status"] == "invited"

        # 3. ACCEPT INVITATION
        r = client.post(
            f"/api/v1/matches/{match_id}/accept",
            json={"team_b_name": "Chennai Super Kings"},
            headers=headers_opp,
        )
        assert r.status_code == 200, f"Accept failed: {r.text}"
        assert r.json()["status"] == "accepted"

        # 4. ADD PLAYERS — host adds guest + registered player
        r = client.post(
            f"/api/v1/matches/{match_id}/team/players",
            json={"guest_name": "Guest Batsman", "role": "batsman"},
            headers=headers_host,
        )
        assert r.status_code == 200, f"Add host player failed: {r.text}"

        r = client.post(
            f"/api/v1/matches/{match_id}/team/players",
            json={"user_id": test_user_c.id, "role": "bowler"},
            headers=headers_host,
        )
        assert r.status_code == 200, f"Add host registered player failed: {r.text}"

        # 4b. ADD PLAYERS — opponent adds guest
        r = client.post(
            f"/api/v1/matches/{match_id}/team/players",
            json={"guest_name": "Opponent Player 1"},
            headers=headers_opp,
        )
        assert r.status_code == 200, f"Add opp player failed: {r.text}"
        r = client.post(
            f"/api/v1/matches/{match_id}/team/players",
            json={"guest_name": "Opponent Player 2"},
            headers=headers_opp,
        )
        assert r.status_code == 200, f"Add opp player 2 failed: {r.text}"

        # 5. VERIFY TEAMS
        r = client.get(f"/api/v1/matches/{match_id}/teams")
        assert r.status_code == 200, f"Get teams failed: {r.text}"
        teams = r.json()
        assert len(teams["team_a"]) >= 2  # captain + 1-2 players
        assert len(teams["team_b"]) >= 2  # captain + 1-2 players

        # 6. MARK TEAMS READY
        r = client.put(
            f"/api/v1/matches/{match_id}/team/ready",
            json={"ready": True},
            headers=headers_host,
        )
        assert r.status_code == 200, f"Host ready failed: {r.text}"

        r = client.put(
            f"/api/v1/matches/{match_id}/team/ready",
            json={"ready": True},
            headers=headers_opp,
        )
        assert r.status_code == 200, f"Opp ready failed: {r.text}"

        # 7. PROPOSE RULES
        r = client.post(
            f"/api/v1/matches/{match_id}/rules/propose",
            json={
                "rules": {
                    "overs_limit": 6,
                    "min_players_per_team": 2,
                    "wide_ball_runs": 1,
                    "no_ball_runs": 1,
                    "free_hit": True,
                    "tennis_ball": True,
                }
            },
            headers=headers_host,
        )
        assert r.status_code == 200, f"Propose rules failed: {r.text}"

        # 8. APPROVE RULES
        r = client.post(
            f"/api/v1/matches/{match_id}/rules/approve",
            headers=headers_opp,
        )
        assert r.status_code == 200, f"Approve rules failed: {r.text}"

        # 9. RECORD TOSS
        r = client.put(
            f"/api/v1/matches/{match_id}/toss",
            json={"toss_winner": "A", "toss_decision": "bat"},
            headers=headers_host,
        )
        assert r.status_code == 200, f"Toss failed: {r.text}"
        assert r.json()["status"] == "toss_done"

        # 10. UPDATE STATUS TO LIVE (new_status is a query parameter)
        r = client.put(
            f"/api/v1/matches/{match_id}/status?new_status=live",
            headers=headers_host,
        )
        assert r.status_code == 200, f"Go live failed: {r.text}"
        assert r.json()["status"] == "live"

        # VERIFY FINAL STATE
        r = client.get(f"/api/v1/matches/{match_id}")
        assert r.status_code == 200
        final = r.json()
        assert final["status"] == "live"
        assert final["toss_winner"] == "A"
        assert final["toss_decision"] == "bat"
        assert final["is_dual_captain"] is True
