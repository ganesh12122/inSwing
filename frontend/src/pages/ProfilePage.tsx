import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { authStore } from '../lib/auth-store'
import { getUserProfile } from '../lib/api/users'
import { logout } from '../lib/api/auth'

export function ProfilePage() {
  const navigate = useNavigate()
  const user = authStore.getUser()

  const { data, isLoading } = useQuery({
    queryKey: ['my-profile'],
    queryFn: () => getUserProfile(user?.id ?? ''),
    enabled: !!user?.id,
  })

  const handleLogout = async () => {
    try { await logout() } catch { /* ignore */ }
    authStore.clearSession()
    navigate('/auth', { replace: true })
  }

  const profile = data?.profile
  const userInfo = data?.user

  if (isLoading) {
    return (
      <div className="flex items-center justify-center pt-20">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-emerald-500 border-t-transparent" />
      </div>
    )
  }

  return (
    <div className="pb-8 pt-6 px-4 max-w-md mx-auto">
      {/* Hero Section */}
      <section className="relative mb-6 rounded-2xl border border-[#2a3a4a] bg-[#162029] p-6 overflow-hidden">
        {/* BG glow */}
        <div className="absolute -top-10 -right-10 h-40 w-40 rounded-full bg-emerald-600 opacity-10 blur-[80px]" />

        <div className="relative flex flex-col items-center text-center">
          {/* Avatar */}
          <div className="mb-4 flex h-24 w-24 items-center justify-center rounded-full border-4 border-[#2a3a4a] bg-[#1B8A4A]">
            <span className="text-3xl font-bold text-white">
              {userInfo?.full_name?.charAt(0)?.toUpperCase() ?? 'P'}
            </span>
          </div>

          <h2 className="text-xl font-bold text-white">{userInfo?.full_name ?? 'Player'}</h2>

          {/* INS-ID */}
          <div className="mt-2 inline-flex items-center gap-1.5 rounded-full bg-[#1b211c] border border-[#3e4a3f] px-3 py-1">
            <span className="material-symbols-outlined text-sm text-emerald-500">verified</span>
            <span className="font-mono text-xs font-bold text-emerald-400 tracking-wide">
              INS-{user?.id?.slice(0, 6).toUpperCase() ?? 'XXXXXX'}
            </span>
          </div>

          {userInfo?.bio && (
            <p className="mt-3 text-sm text-[#becabc]">{userInfo.bio}</p>
          )}

          <div className="mt-3 flex gap-4 text-xs text-[#889488]">
            {userInfo?.email && (
              <span className="flex items-center gap-1">
                <span className="material-symbols-outlined text-sm">mail</span>
                {userInfo.email}
              </span>
            )}
          </div>
        </div>
      </section>

      {/* Cricket Profile */}
      <section className="mb-6">
        <h3 className="mb-3 text-xs font-semibold uppercase tracking-wider text-[#dfe4dc]">Cricket Profile</h3>
        <div className="grid grid-cols-3 gap-3">
          <InfoChip label="Batting" value={profile?.batting_style ?? '—'} />
          <InfoChip label="Bowling" value={profile?.bowling_style ?? '—'} />
          <InfoChip label="Hand" value={profile?.dominant_hand ?? '—'} />
        </div>
      </section>

      {/* Career Stats */}
      <section className="mb-6">
        <h3 className="mb-3 text-xs font-semibold uppercase tracking-wider text-[#dfe4dc]">Career Stats</h3>
        <div className="grid grid-cols-2 gap-3">
          <StatBox label="Matches" value={String(profile?.total_matches ?? 0)} />
          <StatBox label="Runs" value={String(profile?.total_runs ?? 0)} />
          <StatBox label="Wickets" value={String(profile?.total_wickets ?? 0)} />
          <StatBox label="Strike Rate" value={profile?.strike_rate?.toFixed(1) ?? '0.0'} />
          <StatBox label="Average" value={profile?.average_runs?.toFixed(1) ?? '0.0'} />
          <StatBox label="Economy" value={profile?.economy_rate?.toFixed(1) ?? '0.0'} />
        </div>
      </section>

      {/* Actions */}
      <section className="space-y-3">
        <button
          onClick={handleLogout}
          className="w-full rounded-xl border border-red-900/50 bg-red-950/20 p-4 text-center text-sm font-semibold text-red-400 transition hover:bg-red-950/40"
        >
          Sign Out
        </button>
      </section>
    </div>
  )
}

function InfoChip({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-3 text-center">
      <span className="block text-[10px] font-semibold uppercase tracking-wider text-[#889488] mb-1">
        {label}
      </span>
      <span className="block text-sm font-bold text-[#dfe4dc] capitalize">{value}</span>
    </div>
  )
}

function StatBox({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-4 text-center">
      <span className="block text-[10px] font-semibold uppercase tracking-wider text-[#becabc] mb-1">
        {label}
      </span>
      <span className="block font-mono text-xl font-bold text-emerald-400">{value}</span>
    </div>
  )
}
