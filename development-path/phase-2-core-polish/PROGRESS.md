# Phase 2 — Progress Tracker

## Status: 🟡 IN PROGRESS

## Started: 2024-01-15

## Completed: --

---

| #    | Task                                     | Status         | Date       | Notes                                        |
| ---- | ---------------------------------------- | -------------- | ---------- | -------------------------------------------- |
| 2.0  | **Dual Captain Match System (Backend)**  | ✅ Done        | 2024-01-15 | Models, schemas, migration, API endpoints    |
| 2.0a | Dual Captain Flutter UI                  | ⬜ Not Started |            | Create/invite/accept/setup/rules screens     |
| 2.1  | Sync Flutter ↔ Backend Models            | ⬜ Not Started |            | Match, PlayersInMatch freezed models         |
| 2.2  | Complete Live Scoring Flow               | ⬜ Not Started |            |                                              |
| 2.3  | OTP Delivery Integration                 | ⬜ Not Started |            |                                              |
| 2.4  | Rate Limiting                            | ⬜ Not Started |            |                                              |
| 2.5  | Offline Sync                             | ⬜ Not Started |            |                                              |
| 2.6  | Shareable Match Links                    | ⬜ Not Started |            |                                              |
| 2.7  | Error Handling Polish                    | ⬜ Not Started |            |                                              |

---

## Phase 2.0 — Dual Captain System (Backend) — COMPLETED ✅

### Files Modified
- `backend/app/models/match.py` — Added opponent_captain_id, scorer_user_id, invitation fields, rules negotiation, team readiness, expanded enums (match_type_v2, match_status_v2), helper properties
- `backend/app/models/players_in_match.py` — Added captain role, guest player support (is_guest, guest_name), added_by FK, nullable user_id
- `backend/app/models/user.py` — Added opponent_matches relationship
- `backend/app/schemas/match.py` — Added ScorerPermission, expanded MatchRules (gully cricket rules), MatchInviteRequest, MatchInviteAccept, AddPlayerRequest, TeamReadyRequest, RulesProposalRequest, MatchResponse.from_match()
- `backend/app/schemas/players_in_match.py` — Added captain to PlayerRole, guest fields, display_name
- `backend/app/schemas/__init__.py` — Updated exports with all new schemas
- `backend/app/api/matches.py` — Complete rewrite: invitation flow, team management, rules negotiation, backward-compatible legacy endpoints
- `backend/alembic/versions/004_dual_captain_system.py` — Migration for all schema changes

### New API Endpoints
- `POST /matches/{id}/invite` — Send invitation to opponent captain
- `POST /matches/{id}/accept` — Accept invitation (set team B name)
- `POST /matches/{id}/decline` — Decline invitation
- `POST /matches/{id}/team/players` — Add player to captain's team (app user or guest)
- `DELETE /matches/{id}/team/players/{pid}` — Remove player from team
- `PUT /matches/{id}/team/ready` — Mark team as ready
- `GET /matches/{id}/teams` — Get both teams' player lists
- `POST /matches/{id}/rules/propose` — Propose match rules
- `POST /matches/{id}/rules/approve` — Approve proposed rules
- `POST /matches/{id}/rules/counter` — Counter-propose rules
- `GET /matches/{id}/rules` — Get rules + approval status
- `GET /matches/my` — Get current user's matches (host/opponent/player)

---

## Log

```
[2024-01-15] Phase 2 started — Dual Captain System backend implementation complete
  - 8 files modified/created
  - 12 new API endpoints
  - Full invitation → accept → team setup → rules negotiation → toss flow
  - Guest player support (name-only, no app account)
  - Configurable scorer permissions (host_only, captains, designated, all_players)
  - Backward-compatible legacy endpoints preserved
```
