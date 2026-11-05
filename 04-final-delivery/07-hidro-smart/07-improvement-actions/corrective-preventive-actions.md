> **Estado y alcance.** Documento en revisión para la entrega. Las fechas, cifras y funciones heredadas del documento fuente solo se consideran vigentes cuando están respaldadas por evidencia del monorepo PT_HS. Consulta el [índice de entrega](../README.md) y el [estado del borrador](../delivery-draft-status.md).

<strong>HIDROSMART</strong>

Acciones correctivas, preventivas y de mejora

Registro de brechas, prioridad y criterio de cierre

Versión documental consolidada 1.0  
Fecha de corte: 2026-10-09  
Código documental: DOC-11


# 1. Objetivo

Este documento convierte las brechas identificadas en el corte documental en acciones trazables. Una acción se considera cerrada solo con evidencia fechada, responsable, commit o configuración identificable y resultado de prueba.

# 2. Acciones priorizadas

<table>
<tr>
<td><p><strong>ID</strong></p></td>
<td><p><strong>Tipo</strong></p></td>
<td><p><strong>Tema</strong></p></td>
<td><p><strong>Prioridad</strong></p></td>
<td><p><strong>Hallazgo</strong></p></td>
<td><p><strong>Acci&#243;n</strong></p></td>
<td><p><strong>Cierre</strong></p></td>
</tr>
<tr>
<td><p>ACP-01</p></td>
<td><p>Correctiva</p></td>
<td><p>Seguridad MQTT de producci&#243;n</p></td>
<td><p>Alta</p></td>
<td><p>Local opera sin TLS/ACL.</p></td>
<td><p>Configurar TLS, autenticaci&#243;n, ACL, rotaci&#243;n y probar reconexi&#243;n.</p></td>
<td><p>Prueba de conexi&#243;n autorizada/no autorizada y evidencia de certificados.</p></td>
</tr>
<tr>
<td><p>ACP-02</p></td>
<td><p>Correctiva</p></td>
<td><p>Calibraci&#243;n f&#237;sica</p></td>
<td><p>Alta</p></td>
<td><p>Hay lecturas f&#237;sicas, no ensayo de volumen conocido.</p></td>
<td><p>Comparar volumen patr&#243;n, pulsos y error por rango.</p></td>
<td><p>Acta de calibraci&#243;n, datos crudos y aceptaci&#243;n.</p></td>
</tr>
<tr>
<td><p>ACP-03</p></td>
<td><p>Preventiva</p></td>
<td><p>Backup y restore</p></td>
<td><p>Alta</p></td>
<td><p>No verificado end-to-end.</p></td>
<td><p>Automatizar backup, restauraci&#243;n y comprobaci&#243;n de integridad.</p></td>
<td><p>Log de restore, checksum y prueba de consultas.</p></td>
</tr>
<tr>
<td><p>ACP-04</p></td>
<td><p>Correctiva</p></td>
<td><p>Correo transaccional y alertas</p></td>
<td><p>Media</p></td>
<td><p>Brevo ya está integrado por API HTTPS según PT_HS; falta evidencia de entrega E2E de cada flujo activo y configuración privada del entorno.</p></td>
<td><p>Verificar remitente y variables en el gestor, probar verificación/recuperación y documentar messageId, entrega o rebote; conectar aparte los disparadores de alertas que falten.</p></td>
<td><p>Mensaje recibido, log y manejo de error.</p></td>
</tr>
<tr>
<td><p>ACP-05</p></td>
<td><p>Mejora</p></td>
<td><p>Frontend E2E y accesibilidad</p></td>
<td><p>Media</p></td>
<td><p>Lint/build no cubren flujos de usuario.</p></td>
<td><p>A&#241;adir pruebas de rutas, responsive, teclado y lector.</p></td>
<td><p>Reporte por navegador/dispositivo.</p></td>
</tr>
<tr>
<td><p>ACP-06</p></td>
<td><p>Mejora</p></td>
<td><p>Push de tiempo real</p></td>
<td><p>Media</p></td>
<td><p>UI usa polling HTTP de 5 segundos.</p></td>
<td><p>Evaluar WebSocket/SSE solo si el requisito lo exige y medir costo.</p></td>
<td><p>Decisi&#243;n arquitect&#243;nica y prueba de latencia.</p></td>
</tr>
<tr>
<td><p>ACP-07</p></td>
<td><p>Preventiva</p></td>
<td><p>Sincronizaci&#243;n documental</p></td>
<td><p>Media</p></td>
<td><p>Hay versiones locales con cifras/tecnolog&#237;as hist&#243;ricas.</p></td>
<td><p>Usar DOC-00 y fecha de corte en cada entrega.</p></td>
<td><p>Matriz actualizada y revisi&#243;n cruzada.</p></td>
</tr>
<tr>
<td><p>ACP-08</p></td>
<td><p>Mejora</p></td>
<td><p>Identidad institucional</p></td>
<td><p>Alta</p></td>
<td><p>PDF y documentos locales muestran c&#243;digos/fichas distintos.</p></td>
<td><p>Confirmar c&#243;digo, programa, ficha, centro y periodo con coordinaci&#243;n.</p></td>
<td><p>Acta o fuente institucional aprobada.</p></td>
</tr>
</table>


# 3. Clasificación de causas

<table>
<tr>
<td><p><strong>Causa</strong></p></td>
<td><p><strong>Ejemplo</strong></p></td>
<td><p><strong>Respuesta</strong></p></td>
</tr>
<tr>
<td><p>Evidencia incompleta</p></td>
<td><p>No hay prueba de backup/restore.</p></td>
<td><p>Planificar prueba y registrar resultado.</p></td>
</tr>
<tr>
<td><p>Deriva documental</p></td>
<td><p>WebSockets/cloud en documento antiguo.</p></td>
<td><p>Comparar contra c&#243;digo y marcar hist&#243;rico.</p></td>
</tr>
<tr>
<td><p>Dependencia externa</p></td>
<td><p>Brevo y evidencia de entrega, certificados/ACL MQTT y hardware físico.</p></td>
<td><p>Definir ambiente, responsable y criterio de aceptaci&#243;n.</p></td>
</tr>
<tr>
<td><p>Riesgo operativo</p></td>
<td><p>Broker local an&#243;nimo.</p></td>
<td><p>Endurecer configuraci&#243;n antes de producci&#243;n.</p></td>
</tr>
</table>


# 4. Seguimiento

Registrar responsable y fecha objetivo fuera de este documento o en el sistema de gestión aprobado.

No cerrar por declaración; adjuntar evidencia reproducible.

Revisar acciones en cada cambio de rama o corte del repositorio.

Priorizar seguridad, integridad de datos, calibración y recuperación antes de ampliar funcionalidades.

<strong>Nota de control documental. </strong>Las acciones se derivan de docs/estado-verificado-2026-09-26.md, contrato MQTT, README de firmware y discrepancias entre documentación local y código. No se asignan responsables o fechas no proporcionados por el proyecto.

<!-- footer: HidroSmart | DOC-11 | Versión documental consolidada 1.0 | Página PAGE -->


## Seguimiento al corte 2026-11-04

Las acciones hist?ricas de DOC-11 se conservan arriba. Este registro fija estado y evidencia para el corte actual de PT_HS/hu-20-dev (`1f02b78`). ?Pendiente de verificar? significa que el repositorio o el material compartido no demuestra el cierre en todos los ambientes.

| ID | Prioridad | Acci?n actual | Estado documentado | Evidencia necesaria para cerrar |
|---|---|---|---|---|
| SEC-01 | P0 | Confirmar la rotaci?n de todos los secretos expuestos y limpiar las referencias del historial publicado seg?n el plan aprobado. | El equipo indic? que hizo cambios de credenciales; la documentaci?n local no demuestra que cada proveedor acept? las claves nuevas ni que las antiguas fueron revocadas. | Confirmaci?n por proveedor, escaneo del historial y revisi?n de los adjuntos; nunca guardar los valores. |
| SRC-01 | Alta | Mantener PT_HS como fuente funcional can?nica e integrar all? la versi?n aprobada. | Fuente elegida; el checkout local es `hu-20-dev` (`1f02b78`). Los componentes separados est?n en ramas distintas. | Rama/tag final, SHAs y correspondencia documentada para cada artefacto incluido. |
| CI-01 | Alta | Ejecutar CI en el commit de entrega y comprobar el resultado en la rama destino. | Los workflows de `hu-20-dev` pasaron en el commit registrado en `ci-evidence-hu-20.md`; esto no prueba CI en `main` ni en un tag posterior. | Enlaces de Actions con SHA de entrega y todos los checks requeridos verdes. |
| MQTT-01 | Alta | Verificar TLS, ACL de Flespi y el flujo de telemetr?a/estado/comandos del ?nico ESP32 activo. | El firmware de PT_HS declara un ?nico `deviceCode`; existen logs compartidos de conexi?n y telemetr?a, pero la ACL remota y la operaci?n del tag final requieren evidencia fechada. | Captura redactada de conexi?n TLS, topics permitidos, telemetr?a recibida por API y comando autorizado; sin token. |
| IOT-02 | Alta | Verificar modo de vigilancia/medici?n pausada: el caudal sigue entrando y las alertas eval?an la condici?n aunque el consumo contabilizado se pause. | La intenci?n est? en el c?digo y en migraciones; la respuesta funcional completa requiere un caso reproducible de extremo a extremo. | Lectura antes/durante/despu?s, estado de medici?n, alerta generada y resultado en UI/base de datos. |
| MAIL-01 | Alta | Confirmar env?o y recepci?n de los flujos activos por Brevo en el ambiente de entrega. | El c?digo usa Brevo y hubo confirmaci?n de usuario para recuperaci?n; no hay en este paquete una evidencia completa por flujo y versi?n. | Pruebas de verificaci?n, reenv?o y recuperaci?n con messageId/estado y recepci?n, con datos personales ocultos. |
| DB-01 | Alta | Verificar que las migraciones Liquibase requeridas por la versi?n final est?n aplicadas y que la recuperaci?n de PostgreSQL est? probada. | Hay una transcripci?n anterior de `update`; no demuestra restore probado ni que todos los cambios correspondan al tag final. | `status --verbose`, changelog en el entorno y acta/log de restauraci?n en una instancia aislada. |
| DOC-01 | Media | Sincronizar Markdown, diagramas y PDF de entrega con la misma revisi?n. | Se corrigieron referencias internas; los PDF existentes se est?n regenerando desde Markdown. | Revisi?n visual de todos los PDF, cero enlaces rotos y estado de revisi?n final documentado. |
| TEAM-01 | Media | Confirmar autor?a, aportes, roles y revisi?n por pares. | El roster se basa en historiales de los seis repositorios fuente; las confirmaciones personales e institucionales siguen pendientes. | Aprobaci?n de integrantes/instructores y evidencia de revisi?n independiente conforme al proceso del equipo. |
| REL-01 | Alta | Preparar tag, ZIP, hashes y Release solo despu?s de aprobar documentaci?n, CI y pruebas. | No creado; se mantiene deliberadamente pendiente. | Aprobaci?n del equipo, SHA ?nico, ZIP revisados, SHA-256 y acceso del revisor. |

El orden de cierre recomendado es SEC-01, SRC-01/CI-01, MQTT-01/IOT-02/MAIL-01/DB-01, DOC-01/TEAM-01 y finalmente REL-01. No marcar una acci?n cerrada ?nicamente porque existe una implementaci?n.
