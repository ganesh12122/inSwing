# 🏏 inSwing — Project Overview

## What is inSwing?

**inSwing** is a commercial-grade, real-time cricket scoring and tournament management platform built for:

- 🏟️ **Gully cricket players** who want to track their matches professionally
- 🏆 **Club/league organizers** who need tournament management
- 📊 **Semi-professional cricketers** who want career statistics
- 👥 **Cricket communities** who want leaderboards and social features

## The Problem We Solve

Cricket is the most popular sport in South Asia with **billions** of fans, yet:

1. Most informal/gully matches have **zero record-keeping**
2. Existing apps (CricHeroes, CricClubs) are **bloated, slow, or paid**
3. Players have **no way to build a cricket portfolio** from local matches
4. Tournament organizers use **WhatsApp groups and paper** to manage events

## Our Solution

inSwing provides:

- ⚡ **Instant match setup** — Create a match in under 30 seconds
- 📱 **Ball-by-ball live scoring** — Works offline, syncs when connected
- 📊 **Automatic statistics** — Batting avg, strike rate, economy rate auto-calculated
- 🏆 **Tournament brackets** — Round-robin, knockout, and group stage support
- 🔗 **Shareable scorecards** — Share live match links via WhatsApp/Instagram
- 📈 **Player profiles** — Build your cricket resume from local matches
- 🏅 **Leaderboards** — Compare with players in your area

## Business Model

### Free Tier (User Acquisition)

- Create & score unlimited quick matches
- Basic player profile & stats
- View leaderboards
- Match history (last 10 matches)

### Premium Tier ($2-5/month or $20-50/year)

- Tournament management (brackets, scheduling)
- Advanced analytics (wagon wheel, pitch map, Manhattan charts)
- Unlimited match history
- PDF scorecard exports
- Team management & rosters
- Priority support
- Ad-free experience
- Custom match rules
- Multiple scorers per match

### Revenue Streams

1. **Subscriptions** — Premium individual & team plans
2. **Advertisements** — Google AdMob in free tier
3. **Tournament Fees** — Commission on paid tournament entries
4. **Data Licensing** — Anonymized cricket analytics (future)

## Target Market

| Segment                           | Size | Priority     |
| --------------------------------- | ---- | ------------ |
| Indian gully cricket players      | 50M+ | 🔴 Primary   |
| Club/league cricketers (India)    | 5M+  | 🔴 Primary   |
| Cricket communities (India)       | 10M+ | 🟡 Secondary |
| International cricket communities | 20M+ | 🟢 Tertiary  |

## Competitive Landscape

| App                | Strengths                     | Weaknesses                                  | Our Advantage             |
| ------------------ | ----------------------------- | ------------------------------------------- | ------------------------- |
| CricHeroes         | Large user base, feature-rich | Slow, cluttered UI, aggressive monetization | Faster, cleaner UX        |
| CricClubs          | Good tournament management    | Complex setup, US-focused                   | Simpler, India-first      |
| Cricbuzz           | Live pro matches              | No amateur scoring                          | We serve amateur cricket  |
| Score Counter apps | Simple                        | No cricket-specific features                | Purpose-built for cricket |

## Tech Stack Summary

| Layer            | Technology        | Why                               |
| ---------------- | ----------------- | --------------------------------- |
| Backend API      | Python FastAPI    | Async, fast, auto-docs            |
| Database         | PostgreSQL (Neon) | Free tier, reliable               |
| Cache            | Redis (Upstash)   | Free tier, fast                   |
| Frontend         | Flutter (Dart)    | Cross-platform: iOS, Android, Web |
| State Management | Riverpod          | Type-safe, testable               |
| Auth             | Phone OTP + JWT   | No passwords needed               |
| Real-time        | WebSocket         | Live scoring updates              |
| Storage          | Hive (local)      | Offline-first support             |

## Zero Investment Deployment

| Service            | Provider                 | Free Tier                  |
| ------------------ | ------------------------ | -------------------------- |
| Database           | Neon PostgreSQL          | 0.5GB storage, always free |
| Backend            | Railway / Render         | 500 hrs/month              |
| Cache              | Upstash Redis            | 10K commands/day           |
| File Storage       | Cloudflare R2            | 10GB free                  |
| SMS/OTP            | Firebase Auth            | 10K verifications/month    |
| Push Notifications | Firebase Cloud Messaging | Unlimited                  |
| Web Hosting        | Vercel                   | Unlimited                  |
| CI/CD              | GitHub Actions           | 2000 min/month             |
| Error Tracking     | Sentry                   | 5K events/month            |
| Analytics          | PostHog                  | 1M events/month            |
| Payments           | Razorpay                 | No setup cost              |
