# Diseño del software

## Contenido de esta carpeta

- [Documento de diseño](software-design.md): arquitectura, componentes, patrones y decisiones de diseño.
- [Arquitectura](architecture.md): límites de componentes, comunicación y flujos principales.
- [Modelo entidad-relación](entity-relationship.md): modelo conceptual y relaciones principales.
- [Inventario de tablas](database-schema-inventory.md): recuento estático de 57 tablas en nueve esquemas, derivado de las migraciones presentes en PT_HS.
- [Wireframe](ui-wireframe.md) y [PDF fuente del wireframe](ui-wireframe.pdf).
- `diagrams/`: diagramas editables Draw.io y sus fuentes Markdown: casos de uso, actividades, secuencia, componentes, despliegue, estado del dispositivo y dominio.
- `software-design.pdf`: copia de lectura generada el 2026-11-05 desde las fuentes actuales; regenerarla si cambia el Markdown. Sigue siendo un borrador, no una versión aprobada.

## Alcance y límites

El corte de referencia es PT_HS `main`, SHA `32be1cf787f20120dfd3b4cc72226dab55d88216`, consultado el 2026-11-05. HU-21 actualiza la carga del perfil dentro del frontend; no altera los componentes principales ni las migraciones inventariadas. El inventario se obtuvo estáticamente de `BD_HS/01_ddl`; no es una consulta a Neon y no incluye un diccionario exhaustivo de columnas. El diagrama ER se presenta como modelo conceptual, no como representación física completa. Los diagramas describen el sistema y requieren cotejo final con la versión aprobada.

## Para cerrar

Validar arquitectura y patrones con el código final, revisar relaciones y diagramas con BD_HS, confirmar que el wireframe corresponde a la interfaz vigente y volver a generar el PDF si cambia alguna fuente.
