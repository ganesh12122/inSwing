import { createBrowserRouter, Navigate, Outlet, RouterProvider } from 'react-router-dom'
import { AppShell } from '../layouts/AppShell'
import { AuthPage } from '../pages/AuthPage'
import { DashboardPage } from '../pages/DashboardPage'
import { MatchStudioPage } from '../pages/MatchStudioPage'
import { ProfilePage } from '../pages/ProfilePage'
import { ScoringConsolePage } from '../pages/ScoringConsolePage'
import { LiveScorePage } from '../pages/LiveScorePage'
import { ConnectionsPage } from '../pages/ConnectionsPage'
import { NotificationsPage } from '../pages/NotificationsPage'
import { MatchesListPage } from '../pages/MatchesListPage'
import { MatchSetupHubPage } from '../pages/MatchSetupHubPage'
import { authStore } from '../lib/auth-store'

function RequireAuth() {
  return authStore.isAuthenticated() ? <Outlet /> : <Navigate to="/auth" replace />
}

function RedirectIfAuthed() {
  return authStore.isAuthenticated() ? <Navigate to="/dashboard" replace /> : <Outlet />
}

const router = createBrowserRouter([
  {
    path: '/',
    element: <AppShell />,
    children: [
      { index: true, element: <Navigate to="/auth" replace /> },
      {
        element: <RedirectIfAuthed />,
        children: [{ path: 'auth', element: <AuthPage /> }],
      },
      // Public — no auth required
      { path: 'live/:matchId', element: <LiveScorePage /> },
      {
        element: <RequireAuth />,
        children: [
          { path: 'dashboard', element: <DashboardPage /> },
          { path: 'profile', element: <ProfilePage /> },
          { path: 'matches', element: <MatchesListPage /> },
          { path: 'matches/new', element: <MatchStudioPage /> },
          { path: 'match/:matchId/scoring', element: <ScoringConsolePage /> },
          { path: 'match/:matchId/setup', element: <MatchSetupHubPage /> },
          { path: 'connections', element: <ConnectionsPage /> },
          { path: 'notifications', element: <NotificationsPage /> },
        ],
      },
    ],
  },
])

export function AppRouter() {
  return <RouterProvider router={router} />
}
