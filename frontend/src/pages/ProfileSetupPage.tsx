import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate } from 'react-router-dom'
import { updateProfile } from '../lib/api/users'
import { authStore } from '../lib/auth-store'
import type { AxiosError } from 'axios'

const profileSchema = z.object({
  batting_style: z.enum(['right-handed', 'left-handed']),
  bowling_style: z.enum(['fast', 'spin', 'pace', 'none']),
  dominant_hand: z.enum(['right', 'left']),
})

type ProfileInput = z.infer<typeof profileSchema>

const BATTING_OPTIONS = [
  { value: 'right-handed', label: 'Right-Handed', icon: '🏏' },
  { value: 'left-handed', label: 'Left-Handed', icon: '🏏' },
] as const

const BOWLING_OPTIONS = [
  { value: 'fast', label: 'Fast', desc: 'Pace & seam' },
  { value: 'spin', label: 'Spin', desc: 'Offspin, legspin' },
  { value: 'pace', label: 'Medium Pace', desc: 'Medium fast' },
  { value: 'none', label: 'Non-bowler', desc: 'Pure batsman' },
] as const

export function ProfileSetupPage() {
  const navigate = useNavigate()
  const user = authStore.getUser()
  const [serverError, setServerError] = useState('')
  const [success, setSuccess] = useState(false)

  const { register, handleSubmit, formState, watch } = useForm<ProfileInput>({
    resolver: zodResolver(profileSchema),
    defaultValues: {
      batting_style: 'right-handed',
      bowling_style: 'fast',
      dominant_hand: 'right',
    },
  })

  const selectedBat = watch('batting_style')
  const selectedBowl = watch('bowling_style')

  const submit = async (data: ProfileInput) => {
    if (!user?.id) return
    setServerError('')
    try {
      await updateProfile(user.id, data)
      setSuccess(true)
      setTimeout(() => navigate('/dashboard', { replace: true }), 1200)
    } catch (err) {
      const msg =
        (err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed to save profile'
      setServerError(msg)
    }
  }

  return (
    <section className="grid gap-6 lg:grid-cols-[1.3fr_1fr]">
      {/* Left — Hero info */}
      <article className="rounded-2xl border border-[var(--line)] bg-[rgba(15,36,52,0.72)] p-6 lg:p-8">
        <p className="text-xs uppercase tracking-[0.22em] text-[var(--accent-strong)]">Step 1 of 1</p>
        <h2 className="mt-3 text-3xl font-extrabold leading-tight lg:text-4xl">
          Build Your Cricket Identity
        </h2>
        <p className="mt-4 max-w-lg text-[var(--text-muted)] leading-relaxed">
          Your profile powers match assignments, player search, and career statistics.
          Other captains will see your playing style when you're invited to matches.
        </p>

        {/* Stats preview card */}
        <div className="mt-8 rounded-xl border border-[var(--line)] bg-[rgba(8,20,31,0.6)] p-5">
          <p className="text-xs uppercase tracking-[0.18em] text-[var(--text-muted)]">Profile Preview</p>
          <div className="mt-3 flex items-center gap-4">
            <div className="flex h-14 w-14 items-center justify-center rounded-full bg-[linear-gradient(135deg,#0bb0f5,#00d17f)] text-xl font-bold text-slate-900">
              {user?.full_name?.charAt(0)?.toUpperCase() ?? '?'}
            </div>
            <div>
              <p className="font-semibold">{user?.full_name ?? 'Player'}</p>
              <p className="text-sm text-[var(--text-muted)]">
                {selectedBat === 'right-handed' ? 'RHB' : 'LHB'} • {selectedBowl === 'none' ? 'Non-bowler' : selectedBowl.charAt(0).toUpperCase() + selectedBowl.slice(1)}
              </p>
            </div>
          </div>
          <div className="mt-4 grid grid-cols-3 gap-3">
            {[
              { label: 'Matches', value: '0' },
              { label: 'Runs', value: '0' },
              { label: 'Wickets', value: '0' },
            ].map((s) => (
              <div key={s.label} className="rounded-lg bg-[rgba(255,255,255,0.03)] px-3 py-2 text-center">
                <p className="text-lg font-bold">{s.value}</p>
                <p className="text-xs text-[var(--text-muted)]">{s.label}</p>
              </div>
            ))}
          </div>
        </div>
      </article>

      {/* Right — Form */}
      <div className="rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.86)] p-6">
        {success ? (
          <div className="flex flex-col items-center justify-center py-12 text-center">
            <div className="mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-[rgba(0,209,127,0.15)] text-3xl">
              ✓
            </div>
            <h3 className="text-xl font-bold">Profile Saved</h3>
            <p className="mt-2 text-sm text-[var(--text-muted)]">Redirecting to dashboard…</p>
          </div>
        ) : (
          <form onSubmit={handleSubmit(submit)} className="space-y-6">
            <div>
              <h3 className="text-lg font-bold">Playing Style</h3>
              <p className="mt-1 text-sm text-[var(--text-muted)]">Choose how you play</p>
            </div>

            {/* Batting style */}
            <fieldset>
              <legend className="mb-2 text-sm font-medium text-[var(--text-muted)]">Batting Style</legend>
              <div className="grid grid-cols-2 gap-3">
                {BATTING_OPTIONS.map((opt) => (
                  <label
                    key={opt.value}
                    className={`flex cursor-pointer items-center gap-3 rounded-xl border p-3 transition ${
                      selectedBat === opt.value
                        ? 'border-[var(--accent)] bg-[rgba(11,176,245,0.1)]'
                        : 'border-[var(--line)] hover:border-[var(--accent)]'
                    }`}
                  >
                    <input type="radio" value={opt.value} {...register('batting_style')} className="sr-only" />
                    <span className={`text-lg ${selectedBat === opt.value ? '' : 'grayscale'}`}>{opt.icon}</span>
                    <span className="text-sm font-medium">{opt.label}</span>
                  </label>
                ))}
              </div>
              {formState.errors.batting_style && (
                <p className="mt-1 text-xs text-red-300">{formState.errors.batting_style.message}</p>
              )}
            </fieldset>

            {/* Bowling style */}
            <fieldset>
              <legend className="mb-2 text-sm font-medium text-[var(--text-muted)]">Bowling Style</legend>
              <div className="grid grid-cols-2 gap-3">
                {BOWLING_OPTIONS.map((opt) => (
                  <label
                    key={opt.value}
                    className={`flex cursor-pointer flex-col rounded-xl border p-3 transition ${
                      selectedBowl === opt.value
                        ? 'border-[var(--accent-strong)] bg-[rgba(0,209,127,0.08)]'
                        : 'border-[var(--line)] hover:border-[var(--accent-strong)]'
                    }`}
                  >
                    <input type="radio" value={opt.value} {...register('bowling_style')} className="sr-only" />
                    <span className="text-sm font-medium">{opt.label}</span>
                    <span className="text-xs text-[var(--text-muted)]">{opt.desc}</span>
                  </label>
                ))}
              </div>
              {formState.errors.bowling_style && (
                <p className="mt-1 text-xs text-red-300">{formState.errors.bowling_style.message}</p>
              )}
            </fieldset>

            {/* Dominant hand */}
            <fieldset>
              <legend className="mb-2 text-sm font-medium text-[var(--text-muted)]">Dominant Hand</legend>
              <div className="grid grid-cols-2 gap-3">
                {(['right', 'left'] as const).map((h) => (
                  <label
                    key={h}
                    className={`flex cursor-pointer items-center justify-center rounded-xl border p-3 text-sm font-medium transition ${
                      watch('dominant_hand') === h
                        ? 'border-[var(--accent)] bg-[rgba(11,176,245,0.1)]'
                        : 'border-[var(--line)] hover:border-[var(--accent)]'
                    }`}
                  >
                    <input type="radio" value={h} {...register('dominant_hand')} className="sr-only" />
                    {h === 'right' ? 'Right Hand' : 'Left Hand'}
                  </label>
                ))}
              </div>
            </fieldset>

            {serverError && <p className="text-xs text-red-400">{serverError}</p>}

            <button
              type="submit"
              disabled={formState.isSubmitting}
              className="w-full rounded-xl bg-[linear-gradient(90deg,#0bb0f5,#00d17f)] px-4 py-2.5 font-semibold text-slate-900 transition hover:opacity-90 disabled:opacity-50"
            >
              {formState.isSubmitting ? 'Saving…' : 'Save & Continue'}
            </button>
          </form>
        )}
      </div>
    </section>
  )
}
