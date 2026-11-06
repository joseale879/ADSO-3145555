# Estado de preparación de la entrega de Hidro Smart

**Corte documental:** 2026-11-05.  
**Estado:** borrador en revisión; no aprobado como entrega final.

## Estado del repositorio de entrega

La base remota de este corte fue `993c5b2de07aa60bd49d866c63267ce0b983c312`, igual en `main` y `codex/hidrosmart-delivery-draft`. El paquete actualizado se publicó en `main` como `bb009cf`; permanece como borrador en revisión y no crea ni mueve tags.

El repositorio ADSO no tiene el tag remoto `final-delivery-2026`. Ese nombre sí existe como tag anotado en seis repositorios de componentes; sus destinos no forman una versión coordinada: los tags de PT_HS, FT_HS, Firmaware_HS y DOCS_HS no apuntan a sus `main` actuales. Véase el [inventario de código y tags](code-tag/README.md). No crear, mover ni volver a etiquetar una versión hasta cerrar los pendientes y obtener aprobación.

## Avance documental

- Las nueve carpetas principales, de `01-requirements-specification` a `09-project-article`, tienen fuentes Markdown. La existencia de un borrador no significa que esté aprobado ni que toda afirmación esté comprobada.
- Las nueve carpetas tienen PDF de lectura. Seis (requisitos, diseño, pruebas, acciones, manuales y artículo) se regeneraron el 2026-11-05; análisis, propuesta e implementación conservan copias del 2026-11-04. En los seis PDF actualizados se revisaron hojas de contacto de todas las páginas y páginas seleccionadas a tamaño completo; no se inspeccionó cada página a tamaño completo.
- La revisión visual incluyó hojas de contacto de todas las páginas y páginas seleccionadas a tamaño completo; no se inspeccionó a tamaño completo cada página.
- `10-videos/README.md` registra un enlace Canva proporcionado por el equipo; no se verificaron acceso, duración ni contenido. Falta acreditar los dos videos obligatorios.
- No asigno un porcentaje global: no hay una rúbrica ponderada y persisten verificaciones técnicas, aprobaciones y artefactos de entrega.

## Referencias remotas de código

SHA consultados directamente en los remotos el 2026-11-05. PT_HS sigue siendo la fuente funcional canónica elegida por el equipo; los repositorios separados se registran por trazabilidad y no se presumen idénticos entre sí.

| Repositorio | Rama consultada | SHA remoto | Uso documentado |
|---|---|---|---|
| PT_HS | `main` | `32be1cf787f20120dfd3b4cc72226dab55d88216` | Fuente funcional canónica. Incluye HU-21: la carga del perfil es independiente de la consulta de hogares y dispositivos. |
| BK_HS | `main` | `190263da952afba5d4ce7f6c2d83c0fde2b239c4` | Backend separado; referencia de contraste. |
| FT_HS | `main` | `1cc57796aabee446410146ad6475db2a780dbb10` | Frontend separado; incluye el ajuste HU-21 de carga del perfil. |
| BD_HS | `main` | `42ee03b5906dfdcbd9e9f6c7f03ddc453250d23b` | Base de datos separada; comparar identidad y contenido de migraciones antes de afirmar equivalencia. |
| Firmaware_HS | `main` | `2e5cfca7d0573e4225a07c6b7b13ea23e9570f4d` | Firmware separado; contraste con el monorepo y validación física pendiente. |
| DOCS_HS | `main` | `8ad8a018dd5d0875fa4b3360fa2071c1c4a2adde` | Repositorio separado de documentación. |
| ADSO-3145555 | `main` | Base `993c5b2de07aa60bd49d866c63267ce0b983c312` | Repositorio de entrega; este corte incorpora las correcciones documentales preparadas en esta rama. |

Los tags remotos existentes y su SHA objetivo se registran por separado en `code-tag/README.md`; un nombre de tag igual en repositorios distintos no prueba por sí solo que formen una entrega aprobada.


## Auditoría de ramas hacia `main`

Consulta directa y `fetch` de las ramas remotas el 2026-11-05. Se compararon commits y árboles de archivos contra cada `main`; un commit adelantado no significa que el árbol sea más nuevo.

| Repositorio | Flujo actual | Resultado |
|---|---|---|
| PT_HS | `main` `32be1cf`; HU-21 `dev` → `qa` → `staging` → `hu-21-main` → `main` | La cadena HU-21 está completa. HU-04 continúa sin ramas por decisión previa. `hu-05-qa` conserva 8 commits no incluidos en la ascendencia de `main` y está 185 commits detrás; su árbol difiere en 579 rutas y la simulación de merge produce conflictos en frontend, cliente API, traducciones y README. No integrar la rama completa: corresponde a una línea antigua y puede reintroducir código obsoleto. Las demás ramas HU existentes no tienen commits propios fuera de `main`. |
| BD_HS | `main` `42ee03b`; última HU `23` | `develop`, `qa` y `staging` tienen tres commits de merge adelantados, pero sus árboles son anteriores a `main`; difieren en 15 rutas. `staging` carece, entre otras, de la migración de estado de medición y las funciones actuales de pausa y alerta de fuga. No promover esas ramas antiguas sobre `main`. |
| BK_HS | `main` `190263d`; última HU `15` | `develop`, `qa` y `staging` tienen un commit de merge adelantado, pero están entre 66 y 109 commits detrás y difieren en 12 archivos. Son árboles antiguos respecto de `main`; no promoverlos. |
| Firmaware_HS | `main` `2e5cfca`; HU-03 | `main` coincide con `hu-03-main`; las demás ramas examinadas no contienen commits ausentes de `main`. |
| FT_HS | `main` `1cc5779`; HU-21 | `main` y `hu-21-main` incluyen HU-21. `develop` está 25 commits adelantado por historia y 140 detrás; el árbol difiere solo en `SettingsPage.tsx` y `vercel.json`, que no está en `develop`. No promover `develop` porque quitaría la configuración SPA y revertiría la pantalla de ajustes. La brecha previa de ascendencia `qa` → `staging` permanece documentada; no se hizo force-push. |
| DOCS_HS | Solo `main` `8ad8a01` | No tiene ramas HU ni cambios adelantados en el remoto consultado. |

El fetch confirmó que los repositorios separados no tienen commits de código de sus ramas HU pendientes de integrar en sus `main`; algunas ramas de ambiente conservan merges históricos sin equivalencia de árbol y son más antiguas. PT_HS HU-05 es la única rama HU con commits únicos, pero no es una promoción segura por su antigüedad y conflictos. No se hizo push ni merge de ramas de código, ni force-push, durante esta auditoría.

### Cobertura de ascendencia de todas las HUs

La revisión de cada borde `dev` → `qa` → `staging` → `hu-N-main` → `main` encontró brechas históricas aunque las ramas finales `hu-N-main` ya sean ancestros de `main`:

| Repositorio | Flujos HU con ascendencia incompleta | Observación |
|---|---:|---|
| PT_HS | 3: HU-05, HU-16 y HU-19 | HU-05 falla en `qa` → `staging`; HU-16 tiene tres bordes intermedios rotos; HU-19 falla en `dev` → `qa`. |
| BD_HS | 22 de 23 | HU-23 tiene la cadena completa; HU-01 a HU-22 no conservan los tres enlaces intermedios. |
| BK_HS | 14 de 15 | HU-15 tiene la cadena completa; HU-01 a HU-14 no conservan los tres enlaces intermedios. |
| FT_HS | 20 de 21 | HU-21 falla en `qa` → `staging` y `staging` → `hu-21-main`; el resto también presenta huecos históricos. |
| Firmaware_HS | 2 de 3 | HU-03 está completa; HU-01 y HU-02 no conservan todos los enlaces intermedios. |

Esto describe el grafo de commits, no una ausencia automática de código en `main`. No se reconstruyeron en bloque las cadenas antiguas: hacerlo ahora podría reintroducir árboles viejos, borrar configuración vigente o crear conflictos. La corrección segura es conservar el estado actual de `main` y documentar las brechas; a partir de las próximas HUs, abrir y fusionar cada PR estrictamente hacia la rama padre antes de continuar al siguiente ambiente.

## Evidencia de CI consultada

| Repositorio / SHA | Evidencia remota observada | Alcance y límite |
|---|---|---|
| PT_HS `main` / `32be1cf` | Cuatro ejecuciones de Actions terminaron `success`; los nueve check-runs terminaron `success`, incluidos `full-validation`, build/pruebas/E2E del frontend, checks del backend y build del firmware. El estado combinado de commits aún informa `pending` con cero contextos. | Los flujos configurados para este SHA pasaron; el estado combinado de GitHub sigue sin resolverse. No extrapolar el resultado a repositorios separados ni a pruebas físicas. |
| FT_HS `main` / `1cc5779` | El check de Vercel `Vercel Preview Comments` terminó correctamente. | No es una ejecución de pruebas/build del frontend. |
| BK_HS, BD_HS, Firmaware_HS y DOCS_HS `main` | No se encontraron check-runs ni contextos de estado en las consultas efectuadas. | No equivale a CI aprobado. |

Los enlaces consultados para PT_HS están en [Actions](https://github.com/joseale879/PT_HS/actions). Los demás detalles de prueba y sus límites están en `05-test-documentation/`.

## Archivos y evidencias preparados

- Requisitos y matriz de cobertura.
- Análisis del sistema y vistas de proceso.
- Propuesta técnica.
- Diseño, diagramas editables, modelo ER conceptual e inventario estático de base de datos.
- Plan de pruebas, resultados históricos, reproducibilidad y evidencia de CI acotada.
- Procedimiento de implementación, instalación y operación.
- Registro de acciones correctivas, preventivas y de mejora.
- Manuales técnico, de instalación y de usuario.
- Artículo del proyecto.
- Índice de videos y enlace recibido.
- Roster de aprendices/instructores y borrador de registro del software.
- Inventario de repositorios, tags y checklist de artefactos.

Los documentos deben distinguir resultados observados, datos históricos, reportes del equipo e ítems pendientes. Una implementación, una ejecución aislada o una confirmación verbal no sustituyen evidencia de la versión candidata.

## Pendientes para cerrar la entrega

1. Confirmar con los proveedores la revocación de credenciales antiguas y revisar la limpieza del historial publicado según el plan del equipo. No incluir valores secretos.
2. Aprobar el SHA candidato y el conjunto de repositorios que se entregará. Resolver las diferencias entre `main` y los tags remotos existentes sin moverlos ni recrearlos como parte de esta revisión.
3. Aclarar el estado combinado `pending` de PT_HS y obtener evidencia de CI para todos los repositorios incluidos, en los SHA exactos de entrega.
4. Adjuntar evidencia del flujo físico ESP32–Flespi: TLS, ACL, telemetría, estado y comando autorizado, sin exponer tokens.
5. Documentar la prueba de medición pausada y alerta de fuga con lecturas, alerta y resultado visible.
6. Completar evidencia de entrega de correos por Brevo y de respaldo/restauración de PostgreSQL.
7. Regenerar los PDF cuyas fuentes cambien y revisar todas sus páginas; cotejar manuales y diagramas con el SHA candidato.
8. Confirmar nombres, responsabilidades, aportes, autoría, productor, titularidad y campos institucionales con aprendices e instructor.
9. Verificar enlaces y completar los videos obligatorios de pitch (1–2 minutos) y tutorial (3–5 minutos).
10. Preparar exportaciones, revisar secretos/datos personales y generar SHA-256. Crear o actualizar el tag/Release únicamente tras el cierre y la aprobación formal.

## Control de versión documental

Los PDF son copias de lectura derivadas de Markdown. Si se modifica una fuente, se debe regenerar y revisar su PDF correspondiente antes de cerrar el paquete. Los cambios de esta revisión son locales y continúan siendo borradores hasta la aprobación del equipo y del instructor.
