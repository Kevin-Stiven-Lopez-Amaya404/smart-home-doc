---
title: Ficha histórica — auditoría transversal de 2026-10-08
status: borrador
owner: documentacion
last_reviewed: 2026-11-05
canonical_for:
  - ficha-historica-auditoria-transversal-2026-10-08
---

# Ficha histórica — Auditoría frontend/backend del 8 de octubre de 2026

## Procedencia y límites

Fuente íntegra: [Informe_Auditoria_SmartHome_Frontend_Backend_2026-10-08.md](https://github.com/nataliachala1/smarthome-frontend-web/blob/76ac5d0d1e73df086566cf610bf941d3efc8ccf1/Informe_Auditoria_SmartHome_Frontend_Backend_2026-10-08.md), blob Git `85afe8a8a52c7297d221b5b8dfb363857099fdfa`; 334 líneas. La revisión original fue **estática**, del frontend `12-dev` (commit `c99d191`) y backend `09-dev` (commit `8235727`), sin ejecución E2E. Esta ficha no es copia íntegra; el original permanece en el repositorio web.

## Hallazgos registrados en el informe

El informe agrupa 14 hallazgos (H1 a H14), referidos al corte del 2026-10-08, entre ellos:

- Configuración de SMTP, composición Docker, credenciales de ejemplo y diferencias entre ramas de implementación y publicación.
- Desajustes observados entre ciclo de refresh/logout de backend y frontend, permisos de control, formatos de respuesta y contratos WebSocket.
- Ausencia de evidencia concluyente sobre migraciones, protección contra abuso y verificación E2E en ese corte.
- Clientes o pantallas parciales, navegación incompleta y sospechas de información sensible en documentación o historial.

El documento además recoge rutas públicas y privadas, una matriz de integración, cinco fases de corrección y casos de prueba de aceptación recomendados.

## Interpretación segura

**No se puede afirmar que H1–H14 sigan presentes** sin volver a contrastar el código actual. El propio informe distinguía riesgos de efectos demostrados y no certificó una instalación productiva. Sus referencias a secretos de ejemplo requieren revisión antes de publicar copias literales; no reproducimos valores de configuración en esta ficha.

Ver [arquitectura web](../../10-arquitectura/frontend-web.md), [archivo web](README.md) y [manifiesto](manifiesto-limpieza-2026-11-04.md).
