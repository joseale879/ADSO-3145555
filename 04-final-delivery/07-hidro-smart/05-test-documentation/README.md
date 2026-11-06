# Documentación de pruebas

## Contenido de esta carpeta

- [Plan y resultados documentados](test-plan-results.md): alcance, casos y estado de evidencia disponible.
- [Reproducibilidad](test-reproducibility.md): entorno, ejecución desde clon y límites actuales.
- [Evidencia de CI](ci-evidence.md): registra la ejecución histórica HU-20, el estado actual de PT_HS `main` en HU-21 y el corte de los componentes separados.
- `test-documentation.pdf`: copia de lectura generada el 2026-11-05 desde las fuentes actuales; regenerarla si cambia el Markdown. Sigue siendo un borrador, no una versión aprobada.

## Estado de evidencia

La documentación de pruebas está escrita, pero no equivale a una corrida integral física reciente. En PT_HS `main` (HU-21), los flujos configurados de CI y los nueve check-runs terminaron correctamente; el estado combinado de GitHub permanece `pending` sin contextos. Los repositorios separados no tienen evidencia de CI completa en los SHA actuales. Las pruebas físicas de ESP32, MQTT/Flespi y correo requieren evidencias fechadas del ensayo real; no se afirman como completadas en este paquete.

## Para cerrar

Ejecutar los casos en el commit candidato, conservar logs/capturas sin secretos ni datos personales, vincular resultados a cada caso y regenerar el PDF.
