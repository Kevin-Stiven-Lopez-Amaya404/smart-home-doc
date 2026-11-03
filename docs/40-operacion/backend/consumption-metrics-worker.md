---
title: Worker de métricas de consumo del backend
status: borrador
owner: operacion
last_reviewed: 2026-11-03
canonical_for:
  - backend-worker-metricas-consumo
---

# Worker de métricas de consumo — habilitación controlada

> **Estado documental:** implementación documentada. **Corte original:** 2026-10-28. Copia creada el 2026-11-03 de [`docs/CONSUMPTION_METRICS_WORKER.md`](https://github.com/nataliachala1/smarthome-backend/blob/fea02540ae12ed7501ae2b75f6216ab00411796a/docs/CONSUMPTION_METRICS_WORKER.md) en `nataliachala1/smarthome-backend` (`dev` `fea0254`). Registra decisiones y resultados de su fecha; no certifica que sigan vigentes ni equivale a un contrato aprobado. Mientras exista el original en el backend, este documento es una copia.
>
> Contenido conservado íntegro; solo cambian los enlaces relativos y se corrigió la codificación de caracteres (texto UTF-8 doblemente codificado en el original). Trazabilidad en la [matriz de migración](../../00-contexto/migracion-docs-backend.md).
>
> Relación: las variables también figuran en el [catálogo de variables](../variables-de-entorno.md); este documento conserva las condiciones operativas del worker.
>
> Las instrucciones de habilitación se conservan como registro de su fecha; **no son pasos operativos actuales** sin contrastar antes con la configuración y el responsable de infraestructura.

- La ingesta MQTT sigue usando `DATABASE_IOT_URL` y guarda lecturas de manera independiente.
- Los endpoints `/consumption`, `/consumption/summary` y `/consumption/daily` consultan lecturas crudas y funcionan aunque el worker esté apagado.
- Este worker calcula agregados diarios usando una conexión **diferente**, con rol de grupo `smarthome_worker` (NOBYPASSRLS).
- Variables de entorno **del backend**:
  - `CONSUMPTION_METRICS_WORKER_ENABLED=true`
  - `DATABASE_METRICS_URL=postgresql://<login-worker>:<secret>@<servidor>:5432/<base>`
- Provisionar el usuario LOGIN dedicado y su membresía en `smarthome_worker` mediante procedimiento seguro de infraestructura. No usar `smarthome_owner`, `smarthome_ingest_login`, credenciales de usuario web ni `BYPASSRLS`.
- Al iniciar, verifica `pg_has_role(current_user,'smarthome_worker','USAGE')`; rechaza roles o nombres de BD incorrectos.
- No establecer las dos variables hasta probar el usuario con PostgreSQL de desarrollo. Si falta el URL y el worker se activa, el backend falla al arrancar (a propósito).
- Comprueba la actualización de `consumption.consumption_metric` con SQL de solo lectura en DEV; la ingesta y las APIs permanecen separadas.
- **Pendiente fuera de este incremento**: mover las alertas/anomalías al trabajador autorizado, asegurar deduplicación, y prueba física de relé y realtime web/móvil antes de merge/despliegue.
