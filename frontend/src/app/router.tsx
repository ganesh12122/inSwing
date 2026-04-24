import { createBrowserRouter, Navigate, RouterProvider } from 'react-router-dom'
import { AppShell } from '../layouts/AppShell'
import { AuthPage } from '../pages/AuthPage'
import { DashboardPage } from '../pages/DashboardPage'
import { MatchStudioPage } from '../pages/MatchStudioPage'
import { ProfileSetupPage } from '../pages/ProfileSetupPage'

const router = createBrowserRouter([
  {
    path: '/',
    element: <AppShell />,
    children: [
      { index: true, element: <Navigate to="/auth" replace /> },
      { path: 'auth', element: <AuthPage /> },
      { path: 'profile/setup', element: <ProfileSetupPage /> },
      { path: 'dashboard', element: <DashboardPage /> },
      { path: 'matches/new', element: <MatchStudioPage /> },
    ],
  },
])

export function AppRouter() {
  return <RouterProvider router={router} />
}
