"""Dual Captain Match System — add opponent captain, invitation flow,
rules negotiation, team readiness, guest players, scorer permissions.

Revision ID: 004_dual_captain
Revises: 003_postgresql
Create Date: 2024-01-15 00:00:00.000000

"""

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision = "004_dual_captain"
down_revision = "003_postgresql"
branch_labels = None
depends_on = None


def upgrade() -> None:
    """Add dual-captain system columns to matches and players_in_match."""

    # ========================================================================
    # 1. Create new enum types
    # ========================================================================
    match_type_v2 = sa.Enum(
        "quick",
        "dual_captain",
        "friendly",
        "tournament",
        name="match_type_v2",
    )
    match_type_v2.create(op.get_bind(), checkfirst=True)

    match_status_v2 = sa.Enum(
        "created",
        "invited",
        "accepted",
        "teams_ready",
        "rules_proposed",
        "rules_approved",
        "toss_done",
        "live",
        "finished",
        "cancelled",
        "declined",
        name="match_status_v2",
    )
    match_status_v2.create(op.get_bind(), checkfirst=True)

    player_role_v2 = sa.Enum(
        "captain",
        "batsman",
        "bowler",
        "allrounder",
        "wicketkeeper",
        name="player_role_v2",
    )
    player_role_v2.create(op.get_bind(), checkfirst=True)

    # ========================================================================
    # 2. Update matches table — add new columns
    # ========================================================================

    # Opponent captain
    op.add_column(
        "matches",
        sa.Column(
            "opponent_captain_id",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="SET NULL"),
            nullable=True,
        ),
    )
    op.create_index(
        "ix_matches_opponent_captain_id", "matches", ["opponent_captain_id"]
    )

    # Designated scorer
    op.add_column(
        "matches",
        sa.Column(
            "scorer_user_id",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="SET NULL"),
            nullable=True,
        ),
    )

    # Invitation fields
    op.add_column(
        "matches", sa.Column("invitation_message", sa.String(500), nullable=True)
    )
    op.add_column(
        "matches", sa.Column("invited_at", sa.DateTime(timezone=True), nullable=True)
    )
    op.add_column(
        "matches", sa.Column("accepted_at", sa.DateTime(timezone=True), nullable=True)
    )
    op.add_column(
        "matches", sa.Column("declined_at", sa.DateTime(timezone=True), nullable=True)
    )

    # Rules negotiation
    op.add_column("matches", sa.Column("proposed_rules", sa.JSON(), nullable=True))
    op.add_column(
        "matches", sa.Column("rules_proposed_by", sa.String(36), nullable=True)
    )
    op.add_column(
        "matches",
        sa.Column(
            "host_rules_approved", sa.Boolean(), server_default="false", nullable=False
        ),
    )
    op.add_column(
        "matches",
        sa.Column(
            "opponent_rules_approved",
            sa.Boolean(),
            server_default="false",
            nullable=False,
        ),
    )

    # Team readiness
    op.add_column(
        "matches",
        sa.Column(
            "host_team_ready", sa.Boolean(), server_default="false", nullable=False
        ),
    )
    op.add_column(
        "matches",
        sa.Column(
            "opponent_team_ready", sa.Boolean(), server_default="false", nullable=False
        ),
    )
    op.add_column(
        "matches",
        sa.Column(
            "min_players_per_team", sa.Integer(), server_default="2", nullable=False
        ),
    )

    # Make team_b_name nullable (opponent sets it in dual_captain mode)
    op.alter_column(
        "matches", "team_b_name", existing_type=sa.String(100), nullable=True
    )

    # Migrate match_type from old enum to new enum
    # Step 1: Add temporary column with new enum
    op.add_column("matches", sa.Column("match_type_new", match_type_v2, nullable=True))
    # Step 2: Copy data (quick→quick, friendly→friendly, tournament→tournament)
    op.execute("UPDATE matches SET match_type_new = match_type::text::match_type_v2")
    # Step 3: Drop old column and rename new
    op.drop_column("matches", "match_type")
    op.alter_column(
        "matches", "match_type_new", new_column_name="match_type", nullable=False
    )

    # Migrate status from old enum to new enum
    op.add_column("matches", sa.Column("status_new", match_status_v2, nullable=True))
    op.execute("UPDATE matches SET status_new = status::text::match_status_v2")
    op.drop_column("matches", "status")
    op.alter_column("matches", "status_new", new_column_name="status", nullable=False)
    op.create_index("ix_matches_status", "matches", ["status"])

    # ========================================================================
    # 3. Update players_in_match table — add guest support + captain role
    # ========================================================================

    # Make user_id nullable (for guest players)
    op.alter_column(
        "players_in_match", "user_id", existing_type=sa.String(36), nullable=True
    )

    # Guest player support
    op.add_column(
        "players_in_match",
        sa.Column("is_guest", sa.Boolean(), server_default="false", nullable=False),
    )
    op.add_column(
        "players_in_match", sa.Column("guest_name", sa.String(255), nullable=True)
    )

    # Who added this player
    op.add_column(
        "players_in_match",
        sa.Column(
            "added_by",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="SET NULL"),
            nullable=True,
        ),
    )
    op.create_index("ix_players_in_match_added_by", "players_in_match", ["added_by"])

    # Migrate role from old enum to new enum (add 'captain')
    op.add_column(
        "players_in_match", sa.Column("role_new", player_role_v2, nullable=True)
    )
    op.execute("UPDATE players_in_match SET role_new = role::text::player_role_v2")
    op.drop_column("players_in_match", "role")
    op.alter_column(
        "players_in_match",
        "role_new",
        new_column_name="role",
        nullable=False,
        server_default="batsman",
    )

    # ========================================================================
    # 4. Drop old enum types (cleanup)
    # ========================================================================
    op.execute("DROP TYPE IF EXISTS match_type")
    op.execute("DROP TYPE IF EXISTS match_status")
    op.execute("DROP TYPE IF EXISTS player_role")


def downgrade() -> None:
    """Reverse the dual captain migration."""

    # Recreate old enums
    old_match_type = sa.Enum("quick", "friendly", "tournament", name="match_type")
    old_match_type.create(op.get_bind(), checkfirst=True)

    old_match_status = sa.Enum(
        "created", "toss_done", "live", "finished", "cancelled", name="match_status"
    )
    old_match_status.create(op.get_bind(), checkfirst=True)

    old_player_role = sa.Enum(
        "batsman", "bowler", "allrounder", "wicketkeeper", name="player_role"
    )
    old_player_role.create(op.get_bind(), checkfirst=True)

    # Revert players_in_match
    op.add_column(
        "players_in_match", sa.Column("role_old", old_player_role, nullable=True)
    )
    op.execute(
        """
        UPDATE players_in_match
        SET role_old = CASE
            WHEN role::text = 'captain' THEN 'allrounder'::player_role
            ELSE role::text::player_role
        END
    """
    )
    op.drop_column("players_in_match", "role")
    op.alter_column(
        "players_in_match",
        "role_old",
        new_column_name="role",
        nullable=False,
        server_default="batsman",
    )

    op.drop_index("ix_players_in_match_added_by", "players_in_match")
    op.drop_column("players_in_match", "added_by")
    op.drop_column("players_in_match", "guest_name")
    op.drop_column("players_in_match", "is_guest")
    op.alter_column(
        "players_in_match", "user_id", existing_type=sa.String(36), nullable=False
    )

    # Revert matches
    op.drop_index("ix_matches_status", "matches")

    op.add_column("matches", sa.Column("status_old", old_match_status, nullable=True))
    op.execute(
        """
        UPDATE matches
        SET status_old = CASE
            WHEN status::text IN ('created', 'toss_done', 'live', 'finished', 'cancelled')
            THEN status::text::match_status
            ELSE 'created'::match_status
        END
    """
    )
    op.drop_column("matches", "status")
    op.alter_column("matches", "status_old", new_column_name="status", nullable=False)
    op.create_index("ix_matches_status", "matches", ["status"])

    op.add_column("matches", sa.Column("match_type_old", old_match_type, nullable=True))
    op.execute(
        """
        UPDATE matches
        SET match_type_old = CASE
            WHEN match_type::text IN ('quick', 'friendly', 'tournament')
            THEN match_type::text::match_type
            ELSE 'quick'::match_type
        END
    """
    )
    op.drop_column("matches", "match_type")
    op.alter_column(
        "matches", "match_type_old", new_column_name="match_type", nullable=False
    )

    op.alter_column(
        "matches", "team_b_name", existing_type=sa.String(100), nullable=False
    )

    op.drop_column("matches", "min_players_per_team")
    op.drop_column("matches", "opponent_team_ready")
    op.drop_column("matches", "host_team_ready")
    op.drop_column("matches", "opponent_rules_approved")
    op.drop_column("matches", "host_rules_approved")
    op.drop_column("matches", "rules_proposed_by")
    op.drop_column("matches", "proposed_rules")
    op.drop_column("matches", "declined_at")
    op.drop_column("matches", "accepted_at")
    op.drop_column("matches", "invited_at")
    op.drop_column("matches", "invitation_message")
    op.drop_column("matches", "scorer_user_id")
    op.drop_index("ix_matches_opponent_captain_id", "matches")
    op.drop_column("matches", "opponent_captain_id")

    # Drop new enum types
    op.execute("DROP TYPE IF EXISTS match_type_v2")
    op.execute("DROP TYPE IF EXISTS match_status_v2")
    op.execute("DROP TYPE IF EXISTS player_role_v2")
