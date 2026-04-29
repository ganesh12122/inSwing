import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { authStore } from '../lib/auth-store'
import { logout } from '../lib/api/auth'
import { fetchMyMatches } from '../lib/api/matches'
import { getUserProfile } from '../lib/api/users'
import type { MatchResponse } from '../lib/api/matches'

// ── Helpers ─────────────────────────────────────────────────────────────────

function statusBadge(s: string) {
  switch (s) {
    case 'live':
      return { label: 'LIVE', cls: 'bg-red-500/15 text-red-400 border-red-500/30' }
    case 'finished':
      return { label: 'FINISHED', cls: 'bg-[var(--bg-surface)] text-[var(--text-muted)] border-[var(--line)]' }
    case 'created':
    case 'accepted':
    case 'teams_ready':
    case 'toss_done':
      return { label: 'SETUP', cls: 'bg-amber-500/10 text-amber-400 border-amber-500/25' }
    default:
      return { label: s.toUpperCase(), cls: 'bg-[var(--bg-surface)] text-[var(--text-muted)] border-[var(--line)]' }
  }
}

function timeAgo(date: string) {
  const diff = Date.now() - new Date(date).getTime()
  const mins = Math.floor(diff / 60_000)
  if (mins < 1) return 'just now'
  if (mins < 60) return `${mins}m ago`
  const hrs = Math.floor(mins / 60)
  if (hrs < 24) return `${hrs}h ago`
  const days = Math.floor(hrs / 24)
  return `${days}d ago`
}

// ── Page ────────────────────────────────────────────────────────────────────

export function DashboardPage() {
  const navigate = useNavigate()
  const user = authStore.getUser()

  const { data: matchData, isLoading: matchesLoading } = useQuery({
    queryKey: ['my-matches'],
    queryFn: fetchMyMatches,
  })

  const { data: profile } = useQuery({
    queryKey: ['my-profile'],
    queryFn: () => getUserProfile(user?.id ?? ''),
    enabled: !!user?.id,
  })

  const handleLogout = async () => {
    try { await logout() } finally {
      authStore.clearSession()
      navigate('/auth', { replace: true })
    }
  }

  const matches = matchData?.matches ?? []
  const liveCount = matches.filter((m) => m.status === 'live').length
  const finishedCount = matches.filter((m) => m.status === 'finished').length
  const recentMatches = [...matches].sort((a, b) => new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime()).slice(0, 5)

  return (
    <section className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold">
            Welcome{user?.full_name ? `, ${user.full_name}` : ''}
          </h2>
          <p className="mt-0.5 text-sm text-[var(--text-muted)]">Match overview and quick actions</p>
        </div>
        <button
          onClick={handleLogout}
          className="rounded-lg border border-[var(--line)] px-4 py-1.5 text-sm text-[var(--text-muted)] hover:border-red-400 hover:text-red-400 transition"
        >
          Sign out
        </button>
      </div>

      {/* Stat cards */}
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label="Live Now"
          value={matchesLoading ? '…' : String(liveCount)}
          accent={liveCount > 0}
        />
        <StatCard
          label="Total Matches"
          value={matchesLoading ? '…' : String(matches.length)}
        />
        <StatCard
          label="Completed"
          value={matchesLoading ? '…' : String(finishedCount)}
        />
        <StatCard
          label="Batting Style"
          value={profile?.profile?.batting_style?.toUpperCase() ?? '—'}
          small
        />
      </div>

      {/* Quick actions */}
      <div className="flex flex-wrap gap-3">
        <button
          onClick={() => navigate('/matches/new')}
          className="rounded-lg bg-[var(--accent)] px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)] active:scale-[0.98]"
        >
          + New Match
        </button>
        <button
          onClick={() => navigate('/profile')}
          className="rounded-lg border border-[var(--line)] px-5 py-2.5 text-sm font-medium text-[var(--text-muted)] hover:border-[var(--accent)] hover:text-[var(--text-primary)] transition"
        >
          Edit Profile
        </button>
      </div>

      {/* Recent matches */}
      <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-5">
        <div className="mb-4 flex items-center justify-between">
          <h3 className="text-sm font-semibold text-[var(--text-muted)]">Recent Matches</h3>
          {matches.length > 5 && (
            <button className="text-xs text-[var(--accent)] hover:underline">View all</button>
          )}
        </div>

        {matchesLoading && (
          <div className="flex justify-center py-8">
            <div className="h-6 w-6 animate-spin rounded-full border-2 border-[var(--accent)] border-t-transparent" />
          </div>
        )}

        {!matchesLoading && recentMatches.length === 0 && (
          <div className="py-10 text-center">
            <p className="text-base font-medium text-[var(--text-muted)]">No matches yet</p>
            <p className="mt-1 text-sm text-[var(--text-muted)]">
              Create your first match and start scoring.
            </p>
          </div>
        )}

        {!matchesLoading && recentMatches.length > 0 && (
          <div className="space-y-2">
            {recentMatches.map((m) => (
              <MatchCard key={m.id} match={m} onClick={() => {
                if (m.status === 'finished') navigate(`/live/${m.id}`)
                else navigate(`/match/${m.id}/scoring`)
              }} />
            ))}
          </div>
        )}
      </div>
    </section>
  )
}

// ── Sub-components ──────────────────────────────────────────────────────────

function StatCard({ label, value, accent, small }: { label: string; value: string; accent?: boolean; small?: boolean }) {
  return (
    <article className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-4">
      <p className="text-xs font-medium text-[var(--text-muted)]">{label}</p>
      <h3 className={`mt-1.5 font-bold ${small ? 'text-base' : 'text-2xl'} ${accent ? 'text-[var(--accent-strong)]' : ''}`}>
        {value}
      </h3>
    </article>
  )
}

function MatchCard({ match, onClick }: { match: MatchResponse; onClick: () => void }) {
  const badge = statusBadge(match.status)
  return (
    <button
      type="button"
      onClick={onClick}
      className="group flex w-full items-center gap-4 rounded-lg border border-[var(--line)] bg-[var(--bg-deep)] px-4 py-3 text-left transition hover:border-[var(--accent)] hover:bg-[var(--bg-surface)]"
    >
      <div className="min-w-0 flex-1">
        <p className="truncate text-sm font-semibold">
          {match.team_a_name} vs {match.team_b_name ?? 'TBD'}
        </p>
        {match.venue && (
          <p className="truncate text-xs text-[var(--text-muted)]">{match.venue}</p>
        )}
      </div>
      <span className={`shrink-0 rounded border px-2 py-0.5 text-[10px] font-bold tracking-wider ${badge.cls}`}>
        {badge.label}
      </span>
      <span className="shrink-0 text-xs text-[var(--text-muted)]">
        {timeAgo(match.updated_at)}
      </span>
    </button>
  )
}

