# ✨ Phase 2: Core Product Polish + Dual Captain System

> **Status:** ⚪ NOT STARTED
> **Timeline:** Week 3-5
> **Depends on:** Phase 1 completion
> **Goal:** Build the dual-captain match system and make the product usable E2E

---

## 🏏 NEW: Step 2.0 — Dual Captain Match System (PRIORITY)

> **Design doc:** [`docs/DUAL_CAPTAIN_SYSTEM.md`](../../docs/DUAL_CAPTAIN_SYSTEM.md)

This is inSwing's **killer differentiator**. Two captains collaborate to set up and manage a match.

### Step 2.0A: Data Model Updates
- [ ] Add `opponent_captain_id` to Match model
- [ ] Expand `match_status` enum (invited, accepted, teams_ready, rules_proposed, rules_approved)
- [ ] Add rules negotiation fields (proposed_rules, host/opponent approval flags)
- [ ] Add invitation tracking fields (invited_at, accepted_at, invitation_message)
- [ ] Add team readiness flags (host_team_ready, opponent_team_ready)
- [ ] Add `captain` to `player_role` enum in PlayersInMatch
- [ ] Add `added_by` field to PlayersInMatch
- [ ] Expand MatchRules schema (max_overs_per_bowler, min/max_players, gully cricket rules)
- [ ] Create new Alembic migration
- [ ] Update Flutter models to match

### Step 2.0B: Match Invitation Flow
- [ ] `POST /matches/{id}/invite` — Captain A invites Captain B (by phone/user_id)
- [ ] `POST /matches/{id}/accept` — Captain B accepts
- [ ] `POST /matches/{id}/decline` — Captain B declines
- [ ] WebSocket: send invitation notification to Captain B
- [ ] Flutter: Match invitation notification screen
- [ ] Flutter: "Waiting for opponent" screen with live status

### Step 2.0C: Team Management (Each Captain Manages Own Team)
- [ ] `POST /matches/{id}/team/players` — Captain adds player to their own team
- [ ] `DELETE /matches/{id}/team/players/{uid}` — Captain removes from their team
- [ ] `PUT /matches/{id}/team/ready` — Captain marks team as ready
- [ ] `GET /matches/{id}/teams` — Get both teams' player lists
- [ ] Auto-transition: both teams ready → status = `teams_ready`
- [ ] Flutter: Team setup screen (each captain sees their own team)
- [ ] Support guest players (name-only, no app account required)

### Step 2.0D: Rules Negotiation
- [ ] `POST /matches/{id}/rules/propose` — Captain proposes rules
- [ ] `POST /matches/{id}/rules/approve` — Other captain approves
- [ ] `POST /matches/{id}/rules/counter` — Other captain sends counter-proposal
- [ ] Auto-transition: both approve → status = `rules_approved`
- [ ] WebSocket: real-time rules update notifications
- [ ] Flutter: Rules negotiation UI with approve/counter buttons

### Step 2.0E: Quick Match Mode (Skip Invitation)
- [ ] If match_type = 'quick', skip invite flow
- [ ] Single captain creates match, adds both teams, starts immediately
- [ ] Backward compatible with current flow
- [ ] Useful for practice matches, solo scoring

---

## Steps (Original — Still Required)

### Step 2.1: Sync Flutter ↔ Backend Models

- [ ] Audit every Flutter model field vs backend schema
- [ ] Fix `User` model: `name` → `full_name`, add missing fields
- [ ] Fix `Match` model: ensure all fields match `MatchResponse` schema
- [ ] Fix `Innings` model: add `overs_bowled` field
- [ ] Fix `Ball` model: ensure extras/wicket enums match
- [ ] Update `api_service.dart` endpoint URLs to match actual routes
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Test JSON serialization/deserialization for all models

**Files to modify:**
- `flutter/lib/models/user_model.dart`
- `flutter/lib/models/match_model.dart`
- `flutter/lib/services/api_service.dart`
- `flutter/lib/utils/constants.dart`

---

### Step 2.2: Complete Live Scoring Flow (E2E)

- [ ] Verify create match → add players → toss → innings → scoring works
- [ ] Fix scoring UI to show current over, batsman, bowler
- [ ] Add undo last ball functionality
- [ ] Add over completion detection (auto-new over after 6 balls)
- [ ] Add innings completion detection (all out / overs complete)
- [ ] Add match completion with winner calculation
- [ ] WebSocket broadcasts on every ball scored
- [ ] Spectators see live updates

**Files to modify:**
- `flutter/lib/screens/match/match_scoring_screen.dart`
- `flutter/lib/providers/match_scoring_provider.dart`
- `backend/app/api/balls.py`
- `backend/app/services/scoring_service.py`

---

### Step 2.3: OTP Delivery Integration

- [ ] Choose provider: Firebase Auth (free) or MSG91 (free trial)
- [ ] Implement SMS sending in `backend/app/auth/otp.py`
- [ ] Add OTP delivery status tracking
- [ ] Handle delivery failures gracefully
- [ ] Add resend OTP with cooldown
- [ ] Dev mode: still log OTP to console when `DEBUG=True`

---

### Step 2.4: Rate Limiting

- [ ] Add `slowapi` to requirements
- [ ] Configure rate limiter middleware
- [ ] Rate limit auth endpoints (5 req/min for OTP)
- [ ] Rate limit API endpoints (60 req/min general)
- [ ] Return `429` with `Retry-After` header

---

### Step 2.5: Offline Sync

- [ ] Implement offline queue processing
- [ ] Queue ball events when offline
- [ ] Auto-sync when connectivity restored
- [ ] Handle conflicts (server has newer data)
- [ ] Show sync status indicator in UI

---

### Step 2.6: Shareable Match Links

- [ ] Generate unique shareable URLs for matches
- [ ] Create public match view endpoint (no auth required)
- [ ] Add share button in match detail screen
- [ ] Support WhatsApp, Copy Link, generic share

---

### Step 2.7: Error Handling Polish

- [ ] Standardize error display across all screens
- [ ] Add retry buttons on all error states
- [ ] Add loading skeletons instead of spinners
- [ ] Handle WebSocket disconnection gracefully

---

## Completion Checklist

- [ ] **Dual captain match flow works E2E**
- [ ] Flutter models 100% match backend schemas
- [ ] Can score a full match on mobile E2E
- [ ] OTP works with real phone numbers
- [ ] Rate limiting prevents brute force
- [ ] Offline scoring works and syncs
- [ ] Match links shareable via WhatsApp

## Estimated Effort

- **2.0 Dual Captain System**: 15-20 hours
- **2.1 Model Sync**: 3-4 hours
- **2.2 E2E Scoring**: 6-8 hours
- **2.3 OTP Integration**: 3-4 hours
- **2.4 Rate Limiting**: 2-3 hours
- **2.5 Offline Sync**: 4-6 hours
- **2.6 Share Links**: 3-4 hours
- **2.7 Error Polish**: 4-6 hours
- **Total: ~40-55 hours**
