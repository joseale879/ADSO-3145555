# 📋 Sistema de Gestión de Tareas - Full Stack

Sistema completo para gestión de usuarios y tareas con **React** (frontend) + **Spring Boot** (backend) + **PostgreSQL** (BD), completamente **containerizado con Docker**.

## 🏗️ Arquitectura Completa

```
┌─────────────────────────┐
│   React App (Vite)      │ (puerto 3000)
│   - UsuariosTab         │
│   - TareasTab           │
│   - AsignacionesTab     │
└────────────┬────────────┘
             │ HTTP (Axios)
             ↓
┌─────────────────────────────────────────┐
│      Spring Boot 3.5 (Java 21)          │ (puerto 8080)
│   ┌─────────────────────────────────┐   │
│   │  Controllers (DTOs)             │   │
│   │  - UsuarioController            │   │
│   │  - TareaController              │   │
│   │  - UsuarioTareaController       │   │
│   └──────────────┬──────────────────┘   │
│                  │                       │
│   ┌──────────────▼──────────────────┐   │
│   │  Services (Lógica de Negocio)  │   │
│   │  - UsuarioService              │   │
│   │  - TareaService                │   │
│   │  - UsuarioTareaService         │   │
│   └──────────────┬──────────────────┘   │
│                  │                       │
│   ┌──────────────▼──────────────────┐   │
│   │  Repositories (JPA)             │   │
│   │  - UsuarioRepository            │   │
│   │  - TareaRepository              │   │
│   │  - UsuarioTareaRepository       │   │
│   └──────────────┬──────────────────┘   │
│                  │ JDBC                  │
└──────────────────┼──────────────────────┘
                   ↓
┌─────────────────────────┐
│   PostgreSQL 15         │ (puerto 5432)
│   - usuario             │
│   - tarea               │
│   - usuario_tarea       │
└─────────────────────────┘
```

## 🚀 Inicio Rápido

### Opción 1: Docker Compose (Recomendado) ⭐

Todo se levanta en un comando:

```bash
docker compose up -d --build
```

Accede a:
- 🌐 **Frontend**: http://localhost:3000
- 📡 **Backend API**: http://localhost:8080/api
- 📚 **Swagger Docs**: http://localhost:8080/swagger-ui.html
- 🗄️ **PostgreSQL**: localhost:5432

### Opción 2: Desarrollo Local

#### Backend (Spring Boot)

```bash
cd BACKEND
mvn spring-boot:run
```

#### Frontend (React)

```bash
cd FRONT
npm install
npm run dev
```

#### Base de Datos

```bash
docker compose up -d db
```

## 📁 Estructura del Proyecto

```
API/
├── docker-compose.yml                  # Orquestación de servicios
├── README.md                           # Este archivo
│
├── BACKEND/                            # Spring Boot + Java 21
│   ├── src/main/java/com/tareas/backend/
│   │   ├── controller/                 # API REST Controllers
│   │   │   ├── UsuarioController.java
│   │   │   ├── TareaController.java
│   │   │   └── UsuarioTareaController.java
│   │   │
│   │   ├── service/                    # Lógica de negocio
│   │   │   ├── UsuarioService.java
│   │   │   ├── TareaService.java
│   │   │   └── UsuarioTareaService.java
│   │   │
│   │   ├── repository/                 # Acceso a datos (JPA)
│   │   │   ├── UsuarioRepository.java
│   │   │   ├── TareaRepository.java
│   │   │   └── UsuarioTareaRepository.java
│   │   │
│   │   ├── model/                      # Entidades JPA
│   │   │   ├── Usuario.java
│   │   │   ├── Tarea.java
│   │   │   └── UsuarioTarea.java
│   │   │
│   │   ├── dto/                        # Data Transfer Objects ✨ NUEVO
│   │   │   ├── UsuarioRequestDTO.java     (validaciones)
│   │   │   ├── UsuarioResponseDTO.java
│   │   │   ├── TareaRequestDTO.java
│   │   │   ├── TareaResponseDTO.java
│   │   │   ├── AsignacionRequestDTO.java
│   │   │   └── AsignacionResponseDTO.java
│   │   │
│   │   └── BackendApplication.java    # Main class
│   │
│   ├── src/main/resources/
│   │   └── application.properties      # Configuración
│   ├── pom.xml
│   ├── Dockerfile
│   ├── mvnw / mvnw.cmd
│   └── HELP.md
│
├── FRONT/                              # React + Vite
│   ├── src/
│   │   ├── components/
│   │   │   ├── UsuariosTab.jsx        # CRUD Usuarios
│   │   │   ├── TareasTab.jsx          # CRUD Tareas
│   │   │   ├── AsignacionesTab.jsx    # Asignar tareas
│   │   │   ├── UsuariosTab.css
│   │   │   ├── TareasTab.css
│   │   │   └── AsignacionesTab.css
│   │   │
│   │   ├── services/
│   │   │   └── api.js                 # Cliente HTTP (Axios)
│   │   │
│   │   ├── App.jsx
│   │   ├── App.css
│   │   └── main.jsx
│   │
│   ├── public/
│   ├── package.json
│   ├── vite.config.js
│   ├── Dockerfile
│   ├── install.bat
│   └── README.md
│
└── LIQUIBASE/                          # Migraciones de Base de Datos
    ├── changelog.yml                   # Archivo principal
    ├── CHANGES/
    │   ├── DDL/                        # Data Definition Language
    │   │   ├── 00_EXTENCIONS/
    │   │   │   └── extencion.sql       # pgcrypto
    │   │   └── 01_TABLES/
    │   │       └── 01-ddl-tables.sql   # CREATE TABLES
    │   └── DML/                        # Data Manipulation Language
    │       └── 00-INSERTS/
    │           └── 02-dml-tables.sql   # INSERT inicial
    │
    ├── ROLLBACKS/
    │   ├── DDL/
    │   │   └── 00_TABLES/
    │   │       └── 01-drop-tables.sql
    │   └── DML/
    │       └── 00_INSERTS/
    │           └── 02-drop-data.sql
    │
    ├── DRIVERS/
    └── README.md
```

## 🛑 Detener los Servicios

```bash
docker compose down
```

Para eliminar también volúmenes (elimina datos):

```bash
docker compose down -v
```

## 📊 Endpoints de la API

### Usuarios

```
GET    /api/usuarios                    # Obtener todos
POST   /api/usuarios                    # Crear nuevo
GET    /api/usuarios/{id}               # Obtener por ID
PUT    /api/usuarios/{id}               # Actualizar
DELETE /api/usuarios/{id}               # Eliminar
```

**Request (POST/PUT):**
```json
{
  "nombre": "Juan Pérez",
  "email": "juan@example.com"
}
```

**Response (GET/POST):**
```json
{
  "usuarioId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
  "nombre": "Juan Pérez",
  "email": "juan@example.com",
  "createdAt": "2026-04-27T14:30:00"
}
```

### Tareas

```
GET    /api/tareas                      # Obtener todas
POST   /api/tareas                      # Crear nueva
GET    /api/tareas/{id}                 # Obtener por ID
PUT    /api/tareas/{id}                 # Actualizar
DELETE /api/tareas/{id}                 # Eliminar
```

**Request (POST/PUT):**
```json
{
  "titulo": "Implementar autenticación",
  "descripcion": "Agregar JWT al backend",
  "estado": "PENDIENTE"
}
```

**Response (GET/POST):**
```json
{
  "tareaId": "f47ac10b-58cc-4372-a567-0e02b2c3d480",
  "titulo": "Implementar autenticación",
  "descripcion": "Agregar JWT al backend",
  "estado": "PENDIENTE",
  "createdAt": "2026-04-27T14:30:00"
}
```

### Asignaciones (Usuario-Tarea)

```
POST   /api/asignaciones                          # Asignar tarea
DELETE /api/asignaciones?usuarioId=...&tareaId=.. # Desasignar
GET    /api/asignaciones/usuario/{usuarioId}     # Tareas del usuario
GET    /api/asignaciones/tarea/{tareaId}         # Usuarios de la tarea
GET    /api/asignaciones/existe?usuarioId=...&tareaId=.. # Verificar asignación
```

**Request (POST - Asignar):**
```json
{
  "usuarioId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
  "tareaId": "f47ac10b-58cc-4372-a567-0e02b2c3d480"
}
```

**Response (GET - Tareas de Usuario):**
```json
[
  {
    "usuarioId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "tareaId": "f47ac10b-58cc-4372-a567-0e02b2c3d480",
    "usuario": {
      "usuarioId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "nombre": "Juan Pérez",
      "email": "juan@example.com",
      "createdAt": "2026-04-27T14:30:00"
    },
    "tarea": {
      "tareaId": "f47ac10b-58cc-4372-a567-0e02b2c3d480",
      "titulo": "Implementar autenticación",
      "descripcion": "Agregar JWT al backend",
      "estado": "PENDIENTE",
      "createdAt": "2026-04-27T14:30:00"
    }
  }
]
```

## � Validaciones (DTOs)

El backend valida automáticamente todos los requests usando **Jakarta Validation**:

### UsuarioRequestDTO
- `nombre`: No vacío, 2-100 caracteres
- `email`: Formato email válido, máximo 150 caracteres

### TareaRequestDTO
- `titulo`: No vacío, 2-200 caracteres
- `descripcion`: Máximo 1000 caracteres (opcional)
- `estado`: Máximo 50 caracteres (opcional, por defecto "PENDIENTE")

### AsignacionRequestDTO
- `usuarioId`: UUID no nulo
- `tareaId`: UUID no nulo

**Error de validación (400 Bad Request):**
```json
{
  "timestamp": "2026-04-27T14:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "El email debe ser válido"
}
```

---

### Variables de Entorno (Frontend)

Archivo: `FRONT/.env` (opcional, por defecto es http://localhost:8080)

```env
VITE_API_URL=http://localhost:8080
```

### Variables de Entorno (Backend)

En `docker-compose.yml` o `BACKEND/src/main/resources/application.properties`:

```properties
# Base de datos
spring.datasource.url=jdbc:postgresql://db:5432/tareas_db
spring.datasource.username=postgres
spring.datasource.password=postgres

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=validate

# Swagger
springdoc.swagger-ui.enabled=true
springdoc.api-docs.path=/v3/api-docs
```

---

## 🗄️ Base de Datos

### Tablas Principales

**usuarios**
```sql
CREATE TABLE usuario (
  usuario_id UUID PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**tareas**
```sql
CREATE TABLE tarea (
  tarea_id UUID PRIMARY KEY,
  titulo VARCHAR(200) NOT NULL,
  descripcion TEXT,
  estado VARCHAR(50) DEFAULT 'PENDIENTE',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**usuario_tarea** (Relación Many-to-Many)
```sql
CREATE TABLE usuario_tarea (
  usuario_id UUID,
  tarea_id UUID,
  PRIMARY KEY (usuario_id, tarea_id),
  CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id),
  CONSTRAINT fk_tarea FOREIGN KEY (tarea_id) REFERENCES tarea(tarea_id)
);
```

## 🚀 Características

✅ CRUD completo de Usuarios
✅ CRUD completo de Tareas
✅ Relación Many-to-Many entre Usuarios y Tareas
✅ **Data Transfer Objects (DTOs)** para request/response
✅ **Validación de datos** con Jakarta Validation
✅ API REST documentada con Swagger/OpenAPI
✅ Interfaz React moderna y responsiva con Vite
✅ Base de datos PostgreSQL con persistencia
✅ Migraciones automáticas con Liquibase
✅ Containerizado y orquestado con Docker Compose
✅ CORS habilitado para desarrollo
✅ Separación de responsabilidades (Controller → Service → Repository)

## 🛠️ Stack Tecnológico

**Backend**
- Java 21 LTS
- Spring Boot 3.5.14
- Spring Data JPA
- Spring Validation (Jakarta)
- PostgreSQL 15
- Swagger/OpenAPI 3.1
- Liquibase
- Lombok
- Maven

**Frontend**
- React 18
- Vite
- Axios
- CSS3 (Responsive)

**DevOps**
- Docker & Docker Compose
- Maven (Backend build)
- npm/npm (Frontend build)

## � Flujo de Datos Completo

### Ejemplo: Crear un Usuario

#### 1️⃣ Frontend (React)
```js
// UsuariosTab.jsx
const handleSubmit = async (e) => {
  e.preventDefault()
  await usuariosAPI.create({
    nombre: "Juan",
    email: "juan@example.com"
  })
}
```

#### 2️⃣ Cliente HTTP (Axios)
```js
// services/api.js
export const usuariosAPI = {
  create: (data) => api.post('/api/usuarios', data)
}
// POST http://localhost:8080/api/usuarios
```

#### 3️⃣ Backend Controller
```java
@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public ResponseEntity<UsuarioResponseDTO> createUsuario(
    @Valid @RequestBody UsuarioRequestDTO usuarioRequest) {
  Usuario usuario = dtoToUsuario(usuarioRequest); // Convierte DTO → Entity
  Usuario savedUsuario = usuarioService.save(usuario);
  return ResponseEntity.status(HttpStatus.CREATED)
      .body(usuarioToDTO(savedUsuario)); // Convierte Entity → DTO
}
```

#### 4️⃣ Service (Lógica de Negocio)
```java
@Transactional
public Usuario save(Usuario usuario) {
  return usuarioRepository.save(usuario);
}
```

#### 5️⃣ Repository (JPA)
```java
public interface UsuarioRepository extends JpaRepository<Usuario, UUID> {
  // Spring Data genera la query automáticamente
}
```

#### 6️⃣ Base de Datos
```sql
INSERT INTO usuario (usuario_id, nombre, email, created_at)
VALUES (generated_uuid, 'Juan', 'juan@example.com', NOW());
```

#### 7️⃣ Response al Frontend
```json
{
  "usuarioId": "generated-uuid",
  "nombre": "Juan",
  "email": "juan@example.com",
  "createdAt": "2026-04-27T14:30:00"
}
```

---

## 📚 Mejores Prácticas Implementadas

### Separación de Responsabilidades

```
Request → @Valid DTOs → Controller → Service → Repository → DB
                       ↓
                   Respuesta DTO
```

- **DTOs**: Validación y serialización
- **Controllers**: Manejo de requests/responses
- **Services**: Lógica de negocio
- **Repositories**: Acceso a datos
- **Models**: Entidades JPA

### Validación en Capas

```
1️⃣ Frontend (Validación básica en formularios)
2️⃣ DTO (Validación con anotaciones Jakarta)
3️⃣ Service (Validación de lógica de negocio)
4️⃣ Database (Constraints en tablas)
```

### Errores HTTP Estándar

- `200 OK` - Solicitud exitosa
- `201 Created` - Recurso creado
- `204 No Content` - Eliminación exitosa
- `400 Bad Request` - Error de validación
- `404 Not Found` - Recurso no encontrado
- `500 Internal Server Error` - Error del servidor

---

## 📈 Desarrollo

### Compilar Backend

```bash
cd BACKEND
mvn clean package
```

### Build Frontend

```bash
cd FRONT
npm run build
```

### Logs en Docker

```bash
docker logs backend_app      # Logs del backend
docker logs frontend_app     # Logs del frontend
docker logs postgres_db      # Logs de la BD
```

## ❌ Troubleshooting

### El frontend no se conecta al backend

1. Verifica que el backend esté corriendo: `http://localhost:8080/api/usuarios`
2. Revisa la variable `VITE_API_URL` en `FRONT/.env`
3. Comprueba los logs: `docker logs frontend_app`

### La base de datos está corrupta

```bash
docker compose down -v        # Elimina volumen
docker compose up -d --build  # Recrea desde cero
```

### Puerto en uso

```bash
# Cambiar puerto en docker-compose.yml
# Ejemplo: cambiar puerto 3000 a 3001
ports:
  - "3001:3000"
```

## 📝 Notas

- Los datos persisten en el volumen `api_db_data`
- Las migraciones se ejecutan automáticamente con Liquibase
- El frontend se reconstruye automáticamente en desarrollo con Vite
- CORS está habilitado en el backend (`@CrossOrigin(origins = "*")`)

## 👨‍💻 Desarrollo Continuo

Para agregar nuevas funcionalidades:

1. **Backend**: Añade controllers, services y repositories en `BACKEND/src`
2. **Frontend**: Crea componentes en `FRONT/src/components`
3. **Base de datos**: Añade migraciones en `LIQUIBASE/CHANGES`
4. **Rebuild**: `docker compose up -d --build`

## 📞 Soporte

Revisa los README individuales:
- `BACKEND/HELP.md` - Documentación del backend
- `FRONT/README.md` - Documentación del frontend

---

**¡Listo!** Tu sistema está completamente funcional. 🎉
