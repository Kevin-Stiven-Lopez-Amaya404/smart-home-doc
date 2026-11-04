---
title: Referencia individual del backend
status: borrador
owner: backend
last_reviewed: 2026-11-03
canonical_for:
  - indice-referencia-backend
---

# Referencia individual del backend

La [referencia técnica](referencia-tecnica.md) conserva el análisis de la instantánea dev `1cbaca28e9e152d5cb5ff7643560fdfa65857486`: arquitectura, endpoints, árbol completo, configuración e inconsistencias.

Es una derivación de consulta con revisión fija, no una segunda fuente de implementación. Para actualizarla: identificar commit, repetir lectura de código/DTO/configuración/pruebas, comprobar rutas y enlaces, contrastar clientes y SQL y registrar los nuevos límites.

Fuentes canónicas: [bootstrap](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/main.ts) y archivos enlazados en la referencia. No se compiló ni ejecutó el backend. Las limitaciones de la primera inspección quedan identificadas como históricas; consultar los [pendientes centrales](../../00-contexto/evidencias-y-pendientes.md).

## Copias de la documentación del backend

El 2026-11-03 se copiaron a este repositorio los nueve documentos que quedaban en `docs/` del backend (`dev` `fea0254`). Detalle y vigencia en la [matriz de migración](../../00-contexto/migracion-docs-backend.md).

| N.º | Origen en el backend | Destino |
| --- | --- | --- |
| 1 | `docs/CONSUMPTION_METRICS_WORKER.md` | [Worker de métricas de consumo del backend](../../40-operacion/backend/consumption-metrics-worker.md) |
| 2 | `docs/HU09_RATE_LIMITING.md` | [Límites de solicitudes HTTP del backend (HU09)](../../20-contratos/backend/rate-limiting.md) |
| 3 | `docs/HU09_REALTIME_SECURITY.md` | [Seguridad de sesiones y eventos Socket.IO (HU09)](seguridad-realtime.md) |
| 4 | `docs/HU09_SESSION_FAMILIES.md` | [Logout individual y familias de sesión (HU09)](../../20-contratos/backend/sesiones-y-revocacion.md) |
| 5 | `docs/HU10_MQTT_TLS_NAMESPACE.md` | [MQTT con TLS y namespace (HU10)](../../20-contratos/mqtt/tls-y-namespace.md) |
| 6 | `docs/HU16_CONSUMPTION_ACCESS.md` | [Permisos de consumo, históricos y aislamiento (HU16)](../../20-contratos/backend/acceso-a-consumo.md) |
| 7 | `docs/HU16_PAIRING_AP_SESSIONS.md` | [Sesiones backend Shelly LAN-first y AP (HU16)](../../20-contratos/shelly/pairing-lan-ap.md) |
| 8 | `docs/MQTT_CONTRACT.md` | [Contrato MQTT local del backend (archivado)](../../99-archivo/backend/mqtt-contract-2026-10-15.md) |
| 9 | `docs/ROLES_Y_PERMISOS.md` | [Roles y permisos del hogar en el backend](../../20-contratos/backend/roles-y-permisos.md) |

[Volver al resumen del backend](../backend.md).
