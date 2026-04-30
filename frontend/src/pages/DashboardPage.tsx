import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { authStore } from '../lib/auth-store'
import { fetchMyMatches } from '../lib/api/matches'
import { Trophy } from 'lucide-react'
import type { MatchResponse } from '../lib/api/matches'

function timeAgo(date: string) {
  const diff = Date.now() - new Date(date).getTime()
  const mins = Math.floor(diff / 60_000)
  if (mins < 1) return 'just now'
  if (mins < 60) return `${mins}m ago`
  const hrs = Math.floor(mins / 60)
  if (hrs < 24) return `${hrs}h ago`
  return `${Math.floor(hrs / 24)}d ago`
}

export function DashboardPage() {
  const navigate = useNavigate()
  const user = authStore.getUser()

  const { data: matchData, isLoading } = useQuery({
    queryKey: ['my-matches'],
    queryFn: fetchMyMatches,
  })

  const matches = matchData?.matches ?? []
  const liveMatches = matches.filter((m) => m.status === 'live')
  const recentMatches = [...matches]
    .sort((a, b) => new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime())
    .slice(0, 5)

  return (
    <div className="pb-8 pt-6 px-6 max-w-5xl mx-auto">
      {/* Welcome */}
      <section className="mb-6">
        <h2 className="text-2xl font-bold text-[#dfe4dc]">
          Hello, {user?.full_name?.split(' ')[0] ?? 'Player'}!
        </h2>
        <p className="text-sm text-[#becabc]">Ready for today&apos;s innings?</p>
      </section>

      {/* Stats bento */}
      <section className="grid grid-cols-3 gap-3 mb-6">
        <StatBento label="Matches" value={String(matches.length)} />
        <StatBento label="Runs" value="—" />
        <StatBento label="Wickets" value="—" />
      </section>

      {/* Live section */}
      {liveMatches.length > 0 && (
        <section className="mb-6">
          <div className="flex items-center justify-between mb-2">
            <h3 className="text-xs font-semibold uppercase tracking-wider text-[#dfe4dc]">Live Now</h3>
            <div className="flex items-center gap-1.5 rounded-full bg-red-500 px-2 py-0.5">
              <span className="h-1.5 w-1.5 animate-pulse rounded-full bg-white" />
              <span className="text-[10px] font-bold uppercase text-white">Live</span>
            </div>
          </div>
          {liveMatches.map((m) => (
            <LiveCard key={m.id} match={m} onClick={() => navigate(`/match/${m.id}/scoring`)} />
          ))}
        </section>
      )}

      {/* Empty live state */}
      {!isLoading && liveMatches.length === 0 && (
        <section className="mb-6">
          <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-6 text-center">
            <Trophy size={28} className="mx-auto mb-2 text-[#889488]" />
            <p className="text-sm text-[#becabc]">No live matches right now</p>
            <button
              onClick={() => navigate('/matches/new')}
              className="mt-3 rounded-lg bg-[#1B8A4A] px-4 py-2 text-sm font-semibold text-white"
            >
              Start a Match
            </button>
          </div>
        </section>
      )}

      {/* Recent Matches */}
      <section className="mb-6">
        <div className="flex items-center justify-between mb-2">
          <h3 className="text-xs font-semibold uppercase tracking-wider text-[#dfe4dc]">Recent Matches</h3>
          {matches.length > 5 && (
            <button onClick={() => navigate('/matches')} className="text-xs text-emerald-500 font-medium">
              View All
            </button>
          )}
        </div>

        {isLoading && (
          <div className="flex justify-center py-10">
            <div className="h-6 w-6 animate-spin rounded-full border-2 border-emerald-500 border-t-transparent" />
          </div>
        )}

        {!isLoading && recentMatches.length === 0 && (
          <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-8 text-center">
            <p className="text-sm font-medium text-[#becabc]">No matches yet</p>
            <p className="mt-1 text-xs text-[#889488]">Create your first match and start scoring.</p>
          </div>
        )}

        {!isLoading && recentMatches.length > 0 && (
          <div className="space-y-2">
            {recentMatches.map((m) => (
              <RecentMatchCard key={m.id} match={m} onClick={() => {
                if (m.status === 'live') navigate(`/match/${m.id}/scoring`)
                else if (m.status === 'finished') navigate(`/live/${m.id}`)
                else navigate(`/match/${m.id}/setup`)
              }} />
            ))}
          </div>
        )}
      </section>
    </div>
  )
}

// ── Sub-components ──────────────────────────────────────────────────────────

function StatBento({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-4 flex flex-col items-center justify-center text-center">
      <span className="text-[10px] font-semibold uppercase tracking-wider text-[#becabc] mb-1">
        {label}
      </span>
      <span className="font-mono text-lg font-bold text-emerald-400">{value}</span>
    </div>
  )
}

function LiveCard({ match, onClick }: { match: MatchResponse; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className="w-full rounded-xl border border-[#2a3a4a] bg-[#162029] p-4 text-left relative overflow-hidden"
    >
      <div className="flex justify-between items-end mb-3">
        <div>
          <span className="text-[10px] font-semibold uppercase tracking-wider text-[#becabc]">
            {match.team_a_name}
          </span>
          <p className="font-mono text-3xl font-bold text-white">—</p>
        </div>
        <span className="text-xs font-semibold uppercase text-[#889488] pb-2">VS</span>
        <div className="text-right">
          <span className="text-[10px] font-semibold uppercase tracking-wider text-[#becabc]">
            {match.team_b_name ?? 'TBD'}
          </span>
          <p className="font-mono text-3xl font-bold text-white">—</p>
        </div>
      </div>
      <div className="border-t border-[#3e4a3f] pt-3 flex items-center justify-between">
        <span className="text-xs text-[#becabc]">{match.venue ?? 'Venue TBD'}</span>
        <span className="text-[10px] font-semibold text-emerald-400 uppercase">{match.rules.overs_limit} overs</span>
      </div>
    </button>
  )
}

function RecentMatchCard({ match, onClick }: { match: MatchResponse; onClick: () => void }) {
  const statusColors: Record<string, string> = {
    live: 'text-red-400 bg-red-500/10 border-red-500/30',
    finished: 'text-[#becabc] bg-[#1b211c] border-[#3e4a3f]',
    invited: 'text-purple-400 bg-purple-500/10 border-purple-500/25',
    created: 'text-amber-400 bg-amber-500/10 border-amber-500/25',
    accepted: 'text-amber-400 bg-amber-500/10 border-amber-500/25',
    teams_ready: 'text-blue-400 bg-blue-500/10 border-blue-500/25',
    toss_proposed: 'text-blue-400 bg-blue-500/10 border-blue-500/25',
    toss_done: 'text-blue-400 bg-blue-500/10 border-blue-500/25',
  }
  const cls = statusColors[match.status] ?? statusColors.created

  const statusLabel = (() => {
    switch (match.status) {
      case 'live': return 'LIVE'
      case 'finished': return 'FINAL'
      case 'invited': return 'INVITED'
      case 'accepted': return 'ACCEPTED'
      case 'teams_ready': return 'TEAMS READY'
      case 'toss_proposed': return 'TOSS'
      case 'toss_done': return 'TOSS DONE'
      default: return 'SETUP'
    }
  })()

  return (
    <button
      onClick={onClick}
      className="w-full rounded-xl border border-[#2a3a4a] bg-[#162029] p-4 text-left flex items-center gap-3 transition hover:border-emerald-700"
    >
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2 mb-0.5">
          <span className="text-sm font-bold text-[#dfe4dc] truncate">{match.team_a_name}</span>
        </div>
        <div className="flex items-center gap-2">
          <span className="text-sm font-bold text-[#dfe4dc] truncate">{match.team_b_name ?? 'TBD'}</span>
        </div>
      </div>
      <div className="text-right shrink-0">
        <span className={`inline-block rounded border px-1.5 py-0.5 text-[9px] font-bold uppercase tracking-wider ${cls}`}>
          {statusLabel}
        </span>
        <p className="mt-1 text-[10px] text-[#889488]">{timeAgo(match.updated_at)}</p>
      </div>
    </button>
  )
}
