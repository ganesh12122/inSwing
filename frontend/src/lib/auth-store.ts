import type { UserLoginResponse } from './api/auth'

const KEYS = {
  accessToken: 'inswing_access_token',
  refreshToken: 'inswing_refresh_token',
  user: 'inswing_user',
} as const

export type StoredUser = UserLoginResponse['user']

export const authStore = {
  setSession(response: UserLoginResponse) {
    localStorage.setItem(KEYS.accessToken, response.tokens.access_token)
    localStorage.setItem(KEYS.refreshToken, response.tokens.refresh_token)
    localStorage.setItem(KEYS.user, JSON.stringify(response.user))
  },

  clearSession() {
    localStorage.removeItem(KEYS.accessToken)
    localStorage.removeItem(KEYS.refreshToken)
    localStorage.removeItem(KEYS.user)
  },

  getAccessToken(): string | null {
    return localStorage.getItem(KEYS.accessToken)
  },

  getRefreshToken(): string | null {
    return localStorage.getItem(KEYS.refreshToken)
  },

  getUser(): StoredUser | null {
    const raw = localStorage.getItem(KEYS.user)
    if (!raw) return null
    try {
      return JSON.parse(raw) as StoredUser
    } catch {
      return null
    }
  },

  isAuthenticated(): boolean {
    return Boolean(localStorage.getItem(KEYS.accessToken))
  },
}
