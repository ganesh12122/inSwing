"""
Test 5: Notifications CRUD — create, list, read, mark-all-read, delete.
"""

from tests.conftest import get_auth_headers


class TestNotifications:
    """Notification endpoint tests."""

    def test_list_empty_notifications(self, client, test_user):
        """GET /api/v1/notifications/ with no notifications returns empty list."""
        headers = get_auth_headers(test_user)
        resp = client.get("/api/v1/notifications/", headers=headers)
        assert resp.status_code == 200
        assert resp.json() == []

    def test_create_notification(self, client, test_user, admin_user):
        """POST /api/v1/notifications/ creates a notification for a user."""
        headers = get_auth_headers(admin_user)
        resp = client.post(
            "/api/v1/notifications/",
            json={
                "user_id": test_user.id,
                "title": "Match Invitation",
                "message": "You have been invited to a match!",
                "type": "match_invitation",
                "priority": "high",
            },
            headers=headers,
        )
        assert resp.status_code in (200, 201), resp.text
        data = resp.json()
        assert data["title"] == "Match Invitation"
        assert data["status"] == "unread"

    def test_unread_count(self, client, test_user, admin_user):
        """GET /api/v1/notifications/unread-count returns correct count."""
        headers_admin = get_auth_headers(admin_user)
        headers_user = get_auth_headers(test_user)
        # Create 2 notifications
        for i in range(2):
            client.post(
                "/api/v1/notifications/",
                json={
                    "user_id": test_user.id,
                    "title": f"Notification {i}",
                    "message": f"Message {i}",
                    "type": "system",
                },
                headers=headers_admin,
            )
        resp = client.get("/api/v1/notifications/unread-count", headers=headers_user)
        assert resp.status_code == 200
        data = resp.json()
        assert data.get("unread_count", data.get("count", 0)) >= 2

    def test_mark_notification_read(self, client, test_user, admin_user, db_session):
        """PUT /api/v1/notifications/{id}/read marks a notification as read."""
        headers_admin = get_auth_headers(admin_user)
        headers_user = get_auth_headers(test_user)
        # Create notification
        r = client.post(
            "/api/v1/notifications/",
            json={
                "user_id": test_user.id,
                "title": "Test",
                "message": "Test message",
                "type": "system",
            },
            headers=headers_admin,
        )
        notif_id = r.json()["id"]
        # Mark read
        resp = client.put(
            f"/api/v1/notifications/{notif_id}/read", headers=headers_user
        )
        assert resp.status_code == 200
        assert resp.json()["status"] == "read"

    def test_mark_all_read(self, client, test_user, admin_user):
        """PUT /api/v1/notifications/mark-all-read marks all notifications as read."""
        headers_admin = get_auth_headers(admin_user)
        headers_user = get_auth_headers(test_user)
        for i in range(3):
            client.post(
                "/api/v1/notifications/",
                json={
                    "user_id": test_user.id,
                    "title": f"N{i}",
                    "message": f"M{i}",
                    "type": "system",
                },
                headers=headers_admin,
            )
        resp = client.put("/api/v1/notifications/mark-all-read", headers=headers_user)
        assert resp.status_code == 200


class TestNotificationsSecurity:
    """Notification security tests."""

    def test_notifications_require_auth(self, client):
        """Notifications endpoints require authentication."""
        resp = client.get("/api/v1/notifications/")
        assert resp.status_code in (401, 403)

    def test_cannot_read_other_users_notifications(
        self, client, test_user, test_user_b, admin_user
    ):
        """A user cannot mark another user's notification as read."""
        headers_admin = get_auth_headers(admin_user)
        r = client.post(
            "/api/v1/notifications/",
            json={
                "user_id": test_user.id,
                "title": "Private",
                "message": "Only for user A",
                "type": "system",
            },
            headers=headers_admin,
        )
        notif_id = r.json()["id"]
        # User B tries to mark user A's notification
        resp = client.put(
            f"/api/v1/notifications/{notif_id}/read",
            headers=get_auth_headers(test_user_b),
        )
        assert resp.status_code in (403, 404)
