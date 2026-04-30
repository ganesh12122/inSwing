"""Change balls FK from users to players_in_match

Revision ID: 007_balls_fk_to_players_in_match
Revises: 006_toss_approval_flow
Create Date: 2026-04-30
"""

from alembic import op

revision = "007_balls_fk_to_players_in_match"
down_revision = "006_toss_approval_flow"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Drop existing FK constraints referencing users
    op.drop_constraint("balls_batsman_id_fkey", "balls", type_="foreignkey")
    op.drop_constraint("balls_non_striker_id_fkey", "balls", type_="foreignkey")
    op.drop_constraint("balls_bowler_id_fkey", "balls", type_="foreignkey")

    # Create new FK constraints referencing players_in_match
    op.create_foreign_key(
        "balls_batsman_id_fkey",
        "balls",
        "players_in_match",
        ["batsman_id"],
        ["id"],
        ondelete="SET NULL",
    )
    op.create_foreign_key(
        "balls_non_striker_id_fkey",
        "balls",
        "players_in_match",
        ["non_striker_id"],
        ["id"],
        ondelete="SET NULL",
    )
    op.create_foreign_key(
        "balls_bowler_id_fkey",
        "balls",
        "players_in_match",
        ["bowler_id"],
        ["id"],
        ondelete="SET NULL",
    )


def downgrade() -> None:
    op.drop_constraint("balls_batsman_id_fkey", "balls", type_="foreignkey")
    op.drop_constraint("balls_non_striker_id_fkey", "balls", type_="foreignkey")
    op.drop_constraint("balls_bowler_id_fkey", "balls", type_="foreignkey")

    op.create_foreign_key(
        "balls_batsman_id_fkey",
        "balls",
        "users",
        ["batsman_id"],
        ["id"],
        ondelete="SET NULL",
    )
    op.create_foreign_key(
        "balls_non_striker_id_fkey",
        "balls",
        "users",
        ["non_striker_id"],
        ["id"],
        ondelete="SET NULL",
    )
    op.create_foreign_key(
        "balls_bowler_id_fkey",
        "balls",
        "users",
        ["bowler_id"],
        ["id"],
        ondelete="SET NULL",
    )
