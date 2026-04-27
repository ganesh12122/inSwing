import { apiClient } from './client'

// ── Response type shapes (mirror backend Pydantic schemas) ──────────────────

export interface TokenResponse {
  access_token: string
  refresh_token: string
  token_type: string
  expires_in: number
}

export interface UserLoginResponse {
  user: {
    id: string
    full_name: string
    email?: string
    phone_number?: string
    role: string
  }
  tokens: TokenResponse
  message: string
}

export interface OTPResponse {
  session_id: string
  message: string
  expires_in: number
  attempts_remaining: number
  otp_code?: string // only in DEBUG mode
}

// ── Auth API functions ──────────────────────────────────────────────────────

export async function register(
  full_name: string,
  email: string,
  password: string,
  phone_number?: string,
): Promise<UserLoginResponse> {
  const { data } = await apiClient.post<UserLoginResponse>('/auth/register', {
    full_name,
    email,
    password,
    phone_number,
  })
  return data
}

export async function loginWithEmail(email: string, password: string): Promise<UserLoginResponse> {
  const { data } = await apiClient.post<UserLoginResponse>('/auth/login', { email, password })
  return data
}

export async function requestOTP(phone_number: string): Promise<OTPResponse> {
  const { data } = await apiClient.post<OTPResponse>('/auth/request-otp', { phone_number })
  return data
}

export async function verifyOTP(session_id: string, otp_code: string): Promise<UserLoginResponse> {
  const { data } = await apiClient.post<UserLoginResponse>('/auth/verify-otp', { session_id, otp_code })
  return data
}

export async function refreshToken(refresh_token: string): Promise<TokenResponse> {
  const { data } = await apiClient.post<TokenResponse>('/auth/refresh', { refresh_token })
  return data
}

export async function logout(): Promise<void> {
  await apiClient.post('/auth/logout')
}
