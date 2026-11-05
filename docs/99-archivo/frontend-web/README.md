---
title: Archivo documental del frontend web
status: borrador
owner: documentacion
last_reviewed: 2026-11-05
canonical_for:
  - archivo-frontend-web
---

# Archivo documental del frontend web

Este directorio prepara el traslado de informes históricos del repositorio [smarthome-frontend-web](https://github.com/nataliachala1/smarthome-frontend-web/tree/76ac5d0d1e73df086566cf610bf941d3efc8ccf1) a **smart-home-doc** (singular). La arquitectura web vigente ya se describe en [frontend-web.md](../../10-arquitectura/frontend-web.md); no reemplazarla por informes históricos.

## Estado real

**Copias completas verificadas.** Los tres informes se conservan en [originales/](originales/README.md), con hashes Git idénticos a los de origen. Los originales permanecen en el frontend.

| Origen (rama dev, commit fijo) | Clasificación | Blob Git de origen |
| --- | --- | --- |
| [AUDITORIA_TECNICA_FRONTEND_2026-10-25.md](https://github.com/nataliachala1/smarthome-frontend-web/blob/76ac5d0d1e73df086566cf610bf941d3efc8ccf1/AUDITORIA_TECNICA_FRONTEND_2026-10-25.md) | Auditoría histórica | `42ac0148b14b5f6834fd78571c2ca9d79d42b1ce` |
| [FRONTEND_WEB_REFACTOR_PLAN.md](https://github.com/nataliachala1/smarthome-frontend-web/blob/76ac5d0d1e73df086566cf610bf941d3efc8ccf1/FRONTEND_WEB_REFACTOR_PLAN.md) | Propuesta de refactorización (no implementación certificada) | `221bf4b4a78acdd3bffa1dc774a15084add890a8` |
| [Informe_Auditoria_SmartHome_Frontend_Backend_2026-10-08.md](https://github.com/nataliachala1/smarthome-frontend-web/blob/76ac5d0d1e73df086566cf610bf941d3efc8ccf1/Informe_Auditoria_SmartHome_Frontend_Backend_2026-10-08.md) | Auditoría transversal histórica | `85afe8a8a52c7297d221b5b8dfb363857099fdfa` |

## Fichas de lectura verificadas (no copias originales)

- [Auditoría técnica de 2026-10-25](ficha-auditoria-tecnica-2026-10-25.md): alcance, hallazgos y estado histórico de PR.
- [Propuesta de refactorización web](ficha-plan-refactorizacion.md): alcance y fases propuestas, sin considerarlas implementadas.
- [Auditoría transversal de 2026-10-08](ficha-auditoria-transversal-2026-10-08.md): riesgos históricos de integración web/backend.

Estas tres fichas preservan contexto y enlaces por commit; **no acreditan que se haya completado el traslado literal**.

## Procedimiento

1. Copiar íntegramente cada Markdown a este archivo, sin introducir credenciales o datos privados de nueva procedencia.
2. Comparar el blob Git del original y de cada copia; si se modifica formato o enlaces, documentar las diferencias y comprobar integridad semántica.
3. Comprobar referencias entrantes, actualizar rutas y ejecutar `node scripts/check-docs.mjs` y `git diff --check`.
4. Integrar el PR documental en `smart-home-doc/main` y verificar enlaces antes de proponer la eliminación de originales en un PR independiente del frontend hacia `dev`.
5. Conservar `README.md`, `web/README.md`, licencias, `web/package-lock.json`, configuración, código y workflows necesarios en el repositorio de implementación.

[Manifiesto de candidatos de limpieza](manifiesto-limpieza-2026-11-04.md). No hay autorización aquí para eliminar código ni modificar ramas protegidas.
