import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { apiClient } from '../lib/api/client'
import { authStore } from '../lib/auth-store'
import { logout } from '../lib/api/auth'

interface MyMatchesSummary {
  total: number
  live: number
}

async function fetchMyMatchesSummary(): Promise<MyMatchesSummary> {
  const { data } = await apiClient.get<{ matches: { status: string }[] }>('/matches/my')
  const matches = data.matches ?? []
  return {
    total: matches.length,
    live: matches.filter((m) => m.status === 'in_progress').length,
  }
}

export function DashboardPage() {
  const navigate = useNavigate()
  const user = authStore.getUser()

  const { data, isLoading } = useQuery({
    queryKey: ['my-matches-summary'],
    queryFn: fetchMyMatchesSummary,
  })

  const handleLogout = async () => {
    try {
      await logout()
    } finally {
      authStore.clearSession()
      navigate('/auth', { replace: true })
    }
  }

  return (
    <section className="space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold">Welcome back{user?.full_name ? `, ${user.full_name}` : ''}!</h2>
          <p className="text-sm text-[var(--text-muted)]">Here's your cricket dashboard.</p>
        </div>
        <button
          onClick={handleLogout}
          className="rounded-xl border border-[var(--line)] px-4 py-1.5 text-sm text-[var(--text-muted)] hover:border-red-400 hover:text-red-400"
        >
          Sign out
        </button>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <article className="rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.8)] p-5">
          <p className="text-xs uppercase tracking-[0.18em] text-[var(--accent)]">Live Operations</p>
          <h3 className="mt-2 text-2xl font-extrabold">
            {isLoading ? '…' : `${data?.live ?? 0} Live Match${data?.live !== 1 ? 'es' : ''}`}
          </h3>
          <p className="mt-1 text-sm text-[var(--text-muted)]">{isLoading ? '' : `${data?.total ?? 0} total`}</p>
        </article>

        <article className="rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.8)] p-5">
          <p className="text-xs uppercase tracking-[0.18em] text-[var(--accent)]">Career Insights</p>
          <h3 className="mt-2 text-2xl font-extrabold">Player Stats Hub</h3>
          <p className="mt-1 text-sm text-[var(--text-muted)]">Coming soon</p>
        </article>

        <article className="rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.8)] p-5">
          <p className="text-xs uppercase tracking-[0.18em] text-[var(--accent)]">Spectator Reach</p>
          <h3 className="mt-2 text-2xl font-extrabold">Share Live Link</h3>
          <p className="mt-1 text-sm text-[var(--text-muted)]">Coming soon</p>
        </article>
      </div>

      <div className="pt-2">
        <button
          onClick={() => navigate('/matches/new')}
          className="rounded-xl bg-[linear-gradient(90deg,#0bb0f5,#00d17f)] px-6 py-2.5 font-semibold text-slate-900"
        >
          + New Match
        </button>
      </div>
    </section>
  )
}

