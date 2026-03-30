# 🗺️ inSwing — Development Roadmap

## Overview

This roadmap takes inSwing from its current prototype state to a **commercial-grade, revenue-generating product** through 4 phases.

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEVELOPMENT TIMELINE                         │
│                                                                 │
│  Phase 1          Phase 2          Phase 3          Phase 4     │
│  Fix Foundation   Core Polish      Growth Features  Monetize    │
│  ──────────────   ──────────────   ──────────────   ────────── │
│  Week 1-2         Week 3-4         Week 5-8         Week 9-12  │
│                                                                 │
│  ✦ PostgreSQL     ✦ Model sync     ✦ Tournaments    ✦ AdMob    │
│  ✦ Async DB       ✦ E2E scoring    ✦ Teams          ✦ Premium  │
│  ✦ Fix bugs       ✦ OTP delivery   ✦ Analytics      ✦ Payments │
│  ✦ Service layer  ✦ Rate limiting  ✦ PDF export     ✦ Referral │
│  ✦ Tests          ✦ Offline sync   ✦ Push notifs    ✦ Launch   │
│  ✦ Security       ✦ Share links    ✦ Social share   ✦ Monitor  │
│                                                                 │
│  STATUS: 🔴       STATUS: ⚪       STATUS: ⚪       STATUS: ⚪ │
│  NOT STARTED      NOT STARTED      NOT STARTED      NOT STARTED │
└─────────────────────────────────────────────────────────────────┘
```

## Phase Details

### Phase 1: Fix Foundation (Week 1-2) — 🔴 NOT STARTED

> Make the codebase correct, secure, and deployable.

See: [phase-1-fix-foundation/README.md](./phase-1-fix-foundation/README.md)

**Goals:**

- Migrate MySQL → PostgreSQL
- Make database truly async
- Fix all broken code (imports, column names, auth)
- Add service layer
- Write real tests
- Remove hardcoded secrets
- Remove `create_all()`, use Alembic only

**Exit Criteria:**

- [ ] All tests pass
- [ ] Backend runs on PostgreSQL
- [ ] No hardcoded secrets in code
- [ ] All API endpoints functional
- [ ] Alembic migrations run cleanly

---

### Phase 2: Core Product Polish (Week 3-4) — ⚪ NOT STARTED

> Make the product usable end-to-end.

See: [phase-2-core-polish/README.md](./phase-2-core-polish/README.md)

**Goals:**

- Sync Flutter models with backend schemas
- Complete live scoring flow E2E
- Implement OTP delivery (Firebase Auth / MSG91)
- Add rate limiting
- Implement offline sync properly
- Shareable match links
- Error handling improvements

**Exit Criteria:**

- [ ] Can create match → score → complete on mobile
- [ ] OTP works with real phone numbers
- [ ] Offline scoring syncs correctly
- [ ] Match links shareable via WhatsApp
- [ ] Rate limiting prevents abuse

---

### Phase 3: Growth Features (Week 5-8) — ⚪ NOT STARTED

> Build features that differentiate us and drive user acquisition.

See: [phase-3-growth-features/README.md](./phase-3-growth-features/README.md)

**Goals:**

- Tournament management (brackets, groups, knockouts)
- Team management (rosters, team stats)
- Advanced player statistics & analytics
- PDF scorecard export
- Push notifications (FCM)
- Social sharing (WhatsApp, Instagram Stories)
- App icon, splash screen, store listing

**Exit Criteria:**

- [ ] Can create and manage a tournament
- [ ] Teams with rosters work
- [ ] PDF scorecards downloadable
- [ ] Push notifications for match events
- [ ] App published on Play Store (beta)

---

### Phase 4: Monetization (Week 9-12) — ⚪ NOT STARTED

> Turn users into revenue.

See: [phase-4-monetization/README.md](./phase-4-monetization/README.md)

**Goals:**

- Google AdMob integration (free tier ads)
- Premium subscription (Razorpay/Stripe)
- In-app purchase flow
- Referral program
- Analytics dashboard (PostHog)
- Production deployment
- Performance optimization
- Security audit

**Exit Criteria:**

- [ ] Ads showing in free tier
- [ ] Premium subscription purchasable
- [ ] Referral tracking works
- [ ] Deployed to production (all free tiers)
- [ ] <2s page load times
- [ ] Zero known security vulnerabilities

---

## Success Metrics

### Phase 1 (Foundation)

- 0 critical bugs
- 80%+ test coverage on backend
- Clean Alembic migration history

### Phase 2 (Polish)

- End-to-end match completion in <5 minutes
- <500ms API response times
- Offline scoring works for 50+ balls

### Phase 3 (Growth)

- 100 beta users
- 50 matches scored
- 5 tournaments created
- 4.0+ Play Store rating

### Phase 4 (Monetization)

- 1000 users
- 5% conversion to premium
- $100/month revenue
- <0.1% error rate
