import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { fetchMyMatches } from '../lib/api/matches'
import { Trophy } from 'lucide-react'
import type { MatchResponse } from '../lib/api/matches'

type TabFilter = 'all' | 'live' | 'upcoming' | 'finished'

function matchPassesFilter(m: MatchResponse, tab: TabFilter): boolean {
  if (tab === 'all') return true
  if (tab === 'live') return m.status === 'live'
  if (tab === 'finished') return m.status === 'finished'
  return ['created', 'accepted', 'teams_ready', 'toss_done', 'rules_proposed', 'rules_approved'].includes(m.status)
}

function timeAgo(date: string) {
  const diff = Date.now() - new Date(date).getTime()
  const mins = Math.floor(diff / 60_000)
  if (mins < 1) return 'just now'
  if (mins < 60) return `${mins}m ago`
  const hrs = Math.floor(mins / 60)
  if (hrs < 24) return `${hrs}h ago`
  return `${Math.floor(hrs / 24)}d ago`
}

export function MatchesListPage() {
  const navigate = useNavigate()
  const [tab, setTab] = useState<TabFilter>('all')

  const { data, isLoading } = useQuery({
    queryKey: ['my-matches'],
    queryFn: fetchMyMatches,
  })

  const matches = (data?.matches ?? []).filter((m) => matchPassesFilter(m, tab))

  const tabs: { key: TabFilter; label: string }[] = [
    { key: 'all', label: 'All' },
    { key: 'live', label: 'Live' },
    { key: 'upcoming', label: 'Upcoming' },
    { key: 'finished', label: 'Finished' },
  ]

  return (
    <div className="pb-8 pt-6 px-6 max-w-5xl mx-auto">
      <section className="mb-6">
        <h2 className="text-2xl font-bold text-[#dfe4dc]">My Matches</h2>
        <p className="text-sm text-[#becabc]">All your matches in one place</p>
      </section>

      {/* Tabs */}
      <section className="mb-5 flex gap-2 overflow-x-auto no-scrollbar">
        {tabs.map((t) => (
          <button
            key={t.key}
            onClick={() => setTab(t.key)}
            className={`shrink-0 rounded-full px-4 py-2 text-xs font-semibold uppercase tracking-wider transition ${
              tab === t.key
                ? 'bg-emerald-600 text-white'
                : 'bg-[#1b211c] border border-[#3e4a3f] text-[#becabc] hover:border-emerald-700'
            }`}
          >
            {t.label}
          </button>
        ))}
      </section>

      {/* Loading */}
      {isLoading && (
        <div className="flex justify-center py-10">
          <div className="h-6 w-6 animate-spin rounded-full border-2 border-emerald-500 border-t-transparent" />
        </div>
      )}

      {/* Empty */}
      {!isLoading && matches.length === 0 && (
        <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-10 text-center">
          <Trophy size={32} className="mx-auto mb-3 text-[#889488]" />
          <p className="text-sm font-medium text-[#becabc]">No matches found</p>
          <button
            onClick={() => navigate('/matches/new')}
            className="mt-4 rounded-lg bg-[#1B8A4A] px-4 py-2 text-sm font-semibold text-white"
          >
            Create Match
          </button>
        </div>
      )}

      {/* List */}
      {!isLoading && matches.length > 0 && (
        <div className="space-y-2">
          {matches
            .sort((a, b) => new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime())
            .map((m) => {
              const statusColors: Record<string, string> = {
                live: 'text-red-400 bg-red-500/10 border-red-500/30',
                finished: 'text-[#becabc] bg-[#1b211c] border-[#3e4a3f]',
              }
              const cls = statusColors[m.status] ?? 'text-amber-400 bg-amber-500/10 border-amber-500/25'
              const statusLabel = m.status === 'live' ? 'LIVE' : m.status === 'finished' ? 'FINAL' : 'SETUP'

              return (
                <button
                  key={m.id}
                  onClick={() => {
                    if (m.status === 'live') navigate(`/match/${m.id}/scoring`)
                    else if (m.status === 'finished') navigate(`/live/${m.id}`)
                    else navigate(`/match/${m.id}/setup`)
                  }}
                  className="w-full rounded-xl border border-[#2a3a4a] bg-[#162029] p-4 text-left flex items-center gap-3 transition hover:border-emerald-700"
                >
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-bold text-[#dfe4dc] truncate">
                      {m.team_a_name} vs {m.team_b_name ?? 'TBD'}
                    </p>
                    {m.venue && <p className="text-xs text-[#889488] truncate mt-0.5">{m.venue}</p>}
                    <p className="text-[10px] text-[#889488] mt-1">{m.rules.overs_limit} overs · {m.match_type.replace('_', ' ')}</p>
                  </div>
                  <div className="text-right shrink-0">
                    <span className={`inline-block rounded border px-1.5 py-0.5 text-[9px] font-bold uppercase tracking-wider ${cls}`}>
                      {statusLabel}
                    </span>
                    <p className="mt-1 text-[10px] text-[#889488]">{timeAgo(m.updated_at)}</p>
                  </div>
                </button>
              )
            })}
        </div>
      )}
    </div>
  )
}
