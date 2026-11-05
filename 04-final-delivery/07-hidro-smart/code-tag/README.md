# Código fuente, tag y artefactos de entrega

**Estado:** inventario local; ningún tag, ZIP, hash o Release final está creado. PT_HS es la fuente funcional canónica elegida. Los repositorios separados se listan para trazabilidad y no se presumen sincronizados con PT_HS.

## Checkouts locales consultados

Los commits siguientes se observaron localmente el 2026-11-04. No son todavía una versión coordinada de entrega.

| Componente | Repositorio original | Rama y commit local | Tag de entrega | ZIP de versión | Exportación completa | Visibilidad y acceso de revisor |
| --- | --- | --- | --- | --- | --- | --- |
| Monorepo e integración | [joseale879/PT_HS](https://github.com/joseale879/PT_HS) | `hu-20-dev` / `1f02b78` | Pendiente | Pendiente | Pendiente | Verificar |
| Backend separado | [joseamaya009/BK_HS](https://github.com/joseamaya009/BK_HS) | `hu-15-dev` / `9db5040` | Pendiente | Pendiente | Pendiente | Verificar |
| Frontend separado | [joseamaya009/FT_HS](https://github.com/joseamaya009/FT_HS) | `hu-16-staging` / `18d26e3` | Pendiente | Pendiente | Pendiente | Verificar |
| Base de datos | [EmersonMolano/BD_HS](https://github.com/EmersonMolano/BD_HS) | `hu-23-dev` / `7095168` | Pendiente | Pendiente | Pendiente | Verificar |
| Firmware ESP32 | [joseamaya009/Firmaware_HS](https://github.com/joseamaya009/Firmaware_HS) | `hu-03-dev` / `5ec5013` | Pendiente | Pendiente | Pendiente | Verificar |
| Documentación del proyecto | [EmersonMolano/DOCS_HS](https://github.com/EmersonMolano/DOCS_HS) | `main` / `eab6c78` | Pendiente | Pendiente | Pendiente | Verificar |

## Repositorios de entrega y trazabilidad

El equipo indicó joseale879/ADSO-3145555 como remoto de trabajo para subir este paquete. Los documentos actuales están publicados en la rama [codex/hidrosmart-delivery-draft](https://github.com/joseale879/ADSO-3145555/tree/codex/hidrosmart-delivery-draft). Esta rama es un borrador de revisión y no está fusionada en main.

La estructura de entrega también referencia [code-sena/ADSO-3145555](https://github.com/code-sena/ADSO-3145555). No se afirma que el fork de trabajo y el repositorio institucional sean el mismo remoto ni que esta rama ya esté entregada allí. Confirmar con el instructor cuál enlace y método de contribución debe recibir la versión final.

## Artefactos por preparar

La versión de entrega debe quedar identificada por un tag real y el SHA exacto en cada repositorio que se decida entregar. final-delivery-2026 se ha usado como nombre propuesto, pero no se debe presentar como tag existente mientras no se cree y verifique.

- ZIP del código de la versión aprobada, sin secretos ni datos locales.
- Exportación completa en el formato exigido por la guía oficial. Confirmar si requiere solo archivos o también ramas, tags e historial; un ZIP de GitHub de una rama no incluye el historial completo.
- Archivo SHA256SUMS.txt con el hash de cada artefacto una vez generado.
- Release asociado al tag y con los artefactos que indique la guía oficial.
- Acceso de lectura/revisión para el instructor o cuenta indicada por el SENA, confirmado por el propietario de cada repositorio.

Antes de empaquetar, comprobar que las credenciales expuestas en el historial fueron rotadas y que los archivos de entorno con secretos no están en los adjuntos. La limpieza de ramas o del historial se coordina aparte y no debe alterar la evidencia que el SENA solicite conservar.

## Criterio de cierre

No marcar esta sección como completa hasta que el equipo apruebe el conjunto de repositorios, se verifique cada tag/SHA, se construyan y revisen los ZIP, se calcule SHA-256, se compruebe el acceso del revisor y el Release se vincule a la misma versión documentada en todos los archivos.