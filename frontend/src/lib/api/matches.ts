import { apiClient } from './client'

// ── Types mirroring backend schemas ─────────────────────────────────────────

export type MatchType = 'quick' | 'dual_captain' | 'friendly' | 'tournament'

export type MatchStatus =
  | 'created'
  | 'invited'
  | 'accepted'
  | 'teams_ready'
  | 'rules_proposed'
  | 'rules_approved'
  | 'toss_done'
  | 'live'
  | 'finished'
  | 'cancelled'
  | 'declined'

export interface MatchRules {
  overs_limit: number
  powerplay_overs: number
  max_overs_per_bowler: number
  wide_ball_runs: number
  no_ball_runs: number
  free_hit: boolean
  super_over: boolean
  min_players_per_team: number
  max_players_per_team: number
  last_man_batting: boolean
  tennis_ball: boolean
  boundary_runs: number
  scorer_permission: 'host_only' | 'captains' | 'designated' | 'all_players'
}

export interface MatchResponse {
  id: string
  host_user_id: string
  opponent_captain_id: string | null
  scorer_user_id: string | null
  match_type: MatchType
  team_a_name: string
  team_b_name: string | null
  venue: string | null
  status: MatchStatus
  rules: MatchRules
  result: MatchResult | null
  toss_winner: string | null
  toss_decision: string | null
  is_dual_captain: boolean
  both_teams_ready: boolean
  rules_agreed: boolean
  created_at: string
  updated_at: string
  started_at: string | null
  finished_at: string | null
}

export interface MatchResult {
  winner: string
  winning_margin: number
  winning_type: string
  final_scores: Record<string, { runs: number; wickets: number; overs: number }>
}

export interface MatchListResponse {
  matches: MatchResponse[]
  total: number
  page: number
  per_page: number
}

export interface CreateMatchPayload {
  match_type: MatchType
  team_a_name: string
  team_b_name?: string
  venue?: string
  rules?: Partial<MatchRules>
}

export interface PlayerInMatch {
  id: string
  match_id: string
  user_id: string | null
  team: 'A' | 'B'
  role: string
  is_guest: boolean
  guest_name: string | null
  display_name?: string
}

export interface AddPlayerPayload {
  user_id?: string
  guest_name?: string
  team: 'A' | 'B'
  role?: string
}

export interface InningsResponse {
  id: string
  match_id: string
  batting_team: 'A' | 'B'
  overs_allocated: number
  runs: number
  wickets: number
  extras: number
  overs_bowled: number
  is_completed: boolean
  completed_at: string | null
  run_rate: number
  current_over_balls: number
}

export interface BallPayload {
  over_number: number
  ball_in_over: number
  batsman_id?: string
  non_striker_id?: string
  bowler_id?: string
  runs_off_bat: number
  extras_type?: 'wide' | 'no_ball' | 'bye' | 'legbye' | null
  extras_runs?: number
  wicket_type?: 'bowled' | 'caught' | 'runout' | 'lbw' | 'stumped' | 'hit_wicket' | null
  dismissal_info?: Record<string, unknown>
  client_event_id?: string
}

export interface BallResponse {
  id: string
  innings_id: string
  over_number: number
  ball_in_over: number
  runs_off_bat: number
  extras_type: string | null
  extras_runs: number
  total_runs: number
  wicket_type: string | null
  is_legal_delivery: boolean
  created_at: string
}

// ── Live score (public, no auth) ────────────────────────────────────────────

export interface LiveScore {
  match_id: string
  match_type: string
  status: string
  team_a_name: string
  team_b_name: string | null
  venue: string | null
  toss_winner: string | null
  toss_decision: string | null
  result: MatchResult | null
  innings: {
    id: string
    batting_team: string
    runs: number
    wickets: number
    overs: number
    overs_allocated: number
    is_completed: boolean
    run_rate: number
  }[]
  target: number | null
  team_a: { role: string; name: string }[]
  team_b: { role: string; name: string }[]
  started_at: string | null
  source: string
}

// ── API functions ───────────────────────────────────────────────────────────

export async function createMatch(payload: CreateMatchPayload): Promise<MatchResponse> {
  const { data } = await apiClient.post<MatchResponse>('/matches/', payload)
  return data
}

export async function fetchMyMatches(): Promise<MatchListResponse> {
  const { data } = await apiClient.get<MatchListResponse>('/matches/my')
  return data
}

export async function fetchMatch(matchId: string): Promise<MatchResponse> {
  const { data } = await apiClient.get<MatchResponse>(`/matches/${matchId}`)
  return data
}

export async function inviteOpponent(matchId: string, opponentUserId: string, message?: string) {
  const { data } = await apiClient.post(`/matches/${matchId}/invite`, {
    opponent_user_id: opponentUserId,
    invitation_message: message,
  })
  return data
}

export async function acceptInvitation(matchId: string, teamBName: string) {
  const { data } = await apiClient.post(`/matches/${matchId}/accept`, { team_b_name: teamBName })
  return data
}

export async function addPlayer(matchId: string, payload: AddPlayerPayload): Promise<PlayerInMatch> {
  const { data } = await apiClient.post<PlayerInMatch>(`/matches/${matchId}/team/players`, payload)
  return data
}

export interface TeamInfo {
  name: string
  players: PlayerInMatch[]
  count: number
  ready: boolean
}

export interface TeamsResponse {
  team_a: TeamInfo
  team_b: TeamInfo
  min_players: number
}

export async function getTeams(matchId: string): Promise<TeamsResponse> {
  const { data } = await apiClient.get<TeamsResponse>(`/matches/${matchId}/teams`)
  return data
}

export async function markTeamReady(matchId: string, ready = true) {
  const { data } = await apiClient.put(`/matches/${matchId}/team/ready`, { ready })
  return data
}

export async function recordToss(matchId: string, tossWinner: 'A' | 'B', tossDecision: 'bat' | 'bowl') {
  const { data } = await apiClient.put(`/matches/${matchId}/toss`, {
    toss_winner: tossWinner,
    toss_decision: tossDecision,
  })
  return data
}

export async function createInnings(matchId: string, battingTeam: 'A' | 'B', oversAllocated: number) {
  const { data } = await apiClient.post<InningsResponse>(`/matches/${matchId}/innings`, {
    batting_team: battingTeam,
    overs_allocated: oversAllocated,
  })
  return data
}

export async function fetchInnings(matchId: string): Promise<InningsResponse[]> {
  const { data } = await apiClient.get<InningsResponse[]>(`/matches/${matchId}/innings`)
  return data
}

export async function recordBall(
  matchId: string,
  inningsId: string,
  payload: BallPayload,
): Promise<BallResponse> {
  const { data } = await apiClient.post<BallResponse>(
    `/matches/${matchId}/innings/${inningsId}/ball`,
    payload,
  )
  return data
}

export async function fetchBalls(matchId: string, inningsId: string): Promise<BallResponse[]> {
  const { data } = await apiClient.get<BallResponse[]>(
    `/matches/${matchId}/innings/${inningsId}/balls`,
  )
  return data
}

export async function updateMatchStatus(matchId: string, status: MatchStatus) {
  const { data } = await apiClient.put(`/matches/${matchId}/status`, null, {
    params: { new_status: status },
  })
  return data
}

// Public endpoint — no auth token needed
export async function fetchLiveScore(matchId: string): Promise<LiveScore> {
  const { data } = await apiClient.get<LiveScore>(`/public/live/${matchId}`)
  return data
}

export async function fetchLiveBalls(matchId: string, inningsNumber = 1) {
  const { data } = await apiClient.get(`/public/live/${matchId}/balls`, {
    params: { innings_number: inningsNumber },
  })
  return data
}
