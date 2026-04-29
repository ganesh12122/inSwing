import { apiClient } from './client'

// ── Types mirroring backend Pydantic schemas ────────────────────────────────

export interface Profile {
  id: string
  user_id: string
  batting_style: string | null
  bowling_style: string | null
  dominant_hand: string | null
  total_matches: number
  total_runs: number
  total_wickets: number
  total_balls_faced: number
  total_balls_bowled: number
  total_runs_conceded: number
  average_runs: number
  strike_rate: number
  economy_rate: number
  bowling_average: number
  teams: string | null
  achievements: string | null
  created_at: string
  updated_at: string
}

export interface UserProfile {
  user: {
    id: string
    full_name: string
    email: string | null
    phone_number: string | null
    role: string
    bio: string | null
    avatar_url: string | null
    is_active: boolean
    is_verified: boolean
  }
  profile: Profile | null
}

export interface ProfileUpdate {
  batting_style?: string
  bowling_style?: string
  dominant_hand?: string
  teams?: string[]
  achievements?: string[]
}

export interface UserUpdate {
  full_name?: string
  bio?: string
}

// ── API functions ───────────────────────────────────────────────────────────

export async function getUserProfile(userId: string): Promise<UserProfile> {
  const { data } = await apiClient.get<UserProfile>(`/users/${userId}/profile`)
  return data
}

export async function updateProfile(userId: string, profile: ProfileUpdate): Promise<Profile> {
  const { data } = await apiClient.put<Profile>(`/users/${userId}/profile`, profile)
  return data
}

export async function updateUser(userId: string, updates: UserUpdate): Promise<UserProfile['user']> {
  // The backend doesn't have a direct PATCH user endpoint, but profile update covers it
  const { data } = await apiClient.put(`/users/${userId}/profile`, updates)
  return data
}

export async function searchUsers(query: string): Promise<{ id: string; name: string; phone: string }[]> {
  const { data } = await apiClient.get('/search/users', { params: { q: query, limit: 10 } })
  return data.users ?? data ?? []
}
