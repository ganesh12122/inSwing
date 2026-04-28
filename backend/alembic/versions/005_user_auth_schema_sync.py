"""Align users table with auth model.

Revision ID: 005_user_auth_schema_sync
Revises: 004_dual_captain
Create Date: 2026-04-28 00:00:00.000000

"""

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision = "005_user_auth_schema_sync"
down_revision = "004_dual_captain"
branch_labels = None
depends_on = None


def upgrade() -> None:
    """Bring the PostgreSQL users table in sync with the ORM auth fields."""

    op.add_column("users", sa.Column("password_hash", sa.String(255), nullable=True))
    op.alter_column(
        "users",
        "phone_number",
        existing_type=sa.String(length=15),
        nullable=True,
    )


def downgrade() -> None:
    """Revert users table auth schema sync."""

    op.alter_column(
        "users",
        "phone_number",
        existing_type=sa.String(length=15),
        nullable=False,
    )
    op.drop_column("users", "password_hash")
