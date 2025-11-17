# inSwing Cricket Scoring API

A comprehensive FastAPI backend for the inSwing cricket scoring application, providing real-time cricket match management, scoring, and social features.

## Features

- **Authentication & Authorization**: JWT-based authentication with OTP verification
- **User Management**: Complete user profiles with cricket statistics
- **Match Management**: Create, manage, and track cricket matches
- **Real-time Scoring**: Ball-by-ball scoring with idempotent design
- **Leaderboards**: Multiple leaderboard types (batting, bowling, hosting)
- **Notifications**: Real-time notifications for match events
- **Search**: Advanced search for users and matches
- **WebSocket Support**: Real-time updates for match events
- **Comprehensive API Documentation**: Auto-generated OpenAPI/Swagger docs

## Tech Stack

- **Framework**: FastAPI (Python 3.11+)
- **Database**: MySQL with SQLAlchemy ORM
- **Authentication**: JWT tokens with python-jose
- **Validation**: Pydantic for request/response validation
- **Logging**: Structured logging with structlog
- **Migrations**: Alembic for database schema management
- **Real-time**: WebSocket support for live updates

## Project Structure

```
backend/
├── app/
│   ├── api/              # API endpoints
│   │   ├── __init__.py   # Main router
│   │   ├── auth.py       # Authentication endpoints
│   │   ├── users.py      # User management
│   │   ├── matches.py    # Match management
│   │   ├── balls.py      # Scoring endpoints
│   │   ├── leaderboards.py # Leaderboards
│   │   ├── notifications.py # Notifications
│   │   ├── search.py     # Search functionality
│   │   └── websocket.py  # WebSocket endpoints
│   ├── models/           # SQLAlchemy models
│   ├── schemas/          # Pydantic schemas
│   ├── auth/             # Authentication utilities
│   ├── dependencies.py   # FastAPI dependencies
│   ├── database.py       # Database configuration
│   ├── settings.py       # Application settings
│   ├── logging_config.py # Logging configuration
│   ├── error_handlers.py # Error handling
│   └── main.py           # Application entry point
├── alembic/              # Database migrations
├── requirements.txt      # Dependencies
└── README.md            # This file
```

## Installation

### Prerequisites

- Python 3.11+
- MySQL Server
- pip (Python package manager)

### Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd backend
   ```

2. **Create a virtual environment**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables**:
   Create a `.env` file in the backend directory:
   ```env
   DATABASE_URL=mysql://root:Ganesh@15@localhost:3306/inswing
   SECRET_KEY=your-super-secret-jwt-key-change-this-in-production
   ACCESS_TOKEN_EXPIRE_MINUTES=60
   REFRESH_TOKEN_EXPIRE_DAYS=7
   OTP_EXPIRE_MINUTES=5
   REDIS_URL=redis://localhost:6379/0
   DEBUG=true
   ```

5. **Set up the database**:
   ```bash
   # Create the database
   mysql -u root -p -e "CREATE DATABASE inswing;"
   
   # Run migrations
   alembic upgrade head
   ```

6. **Run the application**:
   ```bash
   python app/main.py
   ```

   Or with uvicorn directly:
   ```bash
   uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
   ```

## API Documentation

Once the application is running, you can access:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

## API Endpoints

### Authentication
- `POST /api/v1/auth/login` - Login with phone number
- `POST /api/v1/auth/verify-otp` - Verify OTP code
- `POST /api/v1/auth/refresh` - Refresh JWT token
- `POST /api/v1/auth/logout` - Logout user

### Users
- `GET /api/v1/users/me` - Get current user profile
- `PUT /api/v1/users/me` - Update current user profile
- `GET /api/v1/users/{user_id}` - Get user by ID
- `GET /api/v1/users/search` - Search users

### Matches
- `POST /api/v1/matches` - Create new match
- `GET /api/v1/matches` - List matches with filtering
- `GET /api/v1/matches/{match_id}` - Get match details
- `PUT /api/v1/matches/{match_id}/toss` - Record toss result
- `PUT /api/v1/matches/{match_id}/status` - Update match status
- `POST /api/v1/matches/{match_id}/players` - Add player to match
- `DELETE /api/v1/matches/{match_id}/players/{user_id}` - Remove player from match

### Scoring
- `POST /api/v1/matches/{match_id}/innings` - Create innings
- `GET /api/v1/matches/{match_id}/innings` - List innings
- `POST /api/v1/matches/{match_id}/innings/{innings_id}/ball` - Record ball
- `GET /api/v1/matches/{match_id}/innings/{innings_id}/balls` - Get balls
- `PUT /api/v1/matches/{match_id}/innings/{innings_id}/balls/{ball_id}` - Update ball

### Leaderboards
- `GET /api/v1/leaderboards/batting` - Batting leaderboard
- `GET /api/v1/leaderboards/bowling` - Bowling leaderboard
- `GET /api/v1/leaderboards/matches-hosted` - Most matches hosted
- `GET /api/v1/leaderboards/player-rating` - Player rating leaderboard

### Notifications
- `GET /api/v1/notifications` - Get user notifications
- `GET /api/v1/notifications/unread-count` - Get unread count
- `PUT /api/v1/notifications/{notification_id}/read` - Mark as read
- `PUT /api/v1/notifications/mark-all-read` - Mark all as read
- `DELETE /api/v1/notifications/{notification_id}` - Delete notification

### Search
- `GET /api/v1/search/users` - Search users
- `GET /api/v1/search/matches` - Search matches
- `GET /api/v1/search/combined` - Combined search
- `GET /api/v1/search/suggestions` - Get search suggestions

### WebSocket
- `WS /api/v1/ws/{token}` - WebSocket connection for real-time updates

## Database Schema

The application uses the following main tables:

- **users**: User accounts and profiles
- **otp_sessions**: OTP verification sessions
- **matches**: Cricket match information
- **players_in_match**: Junction table for match participants
- **innings**: Cricket innings data
- **balls**: Ball-by-ball scoring data
- **match_events**: Match event history
- **notifications**: User notifications

## Authentication

The API uses JWT (JSON Web Token) authentication:

1. **Login**: Send phone number to `/auth/login`
2. **OTP Verification**: Verify OTP code to receive JWT tokens
3. **Token Usage**: Include access token in `Authorization: Bearer {token}` header
4. **Token Refresh**: Use refresh token to get new access token

## Error Handling

The API provides consistent error responses:

```json
{
  "error": {
    "message": "Error description",
    "status_code": 400,
    "details": {
      "field": "Additional error details"
    }
  }
}
```

## Logging

The application uses structured logging with the following loggers:

- **request**: HTTP request/response logging
- **database**: Database query logging
- **error_handler**: Error logging
- **auth**: Authentication events
- **api**: API endpoint logging

## Testing

Run tests with pytest:

```bash
# Install test dependencies
pip install pytest pytest-asyncio httpx

# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html
```

## Deployment

### Docker Deployment

1. **Build Docker image**:
   ```bash
   docker build -t inswing-backend .
   ```

2. **Run with Docker Compose**:
   ```bash
   docker-compose up -d
   ```

### Production Deployment

1. **Environment Variables**: Set production environment variables
2. **Database**: Use production MySQL database
3. **Redis**: Configure Redis for caching and WebSocket support
4. **Reverse Proxy**: Use Nginx or similar for SSL termination
5. **Process Manager**: Use Gunicorn with multiple workers

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the test suite
6. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please contact the development team or create an issue in the repository.