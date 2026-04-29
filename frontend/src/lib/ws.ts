import { ENV } from './env'

type MessageHandler = (data: Record<string, unknown>) => void

/**
 * Lightweight WebSocket client for real-time match updates.
 *
 * Authenticated usage:
 *   const ws = createMatchSocket(token)
 *   ws.subscribe(matchId)
 *   ws.onBallUpdate(handler)
 *
 * Public viewer (no auth):
 *   const ws = createPublicMatchSocket(matchId)
 *   ws.onBallUpdate(handler)
 */
export function createMatchSocket(token: string) {
  const base = ENV.apiBaseUrl.replace(/^http/, 'ws').replace(/\/api\/v1$/, '')
  const ws = new WebSocket(`${base}/api/v1/ws/ws/${token}`)

  const handlers: Record<string, MessageHandler[]> = {}

  ws.onmessage = (event) => {
    try {
      const msg = JSON.parse(event.data)
      const type = msg.type as string
      handlers[type]?.forEach((fn) => fn(msg))
    } catch { /* ignore malformed messages */ }
  }

  const on = (type: string, handler: MessageHandler) => {
    if (!handlers[type]) handlers[type] = []
    handlers[type].push(handler)
  }

  const send = (payload: Record<string, unknown>) => {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify(payload))
    }
  }

  // Keep-alive ping every 25s
  const pingInterval = setInterval(() => send({ type: 'ping' }), 25_000)

  return {
    raw: ws,
    subscribe(matchId: string) {
      send({ type: 'subscribe_match', match_id: matchId })
    },
    unsubscribe(matchId: string) {
      send({ type: 'unsubscribe_match', match_id: matchId })
    },
    sendBallUpdate(matchId: string, ballData: Record<string, unknown>) {
      send({ type: 'ball_update', match_id: matchId, ball_data: ballData })
    },
    onBallUpdate(handler: MessageHandler) {
      on('ball_update', handler)
    },
    onMatchStatus(handler: MessageHandler) {
      on('match_status_update', handler)
    },
    onConnected(handler: MessageHandler) {
      on('connection_established', handler)
    },
    close() {
      clearInterval(pingInterval)
      ws.close()
    },
  }
}

export function createPublicMatchSocket(matchId: string) {
  const base = ENV.apiBaseUrl.replace(/^http/, 'ws').replace(/\/api\/v1$/, '')
  const ws = new WebSocket(`${base}/api/v1/ws/public/${matchId}`)

  const handlers: Record<string, MessageHandler[]> = {}

  ws.onmessage = (event) => {
    try {
      const msg = JSON.parse(event.data)
      const type = msg.type as string
      handlers[type]?.forEach((fn) => fn(msg))
    } catch { /* ignore */ }
  }

  const on = (type: string, handler: MessageHandler) => {
    if (!handlers[type]) handlers[type] = []
    handlers[type].push(handler)
  }

  const pingInterval = setInterval(() => {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify({ type: 'ping' }))
    }
  }, 25_000)

  return {
    raw: ws,
    onBallUpdate(handler: MessageHandler) {
      on('ball_update', handler)
    },
    onMatchStatus(handler: MessageHandler) {
      on('match_status_update', handler)
    },
    onConnected(handler: MessageHandler) {
      on('connection_established', handler)
    },
    close() {
      clearInterval(pingInterval)
      ws.close()
    },
  }
}
