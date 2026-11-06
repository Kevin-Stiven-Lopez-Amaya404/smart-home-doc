---
title: Ficha histórica — auditoría técnica web de 2026-10-25
status: borrador
owner: documentacion
last_reviewed: 2026-11-05
canonical_for:
  - ficha-historica-auditoria-web-2026-10-25
---

# Ficha histórica — Auditoría técnica web del 25 de octubre de 2026

## Procedencia y alcance

Fuente íntegra: [AUDITORIA_TECNICA_FRONTEND_2026-10-25.md](https://github.com/nataliachala1/smarthome-frontend-web/blob/76ac5d0d1e73df086566cf610bf941d3efc8ccf1/AUDITORIA_TECNICA_FRONTEND_2026-10-25.md), blob Git `42ac0148b14b5f6834fd78571c2ca9d79d42b1ce`. Documento de 120 líneas, leído en el commit fijo `76ac5d0` de la rama `dev`. **Esta ficha es una síntesis, no una copia del archivo original.** El original sigue en el repositorio web y no debe eliminarse hasta preservarlo íntegramente y verificar su identidad.

## Contenido que registra el documento original

- Auditoría de React, TypeScript, Vite, ESLint, autenticación, cliente HTTP, Socket.IO, rutas, pairing Shelly, Docker y lockfiles.
- Inventario de ramas, historial Git y PR; observa que `main` y `dev` tenían historiales divergentes.
- Advertencia específica sobre el PR #3 de reversión de `12-dev`: la descripción de mejoras no correspondía con el efecto de su diff y podía retirar funciones vigentes.
- Tabla de hallazgos, medidas correctivas, pruebas de validación, orden sugerido de trabajo y pendientes antes de considerar cerrada la auditoría.
- Expone que se prepararon correcciones en una rama aislada, **no** que todas ellas estuvieran presentes en la rama `dev` auditada.

## Precaución de interpretación

El documento fue escrito el 2026-10-25 y cita commits, PR y resultados de CI de ese corte. **Sus afirmaciones de estado no son un informe actual del proyecto**. No utilizar sus listados históricos como prueba de que una vulnerabilidad sigue abierta, de que un PR sigue en Draft o de que una corrección está fusionada hoy.

Fuente de verdad para comportamiento actual: código y pruebas del repositorio web; arquitectura central en [frontend-web.md](../../10-arquitectura/web/README.md). El retiro del original sigue pendiente según [manifiesto](manifiesto-limpieza-2026-11-04.md).
