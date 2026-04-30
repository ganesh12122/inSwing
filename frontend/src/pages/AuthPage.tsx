import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate } from 'react-router-dom'
import { loginWithEmail, register as registerApi } from '../lib/api/auth'
import { authStore } from '../lib/auth-store'
import type { AxiosError } from 'axios'

type AuthView = 'landing' | 'login' | 'register'

// ── Schemas ─────────────────────────────────────────────────────────────────
const loginSchema = z.object({
  email: z.string().email('Enter a valid email'),
  password: z.string().min(6, 'Min 6 characters'),
})
type LoginInput = z.infer<typeof loginSchema>

const registerSchema = z
  .object({
    full_name: z.string().min(2, 'Enter your name'),
    email: z.string().email('Enter a valid email'),
    phone_number: z.string().optional(),
    password: z.string().min(6, 'Min 6 characters'),
    confirm_password: z.string(),
  })
  .refine((d) => d.password === d.confirm_password, {
    message: 'Passwords do not match',
    path: ['confirm_password'],
  })
type RegisterInput = z.infer<typeof registerSchema>

// ── Input field component ───────────────────────────────────────────────────
function Field({
  label,
  error,
  children,
}: {
  label: string
  error?: string
  children: React.ReactNode
}) {
  return (
    <label className="block">
      <span className="mb-1.5 block text-sm font-medium text-[#becabc]">{label}</span>
      {children}
      {error && <p className="mt-1 text-xs text-red-400">{error}</p>}
    </label>
  )
}

const inputClass =
  'w-full h-12 rounded-lg border border-[#3e4a3f] bg-[#1b211c] px-4 text-sm text-[#dfe4dc] outline-none transition-colors focus:border-emerald-500 placeholder:text-[#889488]'

// ── Login Form ──────────────────────────────────────────────────────────────
function LoginForm({ onBack }: { onBack: () => void }) {
  const navigate = useNavigate()
  const [serverError, setServerError] = useState('')
  const { register, handleSubmit, formState } = useForm<LoginInput>({
    resolver: zodResolver(loginSchema),
  })

  const submit = async (data: LoginInput) => {
    setServerError('')
    try {
      const res = await loginWithEmail(data.email, data.password)
      authStore.setSession(res)
      navigate('/dashboard', { replace: true })
    } catch (err) {
      const msg =
        (err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Login failed'
      setServerError(msg)
    }
  }

  return (
    <div className="w-full max-w-md px-4">
      <button
        type="button"
        onClick={onBack}
        className="mb-6 flex items-center gap-1 text-sm text-[#becabc] transition hover:text-emerald-400"
      >
        <span className="material-symbols-outlined text-[18px]">arrow_back</span>
        Back
      </button>

      <h2 className="mb-2 text-2xl font-bold text-white">Welcome back</h2>
      <p className="mb-8 text-sm text-[#becabc]">Sign in to your inSwing account</p>

      <form onSubmit={handleSubmit(submit)} className="space-y-5">
        <Field label="Email" error={formState.errors.email?.message}>
          <input {...register('email')} type="email" placeholder="you@example.com" className={inputClass} />
        </Field>

        <Field label="Password" error={formState.errors.password?.message}>
          <input {...register('password')} type="password" placeholder="••••••••" className={inputClass} />
        </Field>

        {serverError && (
          <div className="rounded-lg border border-red-900/50 bg-red-950/30 p-3 text-xs text-red-400">
            {serverError}
          </div>
        )}

        <button
          type="submit"
          disabled={formState.isSubmitting}
          className="w-full h-14 rounded-lg bg-[#1B8A4A] text-white font-bold text-lg shadow-lg transition-transform active:scale-[0.98] disabled:opacity-50"
        >
          {formState.isSubmitting ? 'Signing in…' : 'Sign In'}
        </button>
      </form>
    </div>
  )
}

// ── Register Form ───────────────────────────────────────────────────────────
function RegisterForm({ onBack }: { onBack: () => void }) {
  const navigate = useNavigate()
  const [serverError, setServerError] = useState('')
  const { register, handleSubmit, formState } = useForm<RegisterInput>({
    resolver: zodResolver(registerSchema),
  })

  const submit = async (data: RegisterInput) => {
    setServerError('')
    try {
      const res = await registerApi(data.full_name, data.email, data.password, data.phone_number)
      authStore.setSession(res)
      navigate('/dashboard', { replace: true })
    } catch (err) {
      const msg =
        (err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Registration failed'
      setServerError(msg)
    }
  }

  return (
    <div className="w-full max-w-md px-4">
      <button
        type="button"
        onClick={onBack}
        className="mb-6 flex items-center gap-1 text-sm text-[#becabc] transition hover:text-emerald-400"
      >
        <span className="material-symbols-outlined text-[18px]">arrow_back</span>
        Back
      </button>

      <h2 className="mb-2 text-2xl font-bold text-white">Create Account</h2>
      <p className="mb-8 text-sm text-[#becabc]">Join the professional scoring platform</p>

      <form onSubmit={handleSubmit(submit)} className="space-y-5">
        <Field label="Full Name" error={formState.errors.full_name?.message}>
          <input {...register('full_name')} placeholder="John Doe" className={inputClass} />
        </Field>

        <Field label="Email" error={formState.errors.email?.message}>
          <input {...register('email')} type="email" placeholder="you@example.com" className={inputClass} />
        </Field>

        <Field label="Phone (optional)" error={formState.errors.phone_number?.message}>
          <input {...register('phone_number')} type="tel" placeholder="+91 98765 43210" className={inputClass} />
        </Field>

        <Field label="Password" error={formState.errors.password?.message}>
          <input {...register('password')} type="password" placeholder="••••••••" className={inputClass} />
        </Field>

        <Field label="Confirm Password" error={formState.errors.confirm_password?.message}>
          <input {...register('confirm_password')} type="password" placeholder="••••••••" className={inputClass} />
        </Field>

        {serverError && (
          <div className="rounded-lg border border-red-900/50 bg-red-950/30 p-3 text-xs text-red-400">
            {serverError}
          </div>
        )}

        <button
          type="submit"
          disabled={formState.isSubmitting}
          className="w-full h-14 rounded-lg bg-[#1B8A4A] text-white font-bold text-lg shadow-lg transition-transform active:scale-[0.98] disabled:opacity-50"
        >
          {formState.isSubmitting ? 'Creating account…' : 'Create Account'}
        </button>
      </form>
    </div>
  )
}

// ── Landing ─────────────────────────────────────────────────────────────────
function Landing({ onLogin, onRegister }: { onLogin: () => void; onRegister: () => void }) {
  return (
    <section className="flex flex-col items-center px-4">
      {/* Logo */}
      <div className="relative group mb-8">
        <div className="absolute -inset-1 rounded-full bg-emerald-500 opacity-25 blur group-hover:opacity-50 transition duration-1000" />
        <div className="relative flex h-32 w-32 items-center justify-center rounded-full border-4 border-[#2A3A4A] bg-[#1B8A4A] shadow-2xl">
          <span className="font-mono text-[64px] font-bold italic tracking-tighter text-white">
            iS
          </span>
        </div>
      </div>

      {/* Title */}
      <h1 className="mb-2 text-[40px] font-bold leading-none tracking-tight text-white">inSwing</h1>
      <p className="mb-10 text-sm font-semibold uppercase tracking-widest text-[#becabc] opacity-80">
        Professional Cricket Scoring
      </p>

      {/* Buttons */}
      <div className="w-full max-w-xs space-y-4">
        <button
          onClick={onLogin}
          className="flex h-14 w-full items-center justify-center rounded-lg bg-[#1B8A4A] text-lg font-bold text-white shadow-lg transition-transform active:scale-[0.98]"
        >
          Login
        </button>
        <button
          onClick={onRegister}
          className="flex h-14 w-full items-center justify-center rounded-lg border border-[#2A3A4A] bg-[#1b211c] text-lg font-bold text-[#dfe4dc] transition-all hover:bg-[#262b26] active:scale-[0.98]"
        >
          Register
        </button>
      </div>

      {/* Footer ornament */}
      <div className="mt-12 flex items-center gap-3">
        <div className="h-px w-8 bg-[#2A3A4A]" />
        <span className="text-[10px] font-semibold uppercase tracking-widest text-[#becabc] opacity-60">
          Broadcast Partner
        </span>
        <div className="h-px w-8 bg-[#2A3A4A]" />
      </div>
    </section>
  )
}

// ── Page Export ──────────────────────────────────────────────────────────────
export function AuthPage() {
  const [view, setView] = useState<AuthView>('landing')

  return (
    <main className="relative flex min-h-dvh flex-col items-center justify-center overflow-hidden broadcast-mesh">
      {/* Background glow */}
      <div className="pointer-events-none absolute inset-0 opacity-20">
        <div className="absolute -left-[10%] -top-[10%] h-[40%] w-[40%] rounded-full bg-[#3ca360] blur-[120px]" />
        <div className="absolute -bottom-[10%] -right-[10%] h-[40%] w-[40%] rounded-full bg-[#df6d7f] opacity-30 blur-[120px]" />
      </div>

      {/* Content */}
      <div className="z-10 w-full flex flex-col items-center">
        {view === 'landing' && (
          <Landing onLogin={() => setView('login')} onRegister={() => setView('register')} />
        )}
        {view === 'login' && <LoginForm onBack={() => setView('landing')} />}
        {view === 'register' && <RegisterForm onBack={() => setView('landing')} />}
      </div>

      {/* Version badge */}
      <p className="absolute bottom-4 text-[10px] font-semibold uppercase tracking-widest text-[#becabc] opacity-40">
        &copy; 2024 inSwing Broadcast Technologies
      </p>
    </main>
  )
}
