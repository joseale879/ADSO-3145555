import React, { useState, useEffect } from 'react'
import { usuariosAPI, tareasAPI, asignacionesAPI } from '../services/api'
import './AsignacionesTab.css'

export default function AsignacionesTab() {
  const [usuarios, setUsuarios] = useState([])
  const [tareas, setTareas] = useState([])
  const [asignaciones, setAsignaciones] = useState([])
  const [loading, setLoading] = useState(false)
  const [selectedUsuario, setSelectedUsuario] = useState('')
  const [selectedTarea, setSelectedTarea] = useState('')
  const [vistaActiva, setVistaActiva] = useState('asignar') // 'asignar', 'usuario', 'tarea'
  const [usuarioSeleccionado, setUsuarioSeleccionado] = useState('')
  const [tareaSeleccionada, setTareaSeleccionada] = useState('')

  useEffect(() => {
    cargarDatos()
  }, [])

  const cargarDatos = async () => {
    setLoading(true)
    try {
      const [usersRes, tareasRes] = await Promise.all([
        usuariosAPI.getAll(),
        tareasAPI.getAll()
      ])
      setUsuarios(usersRes.data)
      setTareas(tareasRes.data)
    } catch (error) {
      console.error('Error cargando datos:', error)
      alert('Error al cargar datos')
    } finally {
      setLoading(false)
    }
  }

  const handleAsignar = async (e) => {
    e.preventDefault()
    if (!selectedUsuario || !selectedTarea) {
      alert('Selecciona usuario y tarea')
      return
    }

    try {
      await asignacionesAPI.asignar({
        usuarioId: selectedUsuario,
        tareaId: selectedTarea
      })
      alert('¡Tarea asignada!')
      setSelectedUsuario('')
      setSelectedTarea('')
      cargarAsignacionesUsuario(selectedUsuario)
    } catch (error) {
      console.error('Error:', error)
      alert('Error al asignar tarea')
    }
  }

  const cargarAsignacionesUsuario = async (usuarioId) => {
    try {
      const { data } = await asignacionesAPI.getTareasDeUsuario(usuarioId)
      setAsignaciones(data)
      setVistaActiva('usuario')
      setUsuarioSeleccionado(usuarioId)
    } catch (error) {
      console.error('Error:', error)
    }
  }

  const cargarAsignacionesTarea = async (tareaId) => {
    try {
      const { data } = await asignacionesAPI.getUsuariosDeTarea(tareaId)
      setAsignaciones(data)
      setVistaActiva('tarea')
      setTareaSeleccionada(tareaId)
    } catch (error) {
      console.error('Error:', error)
    }
  }

  const handleDesasignar = async (usuarioId, tareaId) => {
    if (window.confirm('¿Desasignar tarea?')) {
      try {
        await asignacionesAPI.desasignar(usuarioId, tareaId)
        if (vistaActiva === 'usuario' && usuarioSeleccionado) {
          cargarAsignacionesUsuario(usuarioSeleccionado)
        } else if (vistaActiva === 'tarea' && tareaSeleccionada) {
          cargarAsignacionesTarea(tareaSeleccionada)
        }
      } catch (error) {
        alert('Error al desasignar')
      }
    }
  }

  const obtenerNombreUsuario = (id) => {
    const user = usuarios.find(u => u.usuarioId === id)
    return user ? user.nombre : 'Usuario desconocido'
  }

  const obtenerTitulo = (id) => {
    const tarea = tareas.find(t => t.tareaId === id)
    return tarea ? tarea.titulo : 'Tarea desconocida'
  }

  return (
    <div className="tab-container">
      <h2>📌 Asignaciones - Usuario a Tarea</h2>

      <div className="asignaciones-nav">
        <button
          className={`nav-button ${vistaActiva === 'asignar' ? 'active' : ''}`}
          onClick={() => setVistaActiva('asignar')}
        >
          ➕ Asignar Nueva
        </button>
        <button
          className={`nav-button ${vistaActiva === 'usuario' ? 'active' : ''}`}
          onClick={() => setVistaActiva('usuario')}
        >
          👤 Ver por Usuario
        </button>
        <button
          className={`nav-button ${vistaActiva === 'tarea' ? 'active' : ''}`}
          onClick={() => setVistaActiva('tarea')}
        >
          ✓ Ver por Tarea
        </button>
      </div>

      {loading ? (
        <p className="loading">Cargando...</p>
      ) : (
        <>
          {vistaActiva === 'asignar' && (
            <form onSubmit={handleAsignar} className="form-container">
              <div className="form-group">
                <label>Seleccionar Usuario</label>
                <select
                  value={selectedUsuario}
                  onChange={(e) => setSelectedUsuario(e.target.value)}
                  required
                >
                  <option value="">-- Elige un usuario --</option>
                  {usuarios.map((user) => (
                    <option key={user.usuarioId} value={user.usuarioId}>
                      {user.nombre} ({user.email})
                    </option>
                  ))}
                </select>
              </div>

              <div className="form-group">
                <label>Seleccionar Tarea</label>
                <select
                  value={selectedTarea}
                  onChange={(e) => setSelectedTarea(e.target.value)}
                  required
                >
                  <option value="">-- Elige una tarea --</option>
                  {tareas.map((tarea) => (
                    <option key={tarea.tareaId} value={tarea.tareaId}>
                      {tarea.titulo}
                    </option>
                  ))}
                </select>
              </div>

              <button type="submit" className="btn-submit">
                🔗 Asignar Tarea
              </button>
            </form>
          )}

          {vistaActiva === 'usuario' && (
            <div className="vista-container">
              <div className="selector-group">
                <label>Seleccionar Usuario</label>
                <select
                  value={usuarioSeleccionado}
                  onChange={(e) => {
                    const id = e.target.value
                    setUsuarioSeleccionado(id)
                    if (id) cargarAsignacionesUsuario(id)
                  }}
                >
                  <option value="">-- Elige un usuario --</option>
                  {usuarios.map((user) => (
                    <option key={user.usuarioId} value={user.usuarioId}>
                      {user.nombre}
                    </option>
                  ))}
                </select>
              </div>

              {usuarioSeleccionado && (
                <div className="asignaciones-list">
                  <h3>Tareas de {obtenerNombreUsuario(usuarioSeleccionado)}</h3>
                  {asignaciones.length === 0 ? (
                    <p className="empty">Sin tareas asignadas</p>
                  ) : (
                    <div className="taretas-grid">
                      {asignaciones.map((asig) => (
                        <div key={`${asig.usuarioId}-${asig.tareaId}`} className="tarea-item">
                          <div className="tarea-info">
                            <h4>{asig.tarea.titulo}</h4>
                            <p>{asig.tarea.descripcion}</p>
                            <span className="estado">{asig.tarea.estado}</span>
                          </div>
                          <button
                            onClick={() =>
                              handleDesasignar(asig.usuarioId, asig.tareaId)
                            }
                            className="btn-delete"
                          >
                            ❌ Desasignar
                          </button>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </div>
          )}

          {vistaActiva === 'tarea' && (
            <div className="vista-container">
              <div className="selector-group">
                <label>Seleccionar Tarea</label>
                <select
                  value={tareaSeleccionada}
                  onChange={(e) => {
                    const id = e.target.value
                    setTareaSeleccionada(id)
                    if (id) cargarAsignacionesTarea(id)
                  }}
                >
                  <option value="">-- Elige una tarea --</option>
                  {tareas.map((tarea) => (
                    <option key={tarea.tareaId} value={tarea.tareaId}>
                      {tarea.titulo}
                    </option>
                  ))}
                </select>
              </div>

              {tareaSeleccionada && (
                <div className="asignaciones-list">
                  <h3>Usuarios asignados a "{obtenerTitulo(tareaSeleccionada)}"</h3>
                  {asignaciones.length === 0 ? (
                    <p className="empty">Sin usuarios asignados</p>
                  ) : (
                    <div className="usuarios-grid">
                      {asignaciones.map((asig) => (
                        <div key={`${asig.usuarioId}-${asig.tareaId}`} className="usuario-item">
                          <div className="usuario-info">
                            <h4>{asig.usuario.nombre}</h4>
                            <p>{asig.usuario.email}</p>
                          </div>
                          <button
                            onClick={() =>
                              handleDesasignar(asig.usuarioId, asig.tareaId)
                            }
                            className="btn-delete"
                          >
                            ❌ Desasignar
                          </button>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </div>
          )}
        </>
      )}
    </div>
  )
}
