# 🔌 inSwing — API Reference

## Base URL

- **Development:** `http://localhost:8000/api/v1`
- **Production:** `https://api.inswing.app/api/v1` (planned)

## Authentication

All protected endpoints require a Bearer token:

```
Authorization: Bearer <access_token>
```

---

## Auth Endpoints

### POST `/auth/login`

Send OTP to phone number. Creates user if new.

**Request:**

```json
{
  "phone_number": "+919876543210"
}
```

**Response (200):**

```json
{
  "session_id": "uuid",
  "message": "OTP sent to your phone",
  "expires_in": 600,
  "attempts_remaining": 3
}
```

**Errors:** `400` Invalid phone format, `429` Max attempts reached

---

### POST `/auth/verify-otp`

Verify OTP and receive JWT tokens.

**Request:**

```json
{
  "phone_number": "+919876543210",
  "otp_code": "123456"
}
```

**Response (200):**

```json
{
  "user": {
    "id": "uuid",
    "phone_number": "+919876543210",
    "full_name": "User 3210",
    "role": "player",
    "is_active": true,
    "created_at": "2026-03-30T10:00:00Z"
  },
  "tokens": {
    "access_token": "eyJ...",
    "refresh_token": "eyJ...",
    "token_type": "bearer",
    "expires_in": 3600
  }
}
```

**Errors:** `400` Invalid OTP, `429` Max attempts

---

### POST `/auth/refresh`

Refresh expired access token.

**Request:**

```json
{
  "refresh_token": "eyJ..."
}
```

**Response (200):**

```json
{
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "token_type": "bearer",
  "expires_in": 3600
}
```

---

## User Endpoints

### GET `/users/{user_id}/profile` 🔒

Get user profile with statistics.

**Response (200):**

```json
{
  "user": { "id": "uuid", "full_name": "Virat", "..." },
  "profile": {
    "batting_style": "right-handed",
    "total_matches": 42,
    "total_runs": 1250,
    "strike_rate": 135.5,
    "..."
  }
}
```

### PUT `/users/{user_id}/profile` 🔒

Update own profile. Admins can update any.

**Request:**

```json
{
  "full_name": "Virat Kohli",
  "email": "virat@example.com",
  "bio": "Run machine"
}
```

---

## Match Endpoints

### POST `/matches/` 🔒

Create a new match.

**Request:**

```json
{
  "match_type": "quick",
  "team_a_name": "Mumbai Indians",
  "team_b_name": "Chennai Kings",
  "venue": "Azad Maidan, Mumbai",
  "latitude": 18.9385,
  "longitude": 72.8347,
  "scheduled_at": "2026-03-30T16:00:00Z",
  "rules": {
    "overs_limit": 20,
    "powerplay_overs": 6,
    "wide_ball_runs": 1,
    "no_ball_runs": 1,
    "free_hit": true,
    "super_over": false
  }
}
```

### GET `/matches/` 🔒

List matches with filters.

**Query params:** `status`, `match_type`, `user_id`, `page`, `per_page`

### GET `/matches/{match_id}` 🔒

Get match details.

### PUT `/matches/{match_id}/toss` 🔒 (host only)

Record toss result.

**Request:**

```json
{
  "toss_winner": "A",
  "toss_decision": "bat"
}
```

### PUT `/matches/{match_id}/status` 🔒 (host only)

Update match status: `created` → `toss_done` → `live` → `finished`

### POST `/matches/{match_id}/players` 🔒 (host only)

Add player to match.

**Request:**

```json
{
  "user_id": "uuid",
  "team": "A",
  "role": "batsman"
}
```

---

## Scoring Endpoints

### POST `/matches/{match_id}/innings` 🔒 (host only)

Create a new innings.

**Request:**

```json
{
  "batting_team": "A",
  "overs_allocated": 20
}
```

### POST `/matches/{match_id}/innings/{innings_id}/ball` 🔒 (host only)

Record a ball (idempotent with `client_event_id`).

**Request:**

```json
{
  "over_number": 1,
  "ball_in_over": 1,
  "batsman_id": "uuid",
  "non_striker_id": "uuid",
  "bowler_id": "uuid",
  "runs_off_bat": 4,
  "extras_type": null,
  "extras_runs": 0,
  "wicket_type": null,
  "dismissal_info": null,
  "client_event_id": "offline-uuid-123"
}
```

### GET `/matches/{match_id}/innings/{innings_id}/balls` 🔒

Get all balls in an innings.

**Query params:** `over` (filter by over number), `limit`

---

## Leaderboard Endpoints

### GET `/leaderboards/batting` 🔒

Top run scorers.

**Query params:** `period` (all_time/this_month/this_week), `limit`

### GET `/leaderboards/bowling` 🔒

Top wicket takers.

### GET `/leaderboards/matches-hosted` 🔒

Most matches hosted.

---

## Notification Endpoints

### GET `/notifications/` 🔒

Get user notifications.

### GET `/notifications/unread-count` 🔒

Get unread count.

### PUT `/notifications/{id}/read` 🔒

Mark as read.

### PUT `/notifications/mark-all-read` 🔒

Mark all as read.

---

## WebSocket

### WS `/ws/{jwt_token}`

Real-time match updates.

**Client → Server messages:**

```json
{"type": "ping"}
{"type": "subscribe_match", "match_id": "uuid"}
{"type": "unsubscribe_match", "match_id": "uuid"}
```

**Server → Client messages:**

```json
{"type": "pong", "timestamp": "..."}
{"type": "connection_established", "user_id": "uuid"}
{"type": "ball_scored", "match_id": "uuid", "ball": {...}}
{"type": "wicket", "match_id": "uuid", "ball": {...}}
{"type": "innings_completed", "match_id": "uuid", "innings": {...}}
{"type": "match_finished", "match_id": "uuid", "result": {...}}
```

---

## Error Response Format

All errors follow this structure:

```json
{
  "error": {
    "message": "Human-readable error message",
    "status_code": 400,
    "details": {},
    "timestamp": "2026-03-30T10:00:00Z"
  }
}
```

## HTTP Status Codes Used

| Code | Meaning                              |
| ---- | ------------------------------------ |
| 200  | Success                              |
| 201  | Created                              |
| 400  | Bad Request (validation)             |
| 401  | Unauthorized (invalid token)         |
| 403  | Forbidden (insufficient permissions) |
| 404  | Not Found                            |
| 409  | Conflict (duplicate)                 |
| 422  | Unprocessable Entity                 |
| 429  | Too Many Requests (rate limit)       |
| 500  | Internal Server Error                |
