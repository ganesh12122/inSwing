import { useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import {
  fetchMatch,
  getTeams,
  addPlayer,
  markTeamReady,
  recordToss,
  inviteOpponent,
  acceptInvitation,
  proposeRules,
  approveRules,
  createInnings,
} from '../lib/api/matches'
import { ArrowLeft, Check, CheckCircle, Coins, Clock, MapPin, Calendar, MessageSquare } from 'lucide-react'
import { authStore } from '../lib/auth-store'
import type { MatchRules } from '../lib/api/matches'
import type { AxiosError } from 'axios'

const STEPS = ['Invite', 'Teams', 'Rules', 'Toss'] as const

export function MatchSetupHubPage() {
  const { matchId } = useParams<{ matchId: string }>()
  const navigate = useNavigate()
  const [error, setError] = useState('')

  const { data: match, refetch: refetchMatch } = useQuery({
    queryKey: ['match', matchId],
    queryFn: () => fetchMatch(matchId!),
    enabled: !!matchId,
    refetchInterval: 5000,
  })

  const { data: teams, refetch: refetchTeams } = useQuery({
    queryKey: ['teams', matchId],
    queryFn: () => getTeams(matchId!),
    enabled: !!matchId,
    refetchInterval: 5000,
  })

  // Determine current step from match status
  const getStepIndex = (): number => {
    if (!match) return 0
    if (match.status === 'created' || match.status === 'invited') return 0
    if (match.status === 'accepted') return 1
    if (match.status === 'teams_ready' || match.status === 'rules_proposed' || match.status === 'rules_approved') return 2
    if (match.status === 'toss_done') return 3
    return 0
  }

  const currentStep = getStepIndex()

  if (!matchId) return <p className="p-4 text-[#889488]">No match ID</p>

  if (!match) {
    return (
      <div className="flex items-center justify-center pt-20">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-emerald-500 border-t-transparent" />
      </div>
    )
  }

  // Match is live — redirect to scoring
  if (match.status === 'live') {
    navigate(`/match/${matchId}/scoring`, { replace: true })
    return null
  }

  return (
    <div className="min-h-dvh bg-[#0c1821] pb-8 pt-6 px-6 max-w-2xl mx-auto">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <button
          onClick={() => navigate('/dashboard')}
          className="flex h-10 w-10 items-center justify-center rounded-full border border-[#3e4a3f] text-[#becabc]"
        >
          <ArrowLeft size={18} />
        </button>
        <div>
          <h2 className="text-lg font-bold text-[#dfe4dc]">
            {match.team_a_name} vs {match.team_b_name ?? 'TBD'}
          </h2>
          <p className="text-xs text-[#889488]">
            {match.rules.overs_limit} overs · {match.venue ?? 'Venue TBD'}
            {match.scheduled_at && ` · ${new Date(match.scheduled_at).toLocaleDateString(undefined, { month: 'short', day: 'numeric' })} ${new Date(match.scheduled_at).toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit' })}`}
          </p>
        </div>
      </div>

      {/* Stepper */}
      <section className="mb-8">
        <div className="flex items-center justify-between px-2">
          {STEPS.map((step, i) => (
            <div key={step} className="flex flex-col items-center">
              <div
                className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-bold ${
                  i < currentStep
                    ? 'bg-emerald-600 text-white'
                    : i === currentStep
                      ? 'bg-emerald-600/20 border-2 border-emerald-500 text-emerald-400'
                      : 'bg-[#1b211c] border border-[#3e4a3f] text-[#889488]'
                }`}
              >
                {i < currentStep ? (
                  <Check size={14} />
                ) : (
                  i + 1
                )}
              </div>
              <span className={`mt-1.5 text-[9px] font-semibold uppercase tracking-wider ${
                i <= currentStep ? 'text-emerald-400' : 'text-[#889488]'
              }`}>
                {step}
              </span>
            </div>
          ))}
        </div>
        {/* Progress bar */}
        <div className="mt-3 h-1 rounded-full bg-[#1b211c] overflow-hidden">
          <div
            className="h-full rounded-full bg-emerald-600 transition-all duration-500"
            style={{ width: `${(currentStep / (STEPS.length - 1)) * 100}%` }}
          />
        </div>
      </section>

      {/* Step content */}
      {currentStep === 0 && (
        <InviteStep matchId={matchId} match={match} error={error} setError={setError} onDone={refetchMatch} />
      )}
      {currentStep === 1 && (
        <TeamsStep matchId={matchId} match={match} teams={teams} error={error} setError={setError} onDone={() => { refetchMatch(); refetchTeams() }} />
      )}
      {currentStep === 2 && (
        <RulesStep matchId={matchId} match={match} error={error} setError={setError} onDone={refetchMatch} />
      )}
      {currentStep === 3 && (
        <TossStep matchId={matchId} match={match} error={error} setError={setError} onDone={refetchMatch} navigate={navigate} />
      )}
    </div>
  )
}

// ── Step Components ─────────────────────────────────────────────────────────

function InviteStep({ matchId, match, error, setError, onDone }: {
  matchId: string
  match: { team_a_name: string; match_type: string; status: string; host_user_id: string; opponent_captain_id: string | null; venue: string | null; scheduled_at: string | null; invitation_message: string | null; rules: MatchRules }
  error: string
  setError: (s: string) => void
  onDone: () => void
}) {
  const [inviteId, setInviteId] = useState('')
  const [inviteMessage, setInviteMessage] = useState('')
  const [teamBName, setTeamBName] = useState('')
  const [loading, setLoading] = useState(false)
  const currentUser = authStore.getUser()
  const isHost = currentUser?.id === match.host_user_id
  const isOpponent = currentUser?.id === match.opponent_captain_id

  const handleInvite = async () => {
    if (!inviteId.trim()) return
    setLoading(true)
    setError('')
    try {
      await inviteOpponent(matchId, inviteId.trim(), inviteMessage.trim() || undefined)
      onDone()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Invite failed')
    } finally {
      setLoading(false)
    }
  }

  const handleAccept = async () => {
    if (!teamBName.trim()) { setError('Enter your team name'); return }
    setLoading(true)
    setError('')
    try {
      await acceptInvitation(matchId, teamBName.trim())
      onDone()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Accept failed')
    } finally {
      setLoading(false)
    }
  }

  if (match.match_type === 'quick') {
    return (
      <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-6 text-center">
        <CheckCircle size={28} className="mx-auto mb-2 text-emerald-500" />
        <p className="text-sm text-[#becabc]">Quick match — no invite needed. Proceed to add players.</p>
      </div>
    )
  }

  // Opponent sees Accept UI when status is "invited"
  if (match.status === 'invited' && isOpponent) {
    const scheduledDate = match.scheduled_at ? new Date(match.scheduled_at) : null
    return (
      <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-6 space-y-4">
        <h3 className="text-base font-bold text-[#dfe4dc]">You've Been Invited!</h3>
        <p className="text-sm text-[#becabc]">
          You've been invited to captain a team against <strong className="text-white">{match.team_a_name}</strong>.
        </p>

        {/* Rich invite card */}
        <div className="rounded-lg border border-[#3e4a3f] bg-[#1b211c] p-4 space-y-3">
          {match.invitation_message && (
            <div className="flex items-start gap-2">
              <MessageSquare size={14} className="mt-0.5 text-emerald-400 shrink-0" />
              <p className="text-sm text-[#dfe4dc] italic">"{match.invitation_message}"</p>
            </div>
          )}
          {scheduledDate && (
            <div className="flex items-center gap-2">
              <Calendar size={14} className="text-amber-400 shrink-0" />
              <span className="text-sm text-[#becabc]">
                {scheduledDate.toLocaleDateString(undefined, { weekday: 'short', month: 'short', day: 'numeric' })} at {scheduledDate.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit' })}
              </span>
            </div>
          )}
          {match.venue && (
            <div className="flex items-center gap-2">
              <MapPin size={14} className="text-blue-400 shrink-0" />
              <span className="text-sm text-[#becabc]">{match.venue}</span>
            </div>
          )}
          <div className="flex items-center gap-4 text-xs text-[#889488] pt-1 border-t border-[#3e4a3f]">
            <span>{match.rules.overs_limit} overs</span>
            <span>{match.rules.max_players_per_team} players/team</span>
            {match.rules.tennis_ball && <span>Tennis ball</span>}
            {match.rules.free_hit && <span>Free hit</span>}
          </div>
        </div>

        <input
          value={teamBName}
          onChange={(e) => setTeamBName(e.target.value)}
          placeholder="Your team name..."
          className="w-full h-12 rounded-lg border border-[#3e4a3f] bg-[#1b211c] px-4 text-sm text-[#dfe4dc] outline-none focus:border-emerald-500 placeholder:text-[#889488]"
        />

        {error && <p className="text-xs text-red-400">{error}</p>}

        <button
          onClick={handleAccept}
          disabled={loading || !teamBName.trim()}
          className="w-full h-12 rounded-lg bg-[#1B8A4A] font-bold text-white disabled:opacity-50 transition active:scale-[0.98]"
        >
          {loading ? 'Accepting...' : 'Accept Invitation'}
        </button>
      </div>
    )
  }

  // Host sees "Waiting" after invite sent  
  if (match.status === 'invited' && isHost) {
    return (
      <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-6 text-center space-y-3">
        <Clock size={28} className="mx-auto text-amber-400" />
        <h3 className="text-base font-bold text-[#dfe4dc]">Invitation Sent</h3>
        <p className="text-sm text-[#becabc]">
          Waiting for the opponent captain to accept your invitation.
        </p>
        {match.invitation_message && (
          <p className="text-xs text-[#889488] italic">Your message: "{match.invitation_message}"</p>
        )}
        <p className="text-xs text-[#889488]">They'll see this match in their dashboard. Share your match link if needed.</p>
      </div>
    )
  }

  // Default: Host hasn't sent invite yet (status = "created")
  return (
    <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-6 space-y-4">
      <h3 className="text-base font-bold text-[#dfe4dc]">Invite Opponent Captain</h3>
      <p className="text-sm text-[#becabc]">Enter their User ID or search by name</p>

      <input
        value={inviteId}
        onChange={(e) => setInviteId(e.target.value)}
        placeholder="User ID or search..."
        className="w-full h-12 rounded-lg border border-[#3e4a3f] bg-[#1b211c] px-4 text-sm text-[#dfe4dc] outline-none focus:border-emerald-500 placeholder:text-[#889488]"
      />

      <textarea
        value={inviteMessage}
        onChange={(e) => setInviteMessage(e.target.value)}
        placeholder="Add a message (optional) — e.g. 'Sunday evening match at Marine Drive!'"
        maxLength={500}
        rows={2}
        className="w-full rounded-lg border border-[#3e4a3f] bg-[#1b211c] px-4 py-3 text-sm text-[#dfe4dc] outline-none focus:border-emerald-500 placeholder:text-[#889488] resize-none"
      />

      {error && <p className="text-xs text-red-400">{error}</p>}

      <button
        onClick={handleInvite}
        disabled={loading || !inviteId.trim()}
        className="w-full h-12 rounded-lg bg-[#1B8A4A] font-bold text-white disabled:opacity-50 transition active:scale-[0.98]"
      >
        {loading ? 'Sending...' : 'Send Invite'}
      </button>
    </div>
  )
}

function TeamsStep({ matchId, match, teams, error, setError, onDone }: {
  matchId: string
  match: { team_a_name: string; team_b_name: string | null; host_user_id: string; opponent_captain_id: string | null }
  teams: Awaited<ReturnType<typeof getTeams>> | undefined
  error: string
  setError: (s: string) => void
  onDone: () => void
}) {
  const [playerName, setPlayerName] = useState('')
  const [addingTeam, setAddingTeam] = useState<'A' | 'B' | null>(null)
  const [readyLoading, setReadyLoading] = useState(false)
  const currentUser = authStore.getUser()

  // Determine which team this user is captain of
  const myTeam: 'A' | 'B' | null = currentUser?.id === match.host_user_id ? 'A'
    : currentUser?.id === match.opponent_captain_id ? 'B'
    : null

  const myTeamReady = myTeam === 'A' ? teams?.team_a?.ready : teams?.team_b?.ready
  const otherTeamReady = myTeam === 'A' ? teams?.team_b?.ready : teams?.team_a?.ready

  const handleAdd = async (team: 'A' | 'B') => {
    if (!playerName.trim()) return
    setError('')
    try {
      await addPlayer(matchId, { guest_name: playerName.trim(), team, role: 'batsman' })
      setPlayerName('')
      setAddingTeam(null)
      onDone()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed')
    }
  }

  const handleReady = async () => {
    setReadyLoading(true)
    setError('')
    try {
      await markTeamReady(matchId, !myTeamReady)
      onDone()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed')
    } finally {
      setReadyLoading(false)
    }
  }

  return (
    <div className="space-y-4">
      {(['A', 'B'] as const).map((team) => {
        const info = team === 'A' ? teams?.team_a : teams?.team_b
        const name = team === 'A' ? match.team_a_name : (match.team_b_name ?? 'Team B')
        const isMyTeam = team === myTeam
        const isReady = info?.ready ?? false
        return (
          <div key={team} className={`rounded-xl border bg-[#162029] p-5 ${
            isReady ? 'border-emerald-600/50' : 'border-[#2a3a4a]'
          }`}>
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center gap-2">
                <h4 className="text-sm font-bold text-[#dfe4dc]">{name}</h4>
                {isMyTeam && (
                  <span className="rounded bg-emerald-600/20 px-1.5 py-0.5 text-[9px] font-semibold text-emerald-400 uppercase">You</span>
                )}
              </div>
              <div className="flex items-center gap-2">
                <span className="text-[10px] font-semibold text-[#889488]">{info?.count ?? 0} players</span>
                {isReady && (
                  <span className="flex items-center gap-1 rounded-full bg-emerald-600/15 px-2 py-0.5 text-[10px] font-bold text-emerald-400">
                    <Check size={10} /> Ready
                  </span>
                )}
              </div>
            </div>
            <div className="space-y-1.5">
              {info?.players?.map((p) => (
                <div key={p.id} className="flex items-center justify-between rounded-lg bg-[#1b211c] border border-[#3e4a3f] px-3 py-2">
                  <span className="text-sm text-[#dfe4dc]">{p.display_name ?? p.guest_name}</span>
                  <span className="text-[10px] text-[#889488] uppercase">{p.role}</span>
                </div>
              ))}
            </div>
            {/* Only show add player for own team */}
            {isMyTeam && !isReady && (
              addingTeam === team ? (
                <div className="mt-3 flex gap-2">
                  <input
                    value={playerName}
                    onChange={(e) => setPlayerName(e.target.value)}
                    placeholder="Player name"
                    className="flex-1 h-10 rounded-lg border border-[#3e4a3f] bg-[#1b211c] px-3 text-sm text-[#dfe4dc] outline-none focus:border-emerald-500"
                    onKeyDown={(e) => e.key === 'Enter' && handleAdd(team)}
                    autoFocus
                  />
                  <button onClick={() => handleAdd(team)} className="rounded-lg bg-[#1B8A4A] px-3 text-sm font-semibold text-white">
                    Add
                  </button>
                </div>
              ) : (
                <button
                  onClick={() => setAddingTeam(team)}
                  className="mt-3 w-full rounded-lg border border-dashed border-[#3e4a3f] py-2.5 text-sm text-[#889488] hover:border-emerald-700 hover:text-emerald-400 transition"
                >
                  + Add Player
                </button>
              )
            )}
          </div>
        )
      })}

      {error && <p className="text-xs text-red-400">{error}</p>}

      {/* Ready button */}
      {myTeam && (
        <button
          onClick={handleReady}
          disabled={readyLoading}
          className={`w-full h-12 rounded-lg font-bold transition active:scale-[0.98] disabled:opacity-50 ${
            myTeamReady
              ? 'bg-amber-600/20 border border-amber-500/40 text-amber-400'
              : 'bg-[#1B8A4A] text-white'
          }`}
        >
          {readyLoading
            ? 'Updating...'
            : myTeamReady
              ? 'Undo Ready'
              : 'Mark Team Ready'
          }
        </button>
      )}

      {/* Status message */}
      {myTeamReady && !otherTeamReady && (
        <p className="text-center text-xs text-[#889488]">Waiting for the other captain to mark their team ready...</p>
      )}
      {myTeamReady && otherTeamReady && (
        <p className="text-center text-xs text-emerald-400 font-medium">Both teams are ready! Proceeding to next step...</p>
      )}
    </div>
  )
}

function RulesStep({ matchId, match, error, setError, onDone }: {
  matchId: string
  match: { rules: MatchRules; status: string; host_user_id: string; opponent_captain_id: string | null; rules_agreed: boolean }
  error: string
  setError: (s: string) => void
  onDone: () => void
}) {
  const [loading, setLoading] = useState(false)
  const currentUser = authStore.getUser()
  const isHost = currentUser?.id === match.host_user_id
  const rules = match.rules as unknown as Record<string, unknown>

  const handleApproveRules = async () => {
    setLoading(true)
    setError('')
    try {
      if (match.status === 'teams_ready') {
        // First captain to confirm — propose current rules
        await proposeRules(matchId, match.rules)
        onDone()
      } else if (match.status === 'rules_proposed') {
        // Second captain approves
        await approveRules(matchId)
        onDone()
      }
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed')
    } finally {
      setLoading(false)
    }
  }

  // Rules fully approved — show success
  if (match.status === 'rules_approved' || match.rules_agreed) {
    return (
      <div className="rounded-xl border border-emerald-600/50 bg-[#162029] p-6 text-center space-y-3">
        <CheckCircle size={28} className="mx-auto text-emerald-500" />
        <h3 className="text-base font-bold text-[#dfe4dc]">Rules Agreed!</h3>
        <p className="text-sm text-[#becabc]">Both captains approved. Proceed to toss.</p>
      </div>
    )
  }

  return (
    <div className="space-y-4">
      <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-6">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-base font-bold text-[#dfe4dc]">Match Rules</h3>
          {match.status === 'rules_proposed' && (
            <span className="rounded-full bg-amber-500/15 px-2 py-0.5 text-[10px] font-bold text-amber-400">Pending Approval</span>
          )}
        </div>
        {rules ? (
          <div className="space-y-2">
            {Object.entries(rules).map(([key, val]) => (
              <div key={key} className="flex items-center justify-between rounded-lg bg-[#1b211c] border border-[#3e4a3f] px-3 py-2.5">
                <span className="text-sm text-[#becabc] capitalize">{key.replace(/_/g, ' ')}</span>
                <span className="text-sm font-mono font-bold text-emerald-400">{String(val)}</span>
              </div>
            ))}
          </div>
        ) : (
          <p className="text-sm text-[#889488]">No rules set yet.</p>
        )}
      </div>

      {error && <p className="text-xs text-red-400">{error}</p>}

      {match.status === 'teams_ready' && (
        <button
          onClick={handleApproveRules}
          disabled={loading}
          className="w-full h-12 rounded-lg bg-[#1B8A4A] font-bold text-white disabled:opacity-50 transition active:scale-[0.98]"
        >
          {loading ? 'Confirming...' : 'Confirm Rules & Proceed'}
        </button>
      )}

      {match.status === 'rules_proposed' && (
        <button
          onClick={handleApproveRules}
          disabled={loading}
          className="w-full h-12 rounded-lg bg-[#1B8A4A] font-bold text-white disabled:opacity-50 transition active:scale-[0.98]"
        >
          {loading ? 'Approving...' : 'Approve Rules'}
        </button>
      )}

      {match.status === 'rules_proposed' && (
        <p className="text-center text-xs text-[#889488]">
          {isHost ? 'Waiting for opponent to approve...' : 'Review the rules above and approve to proceed.'}
        </p>
      )}
    </div>
  )
}

function TossStep({ matchId, match, error, setError, onDone, navigate }: {
  matchId: string
  match: { team_a_name: string; team_b_name: string | null; toss_winner: string | null; toss_decision: string | null; rules: MatchRules }
  error: string
  setError: (s: string) => void
  onDone: () => void
  navigate: ReturnType<typeof useNavigate>
}) {
  const [winner, setWinner] = useState<'A' | 'B'>('A')
  const [decision, setDecision] = useState<'bat' | 'bowl'>('bat')
  const [loading, setLoading] = useState(false)

  const handleToss = async () => {
    setLoading(true)
    setError('')
    try {
      await recordToss(matchId, winner, decision)
      onDone()
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Toss failed')
    } finally {
      setLoading(false)
    }
  }

  const handleStartInnings = async () => {
    if (!match.toss_winner) return
    setLoading(true)
    setError('')
    try {
      const battingTeam = match.toss_decision === 'bat' ? match.toss_winner : (match.toss_winner === 'A' ? 'B' : 'A')
      const overs = match.rules.overs_limit ?? 6
      await createInnings(matchId, battingTeam as 'A' | 'B', overs)
      navigate(`/match/${matchId}/scoring`, { replace: true })
    } catch (err) {
      setError((err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed to start')
    } finally {
      setLoading(false)
    }
  }

  // Already tossed
  if (match.toss_winner) {
    return (
      <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-6 text-center space-y-4">
        <Coins size={32} className="mx-auto text-emerald-500" />
        <p className="text-sm text-[#becabc]">
          <strong className="text-[#dfe4dc]">Team {match.toss_winner === 'A' ? match.team_a_name : match.team_b_name}</strong> won the toss and elected to <strong className="text-emerald-400">{match.toss_decision}</strong>
        </p>
        {error && <p className="text-xs text-red-400">{error}</p>}
        <button
          onClick={handleStartInnings}
          disabled={loading}
          className="w-full h-12 rounded-lg bg-[#1B8A4A] font-bold text-white disabled:opacity-50 transition active:scale-[0.98]"
        >
          {loading ? 'Starting...' : 'Start Match'}
        </button>
      </div>
    )
  }

  return (
    <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-6 space-y-5">
      <h3 className="text-base font-bold text-[#dfe4dc]">Record Toss</h3>

      <div>
        <p className="mb-2 text-sm text-[#becabc]">Who won the toss?</p>
        <div className="grid grid-cols-2 gap-3">
          {(['A', 'B'] as const).map((t) => (
            <button
              key={t}
              onClick={() => setWinner(t)}
              className={`rounded-lg border p-3 text-sm font-semibold transition ${
                winner === t
                  ? 'border-emerald-500 bg-emerald-600/10 text-emerald-400'
                  : 'border-[#3e4a3f] text-[#becabc]'
              }`}
            >
              {t === 'A' ? match.team_a_name : (match.team_b_name ?? 'Team B')}
            </button>
          ))}
        </div>
      </div>

      <div>
        <p className="mb-2 text-sm text-[#becabc]">Elected to?</p>
        <div className="grid grid-cols-2 gap-3">
          {(['bat', 'bowl'] as const).map((d) => (
            <button
              key={d}
              onClick={() => setDecision(d)}
              className={`rounded-lg border p-3 text-sm font-semibold transition ${
                decision === d
                  ? 'border-emerald-500 bg-emerald-600/10 text-emerald-400'
                  : 'border-[#3e4a3f] text-[#becabc]'
              }`}
            >
              {d === 'bat' ? 'Bat First' : 'Bowl First'}
            </button>
          ))}
        </div>
      </div>

      {error && <p className="text-xs text-red-400">{error}</p>}

      <button
        onClick={handleToss}
        disabled={loading}
        className="w-full h-12 rounded-lg bg-[#1B8A4A] font-bold text-white disabled:opacity-50 transition active:scale-[0.98]"
      >
        {loading ? 'Recording...' : 'Confirm Toss'}
      </button>
    </div>
  )
}
