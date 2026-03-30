from pydantic import BaseModel, Field
from typing import Optional, Dict, Any, List
from datetime import datetime
from enum import Enum


class MatchType(str, Enum):
    quick = "quick"
    dual_captain = "dual_captain"
    friendly = "friendly"
    tournament = "tournament"


class MatchStatus(str, Enum):
    created = "created"
    invited = "invited"
    accepted = "accepted"
    teams_ready = "teams_ready"
    rules_proposed = "rules_proposed"
    rules_approved = "rules_approved"
    toss_done = "toss_done"
    live = "live"
    finished = "finished"
    cancelled = "cancelled"
    declined = "declined"


class TossDecision(str, Enum):
    bat = "bat"
    bowl = "bowl"


class ScorerPermission(str, Enum):
    """Who can score in a match."""
    host_only = "host_only"       # Only the host captain
    captains = "captains"          # Either captain
    designated = "designated"      # Designated scorer (third party)
    all_players = "all_players"    # Any player in the match


class MatchRules(BaseModel):
    """Match rules configuration — covers gully cricket to semi-pro."""
    overs_limit: int = Field(6, ge=1, le=50, description="Total overs per innings")
    powerplay_overs: int = Field(0, ge=0, le=20, description="Powerplay overs (0 = none)")
    max_overs_per_bowler: int = Field(0, ge=0, le=10, description="Max overs per bowler (0 = no limit)")
    wide_ball_runs: int = Field(1, ge=1, le=2, description="Runs awarded for wide ball")
    no_ball_runs: int = Field(1, ge=1, le=2, description="Runs awarded for no ball")
    free_hit: bool = Field(True, description="Free hit after no ball")
    super_over: bool = Field(False, description="Super over on tie")
    min_players_per_team: int = Field(2, ge=2, le=11, description="Minimum players required per team")
    max_players_per_team: int = Field(11, ge=2, le=15, description="Maximum players allowed per team")
    last_man_batting: bool = Field(False, description="Allow last man to continue batting (gully cricket)")
    tennis_ball: bool = Field(True, description="Tennis ball match (gully cricket default)")
    boundary_runs: int = Field(4, ge=4, le=6, description="Runs for boundary hit along ground")
    scorer_permission: ScorerPermission = Field(
        ScorerPermission.host_only,
        description="Who has permission to score in this match",
    )


class MatchResult(BaseModel):
    """Match result information."""
    winner: str  # 'A' or 'B'
    winning_margin: int
    winning_type: str  # 'runs' or 'wickets'
    mvp: Optional[str] = None  # User ID of MVP
    final_scores: Dict[str, Any]


# === CREATE SCHEMAS ===

class MatchCreate(BaseModel):
    """Schema for creating a new match.

    For quick matches: both team names required, no invitation flow.
    For dual_captain: only team_a_name required, team_b_name set by opponent.
    """
    match_type: MatchType = MatchType.quick
    team_a_name: str = Field(..., min_length=1, max_length=100)
    team_b_name: Optional[str] = Field(None, min_length=1, max_length=100)
    venue: Optional[str] = Field(None, max_length=255)
    latitude: Optional[float] = Field(None, ge=-90, le=90)
    longitude: Optional[float] = Field(None, ge=-180, le=180)
    scheduled_at: Optional[datetime] = None
    rules: MatchRules = Field(default_factory=MatchRules)

    def model_post_init(self, __context: Any) -> None:
        """Validate that quick matches have team_b_name."""
        if self.match_type in (MatchType.quick, MatchType.friendly):
            if not self.team_b_name:
                raise ValueError("team_b_name is required for quick/friendly matches")


class MatchUpdate(BaseModel):
    """Schema for updating match information."""
    team_a_name: Optional[str] = Field(None, min_length=1, max_length=100)
    team_b_name: Optional[str] = Field(None, min_length=1, max_length=100)
    venue: Optional[str] = Field(None, max_length=255)
    latitude: Optional[float] = Field(None, ge=-90, le=90)
    longitude: Optional[float] = Field(None, ge=-180, le=180)
    scheduled_at: Optional[datetime] = None
    rules: Optional[MatchRules] = None


class TossUpdate(BaseModel):
    """Schema for updating toss result."""
    toss_winner: str = Field(..., pattern="^[AB]$")  # 'A' or 'B'
    toss_decision: TossDecision


# === INVITATION SCHEMAS ===

class MatchInviteRequest(BaseModel):
    """Schema for inviting an opponent captain."""
    opponent_user_id: str = Field(..., min_length=1, description="User ID of the opponent captain")
    message: Optional[str] = Field(None, max_length=500, description="Optional invitation message")


class MatchInviteAccept(BaseModel):
    """Schema for accepting a match invitation."""
    team_b_name: str = Field(..., min_length=1, max_length=100, description="Opponent's team name")


# === TEAM MANAGEMENT SCHEMAS ===

class AddPlayerRequest(BaseModel):
    """Schema for adding a player to a team.

    For app users: provide user_id.
    For guest players: provide guest_name (is_guest auto-set).
    """
    user_id: Optional[str] = Field(None, description="User ID for registered players")
    guest_name: Optional[str] = Field(None, min_length=1, max_length=255, description="Name for guest players")
    role: str = Field("batsman", description="Player role in this match")

    def model_post_init(self, __context: Any) -> None:
        """Validate that either user_id or guest_name is provided."""
        if not self.user_id and not self.guest_name:
            raise ValueError("Either user_id or guest_name must be provided")
        if self.user_id and self.guest_name:
            raise ValueError("Provide either user_id or guest_name, not both")


class TeamReadyRequest(BaseModel):
    """Schema for marking a team as ready."""
    ready: bool = Field(True, description="Whether the team is ready")


# === RULES NEGOTIATION SCHEMAS ===

class RulesProposalRequest(BaseModel):
    """Schema for proposing match rules."""
    rules: MatchRules


class RulesApprovalResponse(BaseModel):
    """Schema for rules approval status."""
    proposed_rules: Optional[MatchRules] = None
    rules_proposed_by: Optional[str] = None
    host_rules_approved: bool = False
    opponent_rules_approved: bool = False
    final_rules: Optional[MatchRules] = None

    class Config:
        from_attributes = True


# === RESPONSE SCHEMAS ===

class MatchInDB(BaseModel):
    """Schema for match data from database."""
    id: str
    host_user_id: str
    opponent_captain_id: Optional[str] = None
    scorer_user_id: Optional[str] = None
    match_type: MatchType
    team_a_name: str
    team_b_name: Optional[str] = None
    venue: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    scheduled_at: Optional[datetime] = None
    status: MatchStatus
    invitation_message: Optional[str] = None
    invited_at: Optional[datetime] = None
    accepted_at: Optional[datetime] = None
    declined_at: Optional[datetime] = None
    rules: Optional[Dict[str, Any]] = None
    proposed_rules: Optional[Dict[str, Any]] = None
    rules_proposed_by: Optional[str] = None
    host_rules_approved: bool = False
    opponent_rules_approved: bool = False
    host_team_ready: bool = False
    opponent_team_ready: bool = False
    min_players_per_team: int = 2
    result: Optional[MatchResult] = None
    toss_winner: Optional[str] = None
    toss_decision: Optional[TossDecision] = None
    created_at: datetime
    updated_at: datetime
    started_at: Optional[datetime] = None
    finished_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class MatchResponse(MatchInDB):
    """Schema for match responses — includes computed fields."""
    is_dual_captain: bool = False
    both_teams_ready: bool = False
    rules_agreed: bool = False

    @classmethod
    def from_match(cls, match) -> "MatchResponse":
        """Build response from Match ORM object with computed fields."""
        data = {
            "id": match.id,
            "host_user_id": match.host_user_id,
            "opponent_captain_id": match.opponent_captain_id,
            "scorer_user_id": match.scorer_user_id,
            "match_type": match.match_type,
            "team_a_name": match.team_a_name,
            "team_b_name": match.team_b_name,
            "venue": match.venue,
            "latitude": match.latitude,
            "longitude": match.longitude,
            "scheduled_at": match.scheduled_at,
            "status": match.status,
            "invitation_message": match.invitation_message,
            "invited_at": match.invited_at,
            "accepted_at": match.accepted_at,
            "declined_at": match.declined_at,
            "rules": match.rules,
            "proposed_rules": match.proposed_rules,
            "rules_proposed_by": match.rules_proposed_by,
            "host_rules_approved": match.host_rules_approved,
            "opponent_rules_approved": match.opponent_rules_approved,
            "host_team_ready": match.host_team_ready,
            "opponent_team_ready": match.opponent_team_ready,
            "min_players_per_team": match.min_players_per_team,
            "result": match.result,
            "toss_winner": match.toss_winner,
            "toss_decision": match.toss_decision,
            "created_at": match.created_at,
            "updated_at": match.updated_at,
            "started_at": match.started_at,
            "finished_at": match.finished_at,
            # Computed fields
            "is_dual_captain": match.match_type == "dual_captain",
            "both_teams_ready": match.host_team_ready and match.opponent_team_ready,
            "rules_agreed": match.host_rules_approved and match.opponent_rules_approved,
        }
        return cls(**data)


class MatchListResponse(BaseModel):
    """Schema for match list responses."""
    matches: list[MatchResponse]
    total: int
    page: int
    per_page: int
