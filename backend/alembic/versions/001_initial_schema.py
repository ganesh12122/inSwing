"""Initial database schema for inSwing cricket scoring application.

Revision ID: 001_initial_schema
Revises: 
Create Date: 2024-01-01 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = '001_initial_schema'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Create users table
    op.create_table(
        'users',
        sa.Column('id', mysql.VARCHAR(length=36), nullable=False, primary_key=True),
        sa.Column('phone', mysql.VARCHAR(length=20), nullable=False, unique=True),
        sa.Column('name', mysql.VARCHAR(length=100), nullable=False),
        sa.Column('email', mysql.VARCHAR(length=255), nullable=True, unique=True),
        sa.Column('role', mysql.ENUM('player', 'host', 'admin'), nullable=False, server_default='player'),
        sa.Column('rating', mysql.FLOAT(), nullable=False, server_default='1000.0'),
        sa.Column('total_matches_played', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('matches_won', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('matches_lost', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('profile_picture_url', mysql.VARCHAR(length=500), nullable=True),
        sa.Column('bio', mysql.TEXT(), nullable=True),
        sa.Column('location', mysql.VARCHAR(length=100), nullable=True),
        sa.Column('preferred_position', mysql.VARCHAR(length=50), nullable=True),
        sa.Column('batting_style', mysql.VARCHAR(length=50), nullable=True),
        sa.Column('bowling_style', mysql.VARCHAR(length=50), nullable=True),
        sa.Column('is_active', mysql.BOOLEAN(), nullable=False, server_default='true'),
        sa.Column('is_verified', mysql.BOOLEAN(), nullable=False, server_default='false'),
        sa.Column('created_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.Column('updated_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'))
    )
    
    # Create otp_sessions table
    op.create_table(
        'otp_sessions',
        sa.Column('id', mysql.VARCHAR(length=36), nullable=False, primary_key=True),
        sa.Column('phone', mysql.VARCHAR(length=20), nullable=False),
        sa.Column('otp_code', mysql.VARCHAR(length=6), nullable=False),
        sa.Column('attempts', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('max_attempts', mysql.INTEGER(), nullable=False, server_default='3'),
        sa.Column('expires_at', mysql.DATETIME(), nullable=False),
        sa.Column('is_verified', mysql.BOOLEAN(), nullable=False, server_default='false'),
        sa.Column('created_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP'))
    )
    
    op.create_index('ix_otp_sessions_phone', 'otp_sessions', ['phone'])
    op.create_index('ix_otp_sessions_expires_at', 'otp_sessions', ['expires_at'])
    
    # Create matches table
    op.create_table(
        'matches',
        sa.Column('id', mysql.VARCHAR(length=36), nullable=False, primary_key=True),
        sa.Column('title', mysql.VARCHAR(length=200), nullable=False),
        sa.Column('description', mysql.TEXT(), nullable=True),
        sa.Column('host_user_id', mysql.VARCHAR(length=36), nullable=False),
        sa.Column('location', mysql.VARCHAR(length=200), nullable=True),
        sa.Column('start_time', mysql.DATETIME(), nullable=True),
        sa.Column('team_a_name', mysql.VARCHAR(length=100), nullable=False),
        sa.Column('team_b_name', mysql.VARCHAR(length=100), nullable=False),
        sa.Column('overs_per_innings', mysql.INTEGER(), nullable=False, server_default='20'),
        sa.Column('max_players_per_team', mysql.INTEGER(), nullable=False, server_default='11'),
        sa.Column('toss_won_by', mysql.ENUM('A', 'B'), nullable=True),
        sa.Column('toss_choice', mysql.ENUM('bat', 'field'), nullable=True),
        sa.Column('status', mysql.ENUM('scheduled', 'toss_done', 'live', 'completed', 'cancelled'), nullable=False, server_default='scheduled'),
        sa.Column('team_a_score', mysql.VARCHAR(length=20), nullable=True),
        sa.Column('team_b_score', mysql.VARCHAR(length=20), nullable=True),
        sa.Column('result', mysql.TEXT(), nullable=True),
        sa.Column('winner_team', mysql.ENUM('A', 'B', 'tie'), nullable=True),
        sa.Column('cancelled_reason', mysql.TEXT(), nullable=True),
        sa.Column('started_at', mysql.DATETIME(), nullable=True),
        sa.Column('completed_at', mysql.DATETIME(), nullable=True),
        sa.Column('created_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.Column('updated_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'))
    )
    
    op.create_index('ix_matches_host_user_id', 'matches', ['host_user_id'])
    op.create_index('ix_matches_status', 'matches', ['status'])
    op.create_index('ix_matches_start_time', 'matches', ['start_time'])
    op.create_foreign_key('fk_matches_host_user', 'matches', 'users', ['host_user_id'], ['id'])
    
    # Create players_in_match table
    op.create_table(
        'players_in_match',
        sa.Column('id', mysql.VARCHAR(length=36), nullable=False, primary_key=True),
        sa.Column('match_id', mysql.VARCHAR(length=36), nullable=False),
        sa.Column('user_id', mysql.VARCHAR(length=36), nullable=False),
        sa.Column('team', mysql.ENUM('A', 'B'), nullable=False),
        sa.Column('batting_position', mysql.INTEGER(), nullable=True),
        sa.Column('is_captain', mysql.BOOLEAN(), nullable=False, server_default='false'),
        sa.Column('is_wicket_keeper', mysql.BOOLEAN(), nullable=False, server_default='false'),
        sa.Column('batting_runs', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('balls_faced', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('fours_hit', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('sixes_hit', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('bowling_overs', mysql.FLOAT(), nullable=False, server_default='0'),
        sa.Column('bowling_runs', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('bowling_wickets', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('bowling_maidens', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('fielding_catches', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('fielding_stumpings', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('fielding_run_outs', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('created_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.Column('updated_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'))
    )
    
    op.create_index('ix_players_in_match_match_id', 'players_in_match', ['match_id'])
    op.create_index('ix_players_in_match_user_id', 'players_in_match', ['user_id'])
    op.create_unique_constraint('uq_players_in_match_match_user', 'players_in_match', ['match_id', 'user_id'])
    op.create_foreign_key('fk_players_in_match_match', 'players_in_match', 'matches', ['match_id'], ['id'])
    op.create_foreign_key('fk_players_in_match_user', 'players_in_match', 'users', ['user_id'], ['id'])
    
    # Create innings table
    op.create_table(
        'innings',
        sa.Column('id', mysql.VARCHAR(length=36), nullable=False, primary_key=True),
        sa.Column('match_id', mysql.VARCHAR(length=36), nullable=False),
        sa.Column('innings_number', mysql.INTEGER(), nullable=False, server_default='1'),
        sa.Column('batting_team', mysql.ENUM('A', 'B'), nullable=False),
        sa.Column('overs_allocated', mysql.INTEGER(), nullable=False),
        sa.Column('runs', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('wickets', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('extras', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('overs_bowled', mysql.FLOAT(), nullable=False, server_default='0'),
        sa.Column('is_completed', mysql.BOOLEAN(), nullable=False, server_default='false'),
        sa.Column('completed_at', mysql.DATETIME(), nullable=True),
        sa.Column('created_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.Column('updated_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'))
    )
    
    op.create_index('ix_innings_match_id', 'innings', ['match_id'])
    op.create_unique_constraint('uq_innings_match_number', 'innings', ['match_id', 'innings_number'])
    op.create_foreign_key('fk_innings_match', 'innings', 'matches', ['match_id'], ['id'])
    
    # Create balls table
    op.create_table(
        'balls',
        sa.Column('id', mysql.VARCHAR(length=36), nullable=False, primary_key=True),
        sa.Column('innings_id', mysql.VARCHAR(length=36), nullable=False),
        sa.Column('over_number', mysql.INTEGER(), nullable=False),
        sa.Column('ball_in_over', mysql.INTEGER(), nullable=False),
        sa.Column('batsman_id', mysql.VARCHAR(length=36), nullable=True),
        sa.Column('non_striker_id', mysql.VARCHAR(length=36), nullable=True),
        sa.Column('bowler_id', mysql.VARCHAR(length=36), nullable=True),
        sa.Column('runs_off_bat', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('extras_type', mysql.ENUM('wide', 'no_ball', 'bye', 'leg_bye'), nullable=True),
        sa.Column('extras_runs', mysql.INTEGER(), nullable=False, server_default='0'),
        sa.Column('wicket_type', mysql.ENUM('bowled', 'caught', 'lbw', 'run_out', 'stumped', 'hit_wicket', 'retired_hurt'), nullable=True),
        sa.Column('dismissal_info', mysql.JSON(), nullable=True),
        sa.Column('is_legal_delivery', mysql.BOOLEAN(), nullable=False, server_default='true'),
        sa.Column('client_event_id', mysql.VARCHAR(length=100), nullable=True),
        sa.Column('metadata', mysql.JSON(), nullable=True),
        sa.Column('created_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.Column('updated_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'))
    )
    
    op.create_index('ix_balls_innings_id', 'balls', ['innings_id'])
    op.create_index('ix_balls_client_event_id', 'balls', ['client_event_id'])
    op.create_index('ix_balls_created_at', 'balls', ['created_at'])
    op.create_foreign_key('fk_balls_innings', 'balls', 'innings', ['innings_id'], ['id'])
    op.create_foreign_key('fk_balls_batsman', 'balls', 'users', ['batsman_id'], ['id'])
    op.create_foreign_key('fk_balls_non_striker', 'balls', 'users', ['non_striker_id'], ['id'])
    op.create_foreign_key('fk_balls_bowler', 'balls', 'users', ['bowler_id'], ['id'])
    
    # Create match_events table
    op.create_table(
        'match_events',
        sa.Column('id', mysql.VARCHAR(length=36), nullable=False, primary_key=True),
        sa.Column('match_id', mysql.VARCHAR(length=36), nullable=False),
        sa.Column('event_type', mysql.ENUM('match_created', 'player_joined', 'player_left', 'toss_completed', 'innings_started', 'innings_completed', 'match_completed', 'match_cancelled'), nullable=False),
        sa.Column('event_data', mysql.JSON(), nullable=True),
        sa.Column('created_by', mysql.VARCHAR(length=36), nullable=True),
        sa.Column('created_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP'))
    )
    
    op.create_index('ix_match_events_match_id', 'match_events', ['match_id'])
    op.create_index('ix_match_events_event_type', 'match_events', ['event_type'])
    op.create_index('ix_match_events_created_at', 'match_events', ['created_at'])
    op.create_foreign_key('fk_match_events_match', 'match_events', 'matches', ['match_id'], ['id'])
    op.create_foreign_key('fk_match_events_user', 'match_events', 'users', ['created_by'], ['id'])
    
    # Create notifications table
    op.create_table(
        'notifications',
        sa.Column('id', mysql.VARCHAR(length=36), nullable=False, primary_key=True),
        sa.Column('user_id', mysql.VARCHAR(length=36), nullable=False),
        sa.Column('title', mysql.VARCHAR(length=200), nullable=False),
        sa.Column('message', mysql.TEXT(), nullable=False),
        sa.Column('type', mysql.ENUM('match_invitation', 'match_update', 'match_reminder', 'system', 'achievement'), nullable=False),
        sa.Column('data', mysql.JSON(), nullable=True),
        sa.Column('priority', mysql.ENUM('low', 'medium', 'high'), nullable=False, server_default='medium'),
        sa.Column('status', mysql.ENUM('unread', 'read'), nullable=False, server_default='unread'),
        sa.Column('read_at', mysql.DATETIME(), nullable=True),
        sa.Column('expires_at', mysql.DATETIME(), nullable=True),
        sa.Column('created_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.Column('updated_at', mysql.DATETIME(), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'))
    )
    
    op.create_index('ix_notifications_user_id', 'notifications', ['user_id'])
    op.create_index('ix_notifications_status', 'notifications', ['status'])
    op.create_index('ix_notifications_type', 'notifications', ['type'])
    op.create_index('ix_notifications_created_at', 'notifications', ['created_at'])
    op.create_index('ix_notifications_expires_at', 'notifications', ['expires_at'])
    op.create_foreign_key('fk_notifications_user', 'notifications', 'users', ['user_id'], ['id'])


def downgrade() -> None:
    # Drop tables in reverse order to respect foreign key constraints
    op.drop_table('notifications')
    op.drop_table('match_events')
    op.drop_table('balls')
    op.drop_table('innings')
    op.drop_table('players_in_match')
    op.drop_table('matches')
    op.drop_table('otp_sessions')
    op.drop_table('users')