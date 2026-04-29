import { createBrowserRouter, Navigate, Outlet, RouterProvider } from 'react-router-dom'
import { AppShell } from '../layouts/AppShell'
import { AuthPage } from '../pages/AuthPage'
import { DashboardPage } from '../pages/DashboardPage'
import { MatchStudioPage } from '../pages/MatchStudioPage'
import { ProfileSetupPage } from '../pages/ProfileSetupPage'
import { ScoringConsolePage } from '../pages/ScoringConsolePage'
import { LiveScorePage } from '../pages/LiveScorePage'
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
          { path: 'profile/setup', element: <ProfileSetupPage /> },
          { path: 'profile', element: <ProfileSetupPage /> },
          { path: 'dashboard', element: <DashboardPage /> },
          { path: 'matches/new', element: <MatchStudioPage /> },
          { path: 'match/:matchId/scoring', element: <ScoringConsolePage /> },
        ],
      },
    ],
  },
])

export function AppRouter() {
  return <RouterProvider router={router} />
}
