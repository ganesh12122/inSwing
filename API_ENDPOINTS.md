# inSwing API Endpoints Documentation

## Base URL
```
https://api.inswing.com/api/v1
```

## Authentication
All endpoints require JWT Bearer token except authentication endpoints.

```
Authorization: Bearer <access_token>
```

## Authentication Endpoints

### 1. Request OTP
```http
POST /auth/request-otp
Content-Type: application/json

{
  "phone_number": "+919876543210"
}
```

**Response:**
```json
{
  "success": true,
  "message": "OTP sent successfully",
  "expires_in": 300
}
```

### 2. Verify OTP
```http
POST /auth/verify-otp
Content-Type: application/json

{
  "phone_number": "+919876543210",
  "otp_code": "123456"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600,
  "user": {
    "id": "uuid",
    "phone_number": "+919876543210",
    "full_name": "John Doe",
    "role": "player"
  }
}
```

### 3. Refresh Token
```http
POST /auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600
}
```

### 4. Logout
```http
POST /auth/logout
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

## User Management Endpoints

### 5. Get Current User Profile
```http
GET /users/me
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "id": "uuid",
  "phone_number": "+919876543210",
  "email": "john@example.com",
  "full_name": "John Doe",
  "avatar_url": "https://api.inswing.com/avatars/uuid.jpg",
  "bio": "Cricket enthusiast",
  "role": "player",
  "profile": {
    "batting_style": "right-handed",
    "bowling_style": "fast",
    "dominant_hand": "right",
    "total_matches": 25,
    "total_runs": 450,
    "total_wickets": 12,
    "average_runs": 22.5,
    "strike_rate": 125.0,
    "economy_rate": 6.2,
    "highest_score": 75,
    "best_bowling": "3/25"
  },
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-20T15:45:00Z"
}
```

### 6. Update User Profile
```http
PUT /users/me
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "email": "john@example.com",
  "full_name": "John Doe",
  "avatar_url": "https://example.com/avatar.jpg",
  "bio": "Passionate cricketer",
  "profile": {
    "batting_style": "right-handed",
    "bowling_style": "spin",
    "dominant_hand": "right"
  }
}
```

**Response:**
```json
{
  "id": "uuid",
  "phone_number": "+919876543210",
  "email": "john@example.com",
  "full_name": "John Doe",
  "avatar_url": "https://example.com/avatar.jpg",
  "bio": "Passionate cricketer",
  "role": "player",
  "profile": {
    "batting_style": "right-handed",
    "bowling_style": "spin",
    "dominant_hand": "right"
  },
  "updated_at": "2024-01-20T16:00:00Z"
}
```

### 7. Search Users
```http
GET /users/search?q=john&limit=10
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "users": [
    {
      "id": "uuid",
      "full_name": "John Doe",
      "phone_number": "+919876543210",
      "avatar_url": "https://api.inswing.com/avatars/uuid.jpg",
      "profile": {
        "batting_style": "right-handed",
        "bowling_style": "fast"
      },
      "total_matches": 25
    }
  ],
  "total": 1,
  "page": 1,
  "per_page": 10
}
```

## Match Management Endpoints

### 8. Create Match
```http
POST /matches
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "match_type": "quick",
  "team_a_name": "Super Kings",
  "team_b_name": "Royal Challengers",
  "venue": "City Cricket Ground, Mumbai",
  "latitude": 19.0760,
  "longitude": 72.8777,
  "scheduled_at": "2024-01-25T14:00:00Z",
  "rules": {
    "overs": 20,
    "powerplay": 6,
    "extras_rules": {
      "wides": "retake",
      "no_balls": "free_hit"
    }
  },
  "is_public": true
}
```

**Response:**
```json
{
  "id": "uuid",
  "host_user_id": "uuid",
  "match_type": "quick",
  "team_a_name": "Super Kings",
  "team_b_name": "Royal Challengers",
  "venue": "City Cricket Ground, Mumbai",
  "latitude": 19.0760,
  "longitude": 72.8777,
  "scheduled_at": "2024-01-25T14:00:00Z",
  "status": "created",
  "rules": {
    "overs": 20,
    "powerplay": 6,
    "extras_rules": {
      "wides": "retake",
      "no_balls": "free_hit"
    }
  },
  "is_public": true,
  "created_at": "2024-01-25T13:30:00Z",
  "updated_at": "2024-01-25T13:30:00Z"
}
```

### 9. List Matches
```http
GET /matches?status=live&match_type=quick&page=1&per_page=20
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "matches": [
    {
      "id": "uuid",
      "host_user_id": "uuid",
      "match_type": "quick",
      "team_a_name": "Super Kings",
      "team_b_name": "Royal Challengers",
      "venue": "City Cricket Ground, Mumbai",
      "status": "live",
      "scheduled_at": "2024-01-25T14:00:00Z",
      "created_at": "2024-01-25T13:30:00Z"
    }
  ],
  "total": 15,
  "page": 1,
  "per_page": 20
}
```

### 10. Get Match Details
```http
GET /matches/{match_id}
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "id": "uuid",
  "host_user_id": "uuid",
  "match_type": "quick",
  "team_a_name": "Super Kings",
  "team_b_name": "Royal Challengers",
  "venue": "City Cricket Ground, Mumbai",
  "latitude": 19.0760,
  "longitude": 72.8777,
  "scheduled_at": "2024-01-25T14:00:00Z",
  "status": "live",
  "rules": {
    "overs": 20,
    "powerplay": 6,
    "extras_rules": {
      "wides": "retake",
      "no_balls": "free_hit"
    }
  },
  "toss_winner": "A",
  "toss_decision": "bat",
  "result": null,
  "is_public": true,
  "players": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "team": "A",
      "role": "batsman",
      "full_name": "John Doe",
      "batting_position": 1
    }
  ],
  "innings": [
    {
      "id": "uuid",
      "innings_number": 1,
      "batting_team": "A",
      "bowling_team": "B",
      "overs_allocated": 20,
      "runs": 156,
      "wickets": 7,
      "extras": 12,
      "overs_bowled": 20.0,
      "is_completed": true
    }
  ],
  "created_at": "2024-01-25T13:30:00Z",
  "updated_at": "2024-01-25T15:45:00Z"
}
```

### 11. Record Toss
```http
POST /matches/{match_id}/toss
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "winner": "A",
  "decision": "bat"
}
```

**Response:**
```json
{
  "id": "uuid",
  "toss_winner": "A",
  "toss_decision": "bat",
  "status": "toss_done",
  "updated_at": "2024-01-25T14:05:00Z"
}
```

### 12. Add Player to Match
```http
POST /matches/{match_id}/players
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "user_id": "uuid",
  "team": "A",
  "role": "batsman",
  "batting_position": 1,
  "is_captain": false,
  "is_wicketkeeper": false
}
```

**Response:**
```json
{
  "id": "uuid",
  "match_id": "uuid",
  "user_id": "uuid",
  "team": "A",
  "role": "batsman",
  "batting_position": 1,
  "is_captain": false,
  "is_wicketkeeper": false,
  "full_name": "John Doe",
  "joined_at": "2024-01-25T14:10:00Z"
}
```

### 13. Update Match Status
```http
PUT /matches/{match_id}/status
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "status": "live"
}
```

**Response:**
```json
{
  "id": "uuid",
  "status": "live",
  "updated_at": "2024-01-25T14:15:00Z"
}
```

## Innings Management Endpoints

### 14. Create Innings
```http
POST /matches/{match_id}/innings
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "batting_team": "A",
  "bowling_team": "B",
  "overs_allocated": 20
}
```

**Response:**
```json
{
  "id": "uuid",
  "match_id": "uuid",
  "innings_number": 1,
  "batting_team": "A",
  "bowling_team": "B",
  "overs_allocated": 20,
  "runs": 0,
  "wickets": 0,
  "extras": 0,
  "overs_bowled": 0.0,
  "is_completed": false,
  "start_time": "2024-01-25T14:15:00Z",
  "created_at": "2024-01-25T14:15:00Z"
}
```

### 15. Get Innings Details
```http
GET /matches/{match_id}/innings
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "innings": [
    {
      "id": "uuid",
      "innings_number": 1,
      "batting_team": "A",
      "bowling_team": "B",
      "overs_allocated": 20,
      "runs": 156,
      "wickets": 7,
      "extras": 12,
      "wides": 3,
      "no_balls": 2,
      "byes": 4,
      "leg_byes": 3,
      "overs_bowled": 20.0,
      "is_completed": true,
      "start_time": "2024-01-25T14:15:00Z",
      "end_time": "2024-01-25T15:30:00Z"
    }
  ]
}
```

### 16. End Innings
```http
PUT /matches/{match_id}/innings/{innings_id}
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "is_completed": true
}
```

**Response:**
```json
{
  "id": "uuid",
  "is_completed": true,
  "end_time": "2024-01-25T15:30:00Z",
  "updated_at": "2024-01-25T15:30:00Z"
}
```

## Ball Recording Endpoints

### 17. Record Ball
```http
POST /matches/{match_id}/innings/{innings_id}/ball
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "over_number": 5,
  "ball_in_over": 3,
  "batsman_id": "uuid",
  "non_striker_id": "uuid",
  "bowler_id": "uuid",
  "runs_off_bat": 4,
  "extras_type": null,
  "extras_runs": 0,
  "is_legal": true,
  "wicket_type": null,
  "dismissal_info": null,
  "client_event_id": "uuid"
}
```

**Response:**
```json
{
  "id": "uuid",
  "innings_id": "uuid",
  "over_number": 5,
  "ball_in_over": 3,
  "batsman_id": "uuid",
  "non_striker_id": "uuid",
  "bowler_id": "uuid",
  "runs_off_bat": 4,
  "extras_type": null,
  "extras_runs": 0,
  "is_legal": true,
  "wicket_type": null,
  "dismissal_info": null,
  "client_event_id": "uuid",
  "timestamp": "2024-01-25T15:25:30Z",
  "created_at": "2024-01-25T15:25:30Z"
}
```

### 18. Get Balls in Innings
```http
GET /matches/{match_id}/innings/{innings_id}/balls
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "balls": [
    {
      "id": "uuid",
      "over_number": 5,
      "ball_in_over": 3,
      "batsman_id": "uuid",
      "non_striker_id": "uuid",
      "bowler_id": "uuid",
      "runs_off_bat": 4,
      "extras_type": null,
      "extras_runs": 0,
      "is_legal": true,
      "wicket_type": null,
      "dismissal_info": null,
      "timestamp": "2024-01-25T15:25:30Z"
    }
  ],
  "total": 120,
  "page": 1,
  "per_page": 100
}
```

### 19. Undo Last Ball
```http
DELETE /matches/{match_id}/innings/{innings_id}/balls/{ball_id}
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "success": true,
  "message": "Ball undone successfully",
  "undone_ball_id": "uuid"
}
```

## Statistics & Leaderboards

### 20. Get User Statistics
```http
GET /users/{user_id}/stats
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "user_id": "uuid",
  "total_matches": 25,
  "total_runs": 450,
  "total_wickets": 12,
  "total_balls_faced": 360,
  "total_balls_bowled": 300,
  "total_runs_conceded": 180,
  "average_runs": 22.5,
  "strike_rate": 125.0,
  "economy_rate": 6.2,
  "highest_score": 75,
  "best_bowling": "3/25",
  "batting_stats_by_format": {
    "quick": {"matches": 15, "runs": 300, "average": 25.0, "strike_rate": 130.0},
    "friendly": {"matches": 8, "runs": 120, "average": 20.0, "strike_rate": 120.0},
    "tournament": {"matches": 2, "runs": 30, "average": 15.0, "strike_rate": 110.0}
  },
  "bowling_stats_by_format": {
    "quick": {"matches": 15, "wickets": 8, "economy": 6.0, "average": 22.5},
    "friendly": {"matches": 8, "wickets": 3, "economy": 6.5, "average": 20.0},
    "tournament": {"matches": 2, "wickets": 1, "economy": 7.0, "average": 25.0}
  }
}
```

### 21. Get Leaderboard
```http
GET /leaderboards?type=local&region=mumbai&period=month&limit=20
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "leaderboard_type": "local",
  "region": "mumbai",
  "period": "month",
  "last_updated": "2024-01-25T12:00:00Z",
  "top_run_scorers": [
    {
      "rank": 1,
      "user_id": "uuid",
      "full_name": "John Doe",
      "avatar_url": "https://api.inswing.com/avatars/uuid.jpg",
      "total_matches": 15,
      "total_runs": 450,
      "average": 30.0,
      "strike_rate": 135.0,
      "highest_score": 75
    }
  ],
  "top_wicket_takers": [
    {
      "rank": 1,
      "user_id": "uuid",
      "full_name": "Jane Smith",
      "avatar_url": "https://api.inswing.com/avatars/uuid.jpg",
      "total_matches": 12,
      "total_wickets": 18,
      "economy_rate": 5.5,
      "best_bowling": "4/20"
    }
  ],
  "best_averages": [
    {
      "rank": 1,
      "user_id": "uuid",
      "full_name": "Mike Johnson",
      "avatar_url": "https://api.inswing.com/avatars/uuid.jpg",
      "total_matches": 10,
      "total_runs": 350,
      "average": 35.0,
      "strike_rate": 125.0
    }
  ]
}
```

## Real-Time Endpoints

### 22. WebSocket Connection
```http
WS /matches/{match_id}/live
Authorization: Bearer <access_token>
```

**Connection Message:**
```json
{
  "type": "connection",
  "match_id": "uuid",
  "user_id": "uuid",
  "client_id": "unique_client_id"
}
```

**Live Updates:**
```json
{
  "type": "ball_update",
  "data": {
    "ball_id": "uuid",
    "over_number": 5,
    "ball_in_over": 3,
    "runs_off_bat": 4,
    "extras_type": null,
    "wicket_type": null,
    "score_update": {
      "team_a_score": 156,
      "team_a_wickets": 7,
      "current_over": "4 1 6 . 2 4",
      "run_rate": 7.8,
      "required_rate": null
    }
  },
  "timestamp": "2024-01-25T15:25:30Z"
}
```

### 23. Offline Sync
```http
POST /matches/{match_id}/sync
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "sync_events": [
    {
      "client_event_id": "uuid-1",
      "type": "ball",
      "data": {
        "innings_id": "uuid",
        "over_number": 5,
        "ball_in_over": 1,
        "batsman_id": "uuid",
        "bowler_id": "uuid",
        "runs_off_bat": 1,
        "timestamp": "2024-01-25T15:20:00Z"
      }
    },
    {
      "client_event_id": "uuid-2",
      "type": "ball",
      "data": {
        "innings_id": "uuid",
        "over_number": 5,
        "ball_in_over": 2,
        "batsman_id": "uuid",
        "bowler_id": "uuid",
        "runs_off_bat": 4,
        "timestamp": "2024-01-25T15:20:15Z"
      }
    }
  ]
}
```

**Response:**
```json
{
  "success": true,
  "synced_count": 2,
  "conflicts": [],
  "authoritative_state": {
    "innings_id": "uuid",
    "runs": 156,
    "wickets": 7,
    "overs_bowled": 20.0,
    "last_ball": {
      "over_number": 5,
      "ball_in_over": 2,
      "runs_off_bat": 4
    }
  }
}
```

## Social Features

### 24. Create Highlight
```http
POST /matches/{match_id}/highlights
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "ball_id": "uuid",
  "description": "Amazing cover drive for four!",
  "is_highlight": true
}
```

**Response:**
```json
{
  "id": "uuid",
  "match_id": "uuid",
  "ball_id": "uuid",
  "event_type": "highlight",
  "description": "Amazing cover drive for four!",
  "player_id": "uuid",
  "is_highlight": true,
  "created_at": "2024-01-25T15:26:00Z"
}
```

### 25. Get Match Feed
```http
GET /matches/{match_id}/feed?page=1&per_page=20
Authorization: Bearer <access_token>
```

**Response:**
```json
{
  "events": [
    {
      "id": "uuid",
      "type": "match_start",
      "description": "Match started between Super Kings and Royal Challengers",
      "timestamp": "2024-01-25T14:15:00Z"
    },
    {
      "id": "uuid",
      "type": "boundary",
      "description": "John Doe hits a beautiful four through covers",
      "player_id": "uuid",
      "player_name": "John Doe",
      "meta": {
        "runs": 4,
        "boundary_type": "four",
        "ball_id": "uuid"
      },
      "is_highlight": true,
      "likes": 5,
      "timestamp": "2024-01-25T15:25:30Z"
    }
  ],
  "total": 45,
  "page": 1,
  "per_page": 20
}
```

## Error Responses

### Standard Error Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": {
      "field": "phone_number",
      "message": "Phone number must be between 10-15 digits"
    }
  },
  "timestamp": "2024-01-25T15:30:00Z",
  "request_id": "req_uuid"
}
```

### Common Error Codes
- `AUTHENTICATION_FAILED`: Invalid credentials
- `TOKEN_EXPIRED`: JWT token expired
- `VALIDATION_ERROR`: Input validation failed
- `NOT_FOUND`: Resource not found
- `FORBIDDEN`: Insufficient permissions
- `RATE_LIMIT_EXCEEDED`: Too many requests
- `CONFLICT`: Resource conflict (duplicate entry)
- `SERVER_ERROR`: Internal server error

## Rate Limiting

- **Authentication endpoints**: 5 requests per minute per IP
- **Match creation**: 10 matches per hour per user
- **Ball recording**: 60 balls per minute per match
- **General API**: 100 requests per minute per user

## Pagination

All list endpoints support pagination:
- `page`: Page number (default: 1)
- `per_page`: Items per page (default: 20, max: 100)

Response includes pagination metadata:
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 150,
    "total_pages": 8,
    "has_next": true,
    "has_prev": false
  }
}
```

## WebSocket Protocol

### Connection Flow
1. Client connects with JWT token in query params
2. Server validates token and adds to match room
3. Client sends heartbeat every 30 seconds
4. Server broadcasts updates to all room members

### Message Types
- `connection`: Initial connection handshake
- `ball_update`: New ball recorded
- `wicket`: Wicket event
- `boundary`: Boundary (4/6) event
- `milestone`: Player milestone (50, 100, 5-wicket haul)
- `innings_change`: Innings completed
- `match_status`: Match status change
- `error`: Error notification

### Heartbeat
```json
{
  "type": "heartbeat",
  "timestamp": "2024-01-25T15:30:00Z"
}
```