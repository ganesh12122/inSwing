import { useState, useEffect } from 'react'
import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { getUserProfile, updateProfile } from '../lib/api/users'
import { authStore } from '../lib/auth-store'
import type { AxiosError } from 'axios'

const profileSchema = z.object({
  batting_style: z.enum(['right-handed', 'left-handed']),
  bowling_style: z.enum(['fast', 'spin', 'pace', 'none']),
  dominant_hand: z.enum(['right', 'left']),
})

type ProfileInput = z.infer<typeof profileSchema>

const BATTING_OPTIONS = [
  { value: 'right-handed', label: 'Right-Handed' },
  { value: 'left-handed', label: 'Left-Handed' },
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

  const { data: profileData } = useQuery({
    queryKey: ['profile', user?.id],
    queryFn: () => getUserProfile(user!.id),
    enabled: !!user?.id,
  })

  const { register, handleSubmit, formState, watch, reset } = useForm<ProfileInput>({
    resolver: zodResolver(profileSchema),
    defaultValues: {
      batting_style: 'right-handed',
      bowling_style: 'fast',
      dominant_hand: 'right',
    },
  })

  useEffect(() => {
    const p = profileData?.profile
    if (p) {
      reset({
        batting_style: (p.batting_style as ProfileInput['batting_style']) ?? 'right-handed',
        bowling_style: (p.bowling_style as ProfileInput['bowling_style']) ?? 'fast',
        dominant_hand: (p.dominant_hand as ProfileInput['dominant_hand']) ?? 'right',
      })
    }
  }, [profileData, reset])

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
      <article className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-6 lg:p-8">
        <p className="text-xs font-semibold uppercase tracking-wider text-[var(--accent)]">Player Profile</p>
        <h2 className="mt-3 text-2xl font-bold leading-tight lg:text-3xl">
          Build Your Cricket Identity
        </h2>
        <p className="mt-4 max-w-lg text-sm text-[var(--text-muted)] leading-relaxed">
          Your profile powers match assignments, player search, and career statistics.
          Other captains will see your playing style when you're invited to matches.
        </p>

        {/* Stats preview card */}
        <div className="mt-8 rounded-lg border border-[var(--line)] bg-[var(--bg-deep)] p-5">
          <p className="text-xs font-medium text-[var(--text-muted)]">Profile Preview</p>
          <div className="mt-3 flex items-center gap-4">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-[var(--accent)] text-lg font-bold text-white">
              {user?.full_name?.charAt(0)?.toUpperCase() ?? '?'}
            </div>
            <div>
              <p className="font-semibold">{user?.full_name ?? 'Player'}</p>
              <p className="text-sm text-[var(--text-muted)]">
                {selectedBat === 'right-handed' ? 'RHB' : 'LHB'} · {selectedBowl === 'none' ? 'Non-bowler' : selectedBowl.charAt(0).toUpperCase() + selectedBowl.slice(1)}
              </p>
            </div>
          </div>
          <div className="mt-4 grid grid-cols-3 gap-3">
            {[
              { label: 'Matches', value: '0' },
              { label: 'Runs', value: '0' },
              { label: 'Wickets', value: '0' },
            ].map((s) => (
              <div key={s.label} className="rounded-md bg-[var(--bg-surface)] px-3 py-2 text-center">
                <p className="text-lg font-bold">{s.value}</p>
                <p className="text-xs text-[var(--text-muted)]">{s.label}</p>
              </div>
            ))}
          </div>
        </div>
      </article>

      {/* Right — Form */}
      <div className="rounded-lg border border-[var(--line)] bg-[var(--bg-mid)] p-6">
        {success ? (
          <div className="flex flex-col items-center justify-center py-12 text-center">
            <div className="mb-4 flex h-14 w-14 items-center justify-center rounded-full bg-[var(--accent)]/15 text-2xl text-[var(--accent-strong)]">
              ✓
            </div>
            <h3 className="text-lg font-bold">Profile Saved</h3>
            <p className="mt-2 text-sm text-[var(--text-muted)]">Redirecting to dashboard…</p>
          </div>
        ) : (
          <form onSubmit={handleSubmit(submit)} className="space-y-6">
            <div>
              <h3 className="text-base font-bold">Playing Style</h3>
              <p className="mt-1 text-sm text-[var(--text-muted)]">Choose how you play</p>
            </div>

            {/* Batting style */}
            <fieldset>
              <legend className="mb-2 text-sm font-medium text-[var(--text-muted)]">Batting Style</legend>
              <div className="grid grid-cols-2 gap-3">
                {BATTING_OPTIONS.map((opt) => (
                  <label
                    key={opt.value}
                    className={`flex cursor-pointer items-center gap-3 rounded-lg border p-3 transition ${
                      selectedBat === opt.value
                        ? 'border-[var(--accent)] bg-[var(--accent)]/8'
                        : 'border-[var(--line)] hover:border-[var(--accent)]'
                    }`}
                  >
                    <input type="radio" value={opt.value} {...register('batting_style')} className="sr-only" />
                    <span className="text-sm font-medium">{opt.label}</span>
                  </label>
                ))}
              </div>
              {formState.errors.batting_style && (
                <p className="mt-1 text-xs text-red-400">{formState.errors.batting_style.message}</p>
              )}
            </fieldset>

            {/* Bowling style */}
            <fieldset>
              <legend className="mb-2 text-sm font-medium text-[var(--text-muted)]">Bowling Style</legend>
              <div className="grid grid-cols-2 gap-3">
                {BOWLING_OPTIONS.map((opt) => (
                  <label
                    key={opt.value}
                    className={`flex cursor-pointer flex-col rounded-lg border p-3 transition ${
                      selectedBowl === opt.value
                        ? 'border-[var(--accent-strong)] bg-[var(--accent-strong)]/8'
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
                <p className="mt-1 text-xs text-red-400">{formState.errors.bowling_style.message}</p>
              )}
            </fieldset>

            {/* Dominant hand */}
            <fieldset>
              <legend className="mb-2 text-sm font-medium text-[var(--text-muted)]">Dominant Hand</legend>
              <div className="grid grid-cols-2 gap-3">
                {(['right', 'left'] as const).map((h) => (
                  <label
                    key={h}
                    className={`flex cursor-pointer items-center justify-center rounded-lg border p-3 text-sm font-medium transition ${
                      watch('dominant_hand') === h
                        ? 'border-[var(--accent)] bg-[var(--accent)]/8'
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
              className="w-full rounded-lg bg-[var(--accent)] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)] disabled:opacity-50"
            >
              {formState.isSubmitting ? 'Saving…' : 'Save & Continue'}
            </button>
          </form>
        )}
      </div>
    </section>
  )
}
