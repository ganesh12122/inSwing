# 💰 Phase 4: Monetization

> **Status:** ⚪ NOT STARTED
> **Timeline:** Week 9-12
> **Depends on:** Phase 3 completion
> **Goal:** Turn users into revenue with zero upfront investment

---

## Steps

### Step 4.1: Google AdMob Integration

- [ ] Create AdMob account (free)
- [ ] Create ad units: Banner, Interstitial, Rewarded
- [ ] Add `google_mobile_ads` to Flutter
- [ ] Show banner ad on home screen (free tier users)
- [ ] Show interstitial ad between matches
- [ ] Show rewarded ad to unlock premium features temporarily
- [ ] Respect user privacy (GDPR/consent)
- [ ] Premium users: no ads

**Ad Placement Strategy:**
| Screen | Ad Type | Frequency |
|--------|---------|-----------|
| Home (match list) | Banner (bottom) | Always |
| Match detail | Banner (bottom) | Always |
| After match completion | Interstitial | Every 3rd match |
| Unlock advanced stats | Rewarded | On demand |
| Unlock PDF export | Rewarded | On demand |

**Files to create/modify:**

- `flutter/lib/services/ad_service.dart`
- `flutter/lib/providers/subscription_provider.dart`
- `flutter/pubspec.yaml`

---

### Step 4.2: Premium Subscription System

- [ ] Design subscription plans:
  - **Free**: Basic scoring, 10 match history, ads
  - **Pro** ($2/month): Unlimited history, no ads, PDF export, advanced stats
  - **Team** ($5/month): Pro + tournament management, team features, multiple scorers
- [ ] Backend: subscription model & API
- [ ] Integrate Razorpay (India) or Stripe (global) — both free to set up
- [ ] In-app purchase flow (Google Play Billing)
- [ ] Subscription status check middleware
- [ ] Feature gating based on plan
- [ ] Grace period for expired subscriptions
- [ ] Receipt validation (server-side)

**Backend files to create:**

- `backend/app/models/subscription.py`
- `backend/app/schemas/subscription.py`
- `backend/app/services/payment_service.py`
- `backend/app/api/subscriptions.py`
- `backend/app/middleware/subscription_check.py`

**Flutter files to create:**

- `flutter/lib/models/subscription_model.dart`
- `flutter/lib/providers/subscription_provider.dart`
- `flutter/lib/screens/subscription/plans_screen.dart`
- `flutter/lib/screens/subscription/checkout_screen.dart`

---

### Step 4.3: Referral Program

- [ ] Generate unique referral codes per user
- [ ] Track referrals (who invited whom)
- [ ] Reward: 1 month free Pro for both referrer and referee
- [ ] Referral dashboard (how many invited, status)
- [ ] Share referral link via WhatsApp/SMS
- [ ] Deep link: referral code in URL

**Files to create:**

- `backend/app/models/referral.py`
- `backend/app/services/referral_service.py`
- `backend/app/api/referrals.py`
- `flutter/lib/screens/referral/referral_screen.dart`

---

### Step 4.4: Analytics Dashboard (PostHog)

- [ ] Integrate PostHog SDK (free: 1M events/month)
- [ ] Track key events:
  - User signup
  - Match created/completed
  - Subscription purchased/cancelled
  - Feature usage (scoring, stats, tournaments)
  - App open/close
  - Screen views
- [ ] Set up funnels:
  - Signup → First Match → Complete Match → Return
  - Free → View Premium → Purchase
- [ ] Create dashboards for business metrics

**Files to modify:**

- `flutter/lib/services/analytics_service.dart` (new)
- Integration in key screens/providers

---

### Step 4.5: Production Deployment

- [ ] Set up Neon PostgreSQL (production)
- [ ] Deploy backend to Railway/Render
- [ ] Deploy web to Vercel
- [ ] Set up Upstash Redis
- [ ] Set up Cloudflare R2 (file storage)
- [ ] Configure custom domain (optional)
- [ ] Set up SSL (automatic)
- [ ] Configure CORS for production domains
- [ ] Set up Sentry (error tracking)
- [ ] Set up GitHub Actions CI/CD pipeline
- [ ] Create staging environment
- [ ] Load testing (basic)

---

### Step 4.6: Performance Optimization

- [ ] Backend: add Redis caching for leaderboards, match lists
- [ ] Backend: database query optimization (N+1 queries)
- [ ] Backend: add database connection pooling
- [ ] Flutter: image caching and optimization
- [ ] Flutter: lazy loading for lists
- [ ] Flutter: minimize rebuild scope
- [ ] API response < 500ms (p95)
- [ ] App startup < 2 seconds

---

### Step 4.7: Security Audit

- [ ] Rotate all secrets (JWT key, API keys)
- [ ] Verify CORS is restrictive
- [ ] Verify rate limiting works
- [ ] Test for SQL injection
- [ ] Test for XSS
- [ ] Test for auth bypass
- [ ] Verify token expiration works
- [ ] Verify refresh token rotation
- [ ] Review file upload security
- [ ] HTTPS enforced everywhere

---

### Step 4.8: Public Launch

- [ ] Publish on Google Play Store (production)
- [ ] Submit to Apple App Store (if applicable)
- [ ] Create landing page (Vercel)
- [ ] Social media presence (Instagram, Twitter)
- [ ] First marketing push (cricket communities, WhatsApp groups)
- [ ] Monitor metrics closely for first week
- [ ] Rapid bug fix cycle

---

## Revenue Projections (Conservative)

### Month 1-3 (Beta)

- 500-1000 users
- 0 revenue (building user base)
- Focus: retention and word-of-mouth

### Month 4-6

- 2000-5000 users
- ~$50-200/month (ads + early subscriptions)
- 2-3% conversion rate

### Month 7-12

- 10,000-25,000 users
- ~$500-2000/month
- 5% conversion rate, growing ad revenue

### Year 2+

- 50,000+ users
- ~$5000-10,000/month
- Multiple revenue streams active

---

## Completion Checklist

- [ ] Ads showing correctly (non-intrusive)
- [ ] Subscription flow working E2E
- [ ] Payment processing verified
- [ ] Referral system tracking correctly
- [ ] Analytics capturing all key events
- [ ] Production deployed and stable
- [ ] Performance targets met
- [ ] Security audit passed
- [ ] App live on Play Store
- [ ] First paying customers 🎉

## Estimated Effort

- **4.1 AdMob**: 4-6 hours
- **4.2 Subscriptions**: 12-16 hours
- **4.3 Referrals**: 4-6 hours
- **4.4 Analytics**: 3-4 hours
- **4.5 Deployment**: 6-8 hours
- **4.6 Performance**: 6-8 hours
- **4.7 Security**: 4-6 hours
- **4.8 Launch**: 4-6 hours
- **Total: ~43-60 hours**
