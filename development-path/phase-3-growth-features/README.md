# 🚀 Phase 3: Growth Features

> **Status:** ⚪ NOT STARTED
> **Timeline:** Week 5-8
> **Depends on:** Phase 2 completion
> **Goal:** Build differentiating features that drive user acquisition

---

## Steps

### Step 3.1: Tournament Management System

- [ ] Design tournament database schema (`tournaments`, `tournament_teams`, `tournament_matches`)
- [ ] Create Alembic migration
- [ ] Build tournament CRUD API endpoints
- [ ] Support formats: Knockout, Round Robin, Group Stage + Knockout
- [ ] Automatic bracket/fixture generation
- [ ] Points table calculation (for round robin/group)
- [ ] Net Run Rate calculation
- [ ] Flutter: Tournament creation screen
- [ ] Flutter: Tournament bracket/table view
- [ ] Flutter: Tournament detail screen

**Backend files to create:**

- `backend/app/models/tournament.py`
- `backend/app/schemas/tournament.py`
- `backend/app/services/tournament_service.py`
- `backend/app/api/tournaments.py`

**Flutter files to create:**

- `flutter/lib/models/tournament_model.dart`
- `flutter/lib/providers/tournament_provider.dart`
- `flutter/lib/screens/tournament/`

---

### Step 3.2: Team Management

- [ ] Design teams schema (`teams`, `team_members`)
- [ ] Create Alembic migration
- [ ] Team CRUD API (create, invite, remove members)
- [ ] Team captain/admin roles
- [ ] Team statistics aggregation
- [ ] Team logo upload (Cloudflare R2)
- [ ] Flutter: Team creation/management screens
- [ ] Flutter: Team profile screen with stats

**Backend files to create:**

- `backend/app/models/team.py`
- `backend/app/schemas/team.py`
- `backend/app/services/team_service.py`
- `backend/app/api/teams.py`

**Flutter files to create:**

- `flutter/lib/models/team_model.dart`
- `flutter/lib/providers/team_provider.dart`
- `flutter/lib/screens/team/`

---

### Step 3.3: Advanced Player Statistics & Analytics

- [ ] Batting: Average, SR, HS, 50s, 100s, 4s, 6s per match/career
- [ ] Bowling: Average, Economy, SR, Best figures, 5-wicket hauls
- [ ] Fielding: Catches, Run outs, Stumpings
- [ ] Recent form: last 5/10 match performance graph
- [ ] Head-to-head: player vs player stats
- [ ] Career milestone tracking (first 50, first 100, etc.)
- [ ] Stats recalculation background job
- [ ] Flutter: Stats dashboard screen with charts
- [ ] Flutter: Performance graphs (line charts, bar charts)

**Files to create:**

- `backend/app/services/analytics_service.py`
- `flutter/lib/screens/stats/stats_dashboard_screen.dart`
- Add charting package to `pubspec.yaml` (`fl_chart` or `syncfusion_flutter_charts`)

---

### Step 3.4: PDF Scorecard Export

- [ ] Generate professional scorecard PDF from match data
- [ ] Include: batting card, bowling figures, fall of wickets, extras breakdown
- [ ] Match summary with result
- [ ] Player of the match highlight
- [ ] Downloadable from match detail screen
- [ ] Shareable as file attachment

**Files to create:**

- `backend/app/services/pdf_service.py` (use `reportlab` or `weasyprint`)
- `backend/app/api/exports.py`
- Flutter download integration

---

### Step 3.5: Push Notifications (FCM)

- [ ] Set up Firebase project
- [ ] Integrate FCM in Flutter (Android + iOS)
- [ ] Backend: send notifications via FCM API
- [ ] Notification types:
  - Match invitation
  - Match started (for spectators)
  - Wicket fallen
  - Milestone (50, 100 runs)
  - Match completed
  - Tournament update
- [ ] User notification preferences (opt-in/opt-out)
- [ ] Store FCM tokens in database

**Files to create/modify:**

- `backend/app/services/push_notification_service.py`
- `flutter/lib/services/notification_service.dart`
- `flutter/pubspec.yaml` (add `firebase_messaging`)

---

### Step 3.6: Social Sharing

- [ ] Share match scorecard as image (screenshot-like)
- [ ] WhatsApp share with match summary text
- [ ] Instagram Stories compatible image generation
- [ ] Share player stats card
- [ ] Deep link in shared content (opens app)
- [ ] "Join this match" via link

**Files to create:**

- `flutter/lib/services/share_service.dart`
- `flutter/lib/widgets/share/scorecard_image.dart`
- Add `share_plus` package

---

### Step 3.7: App Branding & Store Listing

- [ ] Design app icon (cricket-themed)
- [ ] Create splash screen
- [ ] Design store listing screenshots
- [ ] Write Play Store description
- [ ] Set up Google Play Console (free developer account: $25 one-time)
- [ ] Generate signed APK/AAB
- [ ] Submit to Play Store (closed beta first)

---

## Completion Checklist

- [ ] Tournament management works end-to-end
- [ ] Teams with rosters functional
- [ ] Player stats dashboard with charts
- [ ] PDF scorecards downloadable
- [ ] Push notifications working (Android)
- [ ] Social sharing functional
- [ ] App published on Play Store (beta)

## Estimated Effort

- **3.1 Tournaments**: 15-20 hours
- **3.2 Teams**: 8-12 hours
- **3.3 Analytics**: 10-15 hours
- **3.4 PDF Export**: 4-6 hours
- **3.5 Push Notifications**: 6-8 hours
- **3.6 Social Sharing**: 4-6 hours
- **3.7 App Branding**: 4-6 hours
- **Total: ~51-73 hours**
