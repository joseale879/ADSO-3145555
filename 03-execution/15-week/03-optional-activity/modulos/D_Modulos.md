# Dominio de Seguridad y Acceso

## Objetivo
Controlar quién puede ingresar al sistema y qué acciones puede realizar.

## Problema que resuelve
Evita que cualquier usuario modifique horarios o información sensible sin autorización.

## Entidades
- Usuario
- Rol
- Permiso
- Sesión
- Token

## Funcionalidades
- Autenticación: Verificar identidad mediante usuario y contraseña.
- Autorización: Determinar qué acciones puede realizar un usuario.
- Gestión de Roles: Asignar permisos según el cargo.

### Ejemplo de roles
- Administrador
  - Gestionar usuarios
  - Gestionar horarios
  - Gestionar ambientes
- Coordinador
  - Gestionar horarios
  - Consultar reportes
- Instructor
  - Consultar horario
  - Crear observaciones

# Dominio de Usuarios

## Objetivo
Administrar la información personal de las personas que usan el sistema.

## Problema que resuelve
Centraliza la información de todos los usuarios.

## Entidades
- Usuario
- Perfil
- Información de contacto

## Funcionalidades
- Registrar usuario
- Actualizar información
- Consultar usuarios
- Activar/Inactivar usuarios

# Dominio de Instructores

## Objetivo
Administrar toda la información académica y laboral de los instructores.

## Problema que resuelve
Permite saber quién puede impartir formación y cuándo.

## Entidades
- Instructor
- Especialidad
- Disponibilidad
- Contrato

## Funcionalidades
- Registrar instructor
  - Nombre
  - Documento
  - Correo
  - Especialidad
- Registrar disponibilidad
  - Lunes: 06:00 - 12:00
  - Martes: 13:00 - 18:00
- Consultar carga horaria: Permite saber cuántas horas tiene asignadas.

# Dominio de Aprendices

## Objetivo
Gestionar la información de los estudiantes.

## Problema que resuelve
Permite conocer quién pertenece a cada ficha.

## Entidades
- Aprendiz
- EstadoAprendiz

## Funcionalidades
- Registrar aprendices
- Consultar aprendices
- Asociar a ficha
- Gestionar estados

# Dominio de Programas de Formación

## Objetivo
Administrar la oferta académica institucional.

## Problema que resuelve
Organiza los programas existentes.

## Entidades
- ProgramaFormacion
- NivelFormacion

## Ejemplos
- ADSO
- Contabilidad
- Electricidad Industrial
- Mecatrónica

## Funcionalidades
- Crear programas
- Modificar programas
- Consultar programas

# Dominio de Fichas

## Objetivo
Gestionar los grupos académicos.

## Problema que resuelve
Permite organizar los aprendices en grupos.

## Entidades
- Ficha
- Jornada

## Ejemplo
- Ficha: 2876541
- Programa: ADSO
- Cantidad: 35 aprendices

## Funcionalidades
- Crear ficha
- Asignar programa
- Consultar ficha
- Consultar aprendices

# Dominio de Ambientes

## Objetivo
Administrar los espacios físicos.

## Problema que resuelve
Permite conocer dónde se desarrollará la formación.

## Entidades
- Ambiente
- TipoAmbiente

## Ejemplos
- Aula 101
- Laboratorio 203
- Sala TIC
- Auditorio

## Funcionalidades
- Registrar ambientes
- Modificar ambientes
- Consultar capacidad
- Consultar disponibilidad

# Dominio de Recursos

## Objetivo
Gestionar los equipos existentes en cada ambiente.

## Problema que resuelve
Garantiza que los ambientes tengan los recursos necesarios.

## Entidades
- Recurso
- Inventario
- AsignacionRecurso

## Ejemplos
- Computadores
- Video Beam
- Impresoras
- Herramientas

## Funcionalidades
- Registrar recursos
- Consultar inventario
- Asociar recursos a ambientes

# Dominio de Disponibilidad

## Objetivo
Controlar cuándo un recurso institucional puede ser utilizado.

## Problema que resuelve
Evita asignaciones imposibles.

## Entidades
- DisponibilidadInstructor
- DisponibilidadAmbiente
- Bloqueo

## Funcionalidades
- Consultar disponibilidad
- Instructor libre
- Ambiente libre
- Franja disponible
- Bloquear disponibilidad

## Ejemplo
- Mantenimiento
- Capacitación
- Vacaciones

# Dominio de Horarios (CORE DOMAIN)

## Objetivo
Gestionar toda la programación académica.

## Problema que resuelve
Es el núcleo que coordina instructores, ambientes y fichas.

## Entidades
- Horario
- FranjaHoraria
- Asignacion

## Funcionalidades
- Crear horario
  - Ejemplo:
    - Ficha ADSO 2876541
    - Instructor: Juan Pérez
    - Ambiente: Laboratorio 203
    - Fecha: 01/09/2026
    - Hora: 08:00 - 12:00
- Editar horario
- Cancelar horario
- Reprogramar horario

# Dominio de Conflictos

## Objetivo
Detectar inconsistencias antes de guardar.

## Problema que resuelve
Evita errores operativos.

## Entidades
- Conflicto
- TipoConflicto
- Validaciones

## Funcionalidades
- Instructor ocupado
- Ambiente ocupado
- Ficha ocupada
- Exceso de carga

## Ejemplo
- Instructor A
  - 08:00 - 10:00
  - No puede asignarse
  - 08:30 - 11:00

# Dominio de Observaciones

## Objetivo
Gestionar novedades e incidentes.

## Problema que resuelve
Permite realizar seguimiento.

## Entidades
- Observacion
- Categoria
- Estado

## Funcionalidades
- Crear observación
  - "El laboratorio 203 no tiene internet."
- Resolver observación
- Consultar historial

# Dominio de Solicitudes

## Objetivo
Gestionar peticiones de cambios.

## Problema que resuelve
Formaliza los procesos de modificación.

## Entidades
- Solicitud
- TipoSolicitud

## Ejemplos
- Cambio de ambiente
- Cambio de instructor
- Cambio de horario

## Flujo
1. Creada
2. Revisada
3. Aprobada
4. Ejecutada

# Dominio de Reportes y Analítica

## Objetivo
Generar información para la toma de decisiones.

## Problema que resuelve
Permite medir el desempeño del sistema.

## Entidades
- Reporte
- Indicador

## Reportes
- Carga horaria
  - Instructor A: 40 horas
- Ocupación de ambientes
  - Laboratorio 203: 85% ocupado
- Horarios por ficha

## KPIs
- Conflictos detectados
- Observaciones resueltas
- Uso de ambientes

# Dominio de Configuración Institucional

## Objetivo
Centralizar reglas globales del sistema.

## Problema que resuelve
Evita que reglas estén dispersas por toda la aplicación.

## Entidades
- Jornada
- CalendarioAcademico
- ParametroSistema
- FranjaConfigurada

## Funcionalidades
- Configurar jornadas
  - Mañana
  - Tarde
  - Noche
  - Fin de semana
- Configurar franjas
  - 06:00 - 08:00
  - 08:00 - 10:00
  - 10:00 - 12:00
- Configurar límites
  - Máximo horas semanales
  - Máximo aprendices por ambiente
