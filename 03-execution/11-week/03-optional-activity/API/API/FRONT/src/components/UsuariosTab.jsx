import React, { useState, useEffect } from 'react'
import { usuariosAPI } from '../services/api'
import './UsuariosTab.css'

export default function UsuariosTab() {
  const [usuarios, setUsuarios] = useState([])
  const [loading, setLoading] = useState(false)
  const [form, setForm] = useState({ nombre: '', email: '' })
  const [editingId, setEditingId] = useState(null)

  useEffect(() => {
    cargarUsuarios()
  }, [])

  const cargarUsuarios = async () => {
    setLoading(true)
    try {
      const { data } = await usuariosAPI.getAll()
      setUsuarios(data)
    } catch (error) {
      console.error('Error cargando usuarios:', error)
      alert('Error al cargar usuarios')
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!form.nombre || !form.email) {
      alert('Completa todos los campos')
      return
    }

    try {
      if (editingId) {
        await usuariosAPI.update(editingId, form)
        alert('Usuario actualizado')
        setEditingId(null)
      } else {
        await usuariosAPI.create(form)
        alert('Usuario creado')
      }
      setForm({ nombre: '', email: '' })
      cargarUsuarios()
    } catch (error) {
      console.error('Error:', error)
      alert('Error al guardar usuario')
    }
  }

  const handleDelete = async (id) => {
    if (window.confirm('¿Eliminar usuario?')) {
      try {
        await usuariosAPI.delete(id)
        cargarUsuarios()
      } catch (error) {
        alert('Error al eliminar')
      }
    }
  }

  const handleEdit = (usuario) => {
    setForm({ nombre: usuario.nombre, email: usuario.email })
    setEditingId(usuario.usuarioId)
  }

  return (
    <div className="tab-container">
      <h2>Gestión de Usuarios</h2>

      <form onSubmit={handleSubmit} className="form-container">
        <input
          type="text"
          placeholder="Nombre"
          value={form.nombre}
          onChange={(e) => setForm({ ...form, nombre: e.target.value })}
          required
        />
        <input
          type="email"
          placeholder="Email"
          value={form.email}
          onChange={(e) => setForm({ ...form, email: e.target.value })}
          required
        />
        <button type="submit">{editingId ? 'Actualizar' : 'Crear'}</button>
        {editingId && (
          <button
            type="button"
            onClick={() => {
              setForm({ nombre: '', email: '' })
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
          {usuarios.length === 0 ? (
            <p className="empty">No hay usuarios</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Nombre</th>
                  <th>Email</th>
                  <th>Creado</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                {usuarios.map((usuario) => (
                  <tr key={usuario.usuarioId}>
                    <td>{usuario.nombre}</td>
                    <td>{usuario.email}</td>
                    <td>{new Date(usuario.createdAt).toLocaleDateString()}</td>
                    <td className="actions">
                      <button
                        onClick={() => handleEdit(usuario)}
                        className="btn-edit"
                      >
                        ✏️
                      </button>
                      <button
                        onClick={() => handleDelete(usuario.usuarioId)}
                        className="btn-delete"
                      >
                        🗑️
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      )}
    </div>
  )
}
