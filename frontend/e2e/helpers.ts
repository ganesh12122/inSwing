import { type Page } from '@playwright/test'

const API_BASE = 'http://localhost:18000/api/v1'

export const TEST_ACCOUNTS = {
  host: {
    email: 'testhost@inswing.com',
    password: 'TestHost@123',
    name: 'Test Host',
  },
  opponent: {
    email: 'shyam@gmail.com',
    password: 'shyam@12',
    name: 'Shyam',
  },
}

/**
 * Login via API and inject tokens into localStorage so the page is authenticated.
 * The page must already be navigated to the app's origin before calling this.
 */
export async function loginViaAPI(
  page: Page,
  email: string,
  password: string
): Promise<{ accessToken: string; userId: string }> {
  const response = await page.request.post(`${API_BASE}/auth/login`, {
    data: { email, password },
  })

  if (!response.ok()) {
    const body = await response.text()
    throw new Error(`Login failed for ${email}: ${response.status()} - ${body}`)
  }

  const data = await response.json()
  const accessToken = data.tokens.access_token
  const refreshToken = data.tokens.refresh_token
  const user = data.user

  // Navigate to app origin first if not there already
  if (!page.url().startsWith('http://localhost:3000')) {
    await page.goto('http://localhost:3000')
  }

  // Inject tokens into localStorage
  await page.evaluate(
    ({ accessToken, refreshToken, user }) => {
      localStorage.setItem('inswing_access_token', accessToken)
      localStorage.setItem('inswing_refresh_token', refreshToken)
      localStorage.setItem('inswing_user', JSON.stringify(user))
    },
    { accessToken, refreshToken, user }
  )

  return { accessToken, userId: user.id }
}

/**
 * Create a match via API (faster than going through UI).
 */
export async function createMatchViaAPI(
  page: Page,
  accessToken: string,
  payload: {
    team_a_name: string
    team_b_name?: string
    match_type?: string
    venue?: string
    overs_limit?: number
  }
): Promise<string> {
  const response = await page.request.post(`${API_BASE}/matches/`, {
    headers: { Authorization: `Bearer ${accessToken}` },
    data: {
      team_a_name: payload.team_a_name,
      team_b_name: payload.team_b_name ?? 'Team B',
      match_type: payload.match_type ?? 'quick',
      venue: payload.venue ?? 'Test Ground',
    },
  })

  if (!response.ok()) {
    const body = await response.text()
    throw new Error(`Create match failed: ${response.status()} - ${body}`)
  }

  const match = await response.json()
  return match.id
}

/**
 * Add players to a match via API.
 */
export async function addPlayersViaAPI(
  page: Page,
  accessToken: string,
  matchId: string,
  players: { team: 'A' | 'B'; guest_name: string; role?: string }[]
): Promise<string[]> {
  const ids: string[] = []
  for (const player of players) {
    const response = await page.request.post(`${API_BASE}/matches/${matchId}/team/players`, {
      headers: { Authorization: `Bearer ${accessToken}` },
      data: {
        guest_name: player.guest_name,
        role: player.role ?? 'batsman',
      },
    })
    if (!response.ok()) {
      const body = await response.text()
      throw new Error(`Add player failed: ${response.status()} - ${body}`)
    }
    const p = await response.json()
    ids.push(p.id)
  }
  return ids
}

/**
 * Mark team ready via API.
 */
export async function markTeamReadyViaAPI(
  page: Page,
  accessToken: string,
  matchId: string
): Promise<void> {
  const response = await page.request.put(`${API_BASE}/matches/${matchId}/team-ready`, {
    headers: { Authorization: `Bearer ${accessToken}` },
    data: { ready: true },
  })
  if (!response.ok()) {
    const body = await response.text()
    throw new Error(`Mark team ready failed: ${response.status()} - ${body}`)
  }
}

/**
 * Record toss via API.
 */
export async function recordTossViaAPI(
  page: Page,
  accessToken: string,
  matchId: string,
  tossWinner: 'A' | 'B',
  tossDecision: 'bat' | 'bowl'
): Promise<void> {
  const response = await page.request.put(`${API_BASE}/matches/${matchId}/toss`, {
    headers: { Authorization: `Bearer ${accessToken}` },
    data: { toss_winner: tossWinner, toss_decision: tossDecision },
  })
  if (!response.ok()) {
    const body = await response.text()
    throw new Error(`Record toss failed: ${response.status()} - ${body}`)
  }
}

/**
 * Create innings via API.
 */
export async function createInningsViaAPI(
  page: Page,
  accessToken: string,
  matchId: string,
  battingTeam: 'A' | 'B',
  oversAllocated: number
): Promise<string> {
  const response = await page.request.post(`${API_BASE}/matches/${matchId}/innings`, {
    headers: { Authorization: `Bearer ${accessToken}` },
    data: { batting_team: battingTeam, overs_allocated: oversAllocated },
  })
  if (!response.ok()) {
    const body = await response.text()
    throw new Error(`Create innings failed: ${response.status()} - ${body}`)
  }
  const innings = await response.json()
  return innings.id
}

/**
 * Get teams for a match.
 */
export async function getTeamsViaAPI(
  page: Page,
  accessToken: string,
  matchId: string
): Promise<{ team_a: { players: Array<{ id: string; guest_name: string; display_name: string | null }> }; team_b: { players: Array<{ id: string; guest_name: string; display_name: string | null }> } }> {
  const response = await page.request.get(`${API_BASE}/matches/${matchId}/teams`, {
    headers: { Authorization: `Bearer ${accessToken}` },
  })
  if (!response.ok()) {
    const body = await response.text()
    throw new Error(`Get teams failed: ${response.status()} - ${body}`)
  }
  return await response.json()
}

/**
 * Advance a quick match directly to live state (skip team ready / rules for quick matches).
 */
export async function advanceMatchToLive(
  page: Page,
  accessToken: string,
  matchId: string,
  oversAllocated: number = 6
): Promise<{ inningsId: string }> {
  // Record toss (quick match: host can toss any time)
  await recordTossViaAPI(page, accessToken, matchId, 'A', 'bat')

  // Create innings → match goes live
  const inningsId = await createInningsViaAPI(page, accessToken, matchId, 'A', oversAllocated)

  return { inningsId }
}
