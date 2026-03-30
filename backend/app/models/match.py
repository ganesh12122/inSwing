from uuid import uuid4

from app.database import Base
from sqlalchemy import (
    JSON,
    Boolean,
    Column,
    DateTime,
    Enum,
    Float,
    ForeignKey,
    Integer,
    String,
    Text,
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func


class Match(Base):
    """Cricket match model with dual-captain support.

    Supports three match modes:
    - quick: Solo scoring (single host, no invitation flow)
    - dual_captain: Two captains collaborate (invite → accept → setup → play)
    - friendly: Legacy mode (same as quick but labeled differently)
    - tournament: Tournament matches (Phase 3, managed by organizer)
    """

    __tablename__ = "matches"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid4()))

    # === CAPTAINS ===
    host_user_id = Column(
        String(36),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    # Opponent captain (null for quick matches)
    opponent_captain_id = Column(
        String(36),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )
    # Designated scorer (null = host scores by default)
    scorer_user_id = Column(
        String(36),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
    )

    # === MATCH INFO ===
    match_type = Column(
        Enum(
            "quick", "dual_captain", "friendly", "tournament",
            name="match_type_v2",
        ),
        default="quick",
        nullable=False,
    )
    team_a_name = Column(String(100), nullable=False)
    team_b_name = Column(String(100), nullable=True)  # Nullable for dual_captain (opponent sets it)

    # Venue information
    venue = Column(String(255), nullable=True)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)

    # Scheduling
    scheduled_at = Column(DateTime(timezone=True), nullable=True, index=True)

    # === MATCH STATUS ===
    status = Column(
        Enum(
            "created",           # Match shell created by host
            "invited",           # Host sent invitation to opponent
            "accepted",          # Opponent accepted invitation
            "teams_ready",       # Both captains marked their teams ready
            "rules_proposed",    # One captain proposed rules
            "rules_approved",    # Both captains approved rules
            "toss_done",         # Toss recorded
            "live",              # Match in progress
            "finished",          # Match completed
            "cancelled",         # Match cancelled
            "declined",          # Invitation declined by opponent
            name="match_status_v2",
        ),
        default="created",
        nullable=False,
        index=True,
    )

    # === INVITATION ===
    invitation_message = Column(String(500), nullable=True)
    invited_at = Column(DateTime(timezone=True), nullable=True)
    accepted_at = Column(DateTime(timezone=True), nullable=True)
    declined_at = Column(DateTime(timezone=True), nullable=True)

    # === RULES (final agreed rules) ===
    rules = Column(
        JSON,
        nullable=False,
        default=lambda: {
            "overs_limit": 6,
            "powerplay_overs": 0,
            "max_overs_per_bowler": 0,
            "wide_ball_runs": 1,
            "no_ball_runs": 1,
            "free_hit": True,
            "super_over": False,
            "min_players_per_team": 2,
            "max_players_per_team": 11,
            "last_man_batting": False,
            "tennis_ball": True,
            "boundary_runs": 4,
            "scorer_permission": "host_only",
        },
    )

    # === RULES NEGOTIATION ===
    proposed_rules = Column(JSON, nullable=True)          # Rules waiting for approval
    rules_proposed_by = Column(String(36), nullable=True)  # User ID of proposer
    host_rules_approved = Column(Boolean, default=False, nullable=False)
    opponent_rules_approved = Column(Boolean, default=False, nullable=False)

    # === TEAM READINESS ===
    host_team_ready = Column(Boolean, default=False, nullable=False)
    opponent_team_ready = Column(Boolean, default=False, nullable=False)
    min_players_per_team = Column(Integer, default=2, nullable=False)

    # === MATCH RESULT ===
    result = Column(JSON, nullable=True)

    # === TOSS ===
    toss_winner = Column(Enum("A", "B", name="toss_winner"), nullable=True)
    toss_decision = Column(Enum("bat", "bowl", name="toss_decision"), nullable=True)

    # === TIMESTAMPS ===
    created_at = Column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    updated_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )
    started_at = Column(DateTime(timezone=True), nullable=True)
    finished_at = Column(DateTime(timezone=True), nullable=True)

    # === RELATIONSHIPS ===
    host = relationship(
        "User", back_populates="hosted_matches", foreign_keys=[host_user_id]
    )
    opponent_captain = relationship(
        "User",
        back_populates="opponent_matches",
        foreign_keys=[opponent_captain_id],
    )
    scorer = relationship(
        "User",
        foreign_keys=[scorer_user_id],
    )
    players = relationship(
        "PlayersInMatch", back_populates="match", cascade="all, delete-orphan"
    )
    innings = relationship(
        "Innings", back_populates="match", cascade="all, delete-orphan"
    )
    events = relationship(
        "MatchEvent", back_populates="match", cascade="all, delete-orphan"
    )

    def __repr__(self):
        return f"<Match(id={self.id}, type={self.match_type}, teams={self.team_a_name} vs {self.team_b_name}, status={self.status})>"

    def to_dict(self):
        """Convert match to dictionary."""
        return {
            "id": self.id,
            "host_user_id": self.host_user_id,
            "opponent_captain_id": self.opponent_captain_id,
            "scorer_user_id": self.scorer_user_id,
            "match_type": self.match_type,
            "team_a_name": self.team_a_name,
            "team_b_name": self.team_b_name,
            "venue": self.venue,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "scheduled_at": (
                self.scheduled_at.isoformat() if self.scheduled_at else None
            ),
            "status": self.status,
            "invitation_message": self.invitation_message,
            "invited_at": self.invited_at.isoformat() if self.invited_at else None,
            "accepted_at": self.accepted_at.isoformat() if self.accepted_at else None,
            "declined_at": self.declined_at.isoformat() if self.declined_at else None,
            "rules": self.rules,
            "proposed_rules": self.proposed_rules,
            "rules_proposed_by": self.rules_proposed_by,
            "host_rules_approved": self.host_rules_approved,
            "opponent_rules_approved": self.opponent_rules_approved,
            "host_team_ready": self.host_team_ready,
            "opponent_team_ready": self.opponent_team_ready,
            "min_players_per_team": self.min_players_per_team,
            "result": self.result,
            "toss_winner": self.toss_winner,
            "toss_decision": self.toss_decision,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
            "started_at": self.started_at.isoformat() if self.started_at else None,
            "finished_at": self.finished_at.isoformat() if self.finished_at else None,
        }

    @property
    def current_innings(self):
        """Get the current active innings."""
        for innings in self.innings:
            if not innings.is_completed:
                return innings
        return None

    @property
    def is_dual_captain(self) -> bool:
        """Check if this is a dual-captain match."""
        return self.match_type == "dual_captain"

    @property
    def both_teams_ready(self) -> bool:
        """Check if both teams are marked as ready."""
        return self.host_team_ready and self.opponent_team_ready

    @property
    def rules_agreed(self) -> bool:
        """Check if both captains have approved the rules."""
        return self.host_rules_approved and self.opponent_rules_approved

    def is_captain(self, user_id: str) -> bool:
        """Check if a user is either captain in this match."""
        return user_id in (self.host_user_id, self.opponent_captain_id)

    def can_score(self, user_id: str) -> bool:
        """Check if a user has scoring permissions based on match rules."""
        permission = (self.rules or {}).get("scorer_permission", "host_only")

        if permission == "host_only":
            return user_id == self.host_user_id
        elif permission == "captains":
            return self.is_captain(user_id)
        elif permission == "designated":
            return user_id == self.scorer_user_id or user_id == self.host_user_id
        elif permission == "all_players":
            return any(p.user_id == user_id for p in self.players)
        return False
