from fastapi import WebSocket, WebSocketDisconnect, Depends, HTTPException, status
from fastapi.routing import APIRouter
from typing import Dict, Set
import json
import asyncio
import structlog
from datetime import datetime

from app.auth.jwt import verify_token
from app.database import get_db
from app.models.user import User

logger = structlog.get_logger()
router = APIRouter()

# Global connection manager for WebSocket connections
class ConnectionManager:
    def __init__(self):
        # Store active connections by user_id
        self.active_connections: Dict[str, WebSocket] = {}
        # Store connections by match_id for match-specific broadcasts
        self.match_connections: Dict[str, Set[str]] = {}
        
    async def connect(self, websocket: WebSocket, user_id: str, match_id: str = None):
        """Accept a new WebSocket connection."""
        await websocket.accept()
        self.active_connections[user_id] = websocket
        
        if match_id:
            if match_id not in self.match_connections:
                self.match_connections[match_id] = set()
            self.match_connections[match_id].add(user_id)
            
        logger.info("WebSocket connection established", 
                   user_id=user_id, 
                   match_id=match_id,
                   total_connections=len(self.active_connections))
    
    def disconnect(self, user_id: str, match_id: str = None):
        """Remove a WebSocket connection."""
        if user_id in self.active_connections:
            del self.active_connections[user_id]
            
        if match_id and match_id in self.match_connections:
            self.match_connections[match_id].discard(user_id)
            if not self.match_connections[match_id]:
                del self.match_connections[match_id]
                
        logger.info("WebSocket connection closed", 
                   user_id=user_id, 
                   match_id=match_id,
                   total_connections=len(self.active_connections))
    
    async def send_personal_message(self, message: dict, user_id: str):
        """Send a message to a specific user."""
        if user_id in self.active_connections:
            connection = self.active_connections[user_id]
            try:
                await connection.send_text(json.dumps(message))
                logger.debug("Personal message sent", user_id=user_id, message_type=message.get('type'))
            except Exception as e:
                logger.error("Failed to send personal message", 
                           user_id=user_id, 
                           error=str(e))
                self.disconnect(user_id)
    
    async def broadcast_to_match(self, message: dict, match_id: str, exclude_user_id: str = None):
        """Broadcast a message to all users in a match."""
        if match_id not in self.match_connections:
            return
            
        disconnected_users = []
        
        for user_id in self.match_connections[match_id]:
            if user_id == exclude_user_id:
                continue
                
            if user_id in self.active_connections:
                connection = self.active_connections[user_id]
                try:
                    await connection.send_text(json.dumps(message))
                    logger.debug("Match broadcast sent", 
                               match_id=match_id, 
                               user_id=user_id, 
                               message_type=message.get('type'))
                except Exception as e:
                    logger.error("Failed to send match broadcast", 
                               user_id=user_id, 
                               match_id=match_id, 
                               error=str(e))
                    disconnected_users.append(user_id)
        
        # Clean up disconnected users
        for user_id in disconnected_users:
            self.disconnect(user_id)
    
    async def broadcast_to_all(self, message: dict, exclude_user_id: str = None):
        """Broadcast a message to all connected users."""
        disconnected_users = []
        
        for user_id, connection in self.active_connections.items():
            if user_id == exclude_user_id:
                continue
                
            try:
                await connection.send_text(json.dumps(message))
                logger.debug("Global broadcast sent", 
                           user_id=user_id, 
                           message_type=message.get('type'))
            except Exception as e:
                logger.error("Failed to send global broadcast", 
                           user_id=user_id, 
                           error=str(e))
                disconnected_users.append(user_id)
        
        # Clean up disconnected users
        for user_id in disconnected_users:
            self.disconnect(user_id)

# Global connection manager instance
manager = ConnectionManager()


@router.websocket("/ws/{token}")
async def websocket_endpoint(websocket: WebSocket, token: str):
    """WebSocket endpoint for real-time updates."""
    user_id = None
    match_id = None
    
    try:
        # Verify JWT token
        payload = verify_token(token)
        if not payload:
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return
            
        user_id = payload.get("sub")
        if not user_id:
            await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
            return
        
        # Accept connection
        await manager.connect(websocket, user_id, match_id)
        
        # Send welcome message
        await manager.send_personal_message({
            "type": "connection_established",
            "timestamp": datetime.utcnow().isoformat(),
            "user_id": user_id
        }, user_id)
        
        # Main message loop
        while True:
            # Receive message from client
            data = await websocket.receive_text()
            
            try:
                message = json.loads(data)
                await handle_websocket_message(message, user_id, websocket)
            except json.JSONDecodeError:
                logger.warning("Invalid JSON received", user_id=user_id)
                await manager.send_personal_message({
                    "type": "error",
                    "message": "Invalid message format"
                }, user_id)
            
    except WebSocketDisconnect:
        manager.disconnect(user_id, match_id)
        logger.info("WebSocket disconnected normally", user_id=user_id)
    except Exception as e:
        logger.error("WebSocket error", user_id=user_id, error=str(e))
        if user_id:
            manager.disconnect(user_id, match_id)


async def handle_websocket_message(message: dict, user_id: str, websocket: WebSocket):
    """Handle incoming WebSocket messages."""
    message_type = message.get("type")
    
    if message_type == "ping":
        # Respond with pong
        await websocket.send_text(json.dumps({
            "type": "pong",
            "timestamp": datetime.utcnow().isoformat()
        }))
        
    elif message_type == "subscribe_match":
        # Subscribe to match updates
        match_id = message.get("match_id")
        if match_id:
            await handle_match_subscription(user_id, match_id, websocket)
        else:
            await websocket.send_text(json.dumps({
                "type": "error",
                "message": "match_id is required for subscribe_match"
            }))
            
    elif message_type == "unsubscribe_match":
        # Unsubscribe from match updates
        match_id = message.get("match_id")
        if match_id:
            await handle_match_unsubscription(user_id, match_id)
        else:
            await websocket.send_text(json.dumps({
                "type": "error",
                "message": "match_id is required for unsubscribe_match"
            }))
            
    elif message_type == "ball_update":
        # Handle ball-by-ball updates (for hosts)
        await handle_ball_update(message, user_id)
        
    elif message_type == "match_status_update":
        # Handle match status updates (for hosts)
        await handle_match_status_update(message, user_id)
        
    else:
        # Unknown message type
        await websocket.send_text(json.dumps({
            "type": "error",
            "message": f"Unknown message type: {message_type}"
        }))


async def handle_match_subscription(user_id: str, match_id: str, websocket: WebSocket):
    """Handle user subscribing to match updates."""
    # Add user to match connections
    if match_id not in manager.match_connections:
        manager.match_connections[match_id] = set()
    manager.match_connections[match_id].add(user_id)
    
    # Send confirmation
    await websocket.send_text(json.dumps({
        "type": "subscription_confirmed",
        "match_id": match_id,
        "timestamp": datetime.utcnow().isoformat()
    }))
    
    logger.info("User subscribed to match updates", 
               user_id=user_id, 
               match_id=match_id)


async def handle_match_unsubscription(user_id: str, match_id: str):
    """Handle user unsubscribing from match updates."""
    if match_id in manager.match_connections:
        manager.match_connections[match_id].discard(user_id)
        if not manager.match_connections[match_id]:
            del manager.match_connections[match_id]
    
    logger.info("User unsubscribed from match updates", 
               user_id=user_id, 
               match_id=match_id)


async def handle_ball_update(message: dict, user_id: str):
    """Handle ball-by-ball updates from match hosts."""
    match_id = message.get("match_id")
    ball_data = message.get("ball_data")
    
    if not match_id or not ball_data:
        await manager.send_personal_message({
            "type": "error",
            "message": "match_id and ball_data are required for ball_update"
        }, user_id)
        return
    
    # Verify user is the match host (this would need database verification in production)
    # For now, we'll allow any authenticated user to send updates
    
    # Broadcast to all users subscribed to this match
    broadcast_message = {
        "type": "ball_update",
        "match_id": match_id,
        "ball_data": ball_data,
        "timestamp": datetime.utcnow().isoformat(),
        "updated_by": user_id
    }
    
    await manager.broadcast_to_match(broadcast_message, match_id, exclude_user_id=user_id)
    
    logger.info("Ball update broadcasted", 
               user_id=user_id, 
               match_id=match_id,
               ball_over=f"{ball_data.get('over_number')}.{ball_data.get('ball_in_over')}")


async def handle_match_status_update(message: dict, user_id: str):
    """Handle match status updates from match hosts."""
    match_id = message.get("match_id")
    status = message.get("status")
    
    if not match_id or not status:
        await manager.send_personal_message({
            "type": "error",
            "message": "match_id and status are required for match_status_update"
        }, user_id)
        return
    
    # Broadcast to all users subscribed to this match
    broadcast_message = {
        "type": "match_status_update",
        "match_id": match_id,
        "status": status,
        "timestamp": datetime.utcnow().isoformat(),
        "updated_by": user_id
    }
    
    await manager.broadcast_to_match(broadcast_message, match_id, exclude_user_id=user_id)
    
    logger.info("Match status update broadcasted", 
               user_id=user_id, 
               match_id=match_id,
               status=status)


# Helper functions for sending specific types of notifications
async def send_ball_notification(match_id: str, ball_data: dict, exclude_user_id: str = None):
    """Send ball-by-ball notification to match subscribers."""
    message = {
        "type": "ball_update",
        "match_id": match_id,
        "ball_data": ball_data,
        "timestamp": datetime.utcnow().isoformat()
    }
    
    await manager.broadcast_to_match(message, match_id, exclude_user_id)


async def send_match_status_notification(match_id: str, status: str, exclude_user_id: str = None):
    """Send match status update to match subscribers."""
    message = {
        "type": "match_status_update",
        "match_id": match_id,
        "status": status,
        "timestamp": datetime.utcnow().isoformat()
    }
    
    await manager.broadcast_to_match(message, match_id, exclude_user_id)


async def send_innings_completion_notification(match_id: str, innings_data: dict, exclude_user_id: str = None):
    """Send innings completion notification to match subscribers."""
    message = {
        "type": "innings_completed",
        "match_id": match_id,
        "innings_data": innings_data,
        "timestamp": datetime.utcnow().isoformat()
    }
    
    await manager.broadcast_to_match(message, match_id, exclude_user_id)


async def send_match_completion_notification(match_id: str, match_result: dict, exclude_user_id: str = None):
    """Send match completion notification to match subscribers."""
    message = {
        "type": "match_completed",
        "match_id": match_id,
        "result": match_result,
        "timestamp": datetime.utcnow().isoformat()
    }
    
    await manager.broadcast_to_match(message, match_id, exclude_user_id)