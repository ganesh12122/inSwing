import { Link, Outlet, useLocation } from 'react-router-dom'
import { authStore } from '../lib/auth-store'

const authedLinks = [
  { path: '/dashboard', label: 'Dashboard' },
  { path: '/matches/new', label: 'New Match' },
  { path: '/profile', label: 'Profile' },
]

export function AppShell() {
  const location = useLocation()
  const isAuthed = authStore.isAuthenticated()
  const isPublicLive = location.pathname.startsWith('/live/')

  return (
    <div className="mx-auto flex min-h-screen max-w-6xl flex-col px-4 py-5 md:px-8">
      <header className="mb-6 rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] px-5 py-3">
        <div className="flex flex-wrap items-center justify-between gap-4">
          <Link to={isAuthed ? '/dashboard' : '/'} className="group flex items-center gap-3">
            <div className="flex h-8 w-8 items-center justify-center rounded bg-[var(--accent)] text-sm font-bold text-white">
              iS
            </div>
            <div>
              <h1 className="text-lg font-bold tracking-tight group-hover:text-[var(--accent-strong)] transition">
                {isPublicLive ? 'Live Scorecard' : 'inSwing'}
              </h1>
            </div>
          </Link>
          {isAuthed && !isPublicLive && (
            <nav className="flex flex-wrap gap-1">
              {authedLinks.map((link) => {
                const active = location.pathname === link.path
                return (
                  <Link
                    key={link.path}
                    to={link.path}
                    className={`rounded-md px-3 py-1.5 text-sm font-medium transition ${
                      active
                        ? 'bg-[var(--accent)] text-white'
                        : 'text-[var(--text-muted)] hover:bg-[var(--bg-surface)] hover:text-[var(--text-primary)]'
                    }`}
                  >
                    {link.label}
                  </Link>
                )
              })}
            </nav>
          )}
        </div>
      </header>

      <main className="flex-1">
        <Outlet />
      </main>
    </div>
  )
}
