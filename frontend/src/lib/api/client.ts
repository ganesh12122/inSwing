import axios from 'axios'
import { ENV } from '../env'

export const apiClient = axios.create({
  baseURL: ENV.apiBaseUrl,
  timeout: 15_000,
  headers: {
    'Content-Type': 'application/json',
  },
})

apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('inswing_access_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})
