# inSwing — Complete Design System & App Blueprint

> Use this document as a prompt for Google Stitch (or any design tool) to generate consistent, production-grade UI designs for the inSwing cricket scoring platform.

---

## 1. BRAND IDENTITY

| Property | Value |
|----------|-------|
| **App Name** | inSwing |
| **Tagline** | Professional Cricket Scoring |
| **Logo** | "iS" mark in a rounded badge (accent green on dark) |
| **Tone** | Professional, sporty, modern. Think Cricbuzz meets EA Sports |
| **Audience** | Semi-professional cricketers, club players, local tournament organizers |
| **Platform** | Mobile-first responsive web app (PWA), later native apps |

---

## 2. COLOR SYSTEM

### Dark Theme (Primary — default)

| Token | Hex | Usage |
|-------|-----|-------|
| `--bg-deep` | `#0C1821` | Page background, app shell |
| `--bg-mid` | `#162029` | Cards, panels, modal backgrounds |
| `--bg-surface` | `#1E2D3D` | Elevated surfaces, inputs, dropdowns |
| `--text-primary` | `#E8ECF1` | Headings, body text |
| `--text-muted` | `#7A8B9A` | Secondary text, labels, hints |
| `--line` | `#2A3A4A` | Borders, dividers, separators |
| `--accent` | `#1B8A4A` | Primary buttons, CTAs, active states (cricket green) |
| `--accent-strong` | `#22C55E` | Hover states, highlights, badges |
| `--danger` | `#EF4444` | Errors, destructive actions, LIVE indicators |
| `--warning` | `#F59E0B` | Warnings, pending states |
| `--info` | `#3B82F6` | Informational badges, links |

### Status Colors

| Status | Color | Context |
|--------|-------|---------|
| LIVE | `#EF4444` (red) + pulse animation | Active match indicator |
| Created | `#7A8B9A` (muted) | Match not started |
| Invited | `#F59E0B` (amber) | Pending invitation |
| Accepted | `#3B82F6` (blue) | Invitation accepted |
| Teams Ready | `#22C55E` (green) | Both teams ready |
| Finished | `#7A8B9A` (muted) | Match complete |

---

## 3. TYPOGRAPHY

| Element | Font | Weight | Size |
|---------|------|--------|------|
| Headings (H1) | Inter | 700 (Bold) | 28-32px |
| Headings (H2) | Inter | 700 | 22-24px |
| Headings (H3) | Inter | 600 (Semibold) | 18px |
| Body | Inter | 400 (Regular) | 14-16px |
| Small/Labels | Inter | 500 (Medium) | 12px |
| Monospace/Scores | JetBrains Mono | 700 | 24-48px |

---

## 4. SPACING & LAYOUT

| Property | Value |
|----------|-------|
| Border radius (cards) | `8px` (rounded-lg) |
| Border radius (buttons) | `8px` |
| Border radius (badges) | `4px` (rounded) |
| Card padding | `24px` (p-6) |
| Section gaps | `24px` (gap-6) |
| Max content width | `1200px` |
| Mobile breakpoint | `< 768px` |

---

## 5. COMPONENT LIBRARY

### Buttons
- **Primary**: `bg-accent`, white text, hover `bg-accent-strong`, rounded-lg, font-semibold
- **Secondary**: `bg-bg-surface`, text-primary, border-line, hover border-accent
- **Danger**: `bg-red-600`, white text
- **Ghost**: transparent, text-muted, hover text-primary

### Cards
- Background: `bg-mid`
- Border: `1px solid var(--line)`
- Padding: `24px`
- Radius: `8px`

### Inputs
- Background: `bg-surface`
- Border: `1px solid var(--line)`
- Focus: `border-accent` + subtle glow
- Placeholder: `text-muted`
- Radius: `8px`
- Height: `40px`

### Badges/Status Pills
- Small: `px-2 py-0.5 text-xs font-medium rounded`
- Colors vary by status (see Status Colors above)

### Navigation
- Fixed top header with "iS" logo badge
- Nav items as pills: active = `bg-accent/10 text-accent-strong`, inactive = `text-muted hover:text-primary`

---

## 6. APP SCREENS & FLOW

### Screen Map (Complete Vision)

```
┌─────────────────────────────────────────────────────────────┐
│                    AUTH FLOW                                  │
│                                                              │
│  ┌──────────────────┐                                        │
│  │   Auth Screen    │  - Clean white/dark split              │
│  │   (Landing)      │  - inSwing logo + avatar              │
│  │                  │  - "Login" / "Register" only           │
│  └────────┬─────────┘                                        │
│           │                                                  │
│  ┌────────▼─────────┐     ┌──────────────────┐              │
│  │  Login Form      │────▶│  Dashboard       │              │
│  │  (phone + pass)  │     │                  │              │
│  └──────────────────┘     └──────────────────┘              │
│  ┌──────────────────┐                                        │
│  │  Register Form   │  - Name, email, phone, password        │
│  │  → Profile Setup │  - Then batting/bowling style          │
│  └──────────────────┘                                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   MAIN APP (Authenticated)                    │
│                                                              │
│  ┌──────────────────┐                                        │
│  │   Dashboard      │  - Welcome header with user name       │
│  │                  │  - Stats cards (matches, runs, wkts)   │
│  │                  │  - Live matches list                    │
│  │                  │  - Recent matches                       │
│  │                  │  - Quick "New Match" CTA               │
│  └──────────────────┘                                        │
│                                                              │
│  ┌──────────────────┐                                        │
│  │   Profile        │  - User avatar + name                  │
│  │                  │  - Cricket identity (bat/bowl style)    │
│  │                  │  - User ID (shareable, searchable)     │
│  │                  │  - Career stats                         │
│  │                  │  - Match history                        │
│  └──────────────────┘                                        │
│                                                              │
│  ┌──────────────────┐                                        │
│  │   Connections    │  - Search players by ID/name            │
│  │   (Friends)      │  - Friend requests sent/received       │
│  │                  │  - Connections list with quick invite   │
│  │                  │  - "Add Connection" with user search   │
│  └──────────────────┘                                        │
│                                                              │
│  ┌──────────────────┐                                        │
│  │  Notifications   │  - Match invites received              │
│  │  (Inbox)         │  - Friend requests                     │
│  │                  │  - Match status updates                │
│  │                  │  - Accept/Decline actions inline       │
│  └──────────────────┘                                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                  MATCH CREATION FLOW                          │
│                                                              │
│  Step 1: Match Type                                          │
│  ┌──────────────────┐                                        │
│  │  Quick Match vs   │  - Radio: Quick Match (solo scorer)  │
│  │  Dual Captain     │  - Radio: Dual Captain (competitive) │
│  └──────────────────┘                                        │
│                                                              │
│  Step 2: Rules Configuration                                 │
│  ┌──────────────────┐                                        │
│  │  Presets bar:     │  Quick 6 | T10 | T20 | Custom        │
│  │  Overs, players,  │                                       │
│  │  last man, etc.   │                                       │
│  └──────────────────┘                                        │
│                                                              │
│  Step 3 (Quick): Team names → Start                          │
│  Step 3 (Dual Captain): Team A name → Invite Opponent        │
│  ┌──────────────────┐                                        │
│  │  Invite Screen   │  - Search connections/recent players  │
│  │                  │  - Or share invite link               │
│  │                  │  - Waiting state after invite sent    │
│  └──────────────────┘                                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│             DUAL CAPTAIN — MATCH SETUP HUB                   │
│             (After opponent accepts invite)                   │
│                                                              │
│  ┌──────────────────────────────────────────────────┐        │
│  │  MATCH SETUP HUB — Progress Stepper              │        │
│  │                                                  │        │
│  │  ● Invitation ──── ● Teams ──── ● Rules ──── ● Toss     │
│  │    (done)           (active)     (locked)      (locked)  │
│  │                                                  │        │
│  │  ┌─────────────────────────────────────────┐     │        │
│  │  │  TEAM MANAGEMENT (Real-time)            │     │        │
│  │  │                                          │     │        │
│  │  │  ┌── Your Team ──┐  ┌── Their Team ──┐  │     │        │
│  │  │  │ 1. You (C)    │  │ 1. Them (C)    │  │     │        │
│  │  │  │ 2. Player X   │  │ 2. Player Y    │  │     │        │
│  │  │  │ + Add Player  │  │ (read-only)    │  │     │        │
│  │  │  │               │  │                 │  │     │        │
│  │  │  │ [Mark Ready]  │  │ Status: Adding  │  │     │        │
│  │  │  └───────────────┘  └─────────────────┘  │     │        │
│  │  └─────────────────────────────────────────┘     │        │
│  │                                                  │        │
│  │  Once both ready → Rules step unlocks            │        │
│  │                                                  │        │
│  │  ┌── Rules Negotiation ───────────────────┐      │        │
│  │  │  Proposed: T10, 2PP, Last Man OFF       │      │        │
│  │  │  [Accept] [Counter-Propose]             │      │        │
│  │  └────────────────────────────────────────┘      │        │
│  │                                                  │        │
│  │  Once rules agreed → Toss step unlocks           │        │
│  │                                                  │        │
│  │  ┌── Toss ───────────────────────────────┐       │        │
│  │  │  Who won the toss?  [Team A] [Team B]  │       │        │
│  │  │  Decision?  [Bat] [Bowl]               │       │        │
│  │  └────────────────────────────────────────┘       │        │
│  └──────────────────────────────────────────────────┘        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                  SCORING CONSOLE                              │
│            (After toss — match goes LIVE)                     │
│                                                              │
│  ┌──────────────────────────────────────────────────┐        │
│  │  HEADER: Team A vs Team B  · T10  · LIVE 🔴      │        │
│  ├──────────────────────────────────────────────────┤        │
│  │  SCOREBOARD                                       │        │
│  │  Team A: 87/3 (6.2)    CRR: 13.76               │        │
│  │  Batsman 1: 34* (18)   Batsman 2: 12* (8)       │        │
│  │  Bowler: 2-0-18-1                                │        │
│  ├──────────────────────────────────────────────────┤        │
│  │  THIS OVER: 4 · 1 · 6 · W · 2 ·                │        │
│  ├──────────────────────────────────────────────────┤        │
│  │  SCORING BUTTONS                                  │        │
│  │  ┌─────┬─────┬─────┬─────┬─────┬─────┬─────┐   │        │
│  │  │  0  │  1  │  2  │  3  │  4  │  6  │  W  │   │        │
│  │  └─────┴─────┴─────┴─────┴─────┴─────┴─────┘   │        │
│  │  ┌─────────────┬─────────────┬───────────────┐   │        │
│  │  │   Wide      │   No Ball   │   Extras      │   │        │
│  │  └─────────────┴─────────────┴───────────────┘   │        │
│  │  ┌───────────────────────────────────────────┐   │        │
│  │  │            UNDO LAST BALL                 │   │        │
│  │  └───────────────────────────────────────────┘   │        │
│  └──────────────────────────────────────────────────┘        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                 LIVE SCOREBOARD (Public View)                 │
│          (Anyone with match link — no auth needed)           │
│                                                              │
│  ┌──────────────────────────────────────────────────┐        │
│  │  🔴 LIVE  ·  Royal Challengers vs Mumbai Indians │        │
│  ├──────────────────────────────────────────────────┤        │
│  │                                                  │        │
│  │      ██████████████████████████  87/3            │        │
│  │      Royal Challengers          6.2 overs        │        │
│  │                                                  │        │
│  │      Target: 120 from 60 balls                   │        │
│  │      RRR: 8.86                                   │        │
│  │                                                  │        │
│  ├──────────────────────────────────────────────────┤        │
│  │  This Over: 4 · 1 · 6 · W · 2 ·                │        │
│  ├──────────────────────────────────────────────────┤        │
│  │  Batsmen:                                        │        │
│  │  V Kohli*    34 (18)  SR 188.88                  │        │
│  │  AB de V     12 (8)   SR 150.00                  │        │
│  ├──────────────────────────────────────────────────┤        │
│  │  Bowler: J Bumrah  2-0-18-1  Econ 9.00          │        │
│  └──────────────────────────────────────────────────┘        │
│                                                              │
│  Updates in REAL-TIME via WebSocket (like Google IPL scores) │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                FUTURE FEATURES (Phase 2+)                     │
│                                                              │
│  - Tournament bracket management                             │
│  - Team management (permanent teams with roster)             │
│  - Player stats / career page                                │
│  - Community / local cricket groups                          │
│  - AI-powered match predictions                              │
│  - Photo gallery per match                                   │
│  - Umpire mode                                               │
│  - Commentary bot                                            │
│  - Premium: advanced analytics, video highlights             │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. AUTH SCREEN — DETAILED DESIGN SPEC

The first screen users see. Must be **extremely clean** — nothing else.

```
┌─────────────────────────────────────────────────────────┐
│                                                          │
│                                                          │
│              ┌────────────────────────┐                  │
│              │                        │                  │
│              │    ┌──────────────┐    │                  │
│              │    │   inSwing    │    │                  │
│              │    │   cricket    │    │                  │
│              │    │   logo/      │    │                  │
│              │    │   avatar     │    │                  │
│              │    └──────────────┘    │                  │
│              │                        │                  │
│              │    ━━━━━━━━━━━━━━━     │                  │
│              │    inSwing             │                  │
│              │    Professional        │                  │
│              │    Cricket Scoring     │                  │
│              │    ━━━━━━━━━━━━━━━     │                  │
│              │                        │                  │
│              │  ┌──────────────────┐  │                  │
│              │  │     Login        │  │ ← Primary btn  │
│              │  └──────────────────┘  │                  │
│              │                        │                  │
│              │  ┌──────────────────┐  │                  │
│              │  │    Register      │  │ ← Secondary btn│
│              │  └──────────────────┘  │                  │
│              │                        │                  │
│              └────────────────────────┘                  │
│                                                          │
│                                                          │
└─────────────────────────────────────────────────────────┘

Background: var(--bg-deep) #0C1821
Card: var(--bg-mid) #162029 with subtle border
Logo: Circular avatar with cricket bat/ball icon in green
"inSwing" text: 24px bold Inter
Tagline: 14px text-muted
Login button: Full width, bg-accent, white text, rounded-lg
Register button: Full width, bg-surface, border-line, text-primary
```

**States:**
- Default: Logo + two buttons
- Login clicked: Slide to login form (phone/email + password + submit)
- Register clicked: Slide to register form (name + email + phone + password)
- Success: Redirect to Profile Setup (new users) or Dashboard (returning)

---

## 8. USER ID & CONNECTIONS SYSTEM

Every user gets a unique **User ID** visible in their profile:
- Format: `INS-XXXXXX` (6 alphanumeric chars, generated at registration)
- Displayed prominently in profile with "Copy" button
- Searchable via connections/search feature

### Connections Flow
```
┌── Search Players ─────────────────────────────┐
│  🔍 Search by name or User ID...              │
│                                               │
│  ┌─────────────────────────────────────────┐  │
│  │ 🏏 Rohit Sharma     INS-R0H1T7          │  │
│  │    RHB · Fast · 45 matches              │  │
│  │                        [+ Add Friend]   │  │
│  └─────────────────────────────────────────┘  │
│  ┌─────────────────────────────────────────┐  │
│  │ 🏏 Virat Kohli      INS-V1R4T9          │  │
│  │    RHB · None · 128 matches             │  │
│  │                        [✓ Connected]    │  │
│  └─────────────────────────────────────────┘  │
└───────────────────────────────────────────────┘
```

### How invite works (PUBG room style):
1. Captain A creates match with rules
2. Instead of sending raw user_id, Captain A sees their **Connections list**
3. Tap a connection → "Invite to match" → opponent gets notification
4. OR: Share an **invite link** (URL with match invite token) via WhatsApp/SMS
5. Opponent opens app → sees invitation in Notifications → Accept/Decline

---

## 9. REAL-TIME UPDATE MECHANISM

### For Dual Captain Match Setup
- Both captains connected via **WebSocket** to same match channel
- When Captain A adds a player → Captain B sees it instantly
- When Captain A marks ready → Captain B sees "Opponent Ready" badge
- Progress stepper auto-advances for both when conditions met

### For Live Scoring
- Scorer (either captain in dual mode) records ball
- WebSocket broadcasts to ALL connected viewers:
  - Other captain's scoring console (synced)
  - Public live scoreboard (spectators)
  - Anyone with the match link
- Like Google's IPL score updater — no refresh needed

---

## 10. NAVIGATION STRUCTURE

### Bottom Tab Bar (Mobile)
```
┌─────────┬─────────┬─────────┬─────────┬─────────┐
│  Home   │  Match  │   +     │ Connect │ Profile │
│   🏠    │   🏏   │  (New)  │   👥    │   👤   │
└─────────┴─────────┴─────────┴─────────┴─────────┘
```

### Top Nav (Desktop)
```
┌─────────────────────────────────────────────────────────────┐
│ [iS] inSwing     Dashboard  Matches  Connections  Profile   │
│                                            🔔 Notifications │
└─────────────────────────────────────────────────────────────┘
```

---

## 11. KEY DESIGN PRINCIPLES

1. **Dark by default** — Professional sports broadcast aesthetic
2. **Cricket green** as primary accent — Not neon, not lime. Deep cricket pitch green
3. **Real-time first** — Every screen that shows data should feel alive
4. **Mobile-first** — 80% of users will be on phones at the cricket ground
5. **Minimal friction** — Creating a match should take < 30 seconds
6. **Score visibility** — Numbers should be large, bold, instantly readable
7. **No clutter** — Each screen serves one purpose. No ads, no distractions
8. **Sporty, not gamey** — Professional broadcast feel, not a casual mobile game

---

## 12. ANIMATION & MICRO-INTERACTIONS

| Element | Animation |
|---------|-----------|
| LIVE badge | Red dot with `pulse` CSS animation |
| Score update | Brief flash/highlight on number change |
| Wicket | Shake animation on score card |
| Boundary (4/6) | Green flash overlay |
| Button press | Scale 0.95 → 1.0 on tap |
| Page transition | Fade-in 200ms |
| Card hover | Border color → accent (200ms ease) |
| Form success | Checkmark with scale-in animation |

---

## 13. COMPLETE FEATURE ROADMAP

### Phase 1 (Current — MVP)
- [x] Auth (register/login)
- [x] Profile setup (batting/bowling/hand)
- [x] Quick match creation & scoring
- [x] Dual captain match flow (backend complete)
- [x] Live scoreboard (public WebSocket)
- [ ] **Dual captain frontend** (invite, teams, rules, real-time)
- [ ] **Auth screen redesign** (clean landing)
- [ ] **User ID system** (INS-XXXXXX)
- [ ] **Connections/friends** feature

### Phase 2
- [ ] Tournament creation & brackets
- [ ] Permanent team management (rosters)
- [ ] Player search & discovery
- [ ] Match history & career stats page
- [ ] Push notifications (match invites, scores)
- [ ] Invite links (shareable via WhatsApp)

### Phase 3
- [ ] Community/groups (local cricket clubs)
- [ ] Leaderboards (area-wise, club-wise)
- [ ] Premium features (analytics, exports)
- [ ] Umpire mode
- [ ] Photo/video highlights
- [ ] AI match predictions

---

## 14. TECHNICAL NOTES (For Developers)

| Layer | Tech |
|-------|------|
| Frontend | React 19 + TypeScript + Vite 8 + Tailwind 4 |
| State | TanStack Query 5 + Zustand |
| Real-time | WebSocket (native browser API) |
| Backend | Python FastAPI + PostgreSQL + Redis |
| Auth | JWT tokens (access + refresh) |
| Hosting | Docker → Railway/Render (free tier) |

### API Base: `http://localhost:18000/api/v1`
### Frontend: `http://localhost:3000`

---

*This document is the single source of truth for inSwing's design language, user flows, and feature vision. Use it to generate consistent mockups across all screens.*
