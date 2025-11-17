from sqlalchemy import Column, String, DateTime, Boolean, Enum, Integer, Float, ForeignKey, Text
from sqlalchemy.dialects.mysql import CHAR as MySQLCHAR
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from uuid import uuid4

from app.database import Base


class Profile(Base):
    """Player profile with cricket-specific statistics and information."""
    
    __tablename__ = "profiles"
    
    id = Column(MySQLCHAR(36), primary_key=True, default=lambda: str(uuid4()))
    user_id = Column(MySQLCHAR(36), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False, index=True)
    
    # Cricket-specific attributes
    batting_style = Column(Enum('right-handed', 'left-handed', name='batting_style'), nullable=True)
    bowling_style = Column(Enum('fast', 'spin', 'pace', 'none', name='bowling_style'), nullable=True)
    dominant_hand = Column(Enum('right', 'left', name='dominant_hand'), nullable=True)
    
    # Denormalized statistics for quick access
    total_matches = Column(Integer, default=0, nullable=False)
    total_runs = Column(Integer, default=0, nullable=False)
    total_wickets = Column(Integer, default=0, nullable=False)
    total_balls_faced = Column(Integer, default=0, nullable=False)
    total_balls_bowled = Column(Integer, default=0, nullable=False)
    total_runs_conceded = Column(Integer, default=0, nullable=False)
    
    # Calculated statistics
    average_runs = Column(Float, default=0.0, nullable=False)
    strike_rate = Column(Float, default=0.0, nullable=False)  # Runs per 100 balls
    economy_rate = Column(Float, default=0.0, nullable=False)  # Runs per over
    bowling_average = Column(Float, default=0.0, nullable=False)
    
    # Additional information
    teams = Column(Text, nullable=True)  # JSON array of team names
    achievements = Column(Text, nullable=True)  # JSON array of achievements
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)
    
    # Relationships
    user = relationship("User", back_populates="profile")
    
    def __repr__(self):
        return f"<Profile(id={self.id}, user_id={self.user_id}, batting={self.batting_style})>"
    
    def to_dict(self):
        """Convert profile to dictionary."""
        return {
            "id": self.id,
            "user_id": self.user_id,
            "batting_style": self.batting_style,
            "bowling_style": self.bowling_style,
            "dominant_hand": self.dominant_hand,
            "total_matches": self.total_matches,
            "total_runs": self.total_runs,
            "total_wickets": self.total_wickets,
            "total_balls_faced": self.total_balls_faced,
            "total_balls_bowled": self.total_balls_bowled,
            "total_runs_conceded": self.total_runs_conceded,
            "average_runs": self.average_runs,
            "strike_rate": self.strike_rate,
            "economy_rate": self.economy_rate,
            "bowling_average": self.bowling_average,
            "teams": self.teams,
            "achievements": self.achievements,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }