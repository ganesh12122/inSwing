import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate } from 'react-router-dom'
import { loginWithEmail, requestOTP, verifyOTP } from '../lib/api/auth'
import { authStore } from '../lib/auth-store'
import type { AxiosError } from 'axios'

// ── Email / password tab ────────────────────────────────────────────────────
const emailSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
})
type EmailInput = z.infer<typeof emailSchema>

function EmailLoginForm() {
  const navigate = useNavigate()
  const [serverError, setServerError] = useState('')
  const { register, handleSubmit, formState } = useForm<EmailInput>({
    resolver: zodResolver(emailSchema),
    defaultValues: { email: '', password: '' },
  })

  const submit = async (data: EmailInput) => {
    setServerError('')
    try {
      const res = await loginWithEmail(data.email, data.password)
      authStore.setSession(res)
      navigate('/dashboard', { replace: true })
    } catch (err) {
      const msg = (err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Login failed'
      setServerError(msg)
    }
  }

  return (
    <form onSubmit={handleSubmit(submit)} className="space-y-4">
      <label className="block">
        <span className="mb-1 block text-sm font-medium text-[var(--text-muted)]">Email</span>
        <input
          {...register('email')}
          type="email"
          className="w-full rounded-lg border border-[var(--line)] bg-[var(--bg-deep)] px-3 py-2.5 text-sm outline-none transition focus:border-[var(--accent)]"
        />
        {formState.errors.email && <p className="mt-1 text-xs text-red-400">{formState.errors.email.message}</p>}
      </label>

      <label className="block">
        <span className="mb-1 block text-sm font-medium text-[var(--text-muted)]">Password</span>
        <input
          {...register('password')}
          type="password"
          className="w-full rounded-lg border border-[var(--line)] bg-[var(--bg-deep)] px-3 py-2.5 text-sm outline-none transition focus:border-[var(--accent)]"
        />
        {formState.errors.password && <p className="mt-1 text-xs text-red-400">{formState.errors.password.message}</p>}
      </label>

      {serverError && <p className="text-xs text-red-400">{serverError}</p>}

      <button
        type="submit"
        disabled={formState.isSubmitting}
        className="w-full rounded-lg bg-[var(--accent)] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)] disabled:opacity-50"
      >
        {formState.isSubmitting ? 'Signing in…' : 'Sign In'}
      </button>
    </form>
  )
}

// ── Phone OTP tab ───────────────────────────────────────────────────────────
const phoneSchema = z.object({ phone: z.string().min(8).max(15) })
const otpSchema = z.object({ otp: z.string().length(6) })
type PhoneInput = z.infer<typeof phoneSchema>
type OtpInput = z.infer<typeof otpSchema>

function OTPLoginForm() {
  const navigate = useNavigate()
  const [sessionId, setSessionId] = useState<string | null>(null)
  const [serverError, setServerError] = useState('')

  const phoneForm = useForm<PhoneInput>({ resolver: zodResolver(phoneSchema) })
  const otpForm = useForm<OtpInput>({ resolver: zodResolver(otpSchema) })

  const sendOTP = async (data: PhoneInput) => {
    setServerError('')
    try {
      const res = await requestOTP(data.phone)
      setSessionId(res.session_id)
    } catch (err) {
      const msg = (err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Could not send OTP'
      setServerError(msg)
    }
  }

  const confirmOTP = async (data: OtpInput) => {
    if (!sessionId) return
    setServerError('')
    try {
      const res = await verifyOTP(sessionId, data.otp)
      authStore.setSession(res)
      navigate('/dashboard', { replace: true })
    } catch (err) {
      const msg = (err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Invalid OTP'
      setServerError(msg)
    }
  }

  if (!sessionId) {
    return (
      <form onSubmit={phoneForm.handleSubmit(sendOTP)} className="space-y-4">
        <label className="block">
          <span className="mb-1 block text-sm font-medium text-[var(--text-muted)]">Phone number</span>
          <input
            {...phoneForm.register('phone')}
            type="tel"
            placeholder="+91 98765 43210"
            className="w-full rounded-lg border border-[var(--line)] bg-[var(--bg-deep)] px-3 py-2.5 text-sm outline-none transition focus:border-[var(--accent)]"
          />
          {phoneForm.formState.errors.phone && (
            <p className="mt-1 text-xs text-red-400">{phoneForm.formState.errors.phone.message}</p>
          )}
        </label>

        {serverError && <p className="text-xs text-red-400">{serverError}</p>}

        <button
          type="submit"
          disabled={phoneForm.formState.isSubmitting}
          className="w-full rounded-lg bg-[var(--accent)] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)] disabled:opacity-50"
        >
          {phoneForm.formState.isSubmitting ? 'Sending…' : 'Send OTP'}
        </button>
      </form>
    )
  }

  return (
    <form onSubmit={otpForm.handleSubmit(confirmOTP)} className="space-y-4">
      <p className="text-sm text-[var(--text-muted)]">Enter the 6-digit code sent to your phone.</p>
      <label className="block">
        <span className="mb-1 block text-sm font-medium text-[var(--text-muted)]">OTP code</span>
        <input
          {...otpForm.register('otp')}
          type="text"
          inputMode="numeric"
          maxLength={6}
          className="w-full rounded-lg border border-[var(--line)] bg-[var(--bg-deep)] px-3 py-2.5 text-center text-2xl tracking-[0.5em] outline-none transition focus:border-[var(--accent)]"
        />
        {otpForm.formState.errors.otp && (
          <p className="mt-1 text-xs text-red-400">{otpForm.formState.errors.otp.message}</p>
        )}
      </label>

      {serverError && <p className="text-xs text-red-400">{serverError}</p>}

      <button
        type="submit"
        disabled={otpForm.formState.isSubmitting}
        className="w-full rounded-lg bg-[var(--accent)] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)] disabled:opacity-50"
      >
        {otpForm.formState.isSubmitting ? 'Verifying…' : 'Verify & Sign In'}
      </button>

      <button
        type="button"
        onClick={() => setSessionId(null)}
        className="w-full text-xs text-[var(--text-muted)] underline underline-offset-2"
      >
        Use a different number
      </button>
    </form>
  )
}

// ── Page shell ──────────────────────────────────────────────────────────────
type Tab = 'email' | 'otp'

export function AuthPage() {
  const [tab, setTab] = useState<Tab>('email')

  return (
    <section className="grid gap-5 md:grid-cols-[1.2fr_1fr]">
      <article className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-6">
        <p className="text-xs font-semibold uppercase tracking-wider text-[var(--accent)]">Welcome</p>
        <h2 className="mt-2 text-2xl font-bold">Sign in to inSwing</h2>
        <p className="mt-3 max-w-xl text-sm text-[var(--text-muted)] leading-relaxed">
          Professional cricket scoring with ball-by-ball accuracy, real-time live scorecards,
          and comprehensive match management — built for every level of the game.
        </p>
      </article>

      <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-6">
        {/* Tab switcher */}
        <div className="mb-5 flex rounded-lg border border-[var(--line)] p-1 text-sm">
          {(['email', 'otp'] as Tab[]).map((t) => (
            <button
              key={t}
              type="button"
              onClick={() => setTab(t)}
              className={`flex-1 rounded-md py-1.5 text-sm font-medium transition-colors ${
                tab === t
                  ? 'bg-[var(--accent)] text-white'
                  : 'text-[var(--text-muted)] hover:text-[var(--text-primary)]'
              }`}
            >
              {t === 'email' ? 'Email' : 'Phone OTP'}
            </button>
          ))}
        </div>

        {tab === 'email' ? <EmailLoginForm /> : <OTPLoginForm />}
      </div>
    </section>
  )
}
