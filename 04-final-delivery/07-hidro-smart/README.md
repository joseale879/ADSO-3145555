# Hidro Smart — entrega final

**Estado: borrador de entrega en revisión.** Los avances están subidos a la rama [codex/hidrosmart-delivery-draft](https://github.com/joseale879/ADSO-3145555/tree/codex/hidrosmart-delivery-draft) del remoto de trabajo joseale879/ADSO-3145555. No se ha aprobado ni fusionado el paquete como entrega final; todavía no se debe crear el tag.

## Información general

| Campo | Estado / dato disponible |
|---|---|
| Producto | Hidro Smart |
| Ficha | 3145555 |
| Programa de formación | Análisis y Desarrollo de Software (228118) |
| Proyecto formativo | Desarrollo de software orientado a servicios |
| Centro de formación | Centro de la Industria, la Empresa y los Servicios — Regional Huila |
| Proceso | Finalización de la etapa lectiva del tecnólogo |
| Semillero | Developers & Geeks — confirmar que corresponde a esta entrega |
| Versión | Pendiente: tag y SHA del código aprobado |
| Fecha de entrega | Pendiente |
| Responsable de entrega | Pendiente de confirmar con el equipo/instructor |

## Resumen del proyecto

Hidro Smart es una solución para monitorear el consumo de agua por hogar. Un sensor conectado a un ESP32 envía telemetría por MQTT; el backend procesa las lecturas y las almacena en PostgreSQL. Las interfaces web y móvil permiten consultar hogares, dispositivos, consumo, reportes e información de alertas. La descripción y las funciones deben cotejarse con el commit final antes de presentar la entrega.

| Información | Dato |
|---|---|
| URL web indicada por el equipo | [https://pt-hs.pages.dev/login](https://pt-hs.pages.dev/login) — comprobar disponibilidad el día de la demostración |
| Tecnologías que aparecen en los repositorios | React, TypeScript, Expo/React Native, Node.js/Express, PostgreSQL/Liquibase y firmware ESP32 en C++/Arduino |
| Acceso de demostración | No incluir credenciales en este repositorio. Coordinar acceso temporal por un canal privado aprobado por el instructor. |

## Equipo

La participación se consolida desde PT_HS y los repositorios separados. Los roles de la tabla se basan en áreas con actividad Git observada y deben confirmarse por cada integrante. La autoría formal se confirma en `software-registration.md`.

| Integrante | Usuario(s) Git observados | Áreas de actividad registradas | Confirmación |
|---|---|---|---|
| JOSE ALEJANDRO MONTEALEGRE RODRIGUEZ | `joseale879` | Integración y desarrollo transversal: backend, frontend, base de datos, firmware y documentación | Pendiente |
| JOSE DAVID AMAYA MOSQUERA | `joseamaya009`; `José David Amaya Mosquera` | Backend, frontend, base de datos e integración/mantenimiento de firmware | Pendiente |
| EMERSON CALET MOLANO CARDOZO | `EmersonMolano`; `Emerson Calet Molano Cardozo` | Backend, frontend, base de datos y documentación | Pendiente |

Los documentos de identidad, teléfonos, direcciones y correos personales se entregan por un canal privado; **no se publican en esta carpeta ni se incluyen en los ZIP públicos**.

## Contenido y estado

La existencia de un archivo Markdown significa que el documento está redactado; no implica aprobación ni evidencia de ejecución. El estado siguiente diferencia el borrador disponible de lo que falta para cerrar la entrega.

| Carpeta o archivo | Contenido disponible | Estado de cierre |
|---|---|---|
| `01-requirements-specification/` | SRS y matriz de cobertura | Redactados; falta aprobación del equipo/instructor y evidencia de aceptación por requisito. |
| `02-software-analysis/` | Análisis del sistema y flujos | Redactado; cotejar actores y procesos contra la versión candidata. |
| `03-technical-proposal/` | Propuesta técnica | Redactada; confirmar supuestos y estimaciones históricas. |
| `04-software-design/` | Arquitectura, diseño, modelo ER conceptual, inventario estático de 57 tablas, wireframe y diagramas | Redactados; verificar el modelo con la base aprobada y actualizar si cambia el código. |
| `05-test-documentation/` | Plan/resultados documentados, reproducibilidad y CI de HU-20 | Redactados; falta evidencia reciente de la versión candidata y ensayos físicos del alcance IoT/correo. |
| `06-implementation-procedure/` | Instalación, operación, dependencias y despliegue | Redactados; reproducir desde clon limpio y verificar las URLs actuales. |
| `07-improvement-actions/` | Acciones correctivas, preventivas y de mejora | Registro redactado; faltan responsables, fechas y evidencias de cierre. |
| `08-manuals/` | Manual técnico, de instalación y de usuario | Redactados; recorrerlos con la versión candidata y corregir desajustes. |
| `09-project-article/` | Artículo del proyecto | Redactado; confirmar autores, fuentes, formato y resultados con el equipo/instructor. |
| `10-videos/` | Enlace Canva recibido e inventario de videos | Hay un enlace sin clasificar; falta verificar acceso y completar/validar pitch y tutorial obligatorios. |
| `code-tag/` | Inventario de repositorios y checklist de artefactos | Incompleto; faltan versión aprobada, exportaciones, hashes, permisos y Release/tag. |
| `team-roster.md` | Integrantes y aportes observados en Git | Borrador; cada persona debe confirmar nombre, usuario, rol y aportes. |
| `software-registration.md` | Borrador de registro de software | Requiere confirmación de autoría, titularidad, productor y demás datos legales/institucionales. |
| `delivery-draft-status.md` | Estado, fuente y pendientes del borrador | Actualizado al 2026-11-05; refleja lo publicado en la rama de revisión y las validaciones aún pendientes. |
| PDF de categorías | Nueve copias de lectura de las categorías 01–09 | Siete se regeneraron el 2026-11-04 y los PDF de acciones y manuales el 2026-11-05. Se revisaron muestras visuales; falta revisión completa y aprobación. |

## Criterios para cerrar la entrega

- Todos los documentos describen la misma versión identificada por tag y SHA.
- La rama final acordada contiene el commit aprobado y su CI termina verde.
- Los autores, productor, solicitante y declaraciones del registro están confirmados por el equipo.
- El inventario de repositorios y componentes de terceros está completo; los secretos y datos personales no aparecen en el material público.
- Los videos obligatorios tienen duración, contenido y permisos de acceso comprobados; el tutorial muestra el sistema real.
- Los PDF corresponden a sus fuentes Markdown finales.
- El código empaquetado, los ZIP, sus hashes y los enlaces del Release corresponden al mismo tag aprobado.

## Archivos grandes

Los videos y otros archivos que excedan el límite del repositorio se alojan fuera de Git y se enlazan en `10-videos/README.md` o en el documento correspondiente. Comprobar el acceso de cada enlace antes de entregar.
