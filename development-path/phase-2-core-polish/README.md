# ✨ Phase 2: Core Product Polish

> **Status:** ⚪ NOT STARTED
> **Timeline:** Week 3-4
> **Depends on:** Phase 1 completion
> **Goal:** Make the product usable end-to-end for real users

---

## Steps

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

**Files to modify:**

- `backend/app/auth/otp.py`
- `backend/app/api/auth.py`
- `backend/app/settings.py`
- `backend/requirements.txt`

---

### Step 2.4: Rate Limiting

- [ ] Add `slowapi` to requirements
- [ ] Configure rate limiter middleware
- [ ] Rate limit auth endpoints (5 req/min for OTP)
- [ ] Rate limit API endpoints (60 req/min general)
- [ ] Rate limit WebSocket connections
- [ ] Return `429` with `Retry-After` header

**Files to modify/create:**

- `backend/app/main.py`
- `backend/app/middleware/rate_limiter.py` (new)
- `backend/requirements.txt`

---

### Step 2.5: Offline Sync

- [ ] Implement offline queue processing in `offline_sync_provider.dart`
- [ ] Queue ball events when offline
- [ ] Auto-sync when connectivity restored
- [ ] Handle conflicts (server has newer data)
- [ ] Show sync status indicator in UI
- [ ] Test: go offline → score 5 balls → go online → verify sync

**Files to modify:**

- `flutter/lib/providers/offline_sync_provider.dart`
- `flutter/lib/providers/connectivity_provider.dart`
- `flutter/lib/services/storage_service.dart`

---

### Step 2.6: Shareable Match Links

- [ ] Generate unique shareable URLs for matches
- [ ] Create public match view endpoint (no auth required)
- [ ] Add share button in match detail screen
- [ ] Support WhatsApp, Copy Link, generic share
- [ ] Enable Flutter deep linking
- [ ] Mobile: match URL opens app directly

**Files to create/modify:**

- `backend/app/api/matches.py` (public view endpoint)
- `flutter/lib/screens/match/match_detail_screen.dart`
- `flutter/lib/routes/app_router.dart` (deep linking)

---

### Step 2.7: Error Handling Polish

- [ ] Standardize error display across all screens
- [ ] Add retry buttons on all error states
- [ ] Add offline indicator banner
- [ ] Add loading skeletons instead of spinners
- [ ] Add empty state illustrations
- [ ] Add pull-to-refresh on all lists
- [ ] Handle WebSocket disconnection gracefully

**Files to modify:**

- `flutter/lib/widgets/common/error_widget.dart`
- `flutter/lib/widgets/common/loading_widget.dart`
- All screen files

---

## Completion Checklist

- [ ] Flutter models 100% match backend schemas
- [ ] Can score a full match on mobile E2E
- [ ] OTP works with real phone numbers
- [ ] Rate limiting prevents brute force
- [ ] Offline scoring works and syncs
- [ ] Match links shareable via WhatsApp
- [ ] Error states handled gracefully everywhere

## Estimated Effort

- **2.1 Model Sync**: 3-4 hours
- **2.2 E2E Scoring**: 6-8 hours
- **2.3 OTP Integration**: 3-4 hours
- **2.4 Rate Limiting**: 2-3 hours
- **2.5 Offline Sync**: 4-6 hours
- **2.6 Share Links**: 3-4 hours
- **2.7 Error Polish**: 4-6 hours
- **Total: ~25-35 hours**
