# Código fuente, tags y artefactos de entrega

**Corte remoto consultado:** 2026-11-05.
**Estado:** inventario de trazabilidad; no constituye aprobación de versión ni prueba de que los repositorios formen un mismo árbol de código.

## Ramas `main` consultadas

Se consultó el SHA remoto de `main` mediante `git ls-remote`. PT_HS es la fuente funcional canónica elegida por el equipo; los repositorios separados se registran como componentes relacionados cuya equivalencia debe demostrarse, no presumirse.

| Componente | Repositorio | Rama | SHA remoto completo | Tag remoto `final-delivery-2026` y SHA objetivo | Estado del tag frente a `main` |
|---|---|---|---|---|---|
| Monorepo e integración | [joseale879/PT_HS](https://github.com/joseale879/PT_HS) | `main` | `32be1cf787f20120dfd3b4cc72226dab55d88216` | Sí: `8dd45ca349134ad0851a536af5f90760b10691f3` | No coincide; el tag apunta al merge HU-19 del 2026-10-30. |
| Backend separado | [joseamaya009/Backend-Hidrosmart](https://github.com/joseamaya009/Backend-Hidrosmart) | `main` | `190263da952afba5d4ce7f6c2d83c0fde2b239c4` | Sí: `190263da952afba5d4ce7f6c2d83c0fde2b239c4` | Coincide con `main`. |
| Frontend separado | [joseamaya009/FT_HS](https://github.com/joseamaya009/FT_HS) | `main` | `1cc57796aabee446410146ad6475db2a780dbb10` | Sí: `91a5ef3125ed73d4d9d410f772b54923f8099430` | No coincide; el tag apunta al merge HU-20 del 2026-10-31 y no incluye el commit HU-21 actual. |
| Base de datos separada | [EmersonMolano/BD_HS](https://github.com/EmersonMolano/BD_HS) | `main` | `42ee03b5906dfdcbd9e9f6c7f03ddc453250d23b` | Sí: `42ee03b5906dfdcbd9e9f6c7f03ddc453250d23b` | Coincide con `main`. Aun así, revisar el historial e identidad de changesets con PT_HS antes de aplicar entre repositorios. |
| Firmware ESP32 | [joseamaya009/Firmaware_HS](https://github.com/joseamaya009/Firmaware_HS) | `main` | `2e5cfca7d0573e4225a07c6b7b13ea23e9570f4d` | Sí: `917fcfd2129ea6ff92860a4321b1fd7863957d85` | No coincide; el tag apunta a un commit de firmware del 2026-10-28. |
| Documentación de componentes | [EmersonMolano/DOCS_HS](https://github.com/EmersonMolano/DOCS_HS) | `main` | `8ad8a018dd5d0875fa4b3360fa2071c1c4a2adde` | Sí: `054a063a667f637a55b3641f83a9e4dded1faa5b` | No coincide; el tag apunta a un commit anterior de documentación. |
| Entrega ADSO | [joseale879/ADSO-3145555](https://github.com/joseale879/ADSO-3145555) | `main` | `993c5b2de07aa60bd49d866c63267ce0b983c312` | No existe en el remoto consultado | No hay tag de entrega en este repositorio. |

Las consultas comprobaron el tag remoto anotado y su SHA de commit desplegado (línea `^{}` de `git ls-remote --tags`). No se crearon, movieron ni borraron tags en esta revisión. Los targets distintos son evidencia de que `final-delivery-2026` no debe presentarse como una versión coordinada y aprobada sin una decisión explícita del equipo.

## Estado del paquete ADSO

Al último corte remoto, `main` y `codex/hidrosmart-delivery-draft` apuntaban a `993c5b2de07aa60bd49d866c63267ce0b983c312`. La revisión actual se mantiene local; el SHA remoto no incluye estas modificaciones documentales locales.

## Artefactos por preparar

Una vez aprobada la versión y fijados los SHA de cada repositorio:

- ZIP del código aprobado, sin secretos ni datos locales.
- Exportación completa en el formato que exija la guía oficial. Confirmar si se requieren ramas, tags e historial; un ZIP de GitHub de una rama no conserva todo el historial.
- `SHA256SUMS.txt` con el hash de cada artefacto generado.
- Release asociado a la versión aprobada, con los artefactos requeridos.
- Acceso de lectura para el instructor o cuenta indicada por el SENA, verificado con los propietarios de cada repositorio.

Antes de empaquetar, comprobar que las credenciales expuestas en el historial fueron rotadas y que los archivos adjuntos no contienen secretos. La limpieza de ramas o historial debe coordinarse aparte y no alterar evidencia requerida por el SENA.

## Criterio de cierre

No marcar esta sección como completa hasta que el equipo apruebe el conjunto de repositorios, se resuelva el estado de los tags existentes, se verifique CI en los SHA de entrega, se construyan y revisen los ZIP, se calcule SHA-256, se confirme el acceso del revisor y el Release corresponda a la misma versión documentada.
