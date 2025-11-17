from sqlalchemy import Column, String, DateTime, Boolean, ForeignKey, Enum
from sqlalchemy.dialects.mysql import CHAR as MySQLCHAR
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from uuid import uuid4

from app.database import Base


class PlayersInMatch(Base):
    """Junction table for players participating in matches."""
    
    __tablename__ = "players_in_match"
    
    id = Column(MySQLCHAR(36), primary_key=True, default=lambda: str(uuid4()))
    match_id = Column(MySQLCHAR(36), ForeignKey("matches.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id = Column(MySQLCHAR(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    
    # Player role in this specific match
    team = Column(Enum('A', 'B', name='match_team'), nullable=False, index=True)
    role = Column(
        Enum('batsman', 'bowler', 'allrounder', 'wicketkeeper', name='player_role'),
        default='batsman',
        nullable=False
    )
    
    # Join timestamp
    joined_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    
    # Relationships
    match = relationship("Match", back_populates="players")
    user = relationship("User", back_populates="match_participations")
    
    def __repr__(self):
        return f"<PlayersInMatch(id={self.id}, match={self.match_id}, user={self.user_id}, team={self.team})>"
    
    def to_dict(self):
        """Convert player in match to dictionary."""
        return {
            "id": self.id,
            "match_id": self.match_id,
            "user_id": self.user_id,
            "team": self.team,
            "role": self.role,
            "joined_at": self.joined_at.isoformat() if self.joined_at else None,
        }