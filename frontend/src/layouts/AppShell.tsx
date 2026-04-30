import { Link, Outlet, useLocation } from 'react-router-dom'
import { authStore } from '../lib/auth-store'

const navItems = [
  { path: '/dashboard', icon: 'home', label: 'Home' },
  { path: '/matches', icon: 'sports_cricket', label: 'Matches' },
  { path: '/matches/new', icon: 'add_circle', label: 'New Match', center: true },
  { path: '/connections', icon: 'group', label: 'Connections' },
  { path: '/profile', icon: 'person', label: 'Profile' },
]

export function AppShell() {
  const location = useLocation()
  const isAuthed = authStore.isAuthenticated()
  const isAuthPage = location.pathname === '/auth'
  const isPublicLive = location.pathname.startsWith('/live/')
  const isScoringConsole = location.pathname.includes('/scoring')
  const isMatchSetup = location.pathname.includes('/setup')

  const hideChrome = isAuthPage || isPublicLive || isScoringConsole || isMatchSetup

  return (
    <div className="flex min-h-dvh flex-col">
      {/* Top App Bar */}
      {!hideChrome && isAuthed && (
        <header className="sticky top-0 z-40 flex h-16 items-center justify-between border-b border-slate-800 bg-slate-950 px-4">
          <div className="flex items-center gap-2">
            <span className="material-symbols-outlined text-emerald-500">sports_cricket</span>
            <h1 className="text-xl font-black italic tracking-tight text-emerald-500">inSwing</h1>
          </div>
          <div className="flex items-center gap-2">
            <Link
              to="/notifications"
              className="relative rounded-full p-2 transition hover:bg-slate-900"
            >
              <span className="material-symbols-outlined text-slate-400">notifications</span>
            </Link>
          </div>
        </header>
      )}

      {/* Main content */}
      <main className={`flex-1 ${hideChrome ? '' : 'pb-24'}`}>
        <Outlet />
      </main>

      {/* Bottom Navigation */}
      {!hideChrome && isAuthed && (
        <nav className="fixed bottom-0 left-0 z-50 flex h-20 w-full items-center justify-around border-t border-slate-800 bg-slate-950 px-2 shadow-lg">
          {navItems.map((item) => {
            const active = location.pathname === item.path ||
              (item.path === '/dashboard' && location.pathname === '/')
            if (item.center) {
              return (
                <Link
                  key={item.path}
                  to={item.path}
                  className="flex flex-col items-center justify-center -mt-6"
                >
                  <div className="flex h-14 w-14 items-center justify-center rounded-full bg-emerald-600 text-white shadow-lg shadow-emerald-900/40">
                    <span
                      className="material-symbols-outlined scale-125"
                      style={{ fontVariationSettings: "'FILL' 1" }}
                    >
                      {item.icon}
                    </span>
                  </div>
                  <span className="mt-1 text-[10px] font-bold uppercase tracking-widest text-slate-400">
                    {item.label}
                  </span>
                </Link>
              )
            }
            return (
              <Link
                key={item.path}
                to={item.path}
                className={`flex flex-col items-center justify-center transition-all duration-150 ${
                  active
                    ? 'scale-110 text-emerald-500'
                    : 'text-slate-400 opacity-70 hover:text-emerald-400'
                }`}
              >
                <span
                  className="material-symbols-outlined"
                  style={active ? { fontVariationSettings: "'FILL' 1" } : undefined}
                >
                  {item.icon}
                </span>
                <span className="mt-1 text-[10px] font-bold uppercase tracking-widest">
                  {item.label}
                </span>
              </Link>
            )
          })}
        </nav>
      )}
    </div>
  )
}
