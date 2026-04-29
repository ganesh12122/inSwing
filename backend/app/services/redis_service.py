"""Redis service for caching, token blacklist, and pub/sub.

Uses redis.asyncio for non-blocking operations.
Falls back gracefully if Redis is unavailable (cache miss = DB hit).
"""

import json
from typing import Any, Optional

import structlog
from redis.asyncio import Redis, from_url
from redis.exceptions import ConnectionError as RedisConnectionError
from redis.exceptions import RedisError

from app.settings import settings

logger = structlog.get_logger()

# Default TTLs (seconds)
MATCH_STATE_TTL = 30  # Live match score — refresh every 30s
LEADERBOARD_TTL = 300  # 5 minutes
TOKEN_BLACKLIST_TTL = 60 * 60 * 24 * 8  # 8 days (> refresh token lifetime)
RATE_LIMIT_TTL = 60  # 1 minute window


class RedisService:
    """Async Redis wrapper with graceful fallback."""

    def __init__(self) -> None:
        self._client: Optional[Redis] = None
        self._available: bool = False

    async def connect(self) -> None:
        """Establish Redis connection."""
        try:
            self._client = from_url(
                settings.REDIS_URL,
                decode_responses=True,
                socket_connect_timeout=5,
                socket_timeout=5,
                retry_on_timeout=True,
            )
            await self._client.ping()
            self._available = True
            logger.info("Redis connected", url=settings.REDIS_URL.split("@")[-1])
        except (RedisConnectionError, RedisError, OSError) as exc:
            self._available = False
            logger.warning("Redis unavailable — running without cache", error=str(exc))

    async def disconnect(self) -> None:
        """Close Redis connection."""
        if self._client:
            await self._client.aclose()
            self._available = False
            logger.info("Redis disconnected")

    @property
    def available(self) -> bool:
        return self._available

    # ------------------------------------------------------------------
    # Generic get / set / delete
    # ------------------------------------------------------------------

    async def get(self, key: str) -> Optional[str]:
        if not self._available:
            return None
        try:
            return await self._client.get(key)  # type: ignore[union-attr]
        except RedisError:
            return None

    async def set(self, key: str, value: str, ttl: int = 60) -> bool:
        if not self._available:
            return False
        try:
            await self._client.set(key, value, ex=ttl)  # type: ignore[union-attr]
            return True
        except RedisError:
            return False

    async def delete(self, key: str) -> bool:
        if not self._available:
            return False
        try:
            await self._client.delete(key)  # type: ignore[union-attr]
            return True
        except RedisError:
            return False

    # ------------------------------------------------------------------
    # JSON helpers
    # ------------------------------------------------------------------

    async def get_json(self, key: str) -> Optional[Any]:
        raw = await self.get(key)
        if raw is None:
            return None
        try:
            return json.loads(raw)
        except (json.JSONDecodeError, TypeError):
            return None

    async def set_json(self, key: str, value: Any, ttl: int = 60) -> bool:
        return await self.set(key, json.dumps(value, default=str), ttl)

    # ------------------------------------------------------------------
    # Match live state cache
    # ------------------------------------------------------------------

    def _match_key(self, match_id: str) -> str:
        return f"match:live:{match_id}"

    async def cache_match_state(self, match_id: str, state: dict) -> bool:
        """Cache the current live score for a match."""
        return await self.set_json(self._match_key(match_id), state, MATCH_STATE_TTL)

    async def get_match_state(self, match_id: str) -> Optional[dict]:
        """Get cached live score for a match."""
        return await self.get_json(self._match_key(match_id))

    async def invalidate_match_state(self, match_id: str) -> bool:
        return await self.delete(self._match_key(match_id))

    # ------------------------------------------------------------------
    # Token blacklist (for logout)
    # ------------------------------------------------------------------

    def _blacklist_key(self, jti: str) -> str:
        return f"token:blacklist:{jti}"

    async def blacklist_token(self, token: str) -> bool:
        """Add a token to the blacklist."""
        return await self.set(self._blacklist_key(token), "1", TOKEN_BLACKLIST_TTL)

    async def is_token_blacklisted(self, token: str) -> bool:
        """Check if a token has been blacklisted."""
        val = await self.get(self._blacklist_key(token))
        return val is not None

    # ------------------------------------------------------------------
    # Rate limiting (sliding window counter)
    # ------------------------------------------------------------------

    def _rate_key(self, identifier: str, window: str) -> str:
        return f"rate:{window}:{identifier}"

    async def check_rate_limit(
        self, identifier: str, limit: int, window_seconds: int = 60
    ) -> tuple[bool, int]:
        """Check and increment rate limit. Returns (allowed, current_count)."""
        if not self._available:
            return True, 0  # No Redis = no rate limiting
        try:
            key = self._rate_key(identifier, str(window_seconds))
            pipe = self._client.pipeline()  # type: ignore[union-attr]
            pipe.incr(key)
            pipe.expire(key, window_seconds)
            results = await pipe.execute()
            current = results[0]
            return current <= limit, current
        except RedisError:
            return True, 0

    # ------------------------------------------------------------------
    # Leaderboard cache
    # ------------------------------------------------------------------

    def _leaderboard_key(self, board_type: str) -> str:
        return f"leaderboard:{board_type}"

    async def cache_leaderboard(self, board_type: str, data: list) -> bool:
        return await self.set_json(
            self._leaderboard_key(board_type), data, LEADERBOARD_TTL
        )

    async def get_leaderboard(self, board_type: str) -> Optional[list]:
        return await self.get_json(self._leaderboard_key(board_type))


# Singleton instance
redis_service = RedisService()
