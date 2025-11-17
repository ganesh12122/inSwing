# inSwing Database Schema

## Database Design Overview

This schema implements a complete cricket scoring system with real-time updates, offline support, and comprehensive statistics tracking.

## Core Tables

### 1. users
```sql
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    avatar_url VARCHAR(500),
    bio TEXT,
    role ENUM('player', 'admin') DEFAULT 'player',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_phone_number (phone_number),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_created_at (created_at)
);
```

### 2. profiles (Player Statistics)
```sql
CREATE TABLE profiles (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) UNIQUE NOT NULL,
    batting_style ENUM('right-handed', 'left-handed'),
    bowling_style ENUM('fast', 'spin', 'pace', 'none'),
    dominant_hand ENUM('right', 'left'),
    total_matches INT DEFAULT 0,
    total_runs INT DEFAULT 0,
    total_wickets INT DEFAULT 0,
    total_balls_faced INT DEFAULT 0,
    total_balls_bowled INT DEFAULT 0,
    total_runs_conceded INT DEFAULT 0,
    average_runs FLOAT DEFAULT 0.0,
    strike_rate FLOAT DEFAULT 0.0,
    economy_rate FLOAT DEFAULT 0.0,
    highest_score INT DEFAULT 0,
    best_bowling VARCHAR(10),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_batting_style (batting_style),
    INDEX idx_bowling_style (bowling_style)
);
```

### 3. matches
```sql
CREATE TABLE matches (
    id VARCHAR(36) PRIMARY KEY,
    host_user_id VARCHAR(36) NOT NULL,
    match_type ENUM('quick', 'friendly', 'tournament') DEFAULT 'quick',
    team_a_name VARCHAR(100) NOT NULL,
    team_b_name VARCHAR(100) NOT NULL,
    venue TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    scheduled_at TIMESTAMP,
    status ENUM('created', 'toss_done', 'live', 'finished', 'cancelled') DEFAULT 'created',
    rules JSON, -- {overs: 20, powerplay: 6, extras_rules: {...}}
    toss_winner ENUM('A', 'B'),
    toss_decision ENUM('bat', 'bowl'),
    result JSON, -- {winner: 'A', mvp: 'user_id', final_scores: {...}}
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (host_user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_host_user_id (host_user_id),
    INDEX idx_status (status),
    INDEX idx_match_type (match_type),
    INDEX idx_scheduled_at (scheduled_at),
    INDEX idx_created_at (created_at),
    INDEX idx_public_status (is_public, status),
    FULLTEXT idx_venue (venue)
);
```

### 4. players_in_match
```sql
CREATE TABLE players_in_match (
    id VARCHAR(36) PRIMARY KEY,
    match_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    team ENUM('A', 'B') NOT NULL,
    role ENUM('batsman', 'bowler', 'allrounder', 'wicketkeeper') DEFAULT 'batsman',
    batting_position INT,
    is_captain BOOLEAN DEFAULT FALSE,
    is_wicketkeeper BOOLEAN DEFAULT FALSE,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_match_player (match_id, user_id),
    INDEX idx_match_id (match_id),
    INDEX idx_user_id (user_id),
    INDEX idx_team (team),
    INDEX idx_match_team (match_id, team)
);
```

### 5. innings
```sql
CREATE TABLE innings (
    id VARCHAR(36) PRIMARY KEY,
    match_id VARCHAR(36) NOT NULL,
    innings_number INT NOT NULL,
    batting_team ENUM('A', 'B') NOT NULL,
    bowling_team ENUM('A', 'B') NOT NULL,
    overs_allocated INT DEFAULT 20,
    runs INT DEFAULT 0,
    wickets INT DEFAULT 0,
    extras INT DEFAULT 0,
    wides INT DEFAULT 0,
    no_balls INT DEFAULT 0,
    byes INT DEFAULT 0,
    leg_byes INT DEFAULT 0,
    overs_bowled DECIMAL(4, 1) DEFAULT 0.0,
    is_completed BOOLEAN DEFAULT FALSE,
    is_follow_on BOOLEAN DEFAULT FALSE,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
    INDEX idx_match_id (match_id),
    INDEX idx_innings_number (innings_number),
    INDEX idx_batting_team (batting_team),
    INDEX idx_completed (is_completed),
    UNIQUE KEY unique_match_innings (match_id, innings_number)
);
```

### 6. balls (Ball-by-Ball Records)
```sql
CREATE TABLE balls (
    id VARCHAR(36) PRIMARY KEY,
    innings_id VARCHAR(36) NOT NULL,
    over_number INT NOT NULL,
    ball_in_over INT NOT NULL CHECK (ball_in_over BETWEEN 1 AND 6),
    batsman_id VARCHAR(36) NOT NULL,
    non_striker_id VARCHAR(36),
    bowler_id VARCHAR(36) NOT NULL,
    runs_off_bat INT DEFAULT 0 CHECK (runs_off_bat BETWEEN 0 AND 6),
    extras_type ENUM('wide', 'no_ball', 'bye', 'legbye', null) DEFAULT NULL,
    extras_runs INT DEFAULT 0,
    is_legal BOOLEAN DEFAULT TRUE,
    wicket_type ENUM('bowled', 'caught', 'runout', 'lbw', 'stumped', 'hit_wicket', null) DEFAULT NULL,
    dismissal_info JSON, -- {fielder_id: "user_id", partnership: 45, new_batsman_id: "user_id"}
    client_event_id VARCHAR(36), -- For idempotency
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (innings_id) REFERENCES innings(id) ON DELETE CASCADE,
    FOREIGN KEY (batsman_id) REFERENCES users(id),
    FOREIGN KEY (non_striker_id) REFERENCES users(id),
    FOREIGN KEY (bowler_id) REFERENCES users(id),
    INDEX idx_innings_id (innings_id),
    INDEX idx_over_ball (over_number, ball_in_over),
    INDEX idx_batsman (batsman_id),
    INDEX idx_bowler (bowler_id),
    INDEX idx_wicket (wicket_type),
    INDEX idx_timestamp (timestamp),
    INDEX idx_client_event (client_event_id),
    UNIQUE KEY unique_innings_ball (innings_id, over_number, ball_in_over, timestamp)
);
```

### 7. match_events (For Feed & Highlights)
```sql
CREATE TABLE match_events (
    id VARCHAR(36) PRIMARY KEY,
    match_id VARCHAR(36) NOT NULL,
    innings_id VARCHAR(36),
    ball_id VARCHAR(36),
    event_type ENUM('boundary', 'wicket', 'milestone', 'highlight', 'comment', 'innings_change', 'match_start', 'match_end') NOT NULL,
    player_id VARCHAR(36),
    description TEXT,
    meta JSON, -- {runs: 4, boundary_type: "four", milestone: 50, highlight_reel: true}
    is_highlight BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
    FOREIGN KEY (innings_id) REFERENCES innings(id) ON DELETE CASCADE,
    FOREIGN KEY (ball_id) REFERENCES balls(id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES users(id),
    INDEX idx_match_id (match_id),
    INDEX idx_event_type (event_type),
    INDEX idx_player_id (player_id),
    INDEX idx_created_at (created_at),
    INDEX idx_highlight (is_highlight)
);
```

### 8. notifications
```sql
CREATE TABLE notifications (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    notification_type ENUM('match_start', 'wicket', 'milestone', 'mentioned', 'comment', 'system', 'innings_change') NOT NULL,
    title VARCHAR(200),
    body TEXT,
    payload JSON, -- {match_id: "uuid", player_id: "uuid", action_url: "/matches/{id}"}
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_notification_type (notification_type),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
);
```

### 9. otp_sessions
```sql
CREATE TABLE otp_sessions (
    id VARCHAR(36) PRIMARY KEY,
    phone_number VARCHAR(15) NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    attempts INT DEFAULT 0,
    expires_at TIMESTAMP NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_phone_number (phone_number),
    INDEX idx_expires_at (expires_at),
    INDEX idx_is_used (is_used)
);
```

### 10. match_comments
```sql
CREATE TABLE match_comments (
    id VARCHAR(36) PRIMARY KEY,
    match_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    parent_comment_id VARCHAR(36),
    comment TEXT NOT NULL,
    likes INT DEFAULT 0,
    is_edited BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES match_comments(id) ON DELETE CASCADE,
    INDEX idx_match_id (match_id),
    INDEX idx_user_id (user_id),
    INDEX idx_parent_comment (parent_comment_id),
    INDEX idx_created_at (created_at)
);
```

### 11. user_sessions
```sql
CREATE TABLE user_sessions (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    access_token VARCHAR(500) NOT NULL,
    refresh_token VARCHAR(500) NOT NULL,
    device_info JSON, -- {device_id: "uuid", platform: "android", app_version: "1.0.0"}
    ip_address VARCHAR(45),
    expires_at TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_access_token (access_token),
    INDEX idx_refresh_token (refresh_token),
    INDEX idx_expires_at (expires_at),
    INDEX idx_is_active (is_active)
);
```

## Performance Indexes

```sql
-- Additional performance indexes
CREATE INDEX idx_balls_innings_over ON balls(innings_id, over_number);
CREATE INDEX idx_matches_location ON matches(latitude, longitude);
CREATE INDEX idx_players_in_match_user ON players_in_match(user_id, match_id);
CREATE INDEX idx_match_events_timeline ON match_events(match_id, created_at DESC);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read, created_at DESC);
CREATE INDEX idx_profiles_stats ON profiles(total_runs DESC, total_wickets DESC, average_runs DESC);
```

## Data Relationships

```
users (1) -----> (N) profiles
users (1) -----> (N) matches (as host)
users (1) -----> (N) players_in_match
users (1) -----> (N) balls (as batsman)
users (1) -----> (N) balls (as bowler)
users (1) -----> (N) notifications
matches (1) ----> (N) players_in_match
matches (1) ----> (N) innings
matches (1) ----> (N) match_events
innings (1) ----> (N) balls
innings (1) ----> (N) match_events
balls (1) ------> (N) match_events (optional)
```

## Key Design Decisions

1. **UUID Primary Keys**: Better for distributed systems and prevents enumeration attacks
2. **JSON Fields**: Flexible storage for rules, results, and metadata
3. **Denormalized Statistics**: Player profiles cache calculated stats for performance
4. **Client Event ID**: Prevents duplicate ball entries during offline sync
5. **Soft Deletes**: All tables use CASCADE for data integrity
6. **Indexing Strategy**: Optimized for common query patterns
7. **Full-Text Search**: Venue search support for location-based features
8. **Decimal Coordinates**: Precise location tracking for nearby matches
9. **Timestamp Tracking**: Created/updated timestamps for audit trails
10. **Check Constraints**: Data validation at database level

## Data Integrity Rules

1. **Ball Validation**: Ball number must be 1-6, runs 0-6
2. **Unique Constraints**: One player per match, unique innings numbers
3. **Foreign Key Constraints**: Maintain referential integrity
4. **Status Transitions**: Match status follows valid workflow
5. **Timestamp Validation**: OTP sessions expire, notifications can be marked read

## Performance Optimizations

1. **Composite Indexes**: Multi-column indexes for complex queries
2. **Covering Indexes**: Include frequently queried columns
3. **Partitioning**: Consider partitioning balls table by match_id for large datasets
4. **Caching**: Player statistics denormalized in profiles table
5. **Read Replicas**: Separate read/write workloads for scaling

## Backup Strategy

1. **Point-in-time Recovery**: MySQL binary logs for 7 days
2. **Daily Backups**: Automated daily full backups
3. **Cross-region Replication**: Disaster recovery setup
4. **Data Archival**: Archive old matches to cold storage after 1 year