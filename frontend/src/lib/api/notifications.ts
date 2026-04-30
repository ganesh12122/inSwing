import { apiClient } from './client'

export interface NotificationData {
  id: string
  user_id: string
  title: string
  message: string
  type: 'match_invitation' | 'match_update' | 'match_reminder' | 'system' | 'achievement'
  data: Record<string, unknown> | null
  priority: 'low' | 'medium' | 'high'
  status: 'unread' | 'read'
  read_at: string | null
  expires_at: string | null
  created_at: string
  updated_at: string
}

export async function fetchNotifications(statusFilter?: 'unread' | 'read'): Promise<NotificationData[]> {
  const params: Record<string, string> = {}
  if (statusFilter) params.status_filter = statusFilter
  const { data } = await apiClient.get<NotificationData[]>('/notifications/', { params })
  return data
}

export async function getUnreadCount(): Promise<number> {
  const { data } = await apiClient.get<{ unread_count: number }>('/notifications/unread-count')
  return data.unread_count
}

export async function markNotificationRead(notificationId: string): Promise<void> {
  await apiClient.put(`/notifications/${notificationId}/read`)
}

export async function markAllRead(): Promise<void> {
  await apiClient.put('/notifications/mark-all-read')
}
