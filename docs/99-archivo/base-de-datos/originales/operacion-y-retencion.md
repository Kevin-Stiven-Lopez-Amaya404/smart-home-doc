---
title: "Operación y retención (archivado)"
status: obsoleto
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - archivo-bd-operacion-y-retencion
---

# Operación y retención

> **Estado documental:** obsoleto (histórico/no canónico). Estado del punto 2: vigente parcial.
>
> **Origen:** [OPERACION_Y_RETENCION.md](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/OPERACION_Y_RETENCION.md), ruta original `OPERACION_Y_RETENCION.md`, SHA-256 `223e57ab21cb7efa927f026ec2eb00799c6e1aa2d5b499ce6869c50463b575c5`, blob `7e421b16ba5d153452a50f6e48adec5bbd4e95a0`.
>
> **Sustituto:** [operacion-y-mantenimiento](../../../10-arquitectura/base-de-datos/operacion-y-mantenimiento.md); [copias-de-seguridad](../../../40-operacion/copias-de-seguridad.md).
>
> El contenido se conserva sin cambios, salvo los enlaces relativos indicados en el punto 4 de la ficha. El original se retirará del repositorio de base de datos solo tras fusionar este PR.

## Telemetría cruda

`devices.device_telemetry_raw` es diagnóstica y no debe crecer indefinidamente. El baseline no ejecuta purgas mediante Liquibase. El worker/operación técnica debe aplicar una retención configurable; valor inicial recomendado para desarrollo: 30 días.

## Auditoría

`identity_audit.audit_log` es append-only para los roles de aplicación. Debe conservarse al menos 12 meses antes de cualquier archivado/purga autorizado por infraestructura.

## Particiones de consumo

El baseline conserva una partición `DEFAULT` como red de seguridad. Antes de habilitar la ingesta, y luego de forma periódica, `smarthome_worker` debe ejecutar:

```sql
SELECT consumption.fn_ensure_consumption_partitions(2);
```

## Backups

`sync.backup` solo registra metadata. `pg_dump`, `pg_restore`, snapshots u otros mecanismos de infraestructura realizan el backup/restauración reales.

La llamada debe realizarse antes de que la partición `DEFAULT` acumule filas del mes que se desea materializar; en producción se recomienda ejecutar el mantenimiento al arrancar el worker y al menos una vez al mes.
