import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { zodResolver } from '@hookform/resolvers/zod'

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
})

type FormInput = z.infer<typeof schema>

export function AuthPage() {
  const { register, handleSubmit, formState } = useForm<FormInput>({
    resolver: zodResolver(schema),
    defaultValues: { email: '', password: '' },
  })

  const submit = (data: FormInput) => {
    // Wiring to backend auth endpoints is next phase after API contract lock.
    // This keeps shell stable while product flow is finalized.
    console.log(data)
  }

  return (
    <section className="grid gap-5 md:grid-cols-[1.2fr_1fr]">
      <article className="rounded-2xl border border-[var(--line)] bg-[rgba(15,36,52,0.72)] p-6">
        <p className="text-xs uppercase tracking-[0.22em] text-[var(--accent-strong)]">Broadcast-grade onboarding</p>
        <h2 className="mt-2 text-3xl font-extrabold">Sign in and Step Into Match Control</h2>
        <p className="mt-3 max-w-xl text-[var(--text-muted)]">
          inSwing V1 focuses on professional profile setup, instant match creation, and ball-by-ball reliability for both
          gully and professional cricket use cases.
        </p>
      </article>

      <form
        onSubmit={handleSubmit(submit)}
        className="rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.86)] p-6"
      >
        <h3 className="text-xl font-bold">Email Login</h3>
        <div className="mt-4 space-y-4">
          <label className="block">
            <span className="mb-1 block text-sm text-[var(--text-muted)]">Email</span>
            <input
              {...register('email')}
              type="email"
              className="w-full rounded-xl border border-[var(--line)] bg-[rgba(255,255,255,0.03)] px-3 py-2 outline-none focus:border-[var(--accent)]"
            />
            {formState.errors.email && <p className="mt-1 text-xs text-red-300">{formState.errors.email.message}</p>}
          </label>

          <label className="block">
            <span className="mb-1 block text-sm text-[var(--text-muted)]">Password</span>
            <input
              {...register('password')}
              type="password"
              className="w-full rounded-xl border border-[var(--line)] bg-[rgba(255,255,255,0.03)] px-3 py-2 outline-none focus:border-[var(--accent)]"
            />
            {formState.errors.password && (
              <p className="mt-1 text-xs text-red-300">{formState.errors.password.message}</p>
            )}
          </label>
        </div>

        <button
          type="submit"
          className="mt-5 w-full rounded-xl bg-[linear-gradient(90deg,#0bb0f5,#00d17f)] px-4 py-2 font-semibold text-slate-900"
        >
          Continue
        </button>
      </form>
    </section>
  )
}
