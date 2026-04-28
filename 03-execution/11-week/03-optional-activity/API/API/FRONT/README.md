# Gestión de Tareas - Frontend React

Sistema completo de gestión de usuarios y tareas con React, conectado a un backend Spring Boot.

## 🚀 Características

- ✅ Gestión de Usuarios (CRUD)
- ✅ Gestión de Tareas (CRUD)
- ✅ Integración con API REST del backend
- ✅ Interfaz moderna y responsiva
- ✅ Validación de formularios
- ✅ Estados de tareas (PENDIENTE, EN_PROGRESO, COMPLETADA)

## 🛠️ Stack Tecnológico

- **React 18** - Framework UI
- **Vite** - Build tool y dev server
- **Axios** - Cliente HTTP
- **CSS3** - Estilos responsivos

## 📦 Instalación Local

### Prerequisitos
- Node.js 16+
- npm o yarn

### Pasos

```bash
cd FRONT
npm install
npm run dev
```

La aplicación abrirá en `http://localhost:5173`

## 🐳 Ejecución con Docker

### Desde Docker Compose (Recomendado)

```bash
cd ..
docker compose up -d --build
```

Accede a:
- 🌐 **Frontend**: http://localhost:3000
- 📡 **Backend**: http://localhost:8080
- 📚 **Swagger**: http://localhost:8080/swagger-ui.html

### Build Docker Manual

```bash
docker build -t tareas-frontend .
docker run -p 3000:3000 tareas-frontend
```

## 📁 Estructura del Proyecto

```
FRONT/
├── src/
│   ├── components/
│   │   ├── UsuariosTab.jsx      # Componente de gestión de usuarios
│   │   ├── UsuariosTab.css
│   │   ├── TareasTab.jsx        # Componente de gestión de tareas
│   │   └── TareasTab.css
│   ├── services/
│   │   └── api.js               # Cliente HTTP (Axios)
│   ├── App.jsx                  # Componente principal
│   ├── App.css
│   └── main.jsx
├── public/                      # Archivos estáticos
├── package.json
├── vite.config.js
├── Dockerfile
└── README.md
```

## 🔌 API Integration

La aplicación se conecta al backend usando `axios`:

```javascript
const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080'
```

### Endpoints utilizados

**Usuarios:**
- GET `/api/usuarios` - Obtener todos
- GET `/api/usuarios/{id}` - Obtener uno
- POST `/api/usuarios` - Crear
- PUT `/api/usuarios/{id}` - Actualizar
- DELETE `/api/usuarios/{id}` - Eliminar

**Tareas:**
- GET `/api/tareas` - Obtener todas
- GET `/api/tareas/{id}` - Obtener una
- POST `/api/tareas` - Crear
- PUT `/api/tareas/{id}` - Actualizar
- DELETE `/api/tareas/{id}` - Eliminar

## 🎨 Estilos

- Paleta de colores: Púrpura (#667eea) y Rosa (#764ba2)
- Diseño responsivo (mobile-first)
- Transiciones suaves
- Interfaz intuitiva

## 📱 Responsividad

La aplicación es completamente responsiva y funciona en:
- Desktop (1920px+)
- Tablet (768px - 1024px)
- Móvil (< 768px)

## 🚀 Desarrollo

### Modo Desarrollo

```bash
npm run dev
```

### Build Producción

```bash
npm run build
```

### Preview

```bash
npm run preview
```

## 🔄 Flujo de Datos

1. Usuario interactúa con la UI
2. Componente React envía solicitud HTTP a través de Axios
3. Backend (Spring Boot) procesa la solicitud
4. Base de datos (PostgreSQL) almacena/recupera datos
5. Respuesta regresa al frontend y actualiza el estado

## ✨ Mejoras Futuras

- [ ] Asignación de tareas a usuarios
- [ ] Sistema de autenticación
- [ ] Notificaciones en tiempo real
- [ ] Filtros y búsqueda avanzada
- [ ] Temas oscuro/claro
- [ ] Exportación de datos

## 📝 License

Proyecto personal para gestión de tareas.

---

**¿Preguntas?** Revisa el backend en `/BACKEND` o contáctame.
