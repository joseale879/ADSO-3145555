import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080'

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
})

export const usuariosAPI = {
  getAll: () => api.get('/api/usuarios'),
  getById: (id) => api.get(`/api/usuarios/${id}`),
  create: (data) => api.post('/api/usuarios', data),
  update: (id, data) => api.put(`/api/usuarios/${id}`, data),
  delete: (id) => api.delete(`/api/usuarios/${id}`)
}

export const tareasAPI = {
  getAll: () => api.get('/api/tareas'),
  getById: (id) => api.get(`/api/tareas/${id}`),
  create: (data) => api.post('/api/tareas', data),
  update: (id, data) => api.put(`/api/tareas/${id}`, data),
  delete: (id) => api.delete(`/api/tareas/${id}`)
}

export const asignacionesAPI = {
  getAll: () => api.get('/api/asignaciones'),
  asignar: (data) => api.post('/api/asignaciones', data),
  desasignar: (usuarioId, tareaId) => api.delete(`/api/asignaciones?usuarioId=${usuarioId}&tareaId=${tareaId}`),
  getTareasDeUsuario: (usuarioId) => api.get(`/api/asignaciones/usuario/${usuarioId}`),
  getUsuariosDeTarea: (tareaId) => api.get(`/api/asignaciones/tarea/${tareaId}`)
}

export default api
