import { createBrowserRouter, Navigate, Outlet, RouterProvider } from 'react-router-dom'
import { AppShell } from '../layouts/AppShell'
import { AuthPage } from '../pages/AuthPage'
import { DashboardPage } from '../pages/DashboardPage'
import { MatchStudioPage } from '../pages/MatchStudioPage'
import { ProfileSetupPage } from '../pages/ProfileSetupPage'
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
      {
        element: <RequireAuth />,
        children: [
          { path: 'profile/setup', element: <ProfileSetupPage /> },
          { path: 'dashboard', element: <DashboardPage /> },
          { path: 'matches/new', element: <MatchStudioPage /> },
        ],
      },
    ],
  },
])

export function AppRouter() {
  return <RouterProvider router={router} />
}
