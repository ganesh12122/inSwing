import { Link, Outlet, useLocation } from 'react-router-dom'
import { authStore } from '../lib/auth-store'
import { Home, Trophy, PlusCircle, Users, User, Bell } from 'lucide-react'

const navItems = [
  { path: '/dashboard', icon: Home, label: 'Dashboard' },
  { path: '/matches', icon: Trophy, label: 'Matches' },
  { path: '/matches/new', icon: PlusCircle, label: 'New Match' },
  { path: '/connections', icon: Users, label: 'Connections' },
  { path: '/profile', icon: User, label: 'Profile' },
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
      {/* Top Navigation Bar */}
      {!hideChrome && isAuthed && (
        <header className="sticky top-0 z-40 border-b border-[#2a3a4a] bg-[#0C1821]/95 backdrop-blur-sm">
          <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-6">
            {/* Logo */}
            <Link to="/dashboard" className="flex items-center gap-2">
              <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-emerald-600">
                <span className="text-sm font-black text-white">iS</span>
              </div>
              <span className="text-lg font-bold text-white">inSwing</span>
            </Link>

            {/* Nav Links */}
            <nav className="hidden md:flex items-center gap-1">
              {navItems.map((item) => {
                const Icon = item.icon
                const active = location.pathname === item.path ||
                  (item.path === '/dashboard' && location.pathname === '/')
                return (
                  <Link
                    key={item.path}
                    to={item.path}
                    className={`flex items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium transition ${
                      active
                        ? 'bg-emerald-600/15 text-emerald-400'
                        : 'text-[#becabc] hover:bg-white/5 hover:text-white'
                    }`}
                  >
                    <Icon size={16} />
                    <span>{item.label}</span>
                  </Link>
                )
              })}
            </nav>

            {/* Right side - notifications */}
            <div className="flex items-center gap-3">
              <Link
                to="/notifications"
                className="relative flex h-9 w-9 items-center justify-center rounded-lg text-[#becabc] transition hover:bg-white/5 hover:text-white"
              >
                <Bell size={18} />
              </Link>
            </div>
          </div>

          {/* Mobile nav (visible on small screens) */}
          <nav className="flex md:hidden items-center gap-1 overflow-x-auto px-4 pb-2 no-scrollbar">
            {navItems.map((item) => {
              const Icon = item.icon
              const active = location.pathname === item.path ||
                (item.path === '/dashboard' && location.pathname === '/')
              return (
                <Link
                  key={item.path}
                  to={item.path}
                  className={`flex shrink-0 items-center gap-1.5 rounded-full px-3 py-1.5 text-xs font-medium transition ${
                    active
                      ? 'bg-emerald-600/20 text-emerald-400'
                      : 'text-[#889488] hover:text-white'
                  }`}
                >
                  <Icon size={14} />
                  <span>{item.label}</span>
                </Link>
              )
            })}
          </nav>
        </header>
      )}

      {/* Main content */}
      <main className="flex-1">
        <Outlet />
      </main>
    </div>
  )
}
