# inSwing: Complete Project Context Document

**Last Updated:** November 14, 2025
**Project Status:** Pre-Development (Ready for TRAE SOLO Builder)
**Team:** Solo developer (you) + AI Builder (TRAE SOLO)

---

## Executive Summary

**inSwing** is a real-time, offline-first mobile and web application designed to democratize local cricket scoring and tournament management. It enables players, organizers, and enthusiasts to create instant matches, track live scores with ball-by-ball precision, manage player statistics, and build a discoverable talent pipeline from gully (local street cricket) to professional cricket.

**Vision:** Turn every local match into a shareable, tracked, and discoverable event with professional-grade analytics and community engagement.

**Target Users:**
- Local cricket players (pickup games, friendly matches)
- Match organizers and tournament hosts
- Cricket enthusiasts and spectators
- Talent scouts looking for emerging players
- Sports bars and ground managers tracking multiple matches

---

## Project Details

### Official Name
**inSwing** — A social + real-time scoring platform for local cricket

### Why "inSwing"?
- **Cricket terminology:** "In-swing" is a bowling technique where the ball moves towards the batsman
- **Metaphor:** Represents the movement of cricket from gully (grassroots) to mainstream
- **Branding:** Modern, memorable, easy to pronounce globally

---

## MVP Feature Set (Phase 1 - Weeks 1-4)

### Core Feature: Real-Time Match Scoring

#### 1. User Accounts & Authentication
- **Phone-based login:** Primary OTP verification via phone number
- **Secondary auth:** Google Sign-In (optional, for future phase)
- **JWT tokens:** 1-hour access token + 7-day refresh token
- **Secure storage:** flutter_secure_storage for token persistence
- **Roles:** Player, Host/Organizer, Viewer, Admin
- **User profiles:** Display name, avatar, bio, batting/bowling style

#### 2. Quick Match Creation & Management
- **One-tap quick match:** Host initiates match instantly
- **Team selection:** Manual team creation or import from contacts
- **Player management:** Add players by phone, invite via SMS, quick-add by name
- **Toss management:** Host records toss result (coin flip or decision)
- **Match settings:** Overs limit, powerplay rules, extras rules (customizable)
- **Venue tagging:** Text or GPS location of cricket ground
- **Match types:** Quick (ad-hoc), Friendly (organized), Tournament

#### 3. Ball-by-Ball Live Scoring
- **Host scoreboard:** One-tap buttons for common events (0, 1, 2, 3, 4, 6, W, NB, WD)
- **Detailed entry:** Full ball information (batsman, bowler, runs, extras, wickets)
- **Undo function:** Host can revert last ball (limited window)
- **Innings management:** Multiple innings support, innings completion
- **Real-time broadcast:** All connected clients see updates within <1 second
- **Scorecard display:** Live runs, wickets, overs, run rate, required rate

#### 4. Live Match Viewing (Public Read-Only)
- **Live spectator view:** Users can join as spectators (not affecting gameplay)
- **Match feed:** Ball-by-ball commentary, match events, player statistics
- **Live leaderboard:** Real-time player performance during match
- **Match search:** Discover live matches nearby or by tournament
- **Low-bandwidth mode:** Text-only view for poor connectivity

#### 5. Player Profiles & Statistics
- **Profile data:** Name, batting style, bowling style, dominant hand, teams
- **Career stats:** Total matches, total runs scored, total wickets, average, strike rate, economy rate
- **Match history:** Chronological list of all matches played
- **Performance trends:** Stats by match type, opponent type, seasonal
- **Verification badges:** For verified/elite players (future phase)

#### 6. Match History & Leaderboards
- **Match archive:** Searchable, filterable list of past matches
- **Local leaderboards:** Top players by city/pincode/region
- **Tournament leaderboards:** Standings for tournament matches
- **Multiple ranking systems:** Runs scored, wickets taken, average, strike rate
- **Period filters:** All-time, this month, this week, today

#### 7. Push Notifications
- **Match start alerts:** Notify players when match is scheduled to start
- **Innings change:** Alert when innings ends and new one begins
- **Player mentions:** Tag players in comments or highlights
- **Milestone alerts:** Notify on significant events (50 runs, 5-wicket haul, etc.)
- **Delivery method:** Firebase Cloud Messaging (FCM)

#### 8. Basic Social Features
- **Highlights:** Host can tag specific balls/events as highlights
- **Like & comment:** Users can like match highlights and add comments
- **Match feed:** Social-style feed of ongoing and completed matches
- **Trending highlights:** Discover popular moments across platform

#### 9. Admin Panel (Basic)
- **Report management:** View user reports of disputed matches
- **User management:** Verify users, manage profiles, handle complaints
- **Match moderation:** Validate scores, flag suspicious matches
- **Analytics dashboard:** Basic metrics (matches, users, active games)

---

## Technical Architecture

### Technology Stack

#### Frontend
- **Framework:** Flutter (Dart)
- **Target platforms:** Android, iOS, Web (all in MVP)
- **State management:** Riverpod for clean, testable state
- **Navigation:** go_router for declarative routing
- **HTTP client:** Dio with JWT interceptors
- **Local storage:** Hive or SQLite for offline caching
- **Secure storage:** flutter_secure_storage for tokens
- **WebSocket:** socket_io_client for real-time connections
- **Additional:** Camera for profile pictures, Maps for venue pinning

#### Backend
- **Framework:** FastAPI (Python 3.11+)
- **Server:** Uvicorn with Gunicorn for production
- **Real-time:** WebSockets (ASGI) + Redis Pub/Sub
- **Database:** MySQL 8.0 (primary relational DB)
- **ORM:** SQLAlchemy with Alembic migrations
- **Authentication:** JWT (python-jose) + OTP verification
- **Background jobs:** Celery or RQ with Redis broker
- **Caching:** Redis for session cache, pub/sub, rate limiting
- **API documentation:** Auto-generated via FastAPI/Swagger

#### Database
- **Primary:** MySQL 8.0 (relational data)
- **Cache:** Redis 7.0 (sessions, pub/sub, temporary data)
- **Future:** Read replicas for scaling, sharding by region

#### Infrastructure
- **Containerization:** Docker (API, worker, realtime services)
- **Dev environment:** Docker Compose (MySQL, Redis, FastAPI)
- **Orchestration:** Start with Docker Compose, scale to Kubernetes
- **CI/CD:** GitHub Actions (build → test → deploy)
- **Monitoring:** Prometheus + Grafana (future phase)
- **Logging:** Structured JSON logs → ELK or Loki
- **Storage:** AWS S3 or DigitalOcean Spaces for media
- **CDN:** CloudFront or Cloudflare for global delivery

---

## Data Model (Core Tables)

### 1. users
```
- id (UUID, PK)
- phone_number (string, unique)
- email (string, unique, nullable)
- full_name (string)
- avatar_url (string, nullable)
- bio (text, nullable)
- role (enum: 'player', 'admin')
- created_at (timestamp)
- updated_at (timestamp)
```

### 2. profiles (Player-Specific Data)
```
- id (UUID, PK)
- user_id (FK to users)
- batting_style (enum: 'right-handed', 'left-handed')
- bowling_style (enum: 'fast', 'spin', 'pace', 'none')
- dominant_hand (enum: 'right', 'left')
- total_matches (int, denormalized)
- total_runs (int, denormalized)
- total_wickets (int, denormalized)
- average_runs (float, denormalized)
- strike_rate (float, denormalized)
- economy_rate (float, denormalized)
- updated_at (timestamp)
```

### 3. matches
```
- id (UUID, PK)
- host_user_id (FK to users)
- match_type (enum: 'quick', 'friendly', 'tournament')
- team_a_name (string)
- team_b_name (string)
- venue (text)
- latitude (float, nullable)
- longitude (float, nullable)
- scheduled_at (timestamp, nullable)
- status (enum: 'created', 'toss_done', 'live', 'finished', 'cancelled')
- rules (JSON: overs, powerplay, extras rules)
- result (JSON: winner, mvp, final_scores, nullable)
- created_at (timestamp)
- updated_at (timestamp)
```

### 4. players_in_match
```
- id (UUID, PK)
- match_id (FK to matches)
- user_id (FK to users)
- team (enum: 'A', 'B')
- role (enum: 'batsman', 'bowler', 'allrounder', 'wicketkeeper')
- joined_at (timestamp)
```

### 5. innings
```
- id (UUID, PK)
- match_id (FK to matches)
- batting_team (enum: 'A', 'B')
- overs_allocated (int)
- runs (int, denormalized)
- wickets (int, denormalized)
- extras (int, denormalized)
- is_completed (boolean)
- created_at (timestamp)
- updated_at (timestamp)
```

### 6. balls (Ball-by-Ball Records)
```
- id (UUID, PK)
- innings_id (FK to innings)
- over_number (int)
- ball_in_over (int: 1-6)
- batsman_id (FK to users)
- non_striker_id (FK to users, nullable)
- bowler_id (FK to users)
- runs_off_bat (int, default 0)
- extras_type (enum: 'wide', 'no_ball', 'bye', 'legbye', null)
- extras_runs (int, default 0)
- wicket_type (enum: 'bowled', 'caught', 'runout', 'lbw', null)
- dismissal_info (JSON, nullable)
- created_at (timestamp, default now())
```

### 7. match_events (For Feed & Highlights)
```
- id (UUID, PK)
- match_id (FK to matches)
- event_type (enum: 'boundary', 'wicket', 'milestone', 'highlight', 'comment')
- meta (JSON: player_id, runs, description, timestamp)
- created_at (timestamp)
```

### 8. notifications
```
- id (UUID, PK)
- user_id (FK to users)
- notification_type (enum: 'match_start', 'wicket', 'milestone', 'mentioned', 'comment', 'system')
- payload (JSON: match_id, player_id, message, action_url)
- read_at (timestamp, nullable)
- created_at (timestamp)
```

### 9. otp_sessions
```
- id (UUID, PK)
- phone_number (string)
- otp_code (string)
- attempts (int, default 0)
- expires_at (timestamp)
- created_at (timestamp)
```

---

## Real-Time Architecture

### WebSocket Flow (Ball-by-Ball Updates)

1. **Host submits ball:** Host app sends `POST /matches/{id}/innings/{inning_id}/ball`
2. **Backend writes:** Ball record saved to MySQL within transaction
3. **Aggregation:** Innings runs/wickets updated atomically
4. **Redis publish:** Update published to `match:{match_id}:updates` channel
5. **WebSocket relay:** All connected clients receive update
6. **Client update:** Flutter app updates UI and local cache
7. **Latency target:** <500ms from host submission to all clients

### Pub/Sub Channels
- `match:{match_id}:updates` — Ball updates, innings changes, match events
- `match:{match_id}:events` — Wickets, milestones, highlights
- `user:{user_id}:notifications` — Personal notifications for user
- `leaderboard:{region}` — Regional leaderboard updates

### Offline-First Architecture

**Problem:** Cricket matches at gully grounds often have unreliable connectivity

**Solution:**
1. **Local queue:** Host queues ball updates in SQLite if offline
2. **Optimistic UI:** App shows update immediately while queuing
3. **Auto-sync:** When online, app syncs queued updates to server
4. **Idempotency:** Each update has `client_event_id` to prevent duplicates
5. **Reconciliation:** Server returns authoritative state after sync
6. **Fallback:** If sync fails, user can manually retry or redo entry

---

## API Surface (MVP Endpoints)

### Authentication
- `POST /auth/login` → Phone + password/OTP → JWT token
- `POST /auth/verify-otp` → Phone + OTP → JWT token
- `POST /auth/refresh` → Refresh token → New access token
- `POST /auth/logout` → Clear session

### User Management
- `POST /users` → Create user profile
- `GET /users/{id}/profile` → Get player profile + stats
- `PUT /users/{id}/profile` → Update profile info
- `GET /users/search` → Search players by name/skill

### Matches
- `POST /matches` → Create new match (host only)
- `GET /matches?status=live` → List live matches
- `GET /matches?status=completed` → List completed matches
- `GET /matches/{id}` → Get match details
- `POST /matches/{id}/toss` → Record toss result
- `PUT /matches/{id}/status` → Update match status (live, finished, etc.)
- `DELETE /matches/{id}` → Cancel match

### Innings
- `POST /matches/{id}/innings` → Create innings
- `GET /matches/{id}/innings` → List innings in match
- `PUT /matches/{id}/innings/{inning_id}` → Update innings (close, etc.)

### Ball Recording
- `POST /matches/{id}/innings/{inning_id}/ball` → Record new ball (idempotent)
- `GET /matches/{id}/innings/{inning_id}/balls` → Get all balls in innings
- `PUT /matches/{id}/innings/{inning_id}/balls/{ball_id}` → Undo/edit last ball

### Real-Time
- `GET /matches/{id}/live` → WebSocket endpoint for live updates
- `POST /matches/{id}/sync` → Offline sync endpoint (multiple events)

### Statistics & Leaderboards
- `GET /users/{id}/stats` → Player career statistics
- `GET /leaderboards?type=local&region=city` → Local leaderboards
- `GET /leaderboards?type=tournament&tournament_id=X` → Tournament leaderboards
- `GET /leaderboards?type=global` → Global leaderboards

### Highlights & Social
- `POST /matches/{id}/highlights` → Create highlight (tag ball/event)
- `POST /highlights/{id}/like` → Like a highlight
- `POST /highlights/{id}/comments` → Comment on highlight
- `GET /matches/{id}/feed` → Match feed (events + comments)

### Admin
- `GET /admin/reports` → List match dispute reports
- `PUT /admin/reports/{id}` → Resolve dispute
- `GET /admin/users` → Manage users
- `GET /admin/analytics` → Basic metrics

---

## MVP UX Flow

### Quick Match Flow (Target: <60 seconds)
1. User taps "Quick Match"
2. Choose team names (or random)
3. Select/invite players (from contacts or add manually)
4. Confirm toss → Match live
5. Start scoring

### Host Scoring Interface
1. Large, clear scorecard display
2. One-tap buttons for common events (0, 1, 2, 3, 4, 6)
3. Toggle for runs (byes, leg-byes)
4. Wicket button with type selector
5. No-ball and wide buttons
6. Current over summary (last 6 balls)
7. Undo button (last 5 balls, within 30 seconds)
8. End innings button

### Spectator View
1. Match list with filters (live, completed, nearby, tournament)
2. Live score display (large runs/wickets)
3. Ball-by-ball commentary
4. Player stats for current batsman/bowler
5. Real-time run rate, required rate
6. Ability to like/comment on highlights

### Player Profile
1. Player name, photo, role
2. Career statistics (matches, runs, wickets, average, SR, ER)
3. Recent match performance
4. Batting/bowling style indicators
5. Teams player belongs to (if organized)

---

## Security & Privacy

### Authentication & Authorization
- JWT tokens with 1-hour expiry
- Refresh tokens stored securely (device only)
- Role-based access control (host, player, viewer)
- API endpoint authorization checks

### Data Privacy
- Phone numbers: Never displayed publicly (only to contacts)
- Email: Optional, never shared
- User location: Only shared during active match (ground venue)
- Data deletion: Users can request deletion of all data

### HTTPS & Encryption
- All endpoints HTTPS only
- TLS 1.3 minimum
- Certificate pinning (future phase)
- Data at rest encryption (database, backups)

### Rate Limiting
- API rate limiting to prevent spam
- OTP attempts limited to 3 per phone per hour
- Match creation rate limited to prevent abuse

### Input Validation
- Server-side validation for all inputs
- XSS prevention in comments/highlights
- SQL injection prevention via ORM
- CSRF protection for state-changing operations

---

## Offline & Unreliable Network Handling

### Problem
Cricket is played in places with poor cellular connectivity.

### Solution

**Offline Queue (Flutter Side)**
- Host queues ball updates in local SQLite if offline
- Each update tagged with `client_event_id` (UUID)
- UI shows "pending" status until confirmed
- Auto-retry when connectivity returns

**Sync Endpoint (Backend)**
```
POST /matches/{id}/sync
Body: [
  { client_event_id, innings_id, ball_data, timestamp },
  ...
]
Response: { 
  success: true, 
  synced_count: X, 
  conflicts: [], 
  authoritative_state: {...} 
}
```

**Idempotency**
- Server stores `client_event_id` to prevent duplicate processing
- Duplicate submissions return same response as first request
- No duplicates appear in final scorecard

**Reconciliation**
- If sync conflict detected (e.g., duplicate ball), server resolves
- Client receives authoritative state and reconciles local cache
- User is notified if changes were made by system

**Optimization**
- Queue syncs every 30 seconds automatically when online
- Users can manually "Sync Now" button
- Aggressive reconnection attempts (exponential backoff)

---

## Future Roadmap

### Phase 2 (After MVP) — Advanced Scoring & Tournaments
- **Detailed ball-by-ball views:** Pitch map, ball trajectory tracking
- **Tournament brackets:** Bracket management, auto-scheduling
- **Tournament modes:** Pool play, knockout, group stages
- **Improved leaderboards:** Tournament-specific standings, head-to-head
- **Player verification:** ID verification for official tournaments
- **Highlight uploads:** Video clips of boundaries, wickets
- **Advanced search:** Filter players by skill, location, availability

### Phase 3 — Monetization & Premium Features
- **Premium subscriptions:** Ad-free, advanced stats, verified badge
- **Tournament listings:** Paid tournament hosting fees
- **Sponsorships:** Branded tournaments, sponsor highlights
- **Advertising:** Interstitial ads, rewarded video ads
- **Payments:** Razorpay/Paytm integration for Indian market

### Phase 4 — Professional Integration
- **Scout feed:** Talent pipeline for professional scouts
- **Video streaming:** Live stream matches to web
- **Advanced analytics:** Heat maps, performance trends, AI recommendations
- **Stats API:** Public API for sports websites, broadcasters
- **Team management:** Organizations can manage teams, tournaments

### Phase 5 — Social & Gamification
- **Social feed:** Timeline of friends' matches, achievements
- **Achievements:** Badges for milestones (100 runs, 5-wicket haul, etc.)
- **Fantasy leagues:** Fantasy cricket integration
- **Challenges:** Head-to-head player challenges
- **Live streaming:** Watch matches on web/TV

### Phase 6 — Enterprise Features
- **Enterprise API:** Cricket management systems for clubs
- **White-label:** Customizable branding for organizations
- **Multi-ground:** Organizations manage multiple grounds
- **Subscription management:** Manage multiple tournaments
- **Reporting:** Detailed analytics and reporting tools

---

## Success Metrics (MVP)

### Engagement Metrics
- DAU (Daily Active Users): Target 1,000+ by end of Month 1
- WAU (Weekly Active Users): Target 5,000+ by end of Month 1
- Session length: Average 30+ minutes
- Match completion rate: 95%+ of created matches completed

### Retention Metrics
- Day 1 retention: 40%+ (most casual users)
- Day 7 retention: 25%+ (core players)
- Day 30 retention: 15%+ (league players)

### Data Accuracy
- Scorecard accuracy: 99%+ (manual verification)
- Data discrepancies: <1% disputed

### Performance Metrics
- API response time: <200ms p99
- WebSocket latency: <500ms ball-to-display
- App load time: <3 seconds
- Uptime: 99.5%+

---

## Development Timeline

### Week 1: TRAE SOLO Builder
- Day 1: Run TRAE SOLO Builder with all 7 prompts
- Day 2: Test, integrate, and document foundation
- Days 3-5: Fix SOLO output, add manual touches

### Week 2: Real-Time Implementation
- Days 1-2: Redis Pub/Sub integration
- Days 2-3: Ball recording + WebSocket flow
- Days 4-5: Flutter WebSocket client

### Week 3: Robustness & Polish
- Days 1-2: Error handling and recovery
- Days 2-3: Offline queue sync implementation
- Days 3-5: UI/UX polish and optimization

### Week 4: Testing & Launch
- Days 1-2: Comprehensive testing
- Day 3: Cloud deployment
- Days 4-5: Beta launch and monitoring

**Total: ~4 weeks to production MVP**

---

## Team & Roles

### Development Team
- **Solo Developer (You):** Full-stack architect and implementer
  - Flutter app: UI, state management, offline sync
  - FastAPI backend: API design, database, real-time logic
  - DevOps: Docker, CI/CD, deployment
  - Testing: QA, manual testing, bug fixing

### External Dependencies
- **TRAE SOLO Builder:** MVP scaffold generation (Week 1, Days 1-2)
- **Third-party services:**
  - OTP provider: Twilio, MSG91, or 2Factor (India)
  - Push notifications: Firebase Cloud Messaging (FCM)
  - File storage: AWS S3 or DigitalOcean Spaces
  - Cloud deployment: Railway, AWS, or GCP
  - Monitoring: Sentry (error tracking)

---

## Critical Assumptions

1. **Connectivity:** While targeting offline-first, assume average connectivity in target markets
2. **Device:** Target modern smartphones (Android 10+, iOS 14+)
3. **Scale:** MVP assumes <10,000 concurrent matches (sharding for growth)
4. **Geography:** MVP focuses on India (OTP, payment, local features)
5. **Users:** Initial focus on casual/friendly cricket (not professional leagues initially)

---

## Known Risks & Mitigations

| Risk | Severity | Mitigation |
|------|----------|-----------|
| Network unreliability | High | Offline queue + client-side retry logic |
| Fake scores/cheating | Medium | Host verification, match reports, dispute resolution |
| Data corruption | High | Idempotency, database constraints, audit logs |
| Server overload | Medium | Redis caching, database read replicas, horizontal scaling |
| User adoption | Medium | Viral features (highlights, social), local marketing, influencers |
| Data growth | Low | Database partitioning, archival of old matches, separate OLAP |

---

## Deployment Checklist

### Pre-Launch (Week 4)
- [ ] All tests passing (unit, integration, E2E)
- [ ] Load testing successful (100+ concurrent matches)
- [ ] Security audit completed
- [ ] Database backups automated
- [ ] Monitoring and alerting set up
- [ ] App Store + Google Play screenshots ready
- [ ] Privacy policy and terms drafted
- [ ] Customer support process defined

### Launch Day
- [ ] Deploy backend to production
- [ ] Deploy Flutter app to App Store and Google Play
- [ ] Run smoke tests on production
- [ ] Enable gradual rollout (10% → 50% → 100%)
- [ ] Monitor dashboards for anomalies
- [ ] Customer support team on standby

### Post-Launch (Week 1 after MVP)
- [ ] Gather user feedback
- [ ] Fix critical bugs
- [ ] Optimize performance based on real usage
- [ ] Plan Phase 2 features
- [ ] Expand to additional markets (if successful)

---

## Key Constraints & Preferences

### Technical Constraints
- **Tech stack locked:** Flutter + FastAPI + MySQL (as specified)
- **Real-time:** WebSockets required (not polling)
- **Offline-first:** Essential for cricket grounds
- **Mobile-first:** Web secondary to iOS/Android

### Timeline Constraints
- **MVP deadline:** 4 weeks (SOLO + manual work)
- **SOLO phase:** 2 days maximum
- **Manual phase:** 3 weeks (prioritize real-time)

### Business Constraints
- **Target market:** India (initially), English-speaking users
- **Monetization:** Free MVP, premium features later
- **Geographic focus:** Urban areas with active cricket culture
- **Device support:** Android 10+, iOS 14+, Web

---

## Communication Guidelines for AI Builder

### For TRAE SOLO Builder Prompts
1. **Be explicit:** Each prompt includes exact table schemas, field names, and relationships
2. **No assumptions:** Avoid "optional features" — only ask for MVP features
3. **Data model is gospel:** Database schema is the source of truth
4. **Architecture given:** Don't redesign, follow the specified tech stack
5. **Code quality matters:** Ask SOLO for proper error handling, comments, type hints

### For Manual Development (Weeks 2-4)
1. **Feature completion over perfection:** Prioritize real-time + offline
2. **Test as you go:** Don't wait until end for testing
3. **Document decisions:** Keep architecture docs updated
4. **Git discipline:** Meaningful commits, clear PRs
5. **Performance mindset:** Think about scalability from day one

### For Questions/Clarifications
- Refer back to this context.md file
- If something is ambiguous, ask for clarification (don't assume)
- If requirements change, update this document first
- Keep decision log (why certain choices were made)

---

## Success Definition

### MVP Success Criteria
- ✅ App launches without crashing (5+ hours continuous play)
- ✅ Login works end-to-end (phone → OTP → home)
- ✅ Can create match and add players in <60 seconds
- ✅ Ball-by-ball scoring works for 4+ complete innings
- ✅ Real-time updates appear on all devices <500ms
- ✅ App remains usable with poor connectivity (offline mode)
- ✅ Database handles 1,000+ concurrent users without degradation
- ✅ Scorecard accuracy matches manual verification
- ✅ Code is production-ready (proper error handling, logging)
- ✅ Deployable to cloud with zero-downtime updates

### Launch Success Criteria
- ✅ 100+ users in first week
- ✅ Average session length >20 minutes
- ✅ Bug report rate <1% of sessions
- ✅ 90%+ of created matches completed
- ✅ <2% data discrepancies reported
- ✅ Uptime >99% (excluding planned maintenance)
- ✅ No critical security issues reported
- ✅ User feedback is positive (NPS >40)

---

## Important Notes for AI Builder

### When Using This Context
1. **Read the entire document first** before starting any coding
2. **Reference section numbers** when discussing specific parts (e.g., "See Data Model Section for users table")
3. **If something contradicts this document, flag it immediately**
4. **Update this document if MVP scope changes**
5. **Keep decision rationale documented**

### What This Document Covers
- ✅ Complete app specification
- ✅ Data model and relationships
- ✅ API endpoints and flows
- ✅ Technical architecture and stack
- ✅ Security and privacy requirements
- ✅ Offline and real-time architecture
- ✅ UX flows and success metrics

### What This Document Does NOT Cover
- ❌ UI/UX design mockups (you'll design)
- ❌ Exact implementation details (SOLO will generate)
- ❌ Specific code patterns (follow industry standards)
- ❌ Cloud infrastructure (will be decided during deployment)

---

## Appendix: Cricket Terminology

For non-cricket developers, here's quick terminology to understand the app:

- **Over:** Set of 6 balls bowled by one bowler
- **Innings:** One team's chance to bat (usually 2 innings per match)
- **Batsman:** Player currently batting
- **Bowler:** Player throwing the ball
- **Runs:** Points scored (0, 1, 2, 3, 4, or 6)
- **Wicket:** When a batsman is dismissed (out)
- **Wide ball:** Ball thrown outside playable area (1 extra run)
- **No-ball:** Illegal delivery (1 extra run)
- **Bye/Leg-bye:** Runs scored without ball hitting bat
- **Powerplay:** First 6 overs with fielding restrictions
- **Run rate:** Runs scored per over
- **Strike rate:** Runs per 100 balls faced (batting stat)
- **Economy rate:** Runs per over given up (bowling stat)

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Nov 14, 2025 | Solo Developer | Initial context document for TRAE SOLO builder |
| | | | - MVP features defined |
| | | | - Technical architecture specified |
| | | | - Data model finalized |
| | | | - Real-time architecture designed |
| | | | - Future roadmap outlined |

---

**Document Version:** 1.0
**Last Updated:** November 14, 2025, 8:52 PM IST
**Status:** Ready for TRAE SOLO Builder
**Next Step:** Use this document when inputting prompts to TRAE SOLO
