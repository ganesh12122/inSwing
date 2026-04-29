import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate } from 'react-router-dom'
import { createMatch } from '../lib/api/matches'
import type { MatchType } from '../lib/api/matches'
import type { AxiosError } from 'axios'

// ── Schema ──────────────────────────────────────────────────────────────────

const matchSchema = z
  .object({
    match_type: z.enum(['quick', 'dual_captain']),
    team_a_name: z.string().min(1, 'Required').max(100),
    team_b_name: z.string().max(100).optional(),
    venue: z.string().max(255).optional(),
    overs_limit: z.coerce.number().min(1).max(50),
    max_players_per_team: z.coerce.number().min(2).max(15),
    wide_ball_runs: z.coerce.number().min(1).max(2),
    no_ball_runs: z.coerce.number().min(1).max(2),
    free_hit: z.boolean(),
    last_man_batting: z.boolean(),
    tennis_ball: z.boolean(),
    scorer_permission: z.enum(['host_only', 'captains', 'designated', 'all_players']),
  })
  .refine((d) => d.match_type === 'dual_captain' || (d.team_b_name && d.team_b_name.length > 0), {
    message: 'Team B name required for quick match',
    path: ['team_b_name'],
  })

type MatchInput = z.infer<typeof matchSchema>

// ── Presets ─────────────────────────────────────────────────────────────────

const PRESETS = [
  {
    label: 'Gully Cricket',
    desc: '6 overs • Tennis ball • Last man standing',
    values: { overs_limit: 6, max_players_per_team: 8, tennis_ball: true, last_man_batting: true, free_hit: true },
  },
  {
    label: 'Club Match',
    desc: '20 overs • Standard rules',
    values: { overs_limit: 20, max_players_per_team: 11, tennis_ball: false, last_man_batting: false, free_hit: true },
  },
  {
    label: 'Quick T10',
    desc: '10 overs • Fast format',
    values: { overs_limit: 10, max_players_per_team: 8, tennis_ball: true, last_man_batting: false, free_hit: true },
  },
] as const

// ── Component ───────────────────────────────────────────────────────────────

export function MatchStudioPage() {
  const navigate = useNavigate()
  const [serverError, setServerError] = useState('')
  const [step, setStep] = useState<'type' | 'config' | 'done'>('type')
  const [createdMatchId, setCreatedMatchId] = useState<string | null>(null)

  const { register, handleSubmit, formState, watch, setValue } = useForm<MatchInput>({
    resolver: zodResolver(matchSchema) as never,
    defaultValues: {
      match_type: 'quick',
      team_a_name: '',
      team_b_name: '',
      venue: '',
      overs_limit: 6,
      max_players_per_team: 8,
      wide_ball_runs: 1,
      no_ball_runs: 1,
      free_hit: true,
      last_man_batting: false,
      tennis_ball: true,
      scorer_permission: 'host_only',
    },
  })

  const matchType = watch('match_type')

  const applyPreset = (preset: (typeof PRESETS)[number]) => {
    for (const [key, val] of Object.entries(preset.values)) {
      setValue(key as keyof MatchInput, val as never)
    }
  }

  const submit = async (data: MatchInput) => {
    setServerError('')
    try {
      const res = await createMatch({
        match_type: data.match_type as MatchType,
        team_a_name: data.team_a_name,
        team_b_name: data.match_type === 'quick' ? data.team_b_name : undefined,
        venue: data.venue || undefined,
        rules: {
          overs_limit: data.overs_limit,
          max_players_per_team: data.max_players_per_team,
          wide_ball_runs: data.wide_ball_runs,
          no_ball_runs: data.no_ball_runs,
          free_hit: data.free_hit,
          last_man_batting: data.last_man_batting,
          tennis_ball: data.tennis_ball,
          scorer_permission: data.scorer_permission,
        },
      })
      setCreatedMatchId(res.id)
      setStep('done')
    } catch (err) {
      const msg =
        (err as AxiosError<{ detail: string }>).response?.data?.detail ?? 'Failed to create match'
      setServerError(msg)
    }
  }

  // ── Step 1: Match type selector ─────────────────────────────────────────
  if (step === 'type') {
    return (
      <section className="space-y-6">
        <article className="rounded-2xl border border-[var(--line)] bg-[rgba(15,36,52,0.72)] p-6 lg:p-8">
          <p className="text-xs uppercase tracking-[0.22em] text-[var(--accent-strong)]">Match Studio</p>
          <h2 className="mt-3 text-3xl font-extrabold lg:text-4xl">Create a Match</h2>
          <p className="mt-3 max-w-xl text-[var(--text-muted)]">
            Choose your match format. Quick matches let you manage both teams solo.
            Dual Captain mode invites an opponent to co-manage their squad.
          </p>
        </article>

        <div className="grid gap-4 md:grid-cols-2">
          {/* Quick Match */}
          <button
            type="button"
            onClick={() => {
              setValue('match_type', 'quick')
              setStep('config')
            }}
            className="group rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.86)] p-6 text-left transition hover:border-[var(--accent)]"
          >
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-xl bg-[rgba(11,176,245,0.12)] text-xl">
              ⚡
            </div>
            <h3 className="text-xl font-bold">Quick Match</h3>
            <p className="mt-2 text-sm text-[var(--text-muted)] leading-relaxed">
              You control both teams. Create teams, add players, toss, and start scoring — all in one flow.
              Perfect for local gully cricket.
            </p>
            <p className="mt-4 text-xs font-medium text-[var(--accent)] opacity-0 transition group-hover:opacity-100">
              Select →
            </p>
          </button>

          {/* Dual Captain */}
          <button
            type="button"
            onClick={() => {
              setValue('match_type', 'dual_captain')
              setStep('config')
            }}
            className="group rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.86)] p-6 text-left transition hover:border-[var(--accent-strong)]"
          >
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-xl bg-[rgba(0,209,127,0.12)] text-xl">
              🤝
            </div>
            <h3 className="text-xl font-bold">Dual Captain</h3>
            <p className="mt-2 text-sm text-[var(--text-muted)] leading-relaxed">
              Invite an opponent captain. Each captain manages their own squad, agrees on rules,
              and negotiates before the match begins.
            </p>
            <p className="mt-4 text-xs font-medium text-[var(--accent-strong)] opacity-0 transition group-hover:opacity-100">
              Select →
            </p>
          </button>
        </div>
      </section>
    )
  }

  // ── Step 3: Success ─────────────────────────────────────────────────────
  if (step === 'done' && createdMatchId) {
    return (
      <section className="flex flex-col items-center justify-center py-16 text-center">
        <div className="mb-5 flex h-20 w-20 items-center justify-center rounded-full bg-[rgba(0,209,127,0.15)] text-4xl">
          🏏
        </div>
        <h2 className="text-2xl font-extrabold">Match Created!</h2>
        <p className="mt-2 text-[var(--text-muted)]">
          {matchType === 'dual_captain'
            ? 'Now invite your opponent captain to get started.'
            : 'Add players, do the toss, and start scoring.'}
        </p>
        <div className="mt-6 flex gap-3">
          <button
            onClick={() => navigate(`/match/${createdMatchId}/scoring`)}
            className="rounded-xl bg-[linear-gradient(90deg,#0bb0f5,#00d17f)] px-6 py-2.5 font-semibold text-slate-900"
          >
            Go to Scoring →
          </button>
          <button
            onClick={() => navigate('/dashboard')}
            className="rounded-xl border border-[var(--line)] px-6 py-2.5 text-sm text-[var(--text-muted)] hover:border-[var(--accent)]"
          >
            Dashboard
          </button>
        </div>
      </section>
    )
  }

  // ── Step 2: Configuration form ──────────────────────────────────────────
  return (
    <section className="space-y-6">
      <div className="flex items-center gap-3">
        <button
          type="button"
          onClick={() => setStep('type')}
          className="flex h-8 w-8 items-center justify-center rounded-lg border border-[var(--line)] text-sm text-[var(--text-muted)] hover:border-[var(--accent)]"
        >
          ←
        </button>
        <div>
          <p className="text-xs uppercase tracking-[0.18em] text-[var(--accent)]">
            {matchType === 'quick' ? 'Quick Match' : 'Dual Captain'}
          </p>
          <h2 className="text-2xl font-extrabold">Configure Match</h2>
        </div>
      </div>

      <form onSubmit={handleSubmit(submit as never)} className="grid gap-6 lg:grid-cols-[1fr_1fr]">
        {/* Left column — Teams */}
        <div className="space-y-5 rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.86)] p-6">
          <h3 className="text-lg font-bold">Teams & Venue</h3>

          <label className="block">
            <span className="mb-1 block text-sm text-[var(--text-muted)]">Your Team Name</span>
            <input
              {...register('team_a_name')}
              placeholder="e.g. Mumbai Mavericks"
              className="w-full rounded-xl border border-[var(--line)] bg-[rgba(255,255,255,0.03)] px-3 py-2.5 outline-none focus:border-[var(--accent)]"
            />
            {formState.errors.team_a_name && (
              <p className="mt-1 text-xs text-red-300">{formState.errors.team_a_name.message}</p>
            )}
          </label>

          {matchType === 'quick' && (
            <label className="block">
              <span className="mb-1 block text-sm text-[var(--text-muted)]">Opponent Team Name</span>
              <input
                {...register('team_b_name')}
                placeholder="e.g. Delhi Dragons"
                className="w-full rounded-xl border border-[var(--line)] bg-[rgba(255,255,255,0.03)] px-3 py-2.5 outline-none focus:border-[var(--accent)]"
              />
              {formState.errors.team_b_name && (
                <p className="mt-1 text-xs text-red-300">{formState.errors.team_b_name.message}</p>
              )}
            </label>
          )}

          {matchType === 'dual_captain' && (
            <div className="rounded-xl border border-dashed border-[var(--line)] bg-[rgba(255,255,255,0.02)] p-4 text-center">
              <p className="text-sm text-[var(--text-muted)]">
                Opponent captain will name their team after accepting your invite
              </p>
            </div>
          )}

          <label className="block">
            <span className="mb-1 block text-sm text-[var(--text-muted)]">Venue (optional)</span>
            <input
              {...register('venue')}
              placeholder="e.g. Marine Drive Ground"
              className="w-full rounded-xl border border-[var(--line)] bg-[rgba(255,255,255,0.03)] px-3 py-2.5 outline-none focus:border-[var(--accent)]"
            />
          </label>
        </div>

        {/* Right column — Rules */}
        <div className="space-y-5 rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.86)] p-6">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-bold">Match Rules</h3>
          </div>

          {/* Presets */}
          <div className="flex flex-wrap gap-2">
            {PRESETS.map((p) => (
              <button
                key={p.label}
                type="button"
                onClick={() => applyPreset(p)}
                className="rounded-lg border border-[var(--line)] px-3 py-1.5 text-xs transition hover:border-[var(--accent)] hover:text-[var(--accent)]"
              >
                {p.label}
              </button>
            ))}
          </div>

          <div className="grid grid-cols-2 gap-4">
            <label className="block">
              <span className="mb-1 block text-xs text-[var(--text-muted)]">Overs</span>
              <input
                {...register('overs_limit')}
                type="number"
                min={1}
                max={50}
                className="w-full rounded-xl border border-[var(--line)] bg-[rgba(255,255,255,0.03)] px-3 py-2 outline-none focus:border-[var(--accent)]"
              />
            </label>
            <label className="block">
              <span className="mb-1 block text-xs text-[var(--text-muted)]">Players / Team</span>
              <input
                {...register('max_players_per_team')}
                type="number"
                min={2}
                max={15}
                className="w-full rounded-xl border border-[var(--line)] bg-[rgba(255,255,255,0.03)] px-3 py-2 outline-none focus:border-[var(--accent)]"
              />
            </label>
            <label className="block">
              <span className="mb-1 block text-xs text-[var(--text-muted)]">Wide Runs</span>
              <select
                {...register('wide_ball_runs')}
                className="w-full rounded-xl border border-[var(--line)] bg-[rgba(255,255,255,0.03)] px-3 py-2 outline-none focus:border-[var(--accent)]"
              >
                <option value={1}>1 run</option>
                <option value={2}>2 runs</option>
              </select>
            </label>
            <label className="block">
              <span className="mb-1 block text-xs text-[var(--text-muted)]">No-Ball Runs</span>
              <select
                {...register('no_ball_runs')}
                className="w-full rounded-xl border border-[var(--line)] bg-[rgba(255,255,255,0.03)] px-3 py-2 outline-none focus:border-[var(--accent)]"
              >
                <option value={1}>1 run</option>
                <option value={2}>2 runs</option>
              </select>
            </label>
          </div>

          {/* Toggle switches */}
          <div className="space-y-3">
            {[
              { name: 'free_hit' as const, label: 'Free Hit', desc: 'After no-ball' },
              { name: 'last_man_batting' as const, label: 'Last Man Batting', desc: 'Gully cricket style' },
              { name: 'tennis_ball' as const, label: 'Tennis Ball', desc: 'Soft ball match' },
            ].map((toggle) => (
              <label key={toggle.name} className="flex cursor-pointer items-center justify-between rounded-xl border border-[var(--line)] px-4 py-3">
                <div>
                  <p className="text-sm font-medium">{toggle.label}</p>
                  <p className="text-xs text-[var(--text-muted)]">{toggle.desc}</p>
                </div>
                <input
                  type="checkbox"
                  {...register(toggle.name)}
                  className="h-5 w-5 accent-[var(--accent-strong)]"
                />
              </label>
            ))}
          </div>

          {/* Scorer permission */}
          <label className="block">
            <span className="mb-1 block text-xs text-[var(--text-muted)]">Who Can Score</span>
            <select
              {...register('scorer_permission')}
              className="w-full rounded-xl border border-[var(--line)] bg-[rgba(255,255,255,0.03)] px-3 py-2 outline-none focus:border-[var(--accent)]"
            >
              <option value="host_only">Host Only</option>
              <option value="captains">Either Captain</option>
              <option value="all_players">Any Player</option>
            </select>
          </label>
        </div>

        {/* Submit row */}
        <div className="lg:col-span-2">
          {serverError && <p className="mb-3 text-xs text-red-400">{serverError}</p>}
          <button
            type="submit"
            disabled={formState.isSubmitting}
            className="w-full rounded-xl bg-[linear-gradient(90deg,#0bb0f5,#00d17f)] px-6 py-3 text-lg font-bold text-slate-900 transition hover:opacity-90 disabled:opacity-50"
          >
            {formState.isSubmitting ? 'Creating Match…' : 'Create Match 🏏'}
          </button>
        </div>
      </form>
    </section>
  )
}
