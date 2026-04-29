import { useEffect, useRef, useState } from 'react'
import { useParams } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { fetchLiveScore, fetchLiveBalls } from '../lib/api/matches'
import type { BallResponse } from '../lib/api/matches'
import { createPublicMatchSocket } from '../lib/ws'

// ── Helpers ─────────────────────────────────────────────────────────────────

function ballLabel(b: {
  runs_off_bat: number
  extras_type: string | null
  wicket_type: string | null
  total_runs: number
}) {
  if (b.wicket_type) return 'W'
  if (b.extras_type === 'wide') return `${b.total_runs}wd`
  if (b.extras_type === 'no_ball') return `${b.total_runs}nb`
  if (b.extras_type === 'bye') return `${b.total_runs}b`
  if (b.extras_type === 'legbye') return `${b.total_runs}lb`
  return String(b.runs_off_bat)
}

function ballColor(b: {
  runs_off_bat: number
  extras_type: string | null
  wicket_type: string | null
}) {
  if (b.wicket_type) return 'bg-red-500/15 text-red-400 border-red-500/30'
  if (b.extras_type) return 'bg-amber-500/10 text-amber-400 border-amber-500/25'
  if (b.runs_off_bat === 4) return 'bg-blue-500/10 text-blue-400 border-blue-500/25'
  if (b.runs_off_bat === 6) return 'bg-purple-500/10 text-purple-400 border-purple-500/25'
  return 'bg-[var(--bg-surface)] border-[var(--line)]'
}

// ── Page ────────────────────────────────────────────────────────────────────

export function LiveScorePage() {
  const { matchId } = useParams<{ matchId: string }>()
  const wsRef = useRef<ReturnType<typeof createPublicMatchSocket> | null>(null)
  const [wsConnected, setWsConnected] = useState(false)

  // ── Live score ────────────────────────────────────────────────────────
  const {
    data: live,
    isLoading,
    isError,
    refetch,
  } = useQuery({
    queryKey: ['live-score', matchId],
    queryFn: () => fetchLiveScore(matchId!),
    enabled: !!matchId,
    refetchInterval: 15_000,
  })

  // ── Balls for the current innings ─────────────────────────────────────
  const currentInnings = live?.innings?.find((i) => !i.is_completed) ?? live?.innings?.[live.innings.length - 1]
  const inningsNumber = currentInnings ? (live?.innings?.indexOf(currentInnings) ?? 0) + 1 : 1

  const { data: balls, refetch: refetchBalls } = useQuery({
    queryKey: ['live-balls', matchId, inningsNumber],
    queryFn: () => fetchLiveBalls(matchId!, inningsNumber),
    enabled: !!matchId && !!currentInnings,
  })

  // ── WebSocket for real-time push ──────────────────────────────────────
  useEffect(() => {
    if (!matchId) return

    const ws = createPublicMatchSocket(matchId)
    wsRef.current = ws

    ws.onConnected(() => setWsConnected(true))

    ws.onBallUpdate(() => {
      refetch()
      refetchBalls()
    })

    ws.onMatchStatus(() => refetch())

    return () => {
      ws.close()
    }
  }, [matchId, refetch, refetchBalls])

  // ── Loading / Error ───────────────────────────────────────────────────
  if (isLoading) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <div className="h-10 w-10 animate-spin rounded-full border-2 border-[var(--accent)] border-t-transparent" />
      </div>
    )
  }

  if (isError || !live) {
    return (
      <div className="flex min-h-[60vh] flex-col items-center justify-center text-center">
        <p className="text-base font-bold">Match not found</p>
        <p className="mt-2 text-sm text-[var(--text-muted)]">
          This match may have been removed or the link is invalid.
        </p>
      </div>
    )
  }

  const isLive = live.status === 'live'
  const isFinished = live.status === 'finished'

  // ── Group balls by over ───────────────────────────────────────────────
  const ballsByOver: Record<number, BallResponse[]> = {}
  if (Array.isArray(balls)) {
    for (const b of balls as BallResponse[]) {
      if (!ballsByOver[b.over_number]) ballsByOver[b.over_number] = []
      ballsByOver[b.over_number].push(b)
    }
  }
  const overNumbers = Object.keys(ballsByOver)
    .map(Number)
    .sort((a, b) => a - b)

  return (
    <section className="mx-auto max-w-2xl space-y-5">
      {/* Connection badge */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div className={`h-2 w-2 rounded-full ${isLive ? 'animate-pulse bg-red-500' : 'bg-[var(--text-muted)]'}`} />
          <span className="text-xs font-semibold uppercase tracking-wider text-[var(--text-muted)]">
            {isFinished ? 'COMPLETED' : isLive ? 'LIVE' : live.status.toUpperCase()}
          </span>
        </div>
        {isLive && (
          <span className="text-xs text-[var(--text-muted)]">
            {wsConnected ? 'Real-time' : 'Polling'}
          </span>
        )}
      </div>

      {/* Main scoreboard */}
      <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-6">
        <div className="flex items-center justify-between">
          <div className="min-w-0 flex-1">
            <p className="truncate text-xs font-semibold uppercase tracking-wider text-[var(--accent)]">
              {live.match_type.replace('_', ' ')}
            </p>
            <h1 className="mt-1 text-xl font-bold">
              {live.team_a_name}
            </h1>
            <p className="text-base text-[var(--text-muted)]">
              vs {live.team_b_name ?? 'TBD'}
            </p>
            {live.venue && (
              <p className="mt-1 text-sm text-[var(--text-muted)]">{live.venue}</p>
            )}
          </div>
          {live.toss_winner && (
            <div className="text-right text-xs text-[var(--text-muted)]">
              Toss: Team {live.toss_winner} ({live.toss_decision})
            </div>
          )}
        </div>
      </div>

      {/* Innings cards */}
      <div className="grid gap-3 sm:grid-cols-2">
        {live.innings?.map((inn, i) => {
          const teamName = inn.batting_team === 'A' ? live.team_a_name : live.team_b_name
          const isCurrent = !inn.is_completed && isLive
          return (
            <div
              key={inn.id}
              className={`relative overflow-hidden rounded-lg border p-5 ${
                isCurrent
                  ? 'border-[var(--accent)] bg-[var(--accent)]/6'
                  : 'border-[var(--line)] bg-[var(--bg-mid)]'
              }`}
            >
              {isCurrent && (
                <span className="absolute right-3 top-3 flex h-5 items-center rounded bg-[var(--accent-strong)]/15 px-2 text-[10px] font-bold text-[var(--accent-strong)]">
                  BATTING
                </span>
              )}
              <p className="text-xs font-medium text-[var(--text-muted)]">
                {i === 0 ? '1st Innings' : '2nd Innings'}
              </p>
              <p className="mt-1 font-medium">{teamName}</p>
              <p className="mt-2 text-3xl font-bold">
                {inn.runs}
                <span className="text-lg text-[var(--text-muted)]">/{inn.wickets}</span>
              </p>
              <p className="mt-1 text-sm text-[var(--text-muted)]">
                {inn.overs} / {inn.overs_allocated} overs · RR {inn.run_rate.toFixed(2)}
              </p>
              {inn.is_completed && (
                <span className="mt-2 inline-block rounded bg-[var(--bg-surface)] px-2 py-0.5 text-xs text-[var(--text-muted)]">
                  Completed
                </span>
              )}
            </div>
          )
        })}
      </div>

      {/* Target banner */}
      {live.target && isLive && currentInnings && !currentInnings.is_completed && (
        <div className="rounded-lg border border-[var(--accent-strong)] bg-[var(--accent-strong)]/8 px-5 py-3 text-center">
          <span className="text-sm font-medium">
            Need <strong className="text-[var(--accent-strong)]">
              {Math.max(0, live.target - currentInnings.runs)}
            </strong>{' '}
            from{' '}
            <strong>
              {(currentInnings.overs_allocated - currentInnings.overs).toFixed(1)}
            </strong>{' '}
            overs
          </span>
        </div>
      )}

      {/* Result banner */}
      {isFinished && live.result && (
        <div className="rounded-lg border border-[var(--accent-strong)] bg-[var(--accent-strong)]/8 px-5 py-4 text-center">
          <p className="text-base font-bold">
            {live.result.winner === 'tie'
              ? 'Match Tied'
              : `Team ${live.result.winner === 'A' ? live.team_a_name : live.team_b_name} won by ${live.result.winning_margin} ${live.result.winning_type}`}
          </p>
        </div>
      )}

      {/* Over-by-over timeline */}
      {overNumbers.length > 0 && (
        <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-5">
          <p className="mb-4 text-xs font-medium text-[var(--text-muted)]">
            Over Timeline
          </p>
          <div className="space-y-3">
            {overNumbers.map((ovNum) => {
              const ovBalls = ballsByOver[ovNum]
              const ovRuns = ovBalls.reduce((s, b) => s + b.total_runs, 0)
              const ovWickets = ovBalls.filter((b) => b.wicket_type).length
              return (
                <div key={ovNum} className="flex items-center gap-3">
                  <span className="w-12 shrink-0 text-right text-xs font-medium text-[var(--text-muted)]">
                    Ov {ovNum}
                  </span>
                  <div className="flex flex-wrap gap-1.5">
                    {ovBalls.map((b, i) => (
                      <span
                        key={b.id ?? i}
                        className={`flex h-8 w-8 items-center justify-center rounded-full border text-xs font-bold ${ballColor(b)}`}
                      >
                        {ballLabel(b)}
                      </span>
                    ))}
                  </div>
                  <span className="ml-auto text-xs text-[var(--text-muted)]">
                    {ovRuns} run{ovRuns !== 1 ? 's' : ''}
                    {ovWickets > 0 && (
                      <>, <span className="text-red-400">{ovWickets}W</span></>
                    )}
                  </span>
                </div>
              )
            })}
          </div>
        </div>
      )}

      {/* Team lineups */}
      {(live.team_a?.length > 0 || live.team_b?.length > 0) && (
        <div className="grid gap-3 sm:grid-cols-2">
          {[
            { name: live.team_a_name, players: live.team_a },
            { name: live.team_b_name ?? 'Team B', players: live.team_b },
          ].map((team) => (
            <div key={team.name} className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-4">
              <p className="mb-2 text-xs font-medium text-[var(--text-muted)]">{team.name}</p>
              <div className="space-y-1.5">
                {team.players?.map((p, i) => (
                  <div key={i} className="flex items-center justify-between text-sm">
                    <span>{p.name}</span>
                    <span className="text-xs text-[var(--text-muted)]">{p.role}</span>
                  </div>
                ))}
                {(!team.players || team.players.length === 0) && (
                  <p className="text-sm text-[var(--text-muted)]">No players listed</p>
                )}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Share bar */}
      <div className="flex items-center justify-center gap-3 pb-8">
        <button
          onClick={() => navigator.clipboard?.writeText(window.location.href)}
          className="rounded-lg border border-[var(--line)] px-5 py-2 text-sm text-[var(--text-muted)] hover:border-[var(--accent)]"
        >
          Copy Link
        </button>
        <a href="/" className="text-sm text-[var(--accent)] hover:underline">
          Open inSwing
        </a>
      </div>
    </section>
  )
}
