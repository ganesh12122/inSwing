import { useNavigate } from 'react-router-dom'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { BellOff, Trophy, UserPlus, RefreshCw, Gavel, Bell, CheckCheck } from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import { fetchNotifications, markNotificationRead, markAllRead } from '../lib/api/notifications'
import type { NotificationData } from '../lib/api/notifications'

function timeAgo(date: string) {
  const diff = Date.now() - new Date(date).getTime()
  const mins = Math.floor(diff / 60_000)
  if (mins < 1) return 'just now'
  if (mins < 60) return `${mins}m ago`
  const hrs = Math.floor(mins / 60)
  if (hrs < 24) return `${hrs}h ago`
  return `${Math.floor(hrs / 24)}d ago`
}

export function NotificationsPage() {
  const navigate = useNavigate()
  const queryClient = useQueryClient()

  const { data: notifications, isLoading } = useQuery({
    queryKey: ['notifications'],
    queryFn: () => fetchNotifications(),
  })

  const handleMarkAllRead = async () => {
    await markAllRead()
    queryClient.invalidateQueries({ queryKey: ['notifications'] })
  }

  const handleNotificationClick = async (n: NotificationData) => {
    if (n.status === 'unread') {
      await markNotificationRead(n.id)
      queryClient.invalidateQueries({ queryKey: ['notifications'] })
    }
    // Navigate based on notification data
    const matchId = n.data?.match_id as string | undefined
    if (matchId) {
      navigate(`/match/${matchId}/setup`)
    }
  }

  const unreadCount = notifications?.filter(n => n.status === 'unread').length ?? 0

  return (
    <div className="pb-8 pt-6 px-6 max-w-3xl mx-auto">
      <section className="mb-6 flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold text-[#dfe4dc]">Notifications</h2>
          <p className="text-sm text-[#becabc]">Match invites, requests & updates</p>
        </div>
        {unreadCount > 0 && (
          <button
            onClick={handleMarkAllRead}
            className="flex items-center gap-1.5 rounded-lg border border-[#3e4a3f] px-3 py-1.5 text-xs font-medium text-[#becabc] transition hover:border-emerald-700 hover:text-emerald-400"
          >
            <CheckCheck size={14} />
            Mark all read
          </button>
        )}
      </section>

      {isLoading && (
        <div className="flex justify-center py-10">
          <div className="h-6 w-6 animate-spin rounded-full border-2 border-emerald-500 border-t-transparent" />
        </div>
      )}

      {!isLoading && (!notifications || notifications.length === 0) && (
        <div className="rounded-xl border border-[#2a3a4a] bg-[#162029] p-10 text-center">
          <BellOff size={32} className="mx-auto mb-3 text-[#889488]" />
          <p className="text-sm font-medium text-[#becabc]">All caught up!</p>
          <p className="mt-1 text-xs text-[#889488]">
            Invites, match updates and friend requests will appear here.
          </p>
        </div>
      )}

      {!isLoading && notifications && notifications.length > 0 && (
        <div className="space-y-2">
          {notifications.map((n) => (
            <NotificationCard
              key={n.id}
              notification={n}
              onAction={() => handleNotificationClick(n)}
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
  notification: NotificationData
  onAction: () => void
}) {
  const iconMap: Record<string, LucideIcon> = {
    match_invitation: Trophy,
    match_update: RefreshCw,
    match_reminder: Bell,
    system: Gavel,
    achievement: UserPlus,
  }

  const Icon = iconMap[notification.type] ?? Bell

  return (
    <button
      onClick={onAction}
      className={`w-full rounded-xl border bg-[#162029] p-4 text-left transition hover:border-emerald-700 ${
        notification.status === 'unread' ? 'border-l-4 border-l-emerald-500 border-[#2a3a4a]' : 'border-[#2a3a4a]'
      }`}
    >
      <div className="flex gap-3">
        <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[#1b211c] border border-[#3e4a3f]">
          <Icon size={18} className="text-emerald-500" />
        </div>
        <div className="flex-1 min-w-0">
          <p className="text-sm font-bold text-[#dfe4dc]">{notification.title}</p>
          <p className="mt-0.5 text-xs text-[#becabc]">{notification.message}</p>
          <p className="mt-1 text-[10px] text-[#889488]">{timeAgo(notification.created_at)}</p>
        </div>
      </div>

      {notification.type === 'match_invitation' && notification.status === 'unread' && (
        <div className="mt-3 flex gap-2 pl-[52px]">
          <span className="rounded-lg bg-[#1B8A4A] px-3 py-1.5 text-xs font-semibold text-white">
            View Match
          </span>
        </div>
      )}
    </button>
  )
}
