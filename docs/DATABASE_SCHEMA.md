# 🗄️ inSwing — Database Schema Reference

## Overview

All tables follow these conventions:

- **Primary Key**: UUID v4 (`id`)
- **Timestamps**: `created_at`, `updated_at` on every table
- **Soft Deletes**: `is_active` flag where applicable
- **Foreign Keys**: Explicit `ON DELETE` behavior
- **Indexes**: On all frequently queried columns

## Tables

### 1. `users`

Core user table for authentication and identity.

| Column         | Type                   | Constraints                | Description         |
| -------------- | ---------------------- | -------------------------- | ------------------- |
| `id`           | UUID (PK)              | NOT NULL, DEFAULT uuid4    | Unique user ID      |
| `phone_number` | VARCHAR(15)            | UNIQUE, NOT NULL, INDEX    | Phone for OTP login |
| `email`        | VARCHAR(255)           | UNIQUE, NULLABLE, INDEX    | Optional email      |
| `full_name`    | VARCHAR(255)           | NOT NULL                   | Display name        |
| `avatar_url`   | VARCHAR(500)           | NULLABLE                   | Profile picture URL |
| `bio`          | TEXT                   | NULLABLE                   | User bio            |
| `role`         | ENUM('player','admin') | NOT NULL, DEFAULT 'player' | User role           |
| `is_active`    | BOOLEAN                | NOT NULL, DEFAULT TRUE     | Soft delete flag    |
| `is_verified`  | BOOLEAN                | NOT NULL, DEFAULT FALSE    | Phone verified      |
| `created_at`   | TIMESTAMP              | NOT NULL, DEFAULT NOW()    |                     |
| `updated_at`   | TIMESTAMP              | NOT NULL, AUTO-UPDATE      |                     |

**Relationships:**

- 1:1 → `profiles`
- 1:N → `matches` (as host)
- N:M → `matches` (via `players_in_match`)
- 1:N → `notifications`

---

### 2. `profiles`

Extended player profile with cricket statistics.

| Column                | Type                               | Constraints             | Description          |
| --------------------- | ---------------------------------- | ----------------------- | -------------------- |
| `id`                  | UUID (PK)                          | NOT NULL                |                      |
| `user_id`             | UUID (FK→users)                    | UNIQUE, NOT NULL, INDEX | One profile per user |
| `batting_style`       | ENUM('right-handed','left-handed') | NULLABLE                |                      |
| `bowling_style`       | ENUM('fast','spin','pace','none')  | NULLABLE                |                      |
| `dominant_hand`       | ENUM('right','left')               | NULLABLE                |                      |
| `total_matches`       | INT                                | DEFAULT 0               | Denormalized stat    |
| `total_runs`          | INT                                | DEFAULT 0               | Denormalized stat    |
| `total_wickets`       | INT                                | DEFAULT 0               | Denormalized stat    |
| `total_balls_faced`   | INT                                | DEFAULT 0               |                      |
| `total_balls_bowled`  | INT                                | DEFAULT 0               |                      |
| `total_runs_conceded` | INT                                | DEFAULT 0               |                      |
| `average_runs`        | FLOAT                              | DEFAULT 0.0             | Calculated           |
| `strike_rate`         | FLOAT                              | DEFAULT 0.0             | Runs per 100 balls   |
| `economy_rate`        | FLOAT                              | DEFAULT 0.0             | Runs per over        |
| `bowling_average`     | FLOAT                              | DEFAULT 0.0             |                      |
| `teams`               | TEXT/JSON                          | NULLABLE                | Team names array     |
| `achievements`        | TEXT/JSON                          | NULLABLE                | Achievements array   |
| `created_at`          | TIMESTAMP                          | NOT NULL                |                      |
| `updated_at`          | TIMESTAMP                          | NOT NULL                |                      |

---

### 3. `matches`

Core match table with all match metadata.

| Column          | Type                                                      | Constraints                        | Description           |
| --------------- | --------------------------------------------------------- | ---------------------------------- | --------------------- |
| `id`            | UUID (PK)                                                 | NOT NULL                           |                       |
| `host_user_id`  | UUID (FK→users)                                           | NOT NULL, INDEX, ON DELETE CASCADE | Match creator         |
| `match_type`    | ENUM('quick','friendly','tournament')                     | NOT NULL, DEFAULT 'quick'          |                       |
| `team_a_name`   | VARCHAR(100)                                              | NOT NULL                           |                       |
| `team_b_name`   | VARCHAR(100)                                              | NOT NULL                           |                       |
| `venue`         | VARCHAR(255)                                              | NULLABLE                           |                       |
| `latitude`      | FLOAT                                                     | NULLABLE                           | GPS coordinate        |
| `longitude`     | FLOAT                                                     | NULLABLE                           | GPS coordinate        |
| `scheduled_at`  | TIMESTAMP                                                 | NULLABLE, INDEX                    | When match is planned |
| `status`        | ENUM('created','toss_done','live','finished','cancelled') | NOT NULL, INDEX                    |                       |
| `rules`         | JSON                                                      | NOT NULL                           | Match rules config    |
| `result`        | JSON                                                      | NULLABLE                           | Final scores & winner |
| `toss_winner`   | ENUM('A','B')                                             | NULLABLE                           |                       |
| `toss_decision` | ENUM('bat','bowl')                                        | NULLABLE                           |                       |
| `created_at`    | TIMESTAMP                                                 | NOT NULL                           |                       |
| `updated_at`    | TIMESTAMP                                                 | NOT NULL                           |                       |
| `started_at`    | TIMESTAMP                                                 | NULLABLE                           | Actual start time     |
| `finished_at`   | TIMESTAMP                                                 | NULLABLE                           | Actual end time       |

**Rules JSON structure:**

```json
{
  "overs_limit": 20,
  "powerplay_overs": 6,
  "wide_ball_runs": 1,
  "no_ball_runs": 1,
  "free_hit": true,
  "super_over": false
}
```

---

### 4. `players_in_match`

Junction table linking users to matches with team assignment.

| Column       | Type              | Constraints                        | Description          |
| ------------ | ----------------- | ---------------------------------- | -------------------- |
| `id`         | UUID (PK)         | NOT NULL                           |                      |
| `match_id`   | UUID (FK→matches) | NOT NULL, INDEX, ON DELETE CASCADE |                      |
| `user_id`    | UUID (FK→users)   | NOT NULL, INDEX, ON DELETE CASCADE |                      |
| `team`       | ENUM('A','B')     | NOT NULL                           | Team assignment      |
| `role`       | VARCHAR(50)       | NULLABLE                           | Player role in match |
| `created_at` | TIMESTAMP         | NOT NULL                           |                      |

**Unique constraint:** (`match_id`, `user_id`)

---

### 5. `innings`

Innings-level aggregation for each match.

| Column            | Type              | Constraints                        | Description                   |
| ----------------- | ----------------- | ---------------------------------- | ----------------------------- |
| `id`              | UUID (PK)         | NOT NULL                           |                               |
| `match_id`        | UUID (FK→matches) | NOT NULL, INDEX, ON DELETE CASCADE |                               |
| `batting_team`    | ENUM('A','B')     | NOT NULL                           |                               |
| `overs_allocated` | INT               | NOT NULL, DEFAULT 20               |                               |
| `runs`            | INT               | DEFAULT 0                          | Denormalized total            |
| `wickets`         | INT               | DEFAULT 0                          | Denormalized total            |
| `extras`          | INT               | DEFAULT 0                          | Denormalized total            |
| `overs_bowled`    | FLOAT             | DEFAULT 0.0                        | Format: 4.3 = 4 overs 3 balls |
| `is_completed`    | BOOLEAN           | DEFAULT FALSE, INDEX               |                               |
| `completed_at`    | TIMESTAMP         | NULLABLE                           |                               |
| `notes`           | JSON              | NULLABLE                           |                               |
| `created_at`      | TIMESTAMP         | NOT NULL                           |                               |
| `updated_at`      | TIMESTAMP         | NOT NULL                           |                               |

---

### 6. `balls`

Ball-by-ball scoring records — the heart of the scoring engine.

| Column            | Type                                                          | Constraints                         | Description                  |
| ----------------- | ------------------------------------------------------------- | ----------------------------------- | ---------------------------- |
| `id`              | UUID (PK)                                                     | NOT NULL                            |                              |
| `innings_id`      | UUID (FK→innings)                                             | NOT NULL, INDEX, ON DELETE CASCADE  |                              |
| `over_number`     | INT                                                           | NOT NULL, INDEX                     | Which over (1-50)            |
| `ball_in_over`    | INT                                                           | NOT NULL                            | Ball number in over (1-6+)   |
| `batsman_id`      | UUID (FK→users)                                               | NULLABLE, INDEX, ON DELETE SET NULL | On-strike batter             |
| `non_striker_id`  | UUID (FK→users)                                               | NULLABLE, ON DELETE SET NULL        | Off-strike batter            |
| `bowler_id`       | UUID (FK→users)                                               | NULLABLE, INDEX, ON DELETE SET NULL | Bowler                       |
| `runs_off_bat`    | INT                                                           | DEFAULT 0                           | Runs scored by batsman       |
| `extras_type`     | ENUM('wide','no_ball','bye','legbye')                         | NULLABLE                            | Type of extra                |
| `extras_runs`     | INT                                                           | DEFAULT 0                           | Extra runs                   |
| `wicket_type`     | ENUM('bowled','caught','runout','lbw','stumped','hit_wicket') | NULLABLE                            |                              |
| `dismissal_info`  | JSON                                                          | NULLABLE                            | Fielder, etc.                |
| `client_event_id` | VARCHAR(100)                                                  | NULLABLE, INDEX                     | Offline sync idempotency key |
| `metadata`        | JSON                                                          | NULLABLE                            | Additional ball info         |
| `created_at`      | TIMESTAMP                                                     | NOT NULL                            |                              |

**Computed properties (in code):**

- `total_runs` = `runs_off_bat` + `extras_runs`
- `is_legal_delivery` = `extras_type` NOT IN ('wide', 'no_ball')

---

### 7. `match_events`

Event log for match milestones and actions.

| Column       | Type              | Constraints                        | Description         |
| ------------ | ----------------- | ---------------------------------- | ------------------- |
| `id`         | UUID (PK)         | NOT NULL                           |                     |
| `match_id`   | UUID (FK→matches) | NOT NULL, INDEX, ON DELETE CASCADE |                     |
| `event_type` | ENUM(...)         | NOT NULL                           | Event type          |
| `data`       | JSON              | NULLABLE                           | Event-specific data |
| `created_at` | TIMESTAMP         | NOT NULL                           |                     |

---

### 8. `notifications`

User notifications for match updates.

| Column       | Type                              | Constraints                        | Description       |
| ------------ | --------------------------------- | ---------------------------------- | ----------------- |
| `id`         | UUID (PK)                         | NOT NULL                           |                   |
| `user_id`    | UUID (FK→users)                   | NOT NULL, INDEX, ON DELETE CASCADE |                   |
| `title`      | VARCHAR(255)                      | NOT NULL                           |                   |
| `message`    | TEXT                              | NOT NULL                           |                   |
| `type`       | ENUM(...)                         | NOT NULL                           | Notification type |
| `data`       | JSON                              | NULLABLE                           | Metadata          |
| `priority`   | VARCHAR(20)                       | NULLABLE                           | low/medium/high   |
| `status`     | ENUM('unread','read','dismissed') | NOT NULL, DEFAULT 'unread'         |                   |
| `read_at`    | TIMESTAMP                         | NULLABLE                           |                   |
| `expires_at` | TIMESTAMP                         | NULLABLE                           |                   |
| `created_at` | TIMESTAMP                         | NOT NULL                           |                   |

---

### 9. `otp_sessions`

Temporary OTP storage for authentication.

| Column         | Type        | Constraints     | Description                  |
| -------------- | ----------- | --------------- | ---------------------------- |
| `id`           | UUID (PK)   | NOT NULL        |                              |
| `phone_number` | VARCHAR(15) | NOT NULL, INDEX |                              |
| `otp_code`     | VARCHAR(10) | NOT NULL        | Generated OTP                |
| `attempts`     | INT         | DEFAULT 0       | Failed verification attempts |
| `expires_at`   | TIMESTAMP   | NOT NULL        | OTP expiry time              |
| `created_at`   | TIMESTAMP   | NOT NULL        |                              |

---

## Future Tables (Planned)

### `tournaments`

| Column         | Type                                   | Description     |
| -------------- | -------------------------------------- | --------------- |
| `id`           | UUID                                   |                 |
| `name`         | VARCHAR                                | Tournament name |
| `organizer_id` | UUID (FK→users)                        |                 |
| `format`       | ENUM('knockout','round_robin','group') |                 |
| `start_date`   | DATE                                   |                 |
| `end_date`     | DATE                                   |                 |
| `max_teams`    | INT                                    |                 |
| `entry_fee`    | DECIMAL                                |                 |
| `prize_pool`   | TEXT/JSON                              |                 |
| `status`       | ENUM                                   |                 |

### `teams`

| Column       | Type            | Description |
| ------------ | --------------- | ----------- |
| `id`         | UUID            |             |
| `name`       | VARCHAR         |             |
| `captain_id` | UUID (FK→users) |             |
| `logo_url`   | VARCHAR         |             |
| `city`       | VARCHAR         |             |

### `team_members`

| Column      | Type            | Description |
| ----------- | --------------- | ----------- |
| `team_id`   | UUID (FK→teams) |             |
| `user_id`   | UUID (FK→users) |             |
| `role`      | ENUM            |             |
| `joined_at` | TIMESTAMP       |             |

### `subscriptions`

| Column       | Type                          | Description        |
| ------------ | ----------------------------- | ------------------ |
| `id`         | UUID                          |                    |
| `user_id`    | UUID (FK→users)               |                    |
| `plan`       | ENUM('free','premium','team') |                    |
| `starts_at`  | TIMESTAMP                     |                    |
| `expires_at` | TIMESTAMP                     |                    |
| `payment_id` | VARCHAR                       | Razorpay/Stripe ID |
