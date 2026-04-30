import { useNavigate } from 'react-router-dom'

interface Notification {
  id: string
  type: 'match_invite' | 'friend_request' | 'match_update' | 'rules_proposed'
  title: string
  body: string
  time: string
  unread: boolean
  matchId?: string
}

// Placeholder data — will be replaced with real API
const mockNotifications: Notification[] = []

export function NotificationsPage() {
  const navigate = useNavigate()

  return (
    <div className="pb-8 pt-6 px-4 max-w-md mx-auto">
      <section className="mb-6">
        <h2 className="text-2xl font-bold text-[#dfe4dc]">Notifications</h2>
        <p className="text-sm text-[#becabc]">Match invites, requests & updates</p>
      </section>

      {mockNotifications.length === 0 && (
        <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-10 text-center">
          <span className="material-symbols-outlined mb-3 text-4xl text-[#889488]">notifications_none</span>
          <p className="text-sm font-medium text-[#becabc]">All caught up!</p>
          <p className="mt-1 text-xs text-[#889488]">
            Invites, match updates and friend requests will appear here.
          </p>
        </div>
      )}

      {mockNotifications.length > 0 && (
        <div className="space-y-2">
          {mockNotifications.map((n) => (
            <NotificationCard
              key={n.id}
              notification={n}
              onAction={() => {
                if (n.matchId) navigate(`/match/${n.matchId}/setup`)
              }}
            />
          ))}
        </div>
      )}
    </div>
  )
}

function NotificationCard({
  notification,
  onAction,
}: {
  notification: Notification
  onAction: () => void
}) {
  const iconMap: Record<Notification['type'], string> = {
    match_invite: 'sports_cricket',
    friend_request: 'person_add',
    match_update: 'update',
    rules_proposed: 'gavel',
  }

  return (
    <button
      onClick={onAction}
      className={`w-full rounded-xl border bg-[#162029] p-4 text-left transition hover:border-emerald-700 ${
        notification.unread ? 'border-l-4 border-l-emerald-500 border-[#2a3a4a]' : 'border-[#2a3a4a]'
      }`}
    >
      <div className="flex gap-3">
        <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[#1b211c] border border-[#3e4a3f]">
          <span className="material-symbols-outlined text-emerald-500 text-xl">
            {iconMap[notification.type]}
          </span>
        </div>
        <div className="flex-1 min-w-0">
          <p className="text-sm font-bold text-[#dfe4dc]">{notification.title}</p>
          <p className="mt-0.5 text-xs text-[#becabc] truncate">{notification.body}</p>
          <p className="mt-1 text-[10px] text-[#889488]">{notification.time}</p>
        </div>
      </div>

      {notification.type === 'match_invite' && (
        <div className="mt-3 flex gap-2 pl-[52px]">
          <span className="rounded-lg bg-[#1B8A4A] px-3 py-1.5 text-xs font-semibold text-white">
            Accept
          </span>
          <span className="rounded-lg border border-[#3e4a3f] px-3 py-1.5 text-xs font-semibold text-[#becabc]">
            Decline
          </span>
        </div>
      )}
    </button>
  )
}
