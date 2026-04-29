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
    <div className="mx-auto flex min-h-screen max-w-6xl flex-col px-4 py-6 md:px-8">
      <header className="mb-6 rounded-2xl border border-[var(--line)] bg-[rgba(9,22,32,0.72)] px-5 py-4 backdrop-blur">
        <div className="flex flex-wrap items-center justify-between gap-4">
          <Link to={isAuthed ? '/dashboard' : '/'} className="group">
            <p className="text-xs uppercase tracking-[0.24em] text-[var(--accent)]">inSwing</p>
            <h1 className="text-xl font-extrabold tracking-tight group-hover:text-[var(--accent)] transition md:text-2xl">
              {isPublicLive ? 'Live Scorecard' : 'Cricket Operations Console'}
            </h1>
          </Link>
          {isAuthed && !isPublicLive && (
            <nav className="flex flex-wrap gap-2">
              {authedLinks.map((link) => {
                const active = location.pathname === link.path
                return (
                  <Link
                    key={link.path}
                    to={link.path}
                    className={`rounded-full border px-3 py-1 text-sm transition ${
                      active
                        ? 'border-[var(--accent)] bg-[rgba(11,176,245,0.15)] text-[var(--text-primary)]'
                        : 'border-[var(--line)] text-[var(--text-muted)] hover:border-[var(--accent)] hover:text-[var(--text-primary)]'
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
