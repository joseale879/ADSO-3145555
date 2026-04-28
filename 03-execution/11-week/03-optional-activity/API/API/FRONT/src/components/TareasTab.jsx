import React, { useState, useEffect } from 'react'
import { tareasAPI } from '../services/api'
import './TareasTab.css'

export default function TareasTab() {
  const [tareas, setTareas] = useState([])
  const [loading, setLoading] = useState(false)
  const [form, setForm] = useState({ titulo: '', descripcion: '', estado: 'PENDIENTE' })
  const [editingId, setEditingId] = useState(null)

  const estados = ['PENDIENTE', 'EN_PROGRESO', 'COMPLETADA']

  useEffect(() => {
    cargarTareas()
  }, [])

  const cargarTareas = async () => {
    setLoading(true)
    try {
      const { data } = await tareasAPI.getAll()
      setTareas(data)
    } catch (error) {
      console.error('Error cargando tareas:', error)
      alert('Error al cargar tareas')
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!form.titulo) {
      alert('El título es requerido')
      return
    }

    try {
      if (editingId) {
        await tareasAPI.update(editingId, form)
        alert('Tarea actualizada')
        setEditingId(null)
      } else {
        await tareasAPI.create(form)
        alert('Tarea creada')
      }
      setForm({ titulo: '', descripcion: '', estado: 'PENDIENTE' })
      cargarTareas()
    } catch (error) {
      console.error('Error:', error)
      alert('Error al guardar tarea')
    }
  }

  const handleDelete = async (id) => {
    if (window.confirm('¿Eliminar tarea?')) {
      try {
        await tareasAPI.delete(id)
        cargarTareas()
      } catch (error) {
        alert('Error al eliminar')
      }
    }
  }

  const handleEdit = (tarea) => {
    setForm({
      titulo: tarea.titulo,
      descripcion: tarea.descripcion,
      estado: tarea.estado
    })
    setEditingId(tarea.tareaId)
  }

  const getEstadoColor = (estado) => {
    switch (estado) {
      case 'PENDIENTE':
        return '#ff9800'
      case 'EN_PROGRESO':
        return '#2196f3'
      case 'COMPLETADA':
        return '#4caf50'
      default:
        return '#9e9e9e'
    }
  }

  return (
    <div className="tab-container">
      <h2>Gestión de Tareas</h2>

      <form onSubmit={handleSubmit} className="form-container">
        <input
          type="text"
          placeholder="Título"
          value={form.titulo}
          onChange={(e) => setForm({ ...form, titulo: e.target.value })}
          required
        />
        <textarea
          placeholder="Descripción"
          value={form.descripcion}
          onChange={(e) => setForm({ ...form, descripcion: e.target.value })}
          rows="3"
        ></textarea>
        <select
          value={form.estado}
          onChange={(e) => setForm({ ...form, estado: e.target.value })}
        >
          {estados.map((estado) => (
            <option key={estado} value={estado}>
              {estado}
            </option>
          ))}
        </select>
        <button type="submit">{editingId ? 'Actualizar' : 'Crear'}</button>
        {editingId && (
          <button
            type="button"
            onClick={() => {
              setForm({ titulo: '', descripcion: '', estado: 'PENDIENTE' })
              setEditingId(null)
            }}
            className="btn-cancel"
          >
            Cancelar
          </button>
        )}
      </form>

      {loading ? (
        <p className="loading">Cargando...</p>
      ) : (
        <div className="list-container">
          {tareas.length === 0 ? (
            <p className="empty">No hay tareas</p>
          ) : (
            <div className="tareas-grid">
              {tareas.map((tarea) => (
                <div key={tarea.tareaId} className="tarea-card">
                  <div
                    className="tarea-status"
                    style={{ backgroundColor: getEstadoColor(tarea.estado) }}
                  >
                    {tarea.estado}
                  </div>
                  <h3>{tarea.titulo}</h3>
                  <p>{tarea.descripcion}</p>
                  <small>{new Date(tarea.createdAt).toLocaleDateString()}</small>
                  <div className="card-actions">
                    <button
                      onClick={() => handleEdit(tarea)}
                      className="btn-edit"
                    >
                      ✏️
                    </button>
                    <button
                      onClick={() => handleDelete(tarea.tareaId)}
                      className="btn-delete"
                    >
                      🗑️
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  )
}
