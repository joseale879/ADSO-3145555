import React, { useState } from 'react'
import UsuariosTab from './components/UsuariosTab'
import TareasTab from './components/TareasTab'
import AsignacionesTab from './components/AsignacionesTab'
import './App.css'

export default function App() {
  const [activeTab, setActiveTab] = useState('usuarios')

  return (
    <div className="app">
      <header className="header">
        <h1>📋 Gestión de Tareas</h1>
        <p>Sistema completo de gestión de usuarios, tareas y asignaciones</p>
      </header>

      <nav className="tabs-nav">
        <button
          className={`tab-button ${activeTab === 'usuarios' ? 'active' : ''}`}
          onClick={() => setActiveTab('usuarios')}
        >
          👥 Usuarios
        </button>
        <button
          className={`tab-button ${activeTab === 'tareas' ? 'active' : ''}`}
          onClick={() => setActiveTab('tareas')}
        >
          ✓ Tareas
        </button>
        <button
          className={`tab-button ${activeTab === 'asignaciones' ? 'active' : ''}`}
          onClick={() => setActiveTab('asignaciones')}
        >
          📌 Asignaciones
        </button>
      </nav>

      <main className="tab-content">
        {activeTab === 'usuarios' && <UsuariosTab />}
        {activeTab === 'tareas' && <TareasTab />}
        {activeTab === 'asignaciones' && <AsignacionesTab />}
      </main>

      <footer className="footer">
        <p>
          API Backend: <code>http://localhost:8080</code> |
          Frontend: <code>http://localhost:3000</code>
        </p>
      </footer>
    </div>
  )
}
