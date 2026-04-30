import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate } from 'react-router-dom'
import { createMatch } from '../lib/api/matches'
import { Zap, Users, ArrowLeft, CheckCircle } from 'lucide-react'
import type { MatchType } from '../lib/api/matches'
import type { AxiosError } from 'axios'

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

const PRESETS = [
  { label: 'Quick 6', icon: 'bolt', values: { overs_limit: 6, max_players_per_team: 8, tennis_ball: true, last_man_batting: true, free_hit: true } },
  { label: 'T10', icon: 'timer', values: { overs_limit: 10, max_players_per_team: 8, tennis_ball: true, last_man_batting: false, free_hit: true } },
  { label: 'T20', icon: 'sports_cricket', values: { overs_limit: 20, max_players_per_team: 11, tennis_ball: false, last_man_batting: false, free_hit: true } },
] as const

const inputClass =
  'w-full h-12 rounded-lg border border-[#3e4a3f] bg-[#1b211c] px-4 text-sm text-[#dfe4dc] outline-none focus:border-emerald-500 placeholder:text-[#889488]'

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

  // ── Step 1: Type selection ──────────────────────────────────────────────
  if (step === 'type') {
    return (
      <div className="pb-8 pt-6 px-6 max-w-2xl mx-auto">
        <section className="mb-8">
          <h2 className="text-2xl font-bold text-[#dfe4dc]">New Match</h2>
          <p className="text-sm text-[#becabc]">Choose your match format</p>
        </section>

        <div className="space-y-4">
          <button
            type="button"
            onClick={() => { setValue('match_type', 'quick'); setStep('config') }}
            className="w-full rounded-xl border border-[#2a3a4a] bg-[#162029] p-5 text-left transition hover:border-emerald-700"
          >
            <div className="flex items-center gap-3 mb-2">
              <div className="flex h-10 w-10 items-center justify-center rounded-full bg-[#1B8A4A]">
                <Zap size={18} className="text-white" />
              </div>
              <h3 className="text-lg font-bold text-[#dfe4dc]">Quick Match</h3>
            </div>
            <p className="text-sm text-[#becabc] pl-[52px]">
              You control both teams. Add players, toss, and start scoring — all in one flow.
            </p>
          </button>

          <button
            type="button"
            onClick={() => { setValue('match_type', 'dual_captain'); setStep('config') }}
            className="w-full rounded-xl border border-[#2a3a4a] bg-[#162029] p-5 text-left transition hover:border-emerald-700"
          >
            <div className="flex items-center gap-3 mb-2">
              <div className="flex h-10 w-10 items-center justify-center rounded-full bg-[#3ca360]">
                <Users size={18} className="text-white" />
              </div>
              <h3 className="text-lg font-bold text-[#dfe4dc]">Dual Captain</h3>
            </div>
            <p className="text-sm text-[#becabc] pl-[52px]">
              Invite an opponent captain. Each manages their squad and agrees on rules together.
            </p>
          </button>
        </div>
      </div>
    )
  }

  // ── Step 3: Success ─────────────────────────────────────────────────────
  if (step === 'done' && createdMatchId) {
    return (
      <div className="flex flex-col items-center justify-center px-6 py-16 text-center max-w-2xl mx-auto">
        <div className="mb-4 flex h-20 w-20 items-center justify-center rounded-full bg-emerald-600/20 border-2 border-emerald-600">
          <CheckCircle size={36} className="text-emerald-400" />
        </div>
        <h2 className="text-xl font-bold text-white">Match Created!</h2>
        <p className="mt-2 text-sm text-[#becabc]">
          {matchType === 'dual_captain'
            ? 'Now invite your opponent captain to get started.'
            : 'Add players, do the toss, and start scoring.'}
        </p>
        <div className="mt-8 flex gap-3 w-full">
          <button
            onClick={() => navigate(`/match/${createdMatchId}/setup`)}
            className="flex-1 h-12 rounded-lg bg-[#1B8A4A] font-bold text-white transition active:scale-[0.98]"
          >
            Setup Match
          </button>
          <button
            onClick={() => navigate('/dashboard')}
            className="flex-1 h-12 rounded-lg border border-[#3e4a3f] text-[#becabc] font-medium transition hover:border-emerald-700"
          >
            Dashboard
          </button>
        </div>
      </div>
    )
  }

  // ── Step 2: Configuration ───────────────────────────────────────────────
  return (
    <div className="pb-8 pt-6 px-6 max-w-2xl mx-auto">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <button
          type="button"
          onClick={() => setStep('type')}
          className="flex h-10 w-10 items-center justify-center rounded-full border border-[#3e4a3f] text-[#becabc] transition hover:border-emerald-700"
        >
          <ArrowLeft size={18} />
        </button>
        <div>
          <p className="text-[10px] font-semibold uppercase tracking-wider text-emerald-500">
            {matchType === 'quick' ? 'Quick Match' : 'Dual Captain'}
          </p>
          <h2 className="text-xl font-bold text-[#dfe4dc]">Configure Match</h2>
        </div>
      </div>

      <form onSubmit={handleSubmit(submit as never)} className="space-y-6">
        {/* Teams */}
        <section className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-5 space-y-4">
          <h3 className="text-xs font-semibold uppercase tracking-wider text-[#dfe4dc]">Teams & Venue</h3>

          <div>
            <span className="mb-1.5 block text-sm text-[#becabc]">Your Team</span>
            <input {...register('team_a_name')} placeholder="Mumbai Mavericks" className={inputClass} />
            {formState.errors.team_a_name && <p className="mt-1 text-xs text-red-400">{formState.errors.team_a_name.message}</p>}
          </div>

          {matchType === 'quick' && (
            <div>
              <span className="mb-1.5 block text-sm text-[#becabc]">Opponent Team</span>
              <input {...register('team_b_name')} placeholder="Delhi Dragons" className={inputClass} />
              {formState.errors.team_b_name && <p className="mt-1 text-xs text-red-400">{formState.errors.team_b_name.message}</p>}
            </div>
          )}

          <div>
            <span className="mb-1.5 block text-sm text-[#becabc]">Venue (optional)</span>
            <input {...register('venue')} placeholder="Marine Drive Ground" className={inputClass} />
          </div>
        </section>

        {/* Rules */}
        <section className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-5 space-y-4">
          <h3 className="text-xs font-semibold uppercase tracking-wider text-[#dfe4dc]">Match Rules</h3>

          {/* Presets */}
          <div className="flex gap-2">
            {PRESETS.map((p) => (
              <button
                key={p.label}
                type="button"
                onClick={() => applyPreset(p)}
                className="flex items-center gap-1.5 rounded-full border border-[#3e4a3f] bg-[#1b211c] px-3 py-1.5 text-xs font-semibold text-[#becabc] transition hover:border-emerald-700 hover:text-emerald-400"
              >
                {p.label}
              </button>
            ))}
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <span className="mb-1.5 block text-xs text-[#889488]">Overs</span>
              <input {...register('overs_limit')} type="number" min={1} max={50} className={inputClass} />
            </div>
            <div>
              <span className="mb-1.5 block text-xs text-[#889488]">Players / Team</span>
              <input {...register('max_players_per_team')} type="number" min={2} max={15} className={inputClass} />
            </div>
            <div>
              <span className="mb-1.5 block text-xs text-[#889488]">Wide Runs</span>
              <select {...register('wide_ball_runs')} className={inputClass}>
                <option value={1}>1 run</option>
                <option value={2}>2 runs</option>
              </select>
            </div>
            <div>
              <span className="mb-1.5 block text-xs text-[#889488]">No-Ball Runs</span>
              <select {...register('no_ball_runs')} className={inputClass}>
                <option value={1}>1 run</option>
                <option value={2}>2 runs</option>
              </select>
            </div>
          </div>

          {/* Toggles */}
          <div className="space-y-2">
            {[
              { name: 'free_hit' as const, label: 'Free Hit' },
              { name: 'last_man_batting' as const, label: 'Last Man Batting' },
              { name: 'tennis_ball' as const, label: 'Tennis Ball' },
            ].map((t) => (
              <label key={t.name} className="flex items-center justify-between rounded-lg border border-[#3e4a3f] bg-[#1b211c] px-4 py-3 cursor-pointer">
                <span className="text-sm font-medium text-[#dfe4dc]">{t.label}</span>
                <input type="checkbox" {...register(t.name)} className="h-5 w-5 rounded accent-emerald-600" />
              </label>
            ))}
          </div>

          {/* Scorer */}
          <div>
            <span className="mb-1.5 block text-xs text-[#889488]">Who Can Score</span>
            <select {...register('scorer_permission')} className={inputClass}>
              <option value="host_only">Host Only</option>
              <option value="captains">Either Captain</option>
              <option value="all_players">Any Player</option>
            </select>
          </div>
        </section>

        {/* Submit */}
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
          {formState.isSubmitting ? 'Creating…' : 'Create Match'}
        </button>
      </form>
    </div>
  )
}
