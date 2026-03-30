"""PostgreSQL migration - replace MySQL types with portable types

Revision ID: 003_postgresql
Revises: 002_comprehensive_schema
Create Date: 2024-01-01 00:00:00.000000

"""

from uuid import uuid4

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision = "003_postgresql"
down_revision = "002_comprehensive_schema"
branch_labels = None
depends_on = None


def upgrade() -> None:
    """
    This migration represents the PostgreSQL-compatible schema.

    Since we're migrating from MySQL to PostgreSQL, this is effectively
    a fresh start. Run this on a new PostgreSQL database.

    All MySQLCHAR(36) columns have been replaced with String(36).
    All MySQL-specific functions have been replaced with PostgreSQL equivalents.
    Notification model has been expanded with title, message, status, priority fields.
    """
    # Users table
    op.create_table(
        "users",
        sa.Column("id", sa.String(36), primary_key=True, default=lambda: str(uuid4())),
        sa.Column(
            "phone_number", sa.String(15), unique=True, nullable=False, index=True
        ),
        sa.Column("email", sa.String(255), unique=True, nullable=True, index=True),
        sa.Column("full_name", sa.String(255), nullable=False),
        sa.Column("avatar_url", sa.String(500), nullable=True),
        sa.Column("bio", sa.Text(), nullable=True),
        sa.Column(
            "role",
            sa.Enum("player", "admin", name="user_role"),
            default="player",
            nullable=False,
        ),
        sa.Column("is_active", sa.Boolean(), default=True, nullable=False),
        sa.Column("is_verified", sa.Boolean(), default=False, nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
    )

    # Profiles table
    op.create_table(
        "profiles",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            unique=True,
            nullable=False,
            index=True,
        ),
        sa.Column(
            "batting_style",
            sa.Enum("right-handed", "left-handed", name="batting_style"),
            nullable=True,
        ),
        sa.Column(
            "bowling_style",
            sa.Enum("fast", "spin", "pace", "none", name="bowling_style"),
            nullable=True,
        ),
        sa.Column(
            "dominant_hand",
            sa.Enum("right", "left", name="dominant_hand"),
            nullable=True,
        ),
        sa.Column("total_matches", sa.Integer(), default=0, nullable=False),
        sa.Column("total_runs", sa.Integer(), default=0, nullable=False),
        sa.Column("total_wickets", sa.Integer(), default=0, nullable=False),
        sa.Column("total_balls_faced", sa.Integer(), default=0, nullable=False),
        sa.Column("total_balls_bowled", sa.Integer(), default=0, nullable=False),
        sa.Column("total_runs_conceded", sa.Integer(), default=0, nullable=False),
        sa.Column("average_runs", sa.Float(), default=0.0, nullable=False),
        sa.Column("strike_rate", sa.Float(), default=0.0, nullable=False),
        sa.Column("economy_rate", sa.Float(), default=0.0, nullable=False),
        sa.Column("bowling_average", sa.Float(), default=0.0, nullable=False),
        sa.Column("teams", sa.Text(), nullable=True),
        sa.Column("achievements", sa.Text(), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
    )

    # Matches table
    op.create_table(
        "matches",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "host_user_id",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
            index=True,
        ),
        sa.Column(
            "match_type",
            sa.Enum("quick", "friendly", "tournament", name="match_type"),
            default="quick",
            nullable=False,
        ),
        sa.Column("team_a_name", sa.String(100), nullable=False),
        sa.Column("team_b_name", sa.String(100), nullable=False),
        sa.Column("venue", sa.String(255), nullable=True),
        sa.Column("latitude", sa.Float(), nullable=True),
        sa.Column("longitude", sa.Float(), nullable=True),
        sa.Column(
            "scheduled_at", sa.DateTime(timezone=True), nullable=True, index=True
        ),
        sa.Column(
            "status",
            sa.Enum(
                "created",
                "toss_done",
                "live",
                "finished",
                "cancelled",
                name="match_status",
            ),
            default="created",
            nullable=False,
            index=True,
        ),
        sa.Column("rules", sa.JSON(), nullable=False),
        sa.Column("result", sa.JSON(), nullable=True),
        sa.Column("toss_winner", sa.Enum("A", "B", name="toss_winner"), nullable=True),
        sa.Column(
            "toss_decision", sa.Enum("bat", "bowl", name="toss_decision"), nullable=True
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column("started_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("finished_at", sa.DateTime(timezone=True), nullable=True),
    )

    # Innings table
    op.create_table(
        "innings",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "match_id",
            sa.String(36),
            sa.ForeignKey("matches.id", ondelete="CASCADE"),
            nullable=False,
            index=True,
        ),
        sa.Column(
            "batting_team", sa.Enum("A", "B", name="batting_team"), nullable=False
        ),
        sa.Column("overs_allocated", sa.Integer(), nullable=False, default=20),
        sa.Column("runs", sa.Integer(), default=0, nullable=False),
        sa.Column("wickets", sa.Integer(), default=0, nullable=False),
        sa.Column("extras", sa.Integer(), default=0, nullable=False),
        sa.Column("overs_bowled", sa.Float(), default=0.0, nullable=False),
        sa.Column(
            "is_completed", sa.Boolean(), default=False, nullable=False, index=True
        ),
        sa.Column("completed_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("notes", sa.JSON(), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
    )

    # Balls table
    op.create_table(
        "balls",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "innings_id",
            sa.String(36),
            sa.ForeignKey("innings.id", ondelete="CASCADE"),
            nullable=False,
            index=True,
        ),
        sa.Column("over_number", sa.Integer(), nullable=False, index=True),
        sa.Column("ball_in_over", sa.Integer(), nullable=False),
        sa.Column(
            "batsman_id",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="SET NULL"),
            nullable=True,
            index=True,
        ),
        sa.Column(
            "non_striker_id",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="SET NULL"),
            nullable=True,
            index=True,
        ),
        sa.Column(
            "bowler_id",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="SET NULL"),
            nullable=True,
            index=True,
        ),
        sa.Column("runs_off_bat", sa.Integer(), default=0, nullable=False),
        sa.Column(
            "extras_type",
            sa.Enum("wide", "no_ball", "bye", "legbye", name="extras_type"),
            nullable=True,
        ),
        sa.Column("extras_runs", sa.Integer(), default=0, nullable=False),
        sa.Column(
            "wicket_type",
            sa.Enum(
                "bowled",
                "caught",
                "runout",
                "lbw",
                "stumped",
                "hit_wicket",
                name="wicket_type",
            ),
            nullable=True,
        ),
        sa.Column("dismissal_info", sa.JSON(), nullable=True),
        sa.Column("client_event_id", sa.String(100), nullable=True, index=True),
        sa.Column("metadata", sa.JSON(), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
    )

    # Players in match table
    op.create_table(
        "players_in_match",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "match_id",
            sa.String(36),
            sa.ForeignKey("matches.id", ondelete="CASCADE"),
            nullable=False,
            index=True,
        ),
        sa.Column(
            "user_id",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
            index=True,
        ),
        sa.Column(
            "team", sa.Enum("A", "B", name="match_team"), nullable=False, index=True
        ),
        sa.Column(
            "role",
            sa.Enum(
                "batsman", "bowler", "allrounder", "wicketkeeper", name="player_role"
            ),
            default="batsman",
            nullable=False,
        ),
        sa.Column(
            "joined_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
    )

    # Match events table
    op.create_table(
        "match_events",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "match_id",
            sa.String(36),
            sa.ForeignKey("matches.id", ondelete="CASCADE"),
            nullable=False,
            index=True,
        ),
        sa.Column(
            "event_type",
            sa.Enum(
                "boundary",
                "wicket",
                "milestone",
                "highlight",
                "comment",
                "innings_change",
                "toss",
                name="event_type",
            ),
            nullable=False,
            index=True,
        ),
        sa.Column("meta", sa.JSON(), nullable=False),
        sa.Column("likes_count", sa.Integer(), default=0, nullable=False),
        sa.Column("comments_count", sa.Integer(), default=0, nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
    )

    # Notifications table (expanded schema)
    op.create_table(
        "notifications",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
            index=True,
        ),
        sa.Column("title", sa.String(200), nullable=False),
        sa.Column("message", sa.String(1000), nullable=False),
        sa.Column(
            "type",
            sa.Enum(
                "match_invitation",
                "match_update",
                "match_reminder",
                "system",
                "achievement",
                name="notification_type_v2",
            ),
            nullable=False,
            index=True,
        ),
        sa.Column("data", sa.JSON(), nullable=True),
        sa.Column(
            "priority",
            sa.Enum("low", "medium", "high", name="notification_priority"),
            default="medium",
            nullable=False,
        ),
        sa.Column(
            "status",
            sa.Enum("unread", "read", name="notification_status"),
            default="unread",
            nullable=False,
            index=True,
        ),
        sa.Column("read_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
    )

    # OTP sessions table
    op.create_table(
        "otp_sessions",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("phone_number", sa.String(15), nullable=False, index=True),
        sa.Column("otp_code", sa.String(6), nullable=False),
        sa.Column("attempts", sa.Integer(), default=0, nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False, index=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
    )


def downgrade() -> None:
    """Drop all tables."""
    op.drop_table("otp_sessions")
    op.drop_table("notifications")
    op.drop_table("match_events")
    op.drop_table("players_in_match")
    op.drop_table("balls")
    op.drop_table("innings")
    op.drop_table("matches")
    op.drop_table("profiles")
    op.drop_table("users")
