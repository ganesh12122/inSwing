"""Add toss_recorded_by column and toss_proposed status

Revision ID: 006_toss_approval_flow
Revises: 005_user_auth_schema_sync
Create Date: 2026-04-30
"""

from alembic import op
import sqlalchemy as sa

revision = "006_toss_approval_flow"
down_revision = "005_user_auth_schema_sync"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Add toss_recorded_by column
    op.add_column(
        "matches", sa.Column("toss_recorded_by", sa.String(36), nullable=True)
    )

    # The status enum uses native_enum=False (VARCHAR), so no ALTER TYPE needed.
    # The "toss_proposed" value is just a string stored in the column.


def downgrade() -> None:
    op.drop_column("matches", "toss_recorded_by")
