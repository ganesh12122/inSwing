export function DashboardPage() {
  return (
    <section className="grid gap-4 md:grid-cols-3">
      <article className="rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.8)] p-5">
        <p className="text-xs uppercase tracking-[0.18em] text-[var(--accent)]">Live Operations</p>
        <h3 className="mt-2 text-2xl font-extrabold">0 Live Matches</h3>
      </article>
      <article className="rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.8)] p-5">
        <p className="text-xs uppercase tracking-[0.18em] text-[var(--accent)]">Career Insights</p>
        <h3 className="mt-2 text-2xl font-extrabold">Player Stats Hub</h3>
      </article>
      <article className="rounded-2xl border border-[var(--line)] bg-[rgba(8,20,31,0.8)] p-5">
        <p className="text-xs uppercase tracking-[0.18em] text-[var(--accent)]">Spectator Reach</p>
        <h3 className="mt-2 text-2xl font-extrabold">Share Live Link</h3>
      </article>
    </section>
  )
}
