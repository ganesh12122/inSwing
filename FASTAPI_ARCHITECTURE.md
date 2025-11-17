# FastAPI Backend Architecture

## Project Structure Overview

The FastAPI backend follows a modular architecture with clear separation of concerns:

```
backend/
├── app/
│   ├── main.py                 # FastAPI application factory
│   ├── config.py              # Configuration management
│   ├── database.py            # Database connection and session
│   ├── redis.py               # Redis connection management
│   ├── models/                # SQLAlchemy ORM models
│   ├── schemas/               # Pydantic validation schemas
│   ├── api/                   # API route handlers
│   ├── services/              # Business logic layer
│   ├── utils/                 # Utility functions
│   ├── middleware/            # Custom middleware
│   └── websocket/             # WebSocket handlers
```

## Core Modules

### 1. Configuration (config.py)
```python
from pydantic import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    # Database
    DATABASE_URL: str = "mysql://user:password@localhost/inswing"
    
    # Redis
    REDIS_URL: str = "redis://localhost:6379"
    
    # JWT
    JWT_SECRET_KEY: str
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7
    
    # OTP
    OTP_EXPIRE_MINUTES: int = 5
    OTP_MAX_ATTEMPTS: int = 3
    
    # API
    API_V1_PREFIX: str = "/api/v1"
    
    # Real-time
    WEBSOCKET_MAX_CONNECTIONS: int = 1000
    
    # Rate limiting
    RATE_LIMIT_PER_MINUTE: int = 60
    
    # File upload
    MAX_FILE_SIZE: int = 5 * 1024 * 1024  # 5MB
    
    # CORS
    CORS_ORIGINS: list = ["*"]
    
    class Config:
        env_file = ".env"

settings = Settings()
```

### 2. Database Models (models/)

#### User Model (models/user.py)
```python
from sqlalchemy import Column, String, Enum, Boolean, Text, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
import uuid

class User(Base):
    __tablename__ = "users"
    
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    phone_number = Column(String(15), unique=True, nullable=False, index=True)
    email = Column(String(255), unique=True, nullable=True, index=True)
    full_name = Column(String(100), nullable=False)
    avatar_url = Column(String(500), nullable=True)
    bio = Column(Text, nullable=True)
    role = Column(Enum('player', 'admin', name='user_role'), default='player', index=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    profile = relationship("Profile", back_populates="user", uselist=False)
    hosted_matches = relationship("Match", back_populates="host")
    match_participations = relationship("PlayerInMatch", back_populates="player")
    balls_batted = relationship("Ball", foreign_keys="Ball.batsman_id", back_populates="batsman")
    balls_bowled = relationship("Ball", foreign_keys="Ball.bowler_id", back_populates="bowler")
    notifications = relationship("Notification", back_populates="user")
    sessions = relationship("UserSession", back_populates="user")
```

#### Match Model (models/match.py)
```python
from sqlalchemy import Column, String, Enum, JSON, Text, DateTime, ForeignKey, Boolean, Integer
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
import uuid

class Match(Base):
    __tablename__ = "matches"
    
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    host_user_id = Column(String(36), ForeignKey("users.id"), nullable=False)
    match_type = Column(Enum('quick', 'friendly', 'tournament', name='match_type'), default='quick', index=True)
    team_a_name = Column(String(100), nullable=False)
    team_b_name = Column(String(100), nullable=False)
    venue = Column(Text, nullable=True)
    latitude = Column(String(20), nullable=True)
    longitude = Column(String(20), nullable=True)
    scheduled_at = Column(DateTime(timezone=True), nullable=True, index=True)
    status = Column(Enum('created', 'toss_done', 'live', 'finished', 'cancelled', name='match_status'), 
                   default='created', index=True)
    rules = Column(JSON, nullable=True)  # {overs: 20, powerplay: 6}
    toss_winner = Column(Enum('A', 'B', name='toss_winner'), nullable=True)
    toss_decision = Column(Enum('bat', 'bowl', name='toss_decision'), nullable=True)
    result = Column(JSON, nullable=True)  # {winner: 'A', mvp: 'user_id'}
    is_public = Column(Boolean, default=True, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), index=True)
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    host = relationship("User", back_populates="hosted_matches")
    players = relationship("PlayerInMatch", back_populates="match", cascade="all, delete-orphan")
    innings = relationship("Innings", back_populates="match", cascade="all, delete-orphan")
    events = relationship("MatchEvent", back_populates="match", cascade="all, delete-orphan")
```

### 3. Pydantic Schemas (schemas/)

#### User Schemas (schemas/user.py)
```python
from pydantic import BaseModel, EmailStr, validator
from typing import Optional, List
from datetime import datetime
from enum import Enum

class UserRole(str, Enum):
    PLAYER = "player"
    ADMIN = "admin"

class UserBase(BaseModel):
    phone_number: str
    email: Optional[EmailStr] = None
    full_name: str
    avatar_url: Optional[str] = None
    bio: Optional[str] = None
    role: UserRole = UserRole.PLAYER

class UserCreate(UserBase):
    password: Optional[str] = None
    
    @validator('phone_number')
    def validate_phone(cls, v):
        # Remove non-numeric characters
        phone = ''.join(filter(str.isdigit, v))
        if len(phone) < 10 or len(phone) > 15:
            raise ValueError('Phone number must be between 10-15 digits')
        return phone

class UserResponse(UserBase):
    id: str
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    class Config:
        orm_mode = True

class UserStats(BaseModel):
    total_matches: int
    total_runs: int
    total_wickets: int
    average_runs: float
    strike_rate: float
    economy_rate: float
    highest_score: int
    best_bowling: Optional[str] = None
```

#### Match Schemas (schemas/match.py)
```python
from pydantic import BaseModel, validator
from typing import Optional, List, Dict, Any
from datetime import datetime
from enum import Enum

class MatchType(str, Enum):
    QUICK = "quick"
    FRIENDLY = "friendly"
    TOURNAMENT = "tournament"

class MatchStatus(str, Enum):
    CREATED = "created"
    TOSS_DONE = "toss_done"
    LIVE = "live"
    FINISHED = "finished"
    CANCELLED = "cancelled"

class MatchBase(BaseModel):
    match_type: MatchType = MatchType.QUICK
    team_a_name: str
    team_b_name: str
    venue: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    scheduled_at: Optional[datetime] = None
    rules: Optional[Dict[str, Any]] = None
    is_public: bool = True
    
    @validator('team_a_name', 'team_b_name')
    def validate_team_name(cls, v):
        if len(v) < 2 or len(v) > 100:
            raise ValueError('Team name must be between 2-100 characters')
        return v.strip()
    
    @validator('latitude')
    def validate_latitude(cls, v):
        if v is not None and (v < -90 or v > 90):
            raise ValueError('Latitude must be between -90 and 90')
        return v
    
    @validator('longitude')
    def validate_longitude(cls, v):
        if v is not None and (v < -180 or v > 180):
            raise ValueError('Longitude must be between -180 and 180')
        return v

class MatchCreate(MatchBase):
    pass

class MatchResponse(MatchBase):
    id: str
    host_user_id: str
    status: MatchStatus
    toss_winner: Optional[str] = None
    toss_decision: Optional[str] = None
    result: Optional[Dict[str, Any]] = None
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    class Config:
        orm_mode = True

class MatchList(BaseModel):
    matches: List[MatchResponse]
    total: int
    page: int
    per_page: int
```

### 4. API Routes (api/)

#### Authentication Routes (api/auth.py)
```python
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.auth import Token, OTPRequest, OTPVerify
from app.services.auth_service import AuthService
from app.utils.security import create_access_token, create_refresh_token

router = APIRouter(prefix="/auth", tags=["authentication"])

@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    """Login with phone number and password/OTP"""
    auth_service = AuthService(db)
    user = auth_service.authenticate_user(form_data.username, form_data.password)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect phone number or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token = create_access_token(data={"sub": user.phone_number})
    refresh_token = create_refresh_token(data={"sub": user.phone_number})
    
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }

@router.post("/request-otp")
async def request_otp(otp_request: OTPRequest, db: Session = Depends(get_db)):
    """Request OTP for phone number verification"""
    auth_service = AuthService(db)
    await auth_service.request_otp(otp_request.phone_number)
    return {"message": "OTP sent successfully"}

@router.post("/verify-otp", response_model=Token)
async def verify_otp(otp_verify: OTPVerify, db: Session = Depends(get_db)):
    """Verify OTP and return JWT tokens"""
    auth_service = AuthService(db)
    user = auth_service.verify_otp(otp_verify.phone_number, otp_verify.otp_code)
    
    access_token = create_access_token(data={"sub": user.phone_number})
    refresh_token = create_refresh_token(data={"sub": user.phone_number})
    
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }
```

#### Match Routes (api/matches.py)
```python
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.schemas.match import MatchCreate, MatchResponse, MatchList
from app.services.match_service import MatchService
from app.utils.security import get_current_user
from app.models.user import User

router = APIRouter(prefix="/matches", tags=["matches"])

@router.post("/", response_model=MatchResponse)
async def create_match(
    match: MatchCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new match"""
    match_service = MatchService(db)
    return match_service.create_match(match, current_user.id)

@router.get("/", response_model=MatchList)
async def list_matches(
    status: Optional[str] = Query(None, description="Filter by match status"),
    match_type: Optional[str] = Query(None, description="Filter by match type"),
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """List matches with optional filters"""
    match_service = MatchService(db)
    return match_service.list_matches(status, match_type, page, per_page)

@router.get("/{match_id}", response_model=MatchResponse)
async def get_match(match_id: str, db: Session = Depends(get_db)):
    """Get match details by ID"""
    match_service = MatchService(db)
    match = match_service.get_match(match_id)
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")
    return match

@router.post("/{match_id}/toss")
async def record_toss(
    match_id: str,
    toss_data: dict,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Record toss result"""
    match_service = MatchService(db)
    return match_service.record_toss(match_id, current_user.id, toss_data)
```

### 5. Business Logic (services/)

#### Match Service (services/match_service.py)
```python
from sqlalchemy.orm import Session
from typing import Optional, Dict, Any
from app.models.match import Match
from app.models.user import User
from app.schemas.match import MatchCreate, MatchResponse
from app.utils.exceptions import NotFoundError, ValidationError

class MatchService:
    def __init__(self, db: Session):
        self.db = db
    
    def create_match(self, match_data: MatchCreate, host_user_id: str) -> MatchResponse:
        """Create a new match"""
        match = Match(
            host_user_id=host_user_id,
            **match_data.dict()
        )
        self.db.add(match)
        self.db.commit()
        self.db.refresh(match)
        return MatchResponse.from_orm(match)
    
    def get_match(self, match_id: str) -> Optional[MatchResponse]:
        """Get match by ID"""
        match = self.db.query(Match).filter(Match.id == match_id).first()
        if not match:
            return None
        return MatchResponse.from_orm(match)
    
    def list_matches(
        self, 
        status: Optional[str] = None,
        match_type: Optional[str] = None,
        page: int = 1,
        per_page: int = 20
    ) -> Dict[str, Any]:
        """List matches with pagination and filters"""
        query = self.db.query(Match)
        
        if status:
            query = query.filter(Match.status == status)
        if match_type:
            query = query.filter(Match.match_type == match_type)
        
        total = query.count()
        matches = query.offset((page - 1) * per_page).limit(per_page).all()
        
        return {
            "matches": [MatchResponse.from_orm(match) for match in matches],
            "total": total,
            "page": page,
            "per_page": per_page
        }
    
    def record_toss(self, match_id: str, user_id: str, toss_data: Dict[str, Any]) -> MatchResponse:
        """Record toss result"""
        match = self.db.query(Match).filter(Match.id == match_id).first()
        if not match:
            raise NotFoundError("Match not found")
        
        if match.host_user_id != user_id:
            raise ValidationError("Only match host can record toss")
        
        if match.status != "created":
            raise ValidationError("Toss already recorded")
        
        match.toss_winner = toss_data["winner"]
        match.toss_decision = toss_data["decision"]
        match.status = "toss_done"
        
        self.db.commit()
        self.db.refresh(match)
        return MatchResponse.from_orm(match)
```

### 6. WebSocket Management (websocket/)

#### Connection Manager (websocket/connection_manager.py)
```python
from typing import Dict, Set
from fastapi import WebSocket
import json
import asyncio
from redis import Redis
import logging

logger = logging.getLogger(__name__)

class ConnectionManager:
    def __init__(self, redis_client: Redis):
        self.active_connections: Dict[str, Set[WebSocket]] = {}
        self.redis = redis_client
        self.pubsub = redis_client.pubsub()
    
    async def connect(self, websocket: WebSocket, match_id: str, user_id: str):
        """Accept WebSocket connection and add to room"""
        await websocket.accept()
        
        room_key = f"match:{match_id}"
        if room_key not in self.active_connections:
            self.active_connections[room_key] = set()
        
        self.active_connections[room_key].add(websocket)
        
        # Subscribe to Redis channel
        await self.pubsub.subscribe(f"{room_key}:updates")
        await self.pubsub.subscribe(f"{room_key}:events")
        
        logger.info(f"User {user_id} connected to match {match_id}")
    
    def disconnect(self, websocket: WebSocket, match_id: str, user_id: str):
        """Remove WebSocket connection from room"""
        room_key = f"match:{match_id}"
        if room_key in self.active_connections:
            self.active_connections[room_key].discard(websocket)
            
            if not self.active_connections[room_key]:
                del self.active_connections[room_key]
        
        logger.info(f"User {user_id} disconnected from match {match_id}")
    
    async def broadcast_to_match(self, match_id: str, message: dict):
        """Broadcast message to all connections in a match"""
        room_key = f"match:{match_id}"
        if room_key in self.active_connections:
            disconnected = set()
            
            for connection in self.active_connections[room_key]:
                try:
                    await connection.send_text(json.dumps(message))
                except:
                    disconnected.add(connection)
            
            # Remove disconnected clients
            for conn in disconnected:
                self.active_connections[room_key].discard(conn)
    
    async def publish_to_redis(self, channel: str, message: dict):
        """Publish message to Redis channel"""
        await self.redis.publish(channel, json.dumps(message))
    
    async def listen_for_updates(self):
        """Listen for Redis messages and broadcast to connected clients"""
        async for message in self.pubsub.listen():
            if message['type'] == 'message':
                try:
                    data = json.loads(message['data'])
                    channel = message['channel'].decode('utf-8')
                    match_id = channel.split(':')[1]
                    
                    await self.broadcast_to_match(match_id, data)
                except Exception as e:
                    logger.error(f"Error processing Redis message: {e}")
```

## Key Design Decisions

1. **Modular Architecture**: Clear separation between API, services, and models
2. **Dependency Injection**: Database sessions and services injected via FastAPI Depends
3. **Type Safety**: Pydantic schemas for request/response validation
4. **Async Support**: Full async/await support for high performance
5. **Error Handling**: Centralized error handling with custom exceptions
6. **Security**: JWT authentication with role-based access control
7. **Rate Limiting**: Built-in rate limiting middleware
8. **Logging**: Structured logging with correlation IDs
9. **Validation**: Multi-layer validation (schema, service, database)
10. **Caching**: Redis integration for session management and pub/sub

## Performance Optimizations

1. **Database Connection Pooling**: SQLAlchemy connection pool configuration
2. **Query Optimization**: Eager loading for related data
3. **Pagination**: Cursor-based pagination for large datasets
4. **Caching Strategy**: Redis caching for frequently accessed data
5. **Async Database Operations**: Non-blocking database queries
6. **Background Tasks**: Celery integration for heavy operations
7. **Connection Limits**: WebSocket connection limits per user/match
8. **Message Queuing**: Redis pub/sub for real-time message distribution

## Security Considerations

1. **Input Validation**: Pydantic schemas prevent injection attacks
2. **SQL Injection**: ORM prevents SQL injection by default
3. **Rate Limiting**: Prevents brute force and DoS attacks
4. **JWT Security**: Secure token generation and validation
5. **CORS Configuration**: Proper CORS headers for web clients
6. **Data Sanitization**: Output encoding for user-generated content
7. **Audit Logging**: Security events logged for monitoring
8. **HTTPS Enforcement**: All API endpoints require HTTPS