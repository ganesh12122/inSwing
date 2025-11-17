"""Comprehensive MySQL database schema for inSwing cricket scoring application.

Revision ID: 002_comprehensive_schema
Revises: 001_initial_schema
Create Date: 2025-11-15 12:00:00.000000

This migration creates a future-proof, scalable database schema with:
- Proper indexing and foreign key constraints
- Partitioning strategy for large tables
- Optimized data types and character sets
- Comprehensive cricket-specific business logic

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql
import uuid

# revision identifiers, used by Alembic.
revision = '002_comprehensive_schema'
down_revision = '001_initial_schema'
branch_labels = None
depends_on = None


def create_uuid_function():
    """Create a function to generate UUIDs for MySQL versions that don't support UUID natively."""
    op.execute("""
        CREATE FUNCTION IF NOT EXISTS generate_uuid() 
        RETURNS VARCHAR(36) 
        DETERMINISTIC
        RETURN LOWER(CONCAT(
            HEX(UNIX_TIMESTAMP(NOW(6)) * 1000000 + MICROSECOND(NOW(6))),
            '-',
            HEX(FLOOR(RAND() * 0xffff)),
            '-',
            HEX(FLOOR(RAND() * 0xffff)),
            '-',
            HEX(FLOOR(RAND() * 0xffff)),
            '-',
            HEX(FLOOR(RAND() * 0xffffff)),
            HEX(FLOOR(RAND() * 0xffffff))
        ))
    """)


def create_partition_functions():
    """Create functions for partition management."""
    # Function to get year from datetime
    op.execute("""
        CREATE FUNCTION IF NOT EXISTS get_year(dt DATETIME)
        RETURNS INT
        DETERMINISTIC
        RETURN YEAR(dt)
    """)
    
    # Function to get month from datetime
    op.execute("""
        CREATE FUNCTION IF NOT EXISTS get_month(dt DATETIME)
        RETURNS INT
        DETERMINISTIC
        RETURN MONTH(dt)
    """)


def create_users_table():
    """Create users table with proper indexing and constraints."""
    op.create_table(
        'users',
        sa.Column('id', mysql.CHAR(36), nullable=False, primary_key=True, 
                  comment='UUID primary key'),
        sa.Column('phone_number', mysql.VARCHAR(20), nullable=False, unique=True,
                  comment='Phone number in E.164 format'),
        sa.Column('email', mysql.VARCHAR(100), nullable=True, unique=True,
                  comment='Email address'),
        sa.Column('full_name', mysql.VARCHAR(100), nullable=False,
                  comment='User full name'),
        sa.Column('avatar_url', mysql.VARCHAR(500), nullable=True,
                  comment='Profile picture URL'),
        sa.Column('bio', mysql.TEXT(collation='utf8mb4_unicode_ci'), nullable=True,
                  comment='User biography'),
        sa.Column('role', mysql.ENUM('player', 'admin', collation='utf8mb4_unicode_ci'), 
                  nullable=False, server_default='player',
                  comment='User role in the system'),
        sa.Column('is_active', mysql.BOOLEAN(), nullable=False, server_default='true',
                  comment='Account active status'),
        sa.Column('is_verified', mysql.BOOLEAN(), nullable=False, server_default='false',
                  comment='Phone verification status'),
        sa.Column('created_at', mysql.TIMESTAMP(), nullable=False, 
                  server_default=sa.text('CURRENT_TIMESTAMP'),
                  comment='Record creation timestamp'),
        sa.Column('updated_at', mysql.TIMESTAMP(), nullable=False, 
                  server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'),
                  comment='Record update timestamp'),
        mysql_charset='utf8mb4',
        mysql_collate='utf8mb4_unicode_ci',
        mysql_engine='InnoDB'
    )
    
    # Create indexes
    op.create_index('idx_users_phone', 'users', ['phone_number'], unique=True)
    op.create_index('idx_users_email', 'users', ['email'], unique=True)
    op.create_index('idx_users_role_active', 'users', ['role', 'is_active'])
    op.create_index('idx_users_created_at', 'users', ['created_at'])


def create_profiles_table():
    """Create profiles table with cricket-specific statistics."""
    op.create_table(
        'profiles',
        sa.Column('id', mysql.CHAR(36), nullable=False, primary_key=True,
                  comment='UUID primary key'),
        sa.Column('user_id', mysql.CHAR(36), nullable=False, unique=True,
                  comment='Foreign key to users table'),
        sa.Column('batting_style', mysql.ENUM('right-handed', 'left-handed', collation='utf8mb4_unicode_ci'), 
                  nullable=True,
                  comment='Player batting style'),
        sa.Column('bowling_style', mysql.ENUM('fast', 'spin', 'pace', 'none', collation='utf8mb4_unicode_ci'), 
                  nullable=True,
                  comment='Player bowling style'),
        sa.Column('dominant_hand', mysql.ENUM('right', 'left', collation='utf8mb4_unicode_ci'), 
                  nullable=True,
                  comment='Player dominant hand'),
        sa.Column('total_matches', mysql.INT(), nullable=False, server_default='0',
                  comment='Total matches played'),
        sa.Column('total_runs', mysql.INT(), nullable=False, server_default='0',
                  comment='Total runs scored'),
        sa.Column('total_wickets', mysql.INT(), nullable=False, server_default='0',
                  comment='Total wickets taken'),
        sa.Column('average_runs', mysql.FLOAT(), nullable=False, server_default='0',
                  comment='Batting average'),
        sa.Column('strike_rate', mysql.FLOAT(), nullable=False, server_default='0',
                  comment='Batting strike rate'),
        sa.Column('economy_rate', mysql.FLOAT(), nullable=False, server_default='0',
                  comment='Bowling economy rate'),
        sa.Column('best_batting_score', mysql.INT(), nullable=False, server_default='0',
                  comment='Best batting score'),
        sa.Column('best_bowling_figures', mysql.VARCHAR(20), nullable=True,
                  comment='Best bowling figures (e.g., "4/25")'),
        sa.Column('fifties', mysql.INT(), nullable=False, server_default='0',
                  comment='Number of 50+ scores'),
        sa.Column('hundreds', mysql.INT(), nullable=False, server_default='0',
                  comment='Number of 100+ scores'),
        sa.Column('catches', mysql.INT(), nullable=False, server_default='0',
                  comment='Total catches taken'),
        sa.Column('stumpings', mysql.INT(), nullable=False, server_default='0',
                  comment='Total stumpings'),
        sa.Column('run_outs', mysql.INT(), nullable=False, server_default='0',
                  comment='Total run outs'),
        sa.Column('rating', mysql.FLOAT(), nullable=False, server_default='1200.0',
                  comment='Player ELO rating'),
        sa.Column('updated_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'),
                  comment='Profile update timestamp'),
        mysql_charset='utf8mb4',
        mysql_collate='utf8mb4_unicode_ci',
        mysql_engine='InnoDB'
    )
    
    # Create indexes and foreign key
    op.create_index('idx_profiles_user_id', 'profiles', ['user_id'], unique=True)
    op.create_index('idx_profiles_rating', 'profiles', ['rating'])
    op.create_index('idx_profiles_total_matches', 'profiles', ['total_matches'])
    op.create_foreign_key(
        'fk_profiles_user_id', 'profiles', 'users',
        ['user_id'], ['id'],
        ondelete='CASCADE'
    )


def create_matches_table():
    """Create matches table with partitioning strategy."""
    op.create_table(
        'matches',
        sa.Column('id', mysql.CHAR(36), nullable=False, primary_key=True,
                  comment='UUID primary key'),
        sa.Column('host_user_id', mysql.CHAR(36), nullable=False,
                  comment='Foreign key to users (match host)'),
        sa.Column('match_type', mysql.ENUM('quick', 'friendly', 'tournament', collation='utf8mb4_unicode_ci'), 
                  nullable=False, server_default='friendly',
                  comment='Type of match'),
        sa.Column('title', mysql.VARCHAR(200), nullable=False,
                  comment='Match title'),
        sa.Column('team_a_name', mysql.VARCHAR(100), nullable=False,
                  comment='Team A name'),
        sa.Column('team_b_name', mysql.VARCHAR(100), nullable=False,
                  comment='Team B name'),
        sa.Column('venue', mysql.TEXT(collation='utf8mb4_unicode_ci'), nullable=True,
                  comment='Match venue description'),
        sa.Column('latitude', mysql.FLOAT(), nullable=True,
                  comment='Venue latitude'),
        sa.Column('longitude', mysql.FLOAT(), nullable=True,
                  comment='Venue longitude'),
        sa.Column('scheduled_at', mysql.TIMESTAMP(), nullable=True,
                  comment='Scheduled match start time'),
        sa.Column('status', mysql.ENUM('created', 'toss_done', 'live', 'finished', 'cancelled', collation='utf8mb4_unicode_ci'), 
                  nullable=False, server_default='created',
                  comment='Match status'),
        sa.Column('toss_won_by', mysql.ENUM('A', 'B', collation='utf8mb4_unicode_ci'), nullable=True,
                  comment='Team that won the toss'),
        sa.Column('toss_decision', mysql.ENUM('bat', 'field', collation='utf8mb4_unicode_ci'), nullable=True,
                  comment='Toss decision (bat/field)'),
        sa.Column('overs_per_innings', mysql.INT(), nullable=False, server_default='20',
                  comment='Overs per innings'),
        sa.Column('max_players_per_team', mysql.INT(), nullable=False, server_default='11',
                  comment='Maximum players per team'),
        sa.Column('team_a_score', mysql.VARCHAR(50), nullable=True,
                  comment='Team A final score'),
        sa.Column('team_b_score', mysql.VARCHAR(50), nullable=True,
                  comment='Team B final score'),
        sa.Column('winner_team', mysql.ENUM('A', 'B', 'tie', collation='utf8mb4_unicode_ci'), nullable=True,
                  comment='Winning team'),
        sa.Column('result_description', mysql.TEXT(collation='utf8mb4_unicode_ci'), nullable=True,
                  comment='Match result description'),
        sa.Column('cancelled_reason', mysql.TEXT(collation='utf8mb4_unicode_ci'), nullable=True,
                  comment='Cancellation reason'),
        sa.Column('started_at', mysql.TIMESTAMP(), nullable=True,
                  comment='Actual match start time'),
        sa.Column('completed_at', mysql.TIMESTAMP(), nullable=True,
                  comment='Match completion time'),
        sa.Column('created_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP'),
                  comment='Record creation timestamp'),
        sa.Column('updated_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'),
                  comment='Record update timestamp'),
        sa.Column('year_created', mysql.INT(), nullable=False,
                  server_default=sa.text('YEAR(CURRENT_TIMESTAMP)'),
                  comment='Year of creation for partitioning'),
        mysql_charset='utf8mb4',
        mysql_collate='utf8mb4_unicode_ci',
        mysql_engine='InnoDB'
    )
    
    # Create indexes
    op.create_index('idx_matches_host_user_id', 'matches', ['host_user_id'])
    op.create_index('idx_matches_status', 'matches', ['status'])
    op.create_index('idx_matches_created_at', 'matches', ['created_at'])
    op.create_index('idx_matches_scheduled_at', 'matches', ['scheduled_at'])
    op.create_index('idx_matches_year_created', 'matches', ['year_created'])
    op.create_index('idx_matches_type_status', 'matches', ['match_type', 'status'])
    
    # Create foreign key
    op.create_foreign_key(
        'fk_matches_host_user_id', 'matches', 'users',
        ['host_user_id'], ['id'],
        ondelete='RESTRICT'
    )


def create_players_in_match_table():
    """Create players_in_match junction table."""
    op.create_table(
        'players_in_match',
        sa.Column('id', mysql.CHAR(36), nullable=False, primary_key=True,
                  comment='UUID primary key'),
        sa.Column('match_id', mysql.CHAR(36), nullable=False,
                  comment='Foreign key to matches'),
        sa.Column('user_id', mysql.CHAR(36), nullable=False,
                  comment='Foreign key to users'),
        sa.Column('team', mysql.ENUM('A', 'B', collation='utf8mb4_unicode_ci'), nullable=False,
                  comment='Team assignment'),
        sa.Column('role', mysql.ENUM('batsman', 'bowler', 'allrounder', 'wicketkeeper', collation='utf8mb4_unicode_ci'), 
                  nullable=False, server_default='allrounder',
                  comment='Player role in match'),
        sa.Column('batting_position', mysql.INT(), nullable=True,
                  comment='Batting order position'),
        sa.Column('is_captain', mysql.BOOLEAN(), nullable=False, server_default='false',
                  comment='Team captain flag'),
        sa.Column('is_wicket_keeper', mysql.BOOLEAN(), nullable=False, server_default='false',
                  comment='Wicket keeper flag'),
        sa.Column('batting_runs', mysql.INT(), nullable=False, server_default='0',
                  comment='Runs scored in this match'),
        sa.Column('balls_faced', mysql.INT(), nullable=False, server_default='0',
                  comment='Balls faced in this match'),
        sa.Column('fours_hit', mysql.INT(), nullable=False, server_default='0',
                  comment='Fours hit in this match'),
        sa.Column('sixes_hit', mysql.INT(), nullable=False, server_default='0',
                  comment='Sixes hit in this match'),
        sa.Column('bowling_overs', mysql.FLOAT(), nullable=False, server_default='0',
                  comment='Overs bowled in this match'),
        sa.Column('bowling_runs', mysql.INT(), nullable=False, server_default='0',
                  comment='Runs conceded while bowling'),
        sa.Column('bowling_wickets', mysql.INT(), nullable=False, server_default='0',
                  comment='Wickets taken in this match'),
        sa.Column('bowling_maidens', mysql.INT(), nullable=False, server_default='0',
                  comment='Maiden overs bowled'),
        sa.Column('fielding_catches', mysql.INT(), nullable=False, server_default='0',
                  comment='Catches taken in this match'),
        sa.Column('fielding_stumpings', mysql.INT(), nullable=False, server_default='0',
                  comment='Stumpings in this match'),
        sa.Column('fielding_run_outs', mysql.INT(), nullable=False, server_default='0',
                  comment='Run outs in this match'),
        sa.Column('joined_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP'),
                  comment='Player join timestamp'),
        sa.Column('updated_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'),
                  comment='Record update timestamp'),
        mysql_charset='utf8mb4',
        mysql_collate='utf8mb4_unicode_ci',
        mysql_engine='InnoDB'
    )
    
    # Create indexes and constraints
    op.create_index('idx_players_in_match_match_id', 'players_in_match', ['match_id'])
    op.create_index('idx_players_in_match_user_id', 'players_in_match', ['user_id'])
    op.create_index('idx_players_in_match_team', 'players_in_match', ['team'])
    op.create_index('idx_players_in_match_role', 'players_in_match', ['role'])
    op.create_unique_constraint(
        'uq_players_in_match_match_user', 'players_in_match',
        ['match_id', 'user_id']
    )
    
    # Create foreign keys
    op.create_foreign_key(
        'fk_players_in_match_match_id', 'players_in_match', 'matches',
        ['match_id'], ['id'],
        ondelete='CASCADE'
    )
    op.create_foreign_key(
        'fk_players_in_match_user_id', 'players_in_match', 'users',
        ['user_id'], ['id'],
        ondelete='CASCADE'
    )


def create_innings_table():
    """Create innings table."""
    op.create_table(
        'innings',
        sa.Column('id', mysql.CHAR(36), nullable=False, primary_key=True,
                  comment='UUID primary key'),
        sa.Column('match_id', mysql.CHAR(36), nullable=False,
                  comment='Foreign key to matches'),
        sa.Column('innings_number', mysql.INT(), nullable=False, server_default='1',
                  comment='Innings number (1 or 2)'),
        sa.Column('batting_team', mysql.ENUM('A', 'B', collation='utf8mb4_unicode_ci'), nullable=False,
                  comment='Team batting in this innings'),
        sa.Column('overs_allocated', mysql.INT(), nullable=False,
                  comment='Total overs allocated for this innings'),
        sa.Column('runs', mysql.INT(), nullable=False, server_default='0',
                  comment='Total runs scored'),
        sa.Column('wickets', mysql.INT(), nullable=False, server_default='0',
                  comment='Total wickets lost'),
        sa.Column('extras', mysql.INT(), nullable=False, server_default='0',
                  comment='Total extras conceded'),
        sa.Column('overs_bowled', mysql.FLOAT(), nullable=False, server_default='0',
                  comment='Overs bowled so far'),
        sa.Column('is_completed', mysql.BOOLEAN(), nullable=False, server_default='false',
                  comment='Innings completion status'),
        sa.Column('completed_at', mysql.TIMESTAMP(), nullable=True,
                  comment='Innings completion timestamp'),
        sa.Column('created_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP'),
                  comment='Record creation timestamp'),
        sa.Column('updated_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'),
                  comment='Record update timestamp'),
        mysql_charset='utf8mb4',
        mysql_collate='utf8mb4_unicode_ci',
        mysql_engine='InnoDB'
    )
    
    # Create indexes
    op.create_index('idx_innings_match_id', 'innings', ['match_id'])
    op.create_index('idx_innings_batting_team', 'innings', ['batting_team'])
    op.create_index('idx_innings_is_completed', 'innings', ['is_completed'])
    op.create_unique_constraint(
        'uq_innings_match_innings_number', 'innings',
        ['match_id', 'innings_number']
    )
    
    # Create foreign key
    op.create_foreign_key(
        'fk_innings_match_id', 'innings', 'matches',
        ['match_id'], ['id'],
        ondelete='CASCADE'
    )


def create_balls_table():
    """Create balls table with partitioning strategy."""
    op.create_table(
        'balls',
        sa.Column('id', mysql.CHAR(36), nullable=False, primary_key=True,
                  comment='UUID primary key'),
        sa.Column('innings_id', mysql.CHAR(36), nullable=False,
                  comment='Foreign key to innings'),
        sa.Column('over_number', mysql.INT(), nullable=False,
                  comment='Over number (starts from 1)'),
        sa.Column('ball_in_over', mysql.INT(), nullable=False,
                  comment='Ball number in over (1-6)'),
        sa.Column('batsman_id', mysql.CHAR(36), nullable=True,
                  comment='Foreign key to users (batsman)'),
        sa.Column('non_striker_id', mysql.CHAR(36), nullable=True,
                  comment='Foreign key to users (non-striker)'),
        sa.Column('bowler_id', mysql.CHAR(36), nullable=True,
                  comment='Foreign key to users (bowler)'),
        sa.Column('runs_off_bat', mysql.INT(), nullable=False, server_default='0',
                  comment='Runs scored off the bat'),
        sa.Column('extras_type', mysql.ENUM('wide', 'no_ball', 'bye', 'leg_bye', collation='utf8mb4_unicode_ci'), 
                  nullable=True,
                  comment='Type of extra'),
        sa.Column('extras_runs', mysql.INT(), nullable=False, server_default='0',
                  comment='Extra runs conceded'),
        sa.Column('wicket_type', mysql.ENUM('bowled', 'caught', 'lbw', 'run_out', 'stumped', 'hit_wicket', 'retired_hurt', 
                                            collation='utf8mb4_unicode_ci'), nullable=True,
                  comment='Type of wicket'),
        sa.Column('dismissal_info', mysql.JSON(), nullable=True,
                  comment='Detailed dismissal information'),
        sa.Column('is_legal_delivery', mysql.BOOLEAN(), nullable=False, server_default='true',
                  comment='Whether this was a legal delivery'),
        sa.Column('client_event_id', mysql.VARCHAR(100), nullable=True,
                  comment='Client event ID for idempotency'),
        sa.Column('ball_metadata', mysql.JSON(), nullable=True,
                  comment='Additional ball metadata'),
        sa.Column('created_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP'),
                  comment='Record creation timestamp'),
        sa.Column('updated_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'),
                  comment='Record update timestamp'),
        sa.Column('month_created', mysql.INT(), nullable=False,
                  server_default=sa.text('MONTH(CURRENT_TIMESTAMP)'),
                  comment='Month of creation for partitioning'),
        mysql_charset='utf8mb4',
        mysql_collate='utf8mb4_unicode_ci',
        mysql_engine='InnoDB'
    )
    
    # Create indexes
    op.create_index('idx_balls_innings_id', 'balls', ['innings_id'])
    op.create_index('idx_balls_over_ball', 'balls', ['over_number', 'ball_in_over'])
    op.create_index('idx_balls_batsman', 'balls', ['batsman_id'])
    op.create_index('idx_balls_bowler', 'balls', ['bowler_id'])
    op.create_index('idx_balls_created_at', 'balls', ['created_at'])
    op.create_index('idx_balls_month_created', 'balls', ['month_created'])
    op.create_index('idx_balls_client_event_id', 'balls', ['client_event_id'])
    
    # Create foreign keys
    op.create_foreign_key(
        'fk_balls_innings_id', 'balls', 'innings',
        ['innings_id'], ['id'],
        ondelete='CASCADE'
    )
    op.create_foreign_key(
        'fk_balls_batsman_id', 'balls', 'users',
        ['batsman_id'], ['id'],
        ondelete='RESTRICT'
    )
    op.create_foreign_key(
        'fk_balls_non_striker_id', 'balls', 'users',
        ['non_striker_id'], ['id'],
        ondelete='RESTRICT'
    )
    op.create_foreign_key(
        'fk_balls_bowler_id', 'balls', 'users',
        ['bowler_id'], ['id'],
        ondelete='RESTRICT'
    )


def create_match_events_table():
    """Create match_events table for tracking match history."""
    op.create_table(
        'match_events',
        sa.Column('id', mysql.CHAR(36), nullable=False, primary_key=True,
                  comment='UUID primary key'),
        sa.Column('match_id', mysql.CHAR(36), nullable=False,
                  comment='Foreign key to matches'),
        sa.Column('event_type', mysql.ENUM('boundary', 'wicket', 'milestone', 'highlight', 'comment', 
                                            collation='utf8mb4_unicode_ci'), nullable=False,
                  comment='Type of match event'),
        sa.Column('meta', mysql.JSON(), nullable=True,
                  comment='Event metadata'),
        sa.Column('created_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP'),
                  comment='Event creation timestamp'),
        mysql_charset='utf8mb4',
        mysql_collate='utf8mb4_unicode_ci',
        mysql_engine='InnoDB'
    )
    
    # Create indexes
    op.create_index('idx_match_events_match_id', 'match_events', ['match_id'])
    op.create_index('idx_match_events_event_type', 'match_events', ['event_type'])
    op.create_index('idx_match_events_created_at', 'match_events', ['created_at'])
    
    # Create foreign key
    op.create_foreign_key(
        'fk_match_events_match_id', 'match_events', 'matches',
        ['match_id'], ['id'],
        ondelete='CASCADE'
    )


def create_notifications_table():
    """Create notifications table for user notifications."""
    op.create_table(
        'notifications',
        sa.Column('id', mysql.CHAR(36), nullable=False, primary_key=True,
                  comment='UUID primary key'),
        sa.Column('user_id', mysql.CHAR(36), nullable=False,
                  comment='Foreign key to users'),
        sa.Column('notification_type', mysql.ENUM('match_start', 'wicket', 'milestone', 'mentioned', 'comment', 'system', 
                                                 collation='utf8mb4_unicode_ci'), nullable=False,
                  comment='Type of notification'),
        sa.Column('payload', mysql.JSON(), nullable=True,
                  comment='Notification payload data'),
        sa.Column('read_at', mysql.TIMESTAMP(), nullable=True,
                  comment='Notification read timestamp'),
        sa.Column('created_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP'),
                  comment='Notification creation timestamp'),
        mysql_charset='utf8mb4',
        mysql_collate='utf8mb4_unicode_ci',
        mysql_engine='InnoDB'
    )
    
    # Create indexes
    op.create_index('idx_notifications_user_id', 'notifications', ['user_id'])
    op.create_index('idx_notifications_read_at', 'notifications', ['read_at'])
    op.create_index('idx_notifications_created_at', 'notifications', ['created_at'])
    op.create_index('idx_notifications_type', 'notifications', ['notification_type'])
    
    # Create foreign key
    op.create_foreign_key(
        'fk_notifications_user_id', 'notifications', 'users',
        ['user_id'], ['id'],
        ondelete='CASCADE'
    )


def create_otp_sessions_table():
    """Create otp_sessions table for OTP verification."""
    op.create_table(
        'otp_sessions',
        sa.Column('id', mysql.CHAR(36), nullable=False, primary_key=True,
                  comment='UUID primary key'),
        sa.Column('phone_number', mysql.VARCHAR(20), nullable=False,
                  comment='Phone number for OTP'),
        sa.Column('otp_code', mysql.VARCHAR(6), nullable=False,
                  comment='OTP code'),
        sa.Column('attempts', mysql.INT(), nullable=False, server_default='0',
                  comment='Number of verification attempts'),
        sa.Column('expires_at', mysql.TIMESTAMP(), nullable=False,
                  comment='OTP expiration timestamp'),
        sa.Column('created_at', mysql.TIMESTAMP(), nullable=False,
                  server_default=sa.text('CURRENT_TIMESTAMP'),
                  comment='Session creation timestamp'),
        mysql_charset='utf8mb4',
        mysql_collate='utf8mb4_unicode_ci',
        mysql_engine='InnoDB'
    )
    
    # Create indexes
    op.create_index('idx_otp_sessions_phone_number', 'otp_sessions', ['phone_number'])
    op.create_index('idx_otp_sessions_expires_at', 'otp_sessions', ['expires_at'])


def create_partitioning_strategy():
    """Create partitioning for large tables."""
    
    # Create partitions for matches table (by year)
    op.execute("""
        ALTER TABLE matches 
        PARTITION BY RANGE (year_created) (
            PARTITION p_2024 VALUES LESS THAN (2025),
            PARTITION p_2025 VALUES LESS THAN (2026),
            PARTITION p_2026 VALUES LESS THAN (2027),
            PARTITION p_2027 VALUES LESS THAN (2028),
            PARTITION p_future VALUES LESS THAN MAXVALUE
        )
    """)
    
    # Create partitions for balls table (by month)
    op.execute("""
        ALTER TABLE balls 
        PARTITION BY RANGE (month_created) (
            PARTITION p_jan VALUES LESS THAN (2),
            PARTITION p_feb VALUES LESS THAN (3),
            PARTITION p_mar VALUES LESS THAN (4),
            PARTITION p_apr VALUES LESS THAN (5),
            PARTITION p_may VALUES LESS THAN (6),
            PARTITION p_jun VALUES LESS THAN (7),
            PARTITION p_jul VALUES LESS THAN (8),
            PARTITION p_aug VALUES LESS THAN (9),
            PARTITION p_sep VALUES LESS THAN (10),
            PARTITION p_oct VALUES LESS THAN (11),
            PARTITION p_nov VALUES LESS THAN (12),
            PARTITION p_dec VALUES LESS THAN (13),
            PARTITION p_future VALUES LESS THAN MAXVALUE
        )
    """)


def create_performance_indexes():
    """Create additional performance indexes."""
    
    # Composite indexes for common queries
    op.create_index('idx_matches_status_created', 'matches', ['status', 'created_at'])
    op.create_index('idx_matches_type_scheduled', 'matches', ['match_type', 'scheduled_at'])
    op.create_index('idx_players_in_match_match_team', 'players_in_match', ['match_id', 'team'])
    op.create_index('idx_innings_match_completed', 'innings', ['match_id', 'is_completed'])
    op.create_index('idx_balls_innings_over', 'balls', ['innings_id', 'over_number', 'ball_in_over'])
    op.create_index('idx_notifications_user_unread', 'notifications', ['user_id', 'read_at'])
    
    # Full-text search indexes
    op.execute("ALTER TABLE users ADD FULLTEXT idx_users_fulltext (full_name, bio)")
    op.execute("ALTER TABLE matches ADD FULLTEXT idx_matches_fulltext (title, venue, team_a_name, team_b_name)")


def create_triggers():
    """Create database triggers for automatic updates."""
    
    # Trigger to update player statistics after match completion
    op.execute("""
        CREATE TRIGGER trg_update_player_stats_after_match
        AFTER UPDATE ON matches
        FOR EACH ROW
        BEGIN
            IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
                -- Update player statistics (simplified version)
                UPDATE profiles p
                INNER JOIN (
                    SELECT user_id, 
                           SUM(batting_runs) as total_runs,
                           SUM(bowling_wickets) as total_wickets,
                           COUNT(*) as matches_played
                    FROM players_in_match 
                    WHERE match_id = NEW.id
                    GROUP BY user_id
                ) pm ON p.user_id = pm.user_id
                SET p.total_matches = p.total_matches + 1,
                    p.total_runs = p.total_runs + COALESCE(pm.total_runs, 0),
                    p.total_wickets = p.total_wickets + COALESCE(pm.total_wickets, 0);
            END IF;
        END
    """)


def upgrade() -> None:
    """Apply all database changes."""
    try:
        # Create utility functions
        create_uuid_function()
        create_partition_functions()
        
        # Create tables in dependency order
        create_users_table()
        create_profiles_table()
        create_matches_table()
        create_players_in_match_table()
        create_innings_table()
        create_balls_table()
        create_match_events_table()
        create_notifications_table()
        create_otp_sessions_table()
        
        # Apply partitioning strategy
        create_partitioning_strategy()
        
        # Create performance optimizations
        create_performance_indexes()
        
        # Create triggers
        create_triggers()
        
        print("✅ Comprehensive database schema created successfully!")
        
    except Exception as e:
        print(f"❌ Error creating comprehensive schema: {e}")
        raise


def downgrade() -> None:
    """Revert all database changes."""
    try:
        # Drop triggers
        op.execute("DROP TRIGGER IF EXISTS trg_update_player_stats_after_match")
        
        # Drop tables in reverse order (respect foreign key constraints)
        op.drop_table('otp_sessions')
        op.drop_table('notifications')
        op.drop_table('match_events')
        op.drop_table('balls')
        op.drop_table('innings')
        op.drop_table('players_in_match')
        op.drop_table('matches')
        op.drop_table('profiles')
        op.drop_table('users')
        
        # Drop utility functions
        op.execute("DROP FUNCTION IF EXISTS generate_uuid")
        op.execute("DROP FUNCTION IF EXISTS get_year")
        op.execute("DROP FUNCTION IF EXISTS get_month")
        
        print("✅ Comprehensive database schema dropped successfully!")
        
    except Exception as e:
        print(f"❌ Error dropping comprehensive schema: {e}")
        raise