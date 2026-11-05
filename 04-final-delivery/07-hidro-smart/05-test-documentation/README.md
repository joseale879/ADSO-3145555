# Documentación de pruebas

## Contenido de esta carpeta

- [Plan y resultados documentados](test-plan-results.md): alcance, casos y estado de evidencia disponible.
- [Reproducibilidad](test-reproducibility.md): entorno, ejecución desde clon y límites actuales.
- [Evidencia de CI de HU-20](ci-evidence-hu-20.md): referencia de una ejecución asociada a la rama de desarrollo, no al futuro commit final.
- `test-documentation.pdf`: copia de lectura generada el 2026-11-04 desde las fuentes actuales; regenerarla si cambia el Markdown. Sigue siendo un borrador, no una versión aprobada.

## Estado de evidencia

La documentación de pruebas está escrita, pero no equivale a una corrida integral reciente. La CI de HU-20 no demuestra que el commit final tenga CI verde. Las pruebas físicas de ESP32, MQTT/Flespi y correo requieren evidencias fechadas del ensayo real; no se afirman como completadas en este paquete.

## Para cerrar

Ejecutar los casos en el commit candidato, conservar logs/capturas sin secretos ni datos personales, vincular resultados a cada caso y regenerar el PDF.
