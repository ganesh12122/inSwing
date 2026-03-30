"""
Test 1: Health check, root, and API info endpoints.
These are unauthenticated — should always work.
"""

import pytest


class TestHealthAndInfo:
    """Basic API availability tests."""

    def test_root_endpoint(self, client):
        """GET / should return welcome message."""
        resp = client.get("/")
        assert resp.status_code == 200
        data = resp.json()
        assert "message" in data
        assert "inSwing" in data["message"]

    def test_health_check(self, client):
        """GET /health should return healthy status."""
        resp = client.get("/health")
        assert resp.status_code == 200
        data = resp.json()
        assert data["status"] == "healthy"

    def test_api_health_check(self, client):
        """GET /api/v1/health should also return healthy."""
        resp = client.get("/api/v1/health")
        assert resp.status_code == 200
        data = resp.json()
        assert data["status"] == "healthy"

    def test_api_info(self, client):
        """GET /api/v1/info should return API metadata."""
        resp = client.get("/api/v1/info")
        assert resp.status_code == 200
        data = resp.json()
        assert "name" in data
        assert "endpoints" in data

    def test_docs_accessible(self, client):
        """GET /docs should return Swagger UI HTML."""
        resp = client.get("/docs")
        assert resp.status_code == 200

    def test_openapi_schema(self, client):
        """GET /openapi.json should return valid OpenAPI schema."""
        resp = client.get("/openapi.json")
        assert resp.status_code == 200
        data = resp.json()
        assert "openapi" in data
        assert "paths" in data

    def test_nonexistent_route_returns_404(self, client):
        """Unknown routes should return 404."""
        resp = client.get("/api/v1/nonexistent")
        assert resp.status_code in (404, 405)
