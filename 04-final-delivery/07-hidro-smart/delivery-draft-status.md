# Estado de preparación de la entrega de Hidro Smart

**Corte documental:** 2026-11-05.  
**Estado:** borrador de revisión, publicado en la rama codex/hidrosmart-delivery-draft del remoto de trabajo joseale879/ADSO-3145555. No está aprobado como entrega final ni fusionado en main. No se ha creado el tag final, ZIP, checksum o Release.

## Avance documental

- Las nueve carpetas principales, de 01-requirements-specification a 09-project-article, tienen fuentes Markdown. Esto mide disponibilidad de borradores, no aprobación ni exactitud final.
- Las nueve carpetas tienen PDF de lectura. Los PDF de acciones y manuales se regeneraron el 2026-11-05; los otros siete se habían generado el 2026-11-04.
- Se revisaron visualmente muestras de páginas de los PDF, además de portada, página intermedia y página final de los manuales. No se ha completado una inspección visual página por página.
- 10-videos/README.md registra un enlace Canva entregado por el equipo; no se verificaron su acceso, duración ni contenido. Faltan evidencias de los dos videos obligatorios.
- No asigno un porcentaje global de preparación: no hay una rúbrica ponderada para calcularlo. Los borradores están redactados; todavía faltan validaciones técnicas, aprobaciones del equipo y artefactos finales.

## Repositorios consultados

Las ramas y commits de los componentes siguientes son los checkouts locales revisados el 2026-11-04. No se verificó en este documento si sus remotos avanzaron después ni se afirma que esas ramas estén sincronizadas.

| Repositorio | Rama local revisada | Commit local | Uso documentado |
|---|---|---|---|
| PT_HS | hu-20-dev | 1f02b78 | Fuente funcional canónica elegida por el equipo. |
| BK_HS | hu-15-dev | 9db5040 | Referencia del backend separado. |
| FT_HS | hu-16-staging | 18d26e3 | Referencia del frontend separado. |
| BD_HS | hu-23-dev | 7095168 | Referencia de la base de datos separada. |
| Firmaware_HS | hu-03-dev | 5ec5013 | Referencia del firmware separado. |
| DOCS_HS | main | eab6c78 | Referencia de documentación separada. |

El paquete de entrega se trabaja en la rama codex/hidrosmart-delivery-draft del remoto joseale879/ADSO-3145555. La ruta code-sena/ADSO-3145555 aparece en la estructura institucional de referencia; no se debe confundir con el remoto de trabajo del equipo.

## Archivos y evidencias preparados

- Requisitos y matriz de cobertura.
- Análisis de sistema y vistas de proceso.
- Propuesta técnica.
- Diseño, diagramas editables, modelo conceptual e inventario estático de base de datos.
- Plan/resultados de pruebas, reproducibilidad y evidencia delimitada de CI.
- Procedimiento de implementación, instalación y operación.
- Registro de acciones correctivas, preventivas y de mejora.
- Manuales técnico, de instalación y de usuario.
- Artículo del proyecto.
- Índice de videos y enlace recibido.
- Roster de aprendices/instructores y borrador de registro del software.
- Inventario de repositorios y checklist de tag y artefactos.

Los documentos distinguen resultados observados, reportes del equipo y pendientes. Una implementación, una ejecución aislada o una confirmación verbal no reemplazan evidencia de la versión candidata.

## Pendientes para cerrar la entrega

1. Confirmar por proveedor que las credenciales antiguas fueron revocadas y revisar el historial publicado conforme al plan del equipo; no incluir valores secretos en los documentos.
2. Fijar el SHA/tag candidato en PT_HS y decidir qué componentes/repositorios separados forman parte del paquete.
3. Verificar CI en la rama/commit exactos que se entregarán y conservar enlaces de ejecución.
4. Adjuntar evidencia del flujo físico ESP32–Flespi: TLS, ACL, telemetría, estado y comando autorizado, sin exponer tokens.
5. Documentar la prueba de medición pausada y alerta de fuga con lecturas, alerta y resultado visible.
6. Completar evidencia de entrega de correos activos por Brevo y de respaldo/restauración de PostgreSQL.
7. Revisar todas las páginas de los nueve PDF y cotejar manuales/diagramas con el SHA candidato.
8. Confirmar nombres, responsabilidades, aportes, autoría, productor, titularidad y campos institucionales con aprendices/instructor.
9. Verificar los enlaces y completar los videos obligatorios de pitch (1–2 minutos) y tutorial (3–5 minutos).
10. Preparar las exportaciones solicitadas, revisar que no contengan secretos/datos personales y generar SHA-256. Crear el tag/Release solo después de la aprobación.

## Control de versión documental

Los PDF son copias de lectura derivadas de Markdown. Si se modifica una fuente, se debe regenerar y revisar su PDF correspondiente antes de cerrar el paquete. Los cambios publicados en la rama de trabajo siguen siendo borradores hasta que el equipo/instructor los apruebe.