import { test, expect, type Page } from '@playwright/test'
import {
  loginViaAPI,
  createMatchViaAPI,
  advanceMatchToLive,
  TEST_ACCOUNTS,
} from './helpers'

/**
 * Scoring Console E2E Tests
 *
 * Prerequisites: Docker services running (postgres, redis, backend at :18000, frontend at :3000)
 * Test account: shyam@gmail.com / shyam@12
 *
 * Strategy: Each test creates its own fresh match via API, then
 * navigates to the scoring console to test UI interactions.
 * Player IDs are optional in the API, so we test scoring controls directly.
 */

const API_BASE = 'http://localhost:18000/api/v1'

/** Helper: log in and navigate to a fresh live match's scoring console */
async function setupLiveMatch(page: Page): Promise<{ matchId: string; inningsId: string; accessToken: string }> {
  await page.goto('/')
  const { accessToken } = await loginViaAPI(page, TEST_ACCOUNTS.opponent.email, TEST_ACCOUNTS.opponent.password)
  const matchId = await createMatchViaAPI(page, accessToken, {
    team_a_name: 'Lions',
    team_b_name: 'Tigers',
  })
  const { inningsId } = await advanceMatchToLive(page, accessToken, matchId)
  await page.goto(`/match/${matchId}/scoring`)
  await page.waitForLoadState('networkidle')
  await page.waitForSelector('button:has-text("WICKET")', { timeout: 10000 })
  return { matchId, inningsId, accessToken }
}

// ── Basic UI Elements ─────────────────────────────────────────────────────

test.describe('Scoring Console - UI Layout', () => {
  test('displays all scoring controls', async ({ page }) => {
    await setupLiveMatch(page)

    for (const run of ['0', '1', '2', '3', '4', '6']) {
      await expect(page.getByRole('button', { name: run, exact: true })).toBeVisible()
    }
    await expect(page.getByRole('button', { name: 'W WICKET' })).toBeVisible()
    await expect(page.getByRole('button', { name: 'Wide' })).toBeVisible()
    await expect(page.getByRole('button', { name: 'No Ball' })).toBeVisible()
    await expect(page.getByRole('button', { name: 'Bye', exact: true })).toBeVisible()
    await expect(page.getByRole('button', { name: 'Leg Bye' })).toBeVisible()
    for (const w of ['Bowled', 'Caught', 'Runout', 'Lbw', 'Stumped']) {
      await expect(page.getByRole('button', { name: w, exact: true })).toBeVisible()
    }
    const selects = page.locator('select')
    await expect(selects).toHaveCount(3)
    await expect(page.getByText(/Over.*1/)).toBeVisible()
    await expect(page.getByText('Live Link')).toBeVisible()
    await expect(page.getByRole('button', { name: 'Copy Link' })).toBeVisible()
  })
})

// ── Run Scoring ───────────────────────────────────────────────────────────

test.describe('Scoring Console - Run Recording', () => {
  test('records a dot ball (0)', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: '0', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: '0' }).first()).toBeVisible()
    await expect(page.getByText(/Ball 2/)).toBeVisible()
  })

  test('records a single (1)', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: '1', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: '1' }).first()).toBeVisible()
  })

  test('records a boundary four (4)', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: '4', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: '4' }).first()).toBeVisible()
  })

  test('records a six (6)', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: '6', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: '6' }).first()).toBeVisible()
  })

  test('score updates in header', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: '4', exact: true }).click()
    await page.waitForTimeout(2000)
    await expect(page.getByText('4/0').first()).toBeVisible()
  })
})

// ── Extras ────────────────────────────────────────────────────────────────

test.describe('Scoring Console - Extras', () => {
  test('records a wide', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'Wide' }).click()
    await expect(page.getByText(/wide/)).toBeVisible()
    await page.getByRole('button', { name: '1', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: /wd/ }).first()).toBeVisible()
    await expect(page.getByText(/Ball 1/)).toBeVisible()
  })

  test('records a no ball', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'No Ball' }).click()
    await expect(page.getByText(/no_ball/)).toBeVisible()
    await page.getByRole('button', { name: '1', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: /nb/ }).first()).toBeVisible()
    await expect(page.getByText(/Ball 1/)).toBeVisible()
  })

  test('records a bye', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'Bye', exact: true }).click()
    await page.getByRole('button', { name: '1', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: /b/ }).first()).toBeVisible()
  })

  test('records a leg bye', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'Leg Bye' }).click()
    await page.getByRole('button', { name: '2', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: /lb/ }).first()).toBeVisible()
  })

  test('deselecting an extra', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'Wide' }).click()
    await expect(page.getByText(/wide/)).toBeVisible()
    await page.getByRole('button', { name: 'Wide' }).click()
    await expect(page.locator('text=Next ball:')).not.toBeVisible()
  })
})

// ── Wickets ───────────────────────────────────────────────────────────────

test.describe('Scoring Console - Wickets', () => {
  test('records a bowled wicket', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'Bowled' }).click()
    await expect(page.getByText(/bowled/)).toBeVisible()
    await page.getByRole('button', { name: '0', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: 'W' }).first()).toBeVisible()
  })

  test('records an LBW wicket', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'Lbw' }).click()
    await page.getByRole('button', { name: '0', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: 'W' }).first()).toBeVisible()
  })

  test('records a caught wicket', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'Caught' }).click()
    await page.getByRole('button', { name: '0', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: 'W' }).first()).toBeVisible()
  })

  test('wicket increments wicket count', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'Bowled' }).click()
    await page.getByRole('button', { name: '0', exact: true }).click()
    await page.waitForTimeout(2000)
    await expect(page.getByText('0/1').first()).toBeVisible()
  })

  test('W button toggles wicket mode', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'W WICKET' }).click()
    await expect(page.getByText(/bowled/)).toBeVisible()
    await page.getByRole('button', { name: 'W WICKET' }).click()
    await expect(page.locator('text=Next ball:')).not.toBeVisible()
  })

  test('deselecting wicket type', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'Caught' }).click()
    await expect(page.getByText(/caught/)).toBeVisible()
    await page.getByRole('button', { name: 'Caught' }).click()
    await expect(page.locator('text=Next ball:')).not.toBeVisible()
  })
})

// ── Over Progression ──────────────────────────────────────────────────────

test.describe('Scoring Console - Over Progression', () => {
  test('completes an over after 6 legal balls', async ({ page }) => {
    await setupLiveMatch(page)
    for (let i = 0; i < 6; i++) {
      await page.getByRole('button', { name: '0', exact: true }).click()
      await page.waitForTimeout(1000)
    }
    await expect(page.getByText(/Over.*2/)).toBeVisible()
    await expect(page.getByText(/Ball 1/)).toBeVisible()
  })

  test('wide does not count as legal delivery', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'Wide' }).click()
    await page.getByRole('button', { name: '1', exact: true }).click()
    await page.waitForTimeout(1000)
    await expect(page.getByText(/Ball 1/)).toBeVisible()
    for (let i = 0; i < 6; i++) {
      await page.getByRole('button', { name: '0', exact: true }).click()
      await page.waitForTimeout(800)
    }
    await expect(page.getByText(/Over.*2/)).toBeVisible()
  })

  test('over strip resets at new over', async ({ page }) => {
    await setupLiveMatch(page)
    for (let i = 0; i < 6; i++) {
      await page.getByRole('button', { name: '0', exact: true }).click()
      await page.waitForTimeout(800)
    }
    await expect(page.getByText('New over')).toBeVisible()
  })
})

// ── Combinations ──────────────────────────────────────────────────────────

test.describe('Scoring Console - Combinations', () => {
  test('extra + wicket combination', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: 'No Ball' }).click()
    await page.getByRole('button', { name: 'Stumped' }).click()
    await expect(page.getByText(/no_ball/)).toBeVisible()
    await expect(page.getByText(/stumped/)).toBeVisible()
    await page.getByRole('button', { name: '0', exact: true }).click()
    await page.waitForTimeout(1500)
    const balls = page.locator('.rounded-full')
    await expect(balls.first()).toBeVisible()
  })

  test('multiple balls maintain running score', async ({ page }) => {
    await setupLiveMatch(page)
    const runs = [4, 1, 6, 0, 2]
    for (const r of runs) {
      await page.getByRole('button', { name: String(r), exact: true }).click()
      await page.waitForTimeout(1200)
    }
    await expect(page.getByText('13/0').first()).toBeVisible()
  })

  test('scoring without selecting players works', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: '3', exact: true }).click()
    await page.waitForTimeout(1500)
    await expect(page.locator('.rounded-full').filter({ hasText: '3' }).first()).toBeVisible()
    await expect(page.getByText('3/0').first()).toBeVisible()
  })
})

// ── Bowler Stats (critical bug fix verification) ──────────────────────────

test.describe('Scoring Console - Stats Fix Verification', () => {
  test('bowler figures do not show NaN after recording balls', async ({ page }) => {
    const { accessToken, matchId } = await setupLiveMatch(page)

    // Add a player to get bowler dropdown option
    await page.request.post(`${API_BASE}/matches/${matchId}/team/players`, {
      headers: { Authorization: `Bearer ${accessToken}` },
      data: { guest_name: 'Test Batsman' },
    })
    await page.reload()
    await page.waitForSelector('button:has-text("WICKET")', { timeout: 10000 })

    const selects = page.locator('select')
    const strikerSelect = selects.nth(0)
    const bowlerSelect = selects.nth(2)

    // Select first available options
    const strikerOptions = await strikerSelect.locator('option').allTextContents()
    if (strikerOptions.length > 1) await strikerSelect.selectOption({ index: 1 })
    const bowlerOptions = await bowlerSelect.locator('option').allTextContents()
    if (bowlerOptions.length > 1) await bowlerSelect.selectOption({ index: 1 })
    await page.waitForTimeout(300)

    await page.getByRole('button', { name: '0', exact: true }).click()
    await page.waitForTimeout(2000)

    // Check bowler card doesn't contain NaN
    const bowlerCard = page.locator('[class*="border-red"]').first()
    if (await bowlerCard.isVisible()) {
      const text = await bowlerCard.textContent()
      expect(text).not.toContain('NaN')
    }
  })
})

// ── Navigation ────────────────────────────────────────────────────────────

test.describe('Scoring Console - Navigation', () => {
  test('dashboard button navigates back', async ({ page }) => {
    await setupLiveMatch(page)
    await page.getByRole('button', { name: '← Dashboard' }).click()
    await page.waitForURL('**/dashboard')
    expect(page.url()).toContain('/dashboard')
  })

  test('live link contains match ID', async ({ page }) => {
    const { matchId } = await setupLiveMatch(page)
    await expect(page.getByText(`/live/${matchId}`)).toBeVisible()
  })
})
