import { useCallback, useEffect, useRef, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import {
  fetchMatch,
  fetchInnings,
  fetchBalls,
  createInnings,
  recordBall,
  deleteBall,
  recordToss,
  addPlayer,
  getTeams,
  markTeamReady,
} from '../lib/api/matches'
import { MoreHorizontal, Trophy, Undo2 } from 'lucide-react'
import type {
  MatchResponse,
  InningsResponse,
  BallResponse,
  TeamsResponse,
  PlayerInMatch,
} from '../lib/api/matches'
import { authStore } from '../lib/auth-store'
import { createMatchSocket } from '../lib/ws'
import type { AxiosError } from 'axios'

// ── Helpers ─────────────────────────────────────────────────────────────────

const RUN_BUTTONS = [0, 1, 2, 3, 4, 6] as const
const EXTRAS = ['wide', 'no_ball', 'bye', 'legbye'] as const
const WICKETS = ['bowled', 'caught', 'runout', 'lbw', 'stumped', 'hit_wicket'] as const

function ballLabel(b: { runs_off_bat: number; extras_type: string | null; wicket_type: string | null; total_runs: number }) {
  if (b.wicket_type) return 'W'
  if (b.extras_type === 'wide') return `${b.total_runs}wd`
  if (b.extras_type === 'no_ball') return `${b.total_runs}nb`
  if (b.extras_type === 'bye') return `${b.total_runs}b`
  if (b.extras_type === 'legbye') return `${b.total_runs}lb`
  return String(b.runs_off_bat)
}

function ballColor(b: { runs_off_bat: number; extras_type: string | null; wicket_type: string | null }) {
  if (b.wicket_type) return 'bg-red-500/15 text-red-400 border-red-500/30'
  if (b.extras_type) return 'bg-amber-500/10 text-amber-400 border-amber-500/25'
  if (b.runs_off_bat === 4) return 'bg-blue-500/10 text-blue-400 border-blue-500/25'
  if (b.runs_off_bat === 6) return 'bg-purple-500/10 text-purple-400 border-purple-500/25'
  return 'bg-[var(--bg-surface)] border-[var(--line)]'
}

// ── Add Player Modal ────────────────────────────────────────────────────────

function AddPlayerModal({
  matchId,
  team,
  onClose,
  onAdded,
}: {
  matchId: string
  team: 'A' | 'B'
  onClose: () => void
  onAdded: () => void
}) {
  const [guestName, setGuestName] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const handleAdd = async () => {
    if (!guestName.trim()) return
    setLoading(true)
    setError('')
    try {
      await addPlayer(matchId, { guest_name: guestName.trim(), team, role: 'batsman' })
      onAdded()
      onClose()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4" onClick={onClose}>
      <div
        className="w-full max-w-sm rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-6"
        onClick={(e) => e.stopPropagation()}
      >
        <h3 className="text-base font-bold">Add Player — Team {team}</h3>
        <p className="mt-1 text-sm text-[var(--text-muted)]">Guest players don't need an account</p>
        <input
          value={guestName}
          onChange={(e) => setGuestName(e.target.value)}
          placeholder="Player name"
          className="mt-4 w-full rounded-lg border border-[var(--line)] bg-[var(--bg-deep)] px-3 py-2.5 text-sm outline-none transition focus:border-[var(--accent)]"
          autoFocus
          onKeyDown={(e) => e.key === 'Enter' && handleAdd()}
        />
        {error && <p className="mt-2 text-xs text-red-400">{error}</p>}
        <div className="mt-4 flex gap-3">
          <button
            onClick={handleAdd}
            disabled={loading || !guestName.trim()}
            className="flex-1 rounded-lg bg-[var(--accent)] py-2 text-sm font-semibold text-white disabled:opacity-50"
          >
            {loading ? 'Adding…' : 'Add Player'}
          </button>
          <button onClick={onClose} className="rounded-lg border border-[var(--line)] px-4 py-2 text-sm text-[var(--text-muted)]">
            Cancel
          </button>
        </div>
      </div>
    </div>
  )
}

// ── Main Page ───────────────────────────────────────────────────────────────

export function ScoringConsolePage() {
  const { matchId } = useParams<{ matchId: string }>()
  const navigate = useNavigate()
  const wsRef = useRef<ReturnType<typeof createMatchSocket> | null>(null)

  // ── State ───────────────────────────────────────────────────────────────
  const [currentInnings, setCurrentInnings] = useState<InningsResponse | null>(null)
  const [overBalls, setOverBalls] = useState<BallResponse[]>([])
  const [currentOver, setCurrentOver] = useState(1)
  const [currentBall, setCurrentBall] = useState(1)
  const [selectedExtras, setSelectedExtras] = useState<string | null>(null)
  const [selectedWicket, setSelectedWicket] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState('')
  const [showAddPlayer, setShowAddPlayer] = useState<'A' | 'B' | null>(null)

  // Player tracking
  const [strikerId, setStrikerId] = useState<string | null>(null)
  const [nonStrikerId, setNonStrikerId] = useState<string | null>(null)
  const [bowlerId, setBowlerId] = useState<string | null>(null)

  // Toss state
  const [tossWinner, setTossWinner] = useState<'A' | 'B'>('A')
  const [tossDecision, setTossDecision] = useState<'bat' | 'bowl'>('bat')

  // ── Queries ─────────────────────────────────────────────────────────────
  const { data: match, refetch: refetchMatch } = useQuery({
    queryKey: ['match', matchId],
    queryFn: () => fetchMatch(matchId!),
    enabled: !!matchId,
  })

  const { data: innings, refetch: refetchInnings } = useQuery({
    queryKey: ['innings', matchId],
    queryFn: () => fetchInnings(matchId!),
    enabled: !!matchId,
  })

  const { data: teams, refetch: refetchTeams } = useQuery({
    queryKey: ['teams', matchId],
    queryFn: () => getTeams(matchId!),
    enabled: !!matchId,
  })

  const { data: allBalls, refetch: refetchBalls } = useQuery({
    queryKey: ['balls', matchId, currentInnings?.id],
    queryFn: () => fetchBalls(matchId!, currentInnings!.id),
    enabled: !!matchId && !!currentInnings,
  })

  // Set current innings from fetched data
  useEffect(() => {
    if (innings && innings.length > 0) {
      const active = innings.find((i) => !i.is_completed) ?? innings[innings.length - 1]
      setCurrentInnings(active)
      const totalLegalBalls = Math.round(active.overs_bowled * 10) % 10
      setCurrentOver(Math.floor(active.overs_bowled) + (totalLegalBalls > 0 ? 0 : 0) + 1)
      setCurrentBall(totalLegalBalls + 1)
    }
  }, [innings])

  // ── WebSocket ───────────────────────────────────────────────────────────
  useEffect(() => {
    const token = authStore.getAccessToken()
    if (!token || !matchId) return

    const ws = createMatchSocket(token)
    wsRef.current = ws

    ws.onConnected(() => {
      ws.subscribe(matchId)
    })

    ws.onBallUpdate(() => {
      refetchInnings()
    })

    ws.onMatchStatus(() => {
      refetchMatch()
    })

    return () => {
      ws.close()
    }
  }, [matchId, refetchInnings, refetchMatch])

  // ── Handlers ────────────────────────────────────────────────────────────
  const handleRecordBall = useCallback(
    async (runs: number) => {
      if (!matchId || !currentInnings || submitting) return

      // Wicket selected but no type chosen? Don't proceed
      if (selectedWicket && !WICKETS.includes(selectedWicket as typeof WICKETS[number])) return

      setSubmitting(true)
      setError('')

      const clientEventId = `${matchId}-${currentInnings.id}-${Date.now()}`

      try {
        const ball = await recordBall(matchId, currentInnings.id, {
          over_number: currentOver,
          ball_in_over: currentBall,
          runs_off_bat: selectedExtras ? 0 : runs,
          extras_type: (selectedExtras ?? undefined) as 'wide' | 'no_ball' | 'bye' | 'legbye' | undefined,
          extras_runs: selectedExtras ? runs || 1 : 0,
          wicket_type: (selectedWicket ?? undefined) as 'bowled' | 'caught' | 'runout' | 'lbw' | 'stumped' | 'hit_wicket' | undefined,
          batsman_id: strikerId ?? undefined,
          non_striker_id: nonStrikerId ?? undefined,
          bowler_id: bowlerId ?? undefined,
          client_event_id: clientEventId,
        })

        setOverBalls((prev) => [...prev, ball])

        if (ball.is_legal_delivery) {
          if (currentBall >= 6) {
            setCurrentOver((o) => o + 1)
            setCurrentBall(1)
            setOverBalls([])
            // End of over: swap strike
            setStrikerId(nonStrikerId)
            setNonStrikerId(strikerId)
          } else {
            setCurrentBall((b) => b + 1)
            // Swap strike on odd runs
            if (runs % 2 === 1) {
              setStrikerId(nonStrikerId)
              setNonStrikerId(strikerId)
            }
          }
        }

        setSelectedExtras(null)
        setSelectedWicket(null)
        refetchInnings()
        refetchBalls()
        refetchMatch()
      } catch (err) {
        setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed to record ball')
      } finally {
        setSubmitting(false)
      }
    },
    [matchId, currentInnings, currentOver, currentBall, selectedExtras, selectedWicket, strikerId, nonStrikerId, bowlerId, submitting, refetchInnings, refetchBalls, refetchMatch],
  )

  const handleToss = async () => {
    if (!matchId) return
    try {
      await recordToss(matchId, tossWinner, tossDecision)
      refetchMatch()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Toss failed')
    }
  }

  const handleCreateInnings = async () => {
    if (!match || !matchId) return
    const battingTeam = match.toss_decision === 'bat' ? match.toss_winner! : (match.toss_winner === 'A' ? 'B' : 'A')
    const oversLimit = match.rules?.overs_limit ?? 6
    try {
      const newInnings = await createInnings(matchId, battingTeam as 'A' | 'B', oversLimit)
      setCurrentInnings(newInnings)
      setCurrentOver(1)
      setCurrentBall(1)
      setOverBalls([])
      refetchInnings()
      refetchMatch()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed to start innings')
    }
  }

  const handleStartSecondInnings = async () => {
    if (!match || !matchId || !innings) return
    const firstInnings = innings[0]
    const secondBattingTeam = firstInnings.batting_team === 'A' ? 'B' : 'A'
    const oversLimit = match.rules?.overs_limit ?? 6
    try {
      const newInnings = await createInnings(matchId, secondBattingTeam, oversLimit)
      setCurrentInnings(newInnings)
      setCurrentOver(1)
      setCurrentBall(1)
      setOverBalls([])
      refetchInnings()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed to start 2nd innings')
    }
  }

  const handleTeamReady = async () => {
    if (!matchId) return
    try {
      await markTeamReady(matchId, true)
      refetchMatch()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed')
    }
  }

  const handleUndoLastBall = useCallback(async () => {
    if (!matchId || !currentInnings || submitting) return
    const lastBall = overBalls.length > 0 ? overBalls[overBalls.length - 1] : (allBalls && allBalls.length > 0 ? allBalls[allBalls.length - 1] : null)
    if (!lastBall) return

    setSubmitting(true)
    setError('')
    try {
      await deleteBall(matchId, currentInnings.id, lastBall.id)
      setOverBalls((prev) => prev.slice(0, -1))

      // Revert ball counter
      if (lastBall.is_legal_delivery) {
        if (currentBall === 1 && currentOver > 1) {
          // Was start of a new over — go back to ball 6 of previous over
          setCurrentOver((o) => o - 1)
          setCurrentBall(6)
        } else if (currentBall > 1) {
          setCurrentBall((b) => b - 1)
        }
        // Revert strike rotation
        const runs = lastBall.runs_off_bat
        if (runs % 2 === 1) {
          setStrikerId(nonStrikerId)
          setNonStrikerId(strikerId)
        }
      }

      refetchInnings()
      refetchBalls()
      refetchMatch()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Undo failed')
    } finally {
      setSubmitting(false)
    }
  }, [matchId, currentInnings, currentOver, currentBall, overBalls, allBalls, strikerId, nonStrikerId, submitting, refetchInnings, refetchBalls, refetchMatch])

  // ── Loading states ──────────────────────────────────────────────────────
  if (!matchId) return <p className="text-[var(--text-muted)]">No match ID</p>
  if (!match) return <LoadingState />

  // ── Match finished ──────────────────────────────────────────────────────
  if (match.status === 'finished') {
    return <MatchFinishedView match={match} innings={innings ?? []} />
  }

  // ── Pre-match phases ────────────────────────────────────────────────────
  if (['created', 'accepted', 'teams_ready', 'rules_approved'].includes(match.status)) {
    return (
      <PreMatchView
        match={match}
        teams={teams}
        error={error}
        onAddPlayer={(team) => setShowAddPlayer(team)}
        onTeamReady={handleTeamReady}
        addPlayerModal={
          showAddPlayer && (
            <AddPlayerModal
              matchId={matchId}
              team={showAddPlayer}
              onClose={() => setShowAddPlayer(null)}
              onAdded={() => refetchTeams()}
            />
          )
        }
      />
    )
  }

  // ── Toss phase ──────────────────────────────────────────────────────────
  if (match.status === 'toss_done' && (!innings || innings.length === 0)) {
    return (
      <section className="space-y-6">
        <MatchHeader match={match} innings={null} />
        <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-6 text-center">
          <h3 className="text-lg font-bold">Ready to Start</h3>
          <p className="mt-2 text-sm text-[var(--text-muted)]">
            Toss won by Team {match.toss_winner} — chose to {match.toss_decision}
          </p>
          <button
            onClick={handleCreateInnings}
            className="mt-4 rounded-lg bg-[var(--accent)] px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)]"
          >
            Start 1st Innings
          </button>
          {error && <p className="mt-2 text-xs text-red-400">{error}</p>}
        </div>
      </section>
    )
  }

  // ── Needs toss ──────────────────────────────────────────────────────────
  if (!match.toss_winner) {
    return (
      <section className="space-y-6">
        <MatchHeader match={match} innings={null} />
        <TossView
          match={match}
          tossWinner={tossWinner}
          tossDecision={tossDecision}
          onSetWinner={setTossWinner}
          onSetDecision={setTossDecision}
          onSubmit={handleToss}
          error={error}
        />
      </section>
    )
  }

  // ── Innings break ───────────────────────────────────────────────────────
  if (currentInnings?.is_completed && innings && innings.length === 1) {
    const target = innings[0].runs + 1
    return (
      <section className="space-y-6">
        <MatchHeader match={match} innings={innings[0]} />
        <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-6 text-center">
          <p className="text-xs font-semibold uppercase tracking-wider text-[var(--accent)]">Innings Break</p>
          <h3 className="mt-2 text-xl font-bold">
            Team {innings[0].batting_team}: {innings[0].runs}/{innings[0].wickets}
          </h3>
          <p className="mt-2 text-base text-[var(--text-muted)]">Target: {target}</p>
          <button
            onClick={handleStartSecondInnings}
            className="mt-4 rounded-lg bg-[var(--accent)] px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)]"
          >
            Start 2nd Innings
          </button>
          {error && <p className="mt-2 text-xs text-red-400">{error}</p>}
        </div>
      </section>
    )
  }

  // ── LIVE SCORING ────────────────────────────────────────────────────────
  const target = innings && innings.length >= 2 ? innings[0].runs + 1 : null

  // Get batting and bowling team players
  const battingTeamKey = currentInnings?.batting_team === 'A' ? 'team_a' : 'team_b'
  const bowlingTeamKey = currentInnings?.batting_team === 'A' ? 'team_b' : 'team_a'
  const battingPlayers = teams?.[battingTeamKey]?.players ?? []
  const bowlingPlayers = teams?.[bowlingTeamKey]?.players ?? []

  return (
    <section className="space-y-4">
      <MatchHeader match={match} innings={currentInnings} target={target} />

      {/* Scoreboard strip */}
      {innings && innings.length > 0 && (
        <div className="flex flex-wrap gap-3">
          {innings.map((inn) => (
            <div
              key={inn.id}
              className={`rounded-lg border px-4 py-2 text-sm ${
                inn.id === currentInnings?.id
                  ? 'border-[var(--accent)] bg-[var(--accent)]/8'
                  : 'border-[var(--line)] bg-[var(--bg-deep)]'
              }`}
            >
              <span className="font-bold">
                {inn.batting_team === 'A' ? match.team_a_name : match.team_b_name}
              </span>{' '}
              <span className="text-[var(--text-muted)]">
                {inn.runs}/{inn.wickets} ({inn.overs_bowled} ov)
                {inn.is_completed && ' ✓'}
              </span>
            </div>
          ))}
          {target && (
            <div className="rounded-lg border border-[var(--accent-strong)] bg-[var(--accent-strong)]/8 px-4 py-2 text-sm font-medium">
              Need {Math.max(0, target - (currentInnings?.runs ?? 0))} off{' '}
              {((currentInnings?.overs_allocated ?? 0) - (currentInnings?.overs_bowled ?? 0)).toFixed(1)} ov
            </div>
          )}
        </div>
      )}

      {/* Batsmen & Bowler Panel */}
      <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-4">
        <BatsmenBowlerPanel
          battingPlayers={battingPlayers}
          bowlingPlayers={bowlingPlayers}
          strikerId={strikerId}
          nonStrikerId={nonStrikerId}
          bowlerId={bowlerId}
          onSetStriker={setStrikerId}
          onSetNonStriker={setNonStrikerId}
          onSetBowler={setBowlerId}
          allBalls={allBalls ?? []}
        />
      </div>

      {/* This over strip */}
      <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-4">
        <div className="mb-3 flex items-center justify-between">
          <p className="text-xs font-medium text-[var(--text-muted)]">
            Over {currentOver} — Ball {currentBall}
          </p>
          <div className="flex items-center gap-3">
            <button
              type="button"
              disabled={submitting || (!overBalls.length && !(allBalls && allBalls.length))}
              onClick={handleUndoLastBall}
              className="flex items-center gap-1 rounded-md border border-amber-500/30 bg-amber-500/10 px-2.5 py-1 text-xs font-medium text-amber-400 transition hover:bg-amber-500/20 disabled:opacity-30 disabled:cursor-not-allowed"
            >
              <Undo2 size={12} />
              Undo
            </button>
            <p className="text-sm font-bold text-[var(--accent)]">
              {currentInnings ? `${currentInnings.runs}/${currentInnings.wickets}` : '—'}
            </p>
          </div>
        </div>

        <div className="flex flex-wrap gap-2">
          {overBalls.map((b, i) => (
            <div
              key={b.id ?? i}
              className={`flex h-10 w-10 items-center justify-center rounded-full border text-sm font-bold ${ballColor(b)}`}
            >
              {ballLabel(b)}
            </div>
          ))}
          {overBalls.length === 0 && (
            <p className="py-2 text-sm text-[var(--text-muted)]">New over — no balls yet</p>
          )}
        </div>
      </div>

      {/* Scoring controls */}
      <div className="grid gap-4 md:grid-cols-[1fr_auto]">
        {/* Run buttons */}
        <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-4">
          <p className="mb-3 text-xs font-medium text-[var(--text-muted)]">Runs</p>
          <div className="grid grid-cols-4 gap-3">
            {RUN_BUTTONS.map((r) => (
              <button
                key={r}
                type="button"
                disabled={submitting}
                onClick={() => handleRecordBall(r)}
                className={`aspect-square flex items-center justify-center rounded-full font-mono text-2xl font-bold transition-transform active:scale-95 disabled:opacity-50 shadow-md ${
                  r === 4 || r === 6
                    ? 'bg-[#3ca360] text-white'
                    : 'bg-[#303630] border border-[#3e4a3f] text-[#dfe4dc]'
                }`}
              >
                {r}
              </button>
            ))}
            <button
              type="button"
              disabled={submitting}
              onClick={() => setSelectedWicket(selectedWicket ? null : 'bowled')}
              className={`aspect-square flex flex-col items-center justify-center rounded-full font-mono text-2xl font-bold transition-transform active:scale-95 disabled:opacity-50 shadow-lg ${
                selectedWicket
                  ? 'bg-red-600 ring-2 ring-red-400 text-white'
                  : 'bg-red-500 text-white'
              }`}
            >
              <span>W</span>
              <span className="text-[9px] font-semibold -mt-1">WICKET</span>
            </button>
            <button
              type="button"
              className="aspect-square flex items-center justify-center rounded-full bg-[#303630] border border-[#3e4a3f] text-[#889488] transition-transform active:scale-95"
            >
              <MoreHorizontal size={18} />
            </button>
          </div>

          {/* Extras */}
          <p className="mb-2 mt-4 text-xs font-medium text-[var(--text-muted)]">Extras</p>
          <div className="flex flex-wrap gap-2">
            {EXTRAS.map((e) => (
              <button
                key={e}
                type="button"
                onClick={() => setSelectedExtras(selectedExtras === e ? null : e)}
                className={`rounded-md border px-3 py-1.5 text-xs font-medium transition ${
                  selectedExtras === e
                    ? 'border-amber-400 bg-amber-500/15 text-amber-400'
                    : 'border-[var(--line)] text-[var(--text-muted)] hover:border-amber-400'
                }`}
              >
                {e === 'no_ball' ? 'No Ball' : e === 'legbye' ? 'Leg Bye' : e.charAt(0).toUpperCase() + e.slice(1)}
              </button>
            ))}
          </div>

          {/* Wicket */}
          <p className="mb-2 mt-4 text-xs font-medium text-[var(--text-muted)]">Wicket</p>
          <div className="flex flex-wrap gap-2">
            {WICKETS.map((w) => (
              <button
                key={w}
                type="button"
                onClick={() => setSelectedWicket(selectedWicket === w ? null : w)}
                className={`rounded-md border px-3 py-1.5 text-xs font-medium transition ${
                  selectedWicket === w
                    ? 'border-red-400 bg-red-500/15 text-red-400'
                    : 'border-[var(--line)] text-[var(--text-muted)] hover:border-red-400'
                }`}
              >
                {w === 'hit_wicket' ? 'Hit Wicket' : w.charAt(0).toUpperCase() + w.slice(1)}
              </button>
            ))}
          </div>

          {(selectedExtras || selectedWicket) && (
            <div className="mt-3 rounded-md border border-dashed border-amber-500/25 bg-amber-500/5 px-3 py-2 text-xs text-amber-300">
              Next ball: {selectedExtras && <strong>{selectedExtras}</strong>}
              {selectedExtras && selectedWicket && ' + '}
              {selectedWicket && <strong className="text-red-400">{selectedWicket}</strong>}
              {' — tap a run button to record'}
            </div>
          )}
        </div>

        {/* Live share link */}
        <div className="flex flex-col gap-3 md:w-48">
          <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-4">
            <p className="text-xs font-medium text-[var(--accent)]">Live Link</p>
            <p className="mt-2 break-all text-xs text-[var(--text-muted)]">
              {window.location.origin}/live/{matchId}
            </p>
            <button
              type="button"
              onClick={() => navigator.clipboard?.writeText(`${window.location.origin}/live/${matchId}`)}
              className="mt-2 w-full rounded-md border border-[var(--line)] py-1.5 text-xs text-[var(--text-muted)] hover:border-[var(--accent)]"
            >
              Copy Link
            </button>
          </div>
          <button
            type="button"
            onClick={() => navigate('/dashboard')}
            className="rounded-lg border border-[var(--line)] py-2 text-sm text-[var(--text-muted)] hover:border-[var(--accent)]"
          >
            ← Dashboard
          </button>
        </div>
      </div>

      {error && <p className="text-xs text-red-400">{error}</p>}
    </section>
  )
}

// ── Sub-components ──────────────────────────────────────────────────────────

function BatsmenBowlerPanel({
  battingPlayers,
  bowlingPlayers,
  strikerId,
  nonStrikerId,
  bowlerId,
  onSetStriker,
  onSetNonStriker,
  onSetBowler,
  allBalls,
}: {
  battingPlayers: PlayerInMatch[]
  bowlingPlayers: PlayerInMatch[]
  strikerId: string | null
  nonStrikerId: string | null
  bowlerId: string | null
  onSetStriker: (id: string | null) => void
  onSetNonStriker: (id: string | null) => void
  onSetBowler: (id: string | null) => void
  allBalls: BallResponse[]
}) {
  // Compute batting stats
  const getBatStats = (playerId: string | null) => {
    if (!playerId) return { runs: 0, balls: 0, fours: 0, sixes: 0, sr: '0.0' }
    const batBalls = allBalls.filter(b => b.batsman_id === playerId)
    const legalBalls = batBalls.filter(b => b.is_legal_delivery)
    const runs = batBalls.reduce((sum, b) => sum + b.runs_off_bat, 0)
    const fours = batBalls.filter(b => b.runs_off_bat === 4).length
    const sixes = batBalls.filter(b => b.runs_off_bat === 6).length
    const ballsFaced = legalBalls.length
    const sr = ballsFaced > 0 ? ((runs / ballsFaced) * 100).toFixed(1) : '0.0'
    return { runs, balls: ballsFaced, fours, sixes, sr }
  }

  // Compute bowling stats
  const getBowlStats = (playerId: string | null) => {
    if (!playerId) return { overs: '0.0', runs: 0, wickets: 0, econ: '0.0' }
    const bowlBalls = allBalls.filter(b => b.bowler_id === playerId)
    const legalBalls = bowlBalls.filter(b => b.is_legal_delivery).length
    const runs = bowlBalls.reduce((sum, b) => sum + b.total_runs, 0)
    const wickets = bowlBalls.filter(b => b.wicket_type).length
    const overs = `${Math.floor(legalBalls / 6)}.${legalBalls % 6}`
    const econ = legalBalls > 0 ? ((runs / legalBalls) * 6).toFixed(1) : '0.0'
    return { overs, runs, wickets, econ }
  }

  const getPlayerName = (id: string | null, players: PlayerInMatch[]) => {
    if (!id) return null
    const p = players.find(pl => pl.id === id)
    return p ? (p.display_name ?? p.guest_name ?? 'Player') : null
  }

  const strikerStats = getBatStats(strikerId)
  const nonStrikerStats = getBatStats(nonStrikerId)
  const bowlerStats = getBowlStats(bowlerId)
  const strikerName = getPlayerName(strikerId, battingPlayers)
  const nonStrikerName = getPlayerName(nonStrikerId, battingPlayers)
  const bowlerName = getPlayerName(bowlerId, bowlingPlayers)

  return (
    <div className="space-y-3">
      {/* Batting figures */}
      <div className="grid gap-3 md:grid-cols-2">
        {/* Striker card */}
        <div className={`rounded-lg border p-3 ${strikerId ? 'border-emerald-500/50 bg-emerald-500/5' : 'border-[var(--line)]'}`}>
          <div className="flex items-center justify-between mb-2">
            <span className="text-[10px] font-bold uppercase tracking-wider text-emerald-400">🏏 Striker</span>
            {strikerId && (
              <span className="font-mono text-lg font-bold text-emerald-400">
                {strikerStats.runs}<span className="text-xs text-[var(--text-muted)]"> ({strikerStats.balls})</span>
              </span>
            )}
          </div>
          {strikerId ? (
            <div className="flex items-center justify-between">
              <span className="text-sm font-semibold text-[#dfe4dc]">{strikerName}</span>
              <span className="text-[10px] text-[var(--text-muted)]">
                {strikerStats.fours}×4 {strikerStats.sixes}×6 SR {strikerStats.sr}
              </span>
            </div>
          ) : null}
          <select
            value={strikerId ?? ''}
            onChange={(e) => onSetStriker(e.target.value || null)}
            className="mt-2 w-full rounded-md border border-[var(--line)] bg-[var(--bg-deep)] px-2 py-1.5 text-xs outline-none focus:border-emerald-500"
          >
            <option value="">Select batsman...</option>
            {battingPlayers.filter(p => p.id !== nonStrikerId).map(p => (
              <option key={p.id} value={p.id}>{p.display_name ?? p.guest_name ?? 'Player'}</option>
            ))}
          </select>
        </div>

        {/* Non-Striker card */}
        <div className={`rounded-lg border p-3 ${nonStrikerId ? 'border-[#3e4a3f] bg-[var(--bg-deep)]' : 'border-[var(--line)]'}`}>
          <div className="flex items-center justify-between mb-2">
            <span className="text-[10px] font-bold uppercase tracking-wider text-[var(--text-muted)]">Non-Striker</span>
            {nonStrikerId && (
              <span className="font-mono text-lg font-bold text-[#becabc]">
                {nonStrikerStats.runs}<span className="text-xs text-[var(--text-muted)]"> ({nonStrikerStats.balls})</span>
              </span>
            )}
          </div>
          {nonStrikerId ? (
            <div className="flex items-center justify-between">
              <span className="text-sm font-semibold text-[#dfe4dc]">{nonStrikerName}</span>
              <span className="text-[10px] text-[var(--text-muted)]">
                {nonStrikerStats.fours}×4 {nonStrikerStats.sixes}×6 SR {nonStrikerStats.sr}
              </span>
            </div>
          ) : null}
          <select
            value={nonStrikerId ?? ''}
            onChange={(e) => onSetNonStriker(e.target.value || null)}
            className="mt-2 w-full rounded-md border border-[var(--line)] bg-[var(--bg-deep)] px-2 py-1.5 text-xs outline-none focus:border-emerald-500"
          >
            <option value="">Select batsman...</option>
            {battingPlayers.filter(p => p.id !== strikerId).map(p => (
              <option key={p.id} value={p.id}>{p.display_name ?? p.guest_name ?? 'Player'}</option>
            ))}
          </select>
        </div>
      </div>

      {/* Bowler card */}
      <div className={`rounded-lg border p-3 ${bowlerId ? 'border-red-500/30 bg-red-500/5' : 'border-[var(--line)]'}`}>
        <div className="flex items-center justify-between mb-2">
          <span className="text-[10px] font-bold uppercase tracking-wider text-red-400">⚾ Bowler</span>
          {bowlerId && (
            <span className="font-mono text-sm font-bold text-red-400">
              {bowlerStats.overs}-{bowlerStats.runs}-{bowlerStats.wickets}
            </span>
          )}
        </div>
        <div className="flex items-center gap-3">
          <div className="flex-1">
            {bowlerId && (
              <div className="flex items-center justify-between mb-1">
                <span className="text-sm font-semibold text-[#dfe4dc]">{bowlerName}</span>
                <span className="text-[10px] text-[var(--text-muted)]">
                  Econ {bowlerStats.econ}
                </span>
              </div>
            )}
            <select
              value={bowlerId ?? ''}
              onChange={(e) => onSetBowler(e.target.value || null)}
              className="w-full rounded-md border border-[var(--line)] bg-[var(--bg-deep)] px-2 py-1.5 text-xs outline-none focus:border-emerald-500"
            >
              <option value="">Select bowler...</option>
              {bowlingPlayers.map(p => (
                <option key={p.id} value={p.id}>{p.display_name ?? p.guest_name ?? 'Player'}</option>
              ))}
            </select>
          </div>
        </div>
      </div>
    </div>
  )
}

function LoadingState() {
  return (
    <div className="flex items-center justify-center py-20">
      <div className="h-8 w-8 animate-spin rounded-full border-2 border-emerald-500 border-t-transparent" />
    </div>
  )
}

function MatchHeader({
  match,
  innings,
}: {
  match: MatchResponse
  innings: InningsResponse | null
  target?: number | null
}) {
  return (
    <div className="rounded-xl border border-[#3e4a3f] bg-[#1b211c] px-5 py-4 shadow-lg">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <div className="flex items-center gap-2">
            <Trophy size={18} className="text-emerald-500" />
            <h2 className="text-lg font-bold text-[#dfe4dc]">
              {match.team_a_name} vs {match.team_b_name ?? 'TBD'}
            </h2>
            {match.status === 'live' && (
              <span className="flex items-center gap-1 rounded-sm bg-red-500 px-1.5 py-0.5">
                <span className="h-1.5 w-1.5 animate-pulse rounded-full bg-white" />
                <span className="text-[10px] font-bold uppercase text-white">LIVE</span>
              </span>
            )}
          </div>
          {match.venue && <p className="text-sm text-[#becabc] mt-0.5">{match.venue}</p>}
        </div>
        {innings && (
          <div className="text-right">
            <span className="text-xs font-semibold uppercase tracking-wider text-[#becabc] block mb-0.5">TOTAL SCORE</span>
            <p className="font-mono text-3xl font-bold text-emerald-400">
              {innings.runs}<span className="text-lg text-[#becabc]">/{innings.wickets}</span>
            </p>
            <p className="font-mono text-sm text-[#becabc]">{innings.overs_bowled} ov</p>
          </div>
        )}
      </div>
    </div>
  )
}

function TossView({
  match,
  tossWinner,
  tossDecision,
  onSetWinner,
  onSetDecision,
  onSubmit,
  error,
}: {
  match: MatchResponse
  tossWinner: 'A' | 'B'
  tossDecision: 'bat' | 'bowl'
  onSetWinner: (v: 'A' | 'B') => void
  onSetDecision: (v: 'bat' | 'bowl') => void
  onSubmit: () => void
  error: string
}) {
  return (
    <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-6">
      <h3 className="text-lg font-bold">Toss</h3>
      <p className="mt-1 text-sm text-[var(--text-muted)]">Record who won the toss and their decision</p>

      <div className="mt-4 space-y-4">
        <div>
          <p className="mb-2 text-sm text-[var(--text-muted)]">Who won?</p>
          <div className="grid grid-cols-2 gap-3">
            {(['A', 'B'] as const).map((t) => (
              <button
                key={t}
                type="button"
                onClick={() => onSetWinner(t)}
                className={`rounded-lg border p-3 text-sm font-medium transition ${
                  tossWinner === t ? 'border-[var(--accent)] bg-[var(--accent)]/8' : 'border-[var(--line)]'
                }`}
              >
                {t === 'A' ? match.team_a_name : match.team_b_name ?? 'Team B'}
              </button>
            ))}
          </div>
        </div>

        <div>
          <p className="mb-2 text-sm text-[var(--text-muted)]">Elected to?</p>
          <div className="grid grid-cols-2 gap-3">
            {(['bat', 'bowl'] as const).map((d) => (
              <button
                key={d}
                type="button"
                onClick={() => onSetDecision(d)}
                className={`rounded-lg border p-3 text-sm font-medium transition ${
                  tossDecision === d ? 'border-[var(--accent-strong)] bg-[var(--accent-strong)]/8' : 'border-[var(--line)]'
                }`}
              >
                {d.charAt(0).toUpperCase() + d.slice(1)}
              </button>
            ))}
          </div>
        </div>

        {error && <p className="text-xs text-red-400">{error}</p>}

        <button
          onClick={onSubmit}
          className="w-full rounded-lg bg-[var(--accent)] py-2.5 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)]"
        >
          Confirm Toss
        </button>
      </div>
    </div>
  )
}

function PreMatchView({
  match,
  teams,
  error,
  onAddPlayer,
  onTeamReady,
  addPlayerModal,
}: {
  match: MatchResponse
  teams: TeamsResponse | undefined
  error: string
  onAddPlayer: (team: 'A' | 'B') => void
  onTeamReady: () => void
  addPlayerModal: React.ReactNode
}) {
  return (
    <section className="space-y-6">
      <MatchHeader match={match} innings={null} />

      <div className="grid gap-4 md:grid-cols-2">
        {(['A', 'B'] as const).map((team) => {
          const teamInfo = team === 'A' ? teams?.team_a : teams?.team_b
          const players = teamInfo?.players
          const teamName = teamInfo?.name ?? (team === 'A' ? match.team_a_name : (match.team_b_name ?? 'Team B'))
          return (
            <div key={team} className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-5">
              <div className="flex items-center justify-between">
                <h3 className="font-bold">{teamName}</h3>
                <span className="text-xs text-[var(--text-muted)]">{teamInfo?.count ?? 0} players</span>
              </div>
              <div className="mt-3 space-y-2">
                {players?.map((p) => (
                  <div key={p.id} className="flex items-center justify-between rounded-md border border-[var(--line)] px-3 py-2">
                    <span className="text-sm">{p.display_name ?? p.guest_name ?? 'Player'}</span>
                    <span className="text-xs text-[var(--text-muted)]">{p.role}</span>
                  </div>
                ))}
                {(!players || players.length === 0) && (
                  <p className="py-3 text-center text-sm text-[var(--text-muted)]">No players added yet</p>
                )}
              </div>
              <button
                type="button"
                onClick={() => onAddPlayer(team)}
                className="mt-3 w-full rounded-lg border border-dashed border-[var(--line)] py-2 text-sm text-[var(--text-muted)] hover:border-[var(--accent)] hover:text-[var(--accent)]"
              >
                + Add Player
              </button>
            </div>
          )
        })}
      </div>

      <div className="flex gap-3">
        <button
          onClick={onTeamReady}
          className="rounded-lg bg-[var(--accent)] px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)]"
        >
          Mark Team Ready
        </button>
      </div>
      {error && <p className="text-xs text-red-400">{error}</p>}
      {addPlayerModal}
    </section>
  )
}

function MatchFinishedView({ match, innings }: { match: MatchResponse; innings: InningsResponse[] }) {
  const result = match.result
  const navigate = useNavigate()

  return (
    <section className="space-y-6">
      <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-6 text-center">
        <p className="text-xs font-semibold uppercase tracking-wider text-[var(--accent-strong)]">Match Complete</p>
        <h2 className="mt-3 text-2xl font-bold">
          {match.team_a_name} vs {match.team_b_name}
        </h2>

        {result && (
          <div className="mt-4">
            <p className="text-lg font-bold">
              {result.winner === 'tie'
                ? 'Match Tied'
                : `Team ${result.winner === 'A' ? match.team_a_name : match.team_b_name} won by ${result.winning_margin} ${result.winning_type}`}
            </p>
          </div>
        )}

        <div className="mt-6 flex justify-center gap-4">
          {innings.map((inn) => (
            <div key={inn.id} className="rounded-lg border border-[var(--line)] bg-[var(--bg-deep)] px-6 py-4">
              <p className="text-xs text-[var(--text-muted)]">
                {inn.batting_team === 'A' ? match.team_a_name : match.team_b_name}
              </p>
              <p className="mt-1 text-xl font-bold">
                {inn.runs}/{inn.wickets}
              </p>
              <p className="text-sm text-[var(--text-muted)]">{inn.overs_bowled} overs</p>
            </div>
          ))}
        </div>

        <div className="mt-6 flex justify-center gap-3">
          <button
            onClick={() => navigator.clipboard?.writeText(`${window.location.origin}/live/${match.id}`)}
            className="rounded-lg border border-[var(--line)] px-5 py-2 text-sm text-[var(--text-muted)] hover:border-[var(--accent)]"
          >
            Share Result
          </button>
          <button
            onClick={() => navigate('/dashboard')}
            className="rounded-lg bg-[var(--accent)] px-5 py-2 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)]"
          >
            Dashboard
          </button>
        </div>
      </div>
    </section>
  )
}
