import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { searchUsers } from '../lib/api/users'
import { Search, UserSearch, Users, UserPlus } from 'lucide-react'

type Tab = 'connections' | 'requests' | 'discover'

export function ConnectionsPage() {
  const [tab, setTab] = useState<Tab>('discover')
  const [search, setSearch] = useState('')

  const { data: searchResults, isLoading } = useQuery({
    queryKey: ['search-users', search],
    queryFn: () => searchUsers(search),
    enabled: search.length >= 2,
  })

  const tabs: { key: Tab; label: string }[] = [
    { key: 'connections', label: 'My Team' },
    { key: 'requests', label: 'Requests' },
    { key: 'discover', label: 'Discover' },
  ]

  return (
    <div className="pb-8 pt-6 px-6 max-w-4xl mx-auto">
      {/* Header */}
      <section className="mb-6">
        <h2 className="text-2xl font-bold text-[#dfe4dc]">Connections</h2>
        <p className="text-sm text-[#becabc]">Find players and build your squad</p>
      </section>

      {/* Search */}
      <section className="mb-5">
        <div className="relative">
          <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#889488]" />
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by name or INS-ID..."
            className="w-full h-12 rounded-xl border border-[#3e4a3f] bg-[#1b211c] pl-10 pr-4 text-sm text-[#dfe4dc] outline-none placeholder:text-[#889488] focus:border-emerald-500"
          />
        </div>
      </section>

      {/* Tabs */}
      <section className="mb-5 flex gap-2">
        {tabs.map((t) => (
          <button
            key={t.key}
            onClick={() => setTab(t.key)}
            className={`rounded-full px-4 py-2 text-xs font-semibold uppercase tracking-wider transition ${
              tab === t.key
                ? 'bg-emerald-600 text-white'
                : 'bg-[#1b211c] border border-[#3e4a3f] text-[#becabc] hover:border-emerald-700'
            }`}
          >
            {t.label}
          </button>
        ))}
      </section>

      {/* Content */}
      {tab === 'discover' && (
        <section className="space-y-3">
          {search.length < 2 && (
            <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-8 text-center">
              <UserSearch size={28} className="mx-auto mb-2 text-[#889488]" />
              <p className="text-sm text-[#becabc]">Search for players by name or INS-ID</p>
              <p className="mt-1 text-xs text-[#889488]">Type at least 2 characters to search</p>
            </div>
          )}

          {isLoading && search.length >= 2 && (
            <div className="flex justify-center py-8">
              <div className="h-6 w-6 animate-spin rounded-full border-2 border-emerald-500 border-t-transparent" />
            </div>
          )}

          {!isLoading && search.length >= 2 && searchResults?.length === 0 && (
            <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-8 text-center">
              <p className="text-sm text-[#becabc]">No players found</p>
            </div>
          )}

          {!isLoading && searchResults && searchResults.length > 0 && (
            <div className="space-y-2">
              {searchResults.map((u) => (
                <PlayerCard key={u.id} name={u.name} insId={u.id.slice(0, 6).toUpperCase()} />
              ))}
            </div>
          )}
        </section>
      )}

      {tab === 'connections' && (
        <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-8 text-center">
          <Users size={28} className="mx-auto mb-2 text-[#889488]" />
          <p className="text-sm text-[#becabc]">Your connections will appear here</p>
          <p className="mt-1 text-xs text-[#889488]">Search and add players to build your network</p>
        </div>
      )}

      {tab === 'requests' && (
        <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-8 text-center">
          <UserPlus size={28} className="mx-auto mb-2 text-[#889488]" />
          <p className="text-sm text-[#becabc]">No pending requests</p>
        </div>
      )}
    </div>
  )
}

function PlayerCard({ name, insId }: { name: string; insId: string }) {
  return (
    <div className="flex items-center gap-3 rounded-xl border border-[#2a3a4a] bg-[#162029] p-4">
      <div className="flex h-11 w-11 shrink-0 items-center justify-center rounded-full bg-[#1B8A4A]">
        <span className="text-sm font-bold text-white">{name.charAt(0).toUpperCase()}</span>
      </div>
      <div className="flex-1 min-w-0">
        <p className="text-sm font-bold text-[#dfe4dc] truncate">{name}</p>
        <p className="font-mono text-[10px] text-emerald-400 tracking-wide">INS-{insId}</p>
      </div>
      <button className="rounded-lg bg-[#1B8A4A] px-3 py-1.5 text-xs font-semibold text-white transition active:scale-95">
        Connect
      </button>
    </div>
  )
}
