---
title: "HU14 — Observabilidad sin cambios de base de datos (archivado)"
status: obsoleto
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - archivo-bd-hu14-observability-metrics
---

# HU14 — Observabilidad sin cambios de base de datos

> **Estado documental:** obsoleto (histórico/no canónico). Estado del punto 2: histórico.
>
> **Origen:** [docs/HU14_OBSERVABILITY_METRICS.md](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU14_OBSERVABILITY_METRICS.md), ruta original `docs/HU14_OBSERVABILITY_METRICS.md`, SHA-256 `322e8eaed46ef5176703eb38c8ba286389d63c97b69c3226fd22009cffb19626`, blob `771106dc13c829eb69cddddbd8d7356d5cbd0cb3`.
>
> **Sustituto:** [monitoreo-y-salud](../../../../40-operacion/monitoreo-y-salud.md).
>
> El contenido se conserva sin cambios, salvo los enlaces relativos indicados en el punto 4 de la ficha. El original se retirará del repositorio de base de datos solo tras fusionar este PR.

Fecha: 2026-10-15. Rama `14-dev`, derivada de `09-dev`. El incremento HU14 instrumenta solicitudes HTTP y exporta métricas de proceso desde NestJS. No añade consultas de aplicación, telemetría persistida, changesets, tablas, roles, grants, políticas RLS ni índices.

La readiness existente conserva `SELECT 1` contra PostgreSQL. El endpoint `/metrics` y las métricas de latencia/estado son responsabilidad del backend y de la plataforma de observabilidad. La guía de integración, scrape autenticado, ejemplos de alertas y límites operativos están en el backend: `docs/HU14_OBSERVABILITY_METRICS.md`.

No se ejecutó DDL ni se requiere migrar la base para este incremento. No añadir índices sin evidencia de consultas lentas y mediciones de staging.
