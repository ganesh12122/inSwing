# 🏏 Dual Captain Match System — Feature Design

## Overview

The Dual Captain system transforms inSwing from a **single-scorer app** into a **collaborative match management platform** where two team captains jointly set up and manage a cricket match.

> **This is inSwing's killer differentiator.** No other gully cricket app does this properly.

---

## Current System vs Proposed System

### ❌ Current Flow (Single Host)

```
Captain A creates match → adds ALL players to both teams
→ sets rules alone → does toss → scores alone
```

**Problems:**

- Captain A controls everything — Captain B has no say
- Captain A manually adds Team B players (doesn't know them)
- Rules are unilateral — no negotiation
- No invite/accept flow
- Basically a "scorekeeper" app, not a "match management" app

### ✅ Proposed Flow (Dual Captain)

```
Captain A creates match → sets Team A name → invites Captain B
→ Captain B accepts → sets Team B name → both add their own players
→ Captain A proposes rules → Captain B approves/counters
→ Both approve rules → Toss → Match goes live → Both can view live scores
```

---

## Match Lifecycle (New Status Flow)

```
created          Captain A creates match shell with Team A name
    ↓
invited          Captain A sends invite to Captain B (by phone/search)
    ↓
accepted         Captain B accepts → becomes opponent_captain
    ↓
teams_ready      Both captains have added their players (min players met)
    ↓
rules_proposed   One captain proposes rules
    ↓
rules_approved   Both captains approve the rules
    ↓
toss_done        Toss recorded
    ↓
live             Match is in progress (scoring active)
    ↓
finished         Match completed with result
    |
cancelled        Either captain can cancel (with confirmation)
```

### Status Transition Rules

| Current Status   | Can Transition To                                         | Who Can Trigger                                     |
| ---------------- | --------------------------------------------------------- | --------------------------------------------------- |
| `created`        | `invited`, `cancelled`                                    | Host captain                                        |
| `invited`        | `accepted`, `cancelled`                                   | Opponent (accept), Host (cancel)                    |
| `accepted`       | `teams_ready`, `cancelled`                                | System (auto when both teams ready), Either captain |
| `teams_ready`    | `rules_proposed`, `cancelled`                             | Either captain                                      |
| `rules_proposed` | `rules_approved`, `rules_proposed` (counter), `cancelled` | Other captain                                       |
| `rules_approved` | `toss_done`, `cancelled`                                  | Host captain                                        |
| `toss_done`      | `live`                                                    | System (auto on first ball)                         |
| `live`           | `finished`, `cancelled`                                   | System/Host                                         |
| `finished`       | — (terminal)                                              | —                                                   |
| `cancelled`      | — (terminal)                                              | —                                                   |

---

## Data Model Changes

### Match Model (Updated)

```python
class Match(Base):
    # Existing fields...
    host_user_id = Column(String(36), ForeignKey("users.id"))       # Captain A

    # NEW: Opponent captain
    opponent_captain_id = Column(String(36), ForeignKey("users.id"), nullable=True)

    # UPDATED: Extended status enum
    status = Column(Enum(
        'created', 'invited', 'accepted', 'teams_ready',
        'rules_proposed', 'rules_approved', 'toss_done',
        'live', 'finished', 'cancelled',
        name='match_status_v2'
    ))

    # NEW: Rules negotiation
    proposed_rules = Column(JSON, nullable=True)        # Rules waiting for approval
    rules_proposed_by = Column(String(36), nullable=True)  # Who proposed current rules
    host_rules_approved = Column(Boolean, default=False)
    opponent_rules_approved = Column(Boolean, default=False)

    # NEW: Invitation tracking
    invitation_message = Column(String(500), nullable=True)
    invited_at = Column(DateTime(timezone=True), nullable=True)
    accepted_at = Column(DateTime(timezone=True), nullable=True)

    # NEW: Team readiness
    host_team_ready = Column(Boolean, default=False)
    opponent_team_ready = Column(Boolean, default=False)

    # NEW: Minimum players per team (from rules)
    min_players_per_team = Column(Integer, default=2)  # Gully cricket can be 2v2!
```

### PlayersInMatch Model (Updated)

```python
class PlayersInMatch(Base):
    # Existing fields...

    # UPDATED: Add 'captain' to role enum
    role = Column(Enum(
        'captain', 'batsman', 'bowler', 'allrounder', 'wicketkeeper',
        name='player_role_v2'
    ))

    # NEW: Who added this player (host captain or opponent captain)
    added_by = Column(String(36), ForeignKey("users.id"), nullable=True)
```

### MatchRules Schema (Expanded)

```python
class MatchRules(BaseModel):
    overs_limit: int = Field(6, ge=1, le=50)
    powerplay_overs: int = Field(0, ge=0, le=10)
    max_overs_per_bowler: int = Field(0)  # 0 = no limit
    wide_ball_runs: int = Field(1, ge=1, le=2)
    no_ball_runs: int = Field(1, ge=1, le=2)
    free_hit: bool = True
    super_over: bool = False
    min_players_per_team: int = Field(2, ge=2, le=11)
    max_players_per_team: int = Field(11, ge=2, le=15)
    last_man_batting: bool = False  # Gully cricket special!
    tennis_ball: bool = True        # Gully cricket default
    boundary_runs: int = Field(4, ge=4, le=6)
```

---

## API Endpoints (New/Modified)

### Match Creation & Invitation

```
POST   /api/v1/matches/                    # Captain A creates match
POST   /api/v1/matches/{id}/invite         # Captain A invites Captain B
POST   /api/v1/matches/{id}/accept         # Captain B accepts invite
POST   /api/v1/matches/{id}/decline        # Captain B declines invite
```

### Team Management (Each captain manages their own team)

```
POST   /api/v1/matches/{id}/team/players   # Captain adds player to THEIR team
DELETE /api/v1/matches/{id}/team/players/{uid}  # Captain removes from THEIR team
PUT    /api/v1/matches/{id}/team/ready      # Captain marks their team as ready
GET    /api/v1/matches/{id}/teams           # Get both teams' player lists
```

### Rules Negotiation

```
POST   /api/v1/matches/{id}/rules/propose  # Captain proposes rules
POST   /api/v1/matches/{id}/rules/approve  # Other captain approves
POST   /api/v1/matches/{id}/rules/counter  # Other captain counters with changes
GET    /api/v1/matches/{id}/rules           # Get current rules + approval status
```

### Existing (unchanged)

```
PUT    /api/v1/matches/{id}/toss           # Record toss
POST   /api/v1/matches/{id}/innings        # Create innings
POST   /api/v1/matches/{id}/innings/{iid}/ball  # Record ball
```

---

## Real-Time Updates (WebSocket)

Both captains receive live updates for:

```json
{"type": "match_invitation", "match_id": "...", "from": "Captain A"}
{"type": "invitation_accepted", "match_id": "...", "by": "Captain B"}
{"type": "player_added", "match_id": "...", "team": "B", "player": {...}}
{"type": "team_ready", "match_id": "...", "team": "A"}
{"type": "rules_proposed", "match_id": "...", "proposed_by": "...", "rules": {...}}
{"type": "rules_approved", "match_id": "...", "approved_by": "..."}
{"type": "toss_result", "match_id": "...", "winner": "A", "decision": "bat"}
{"type": "ball_update", "match_id": "...", "ball_data": {...}}
```

---

## Flutter UI Flow

### Screen 1: Create Match

- Captain A enters Team A name
- Selects match type (quick/friendly/tournament)
- Sets venue (optional GPS)
- Searches for opponent captain (by phone number or name)
- Sends invite → navigates to "Waiting for opponent" screen

### Screen 2: Match Invitation (Opponent Side)

- Captain B sees notification/invite
- Views match details (team name, venue, match type)
- Can Accept or Decline
- On accept → enters Team B name → navigates to team setup

### Screen 3: Team Setup (Both Captains)

- Each captain adds their own players
- Search by phone number (app users) or enter name (guest players)
- Set player roles (batsman, bowler, allrounder, wicketkeeper)
- "Team Ready" button → marks their team as complete
- Shows opponent's team readiness status

### Screen 4: Rules Negotiation

- One captain proposes rules (overs, powerplay, extras rules, etc.)
- Other captain sees proposal → can Approve or Counter
- Counter-proposal goes back → continues until both approve
- Shows "✅ Rules Agreed" when both approve

### Screen 5: Toss

- Host captain records toss result
- Shows which team bats/bowls first

### Screen 6: Live Scoring

- Same as current scoring screen
- Both captains can view, but only designated scorer records balls

---

## Gully Cricket Special Rules

Since our target is gully cricket players, include these special rules:

- **Last Man Batting**: Allow batting team to continue with 1 player
- **Tennis Ball**: Different ball dynamics
- **No Umpire Mode**: Both captains agree on decisions
- **Flexible Team Sizes**: 2v2 up to 11v11
- **No Powerplay Option**: Skip powerplay for short matches
- **Custom Boundary**: 4 or 6 for boundary hits
- **Quick Match**: 2-6 overs, no complicated rules

---

## Implementation Priority

### Phase 2A (Build Core Flow)

1. Update Match model with new fields
2. Implement invite/accept API endpoints
3. Implement team management endpoints (each captain manages own team)
4. Basic rules proposal/approval
5. Update Flutter create match screen

### Phase 2B (Polish & Real-Time)

1. WebSocket notifications for all steps
2. Rules negotiation UI
3. Team readiness indicators
4. Match invitation notifications (push)
5. Guest player support (non-app users)

### Phase 3 (Advanced)

1. Tournament brackets (multiple matches)
2. Match history and rematch
3. Captain ratings
4. Team profiles

---

## Why This Matters for Revenue

1. **Network Effect**: Every match REQUIRES 2 app installs (both captains) → organic growth
2. **Engagement**: Rules negotiation, team setup = more time in app
3. **Premium Upsell**: Advanced rules (DLS, custom scoring) → paid feature
4. **Data Value**: Match data from 2 verified captains = higher quality stats
5. **Virality**: "Join my match" invite link → new user acquisition

---

## Decisions — ALL CONFIRMED ✅

1. ✅ **Dual-captain model** — YES, proceed with full implementation
2. ✅ **Quick Match mode** — YES, skips invitation entirely (solo scoring, host manages everything)
3. ✅ **Guest Players** — YES, support adding players by name only (no app account needed)
4. ✅ **Scorer Permissions** — Configurable per match via rules:
   - `host_only` — Only the host captain can score (default)
   - `captains` — Either captain can score
   - `designated` — A designated third-party scorer
   - `all_players` — Any player in the match can score
5. ✅ **Three match modes**: `quick` (solo), `dual_captain` (invite flow), `tournament` (Phase 3)
6. ✅ **Tournament mode** = single organizer host, deferred to Phase 3
