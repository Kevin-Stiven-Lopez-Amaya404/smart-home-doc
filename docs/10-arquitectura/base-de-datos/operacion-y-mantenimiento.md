---
title: Operación y mantenimiento de datos
status: borrador
owner: datos
last_reviewed: 2026-10-29
canonical_for:
  - operacion-base-datos
---

# Operación y mantenimiento de datos

## Entorno real pendiente de verificación

Las configuraciones inspeccionadas no prueban que exista un despliegue activo, una copia utilizable, alertas o mantenimiento periódico. No se usaron los scripts temporales ni archivos .env del checkout local para inferir estado productivo.

La navegación operativa común permanece en [operación central](../../40-operacion/README.md); esta página describe condiciones específicas de PostgreSQL y sus fuentes.

## Roles y conexiones

Separar migración, aplicación, ingestión, métricas y operaciones MQTT. El script productivo solo provisiona dos LOGIN básicos. Las cuentas de roles MQTT, auditoría y redes necesitan verificación específica.

Antes de investigar permisos comprobar session_user, current_user, membresías, propietario y BYPASSRLS. No ocultar una conexión privilegiada con SET ROLE al evaluar aislamiento.

Fuentes: [provisión](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/provision-runtime-roles.sql), [auditoría general](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/audit-runtime-roles.sql), [auditoría de revocación](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/audit-mqtt-revocation.sql).

## Particiones y retención

consumption.consumption conserva una DEFAULT. fn_ensure_consumption_partitions(2) crea mes actual y dos futuros, con límite de 24 y calendario UTC. Debe planificarse antes de que DEFAULT acumule filas del rango a materializar; la función no incluye un proceso que redistribuya esos datos.

La guía local recomienda invocación al iniciar un worker y periódicamente. No se verificó un scheduler que la ejecute. La retención de telemetría cruda y auditoría se expresa en documentos, no en un job Liquibase de purga.

Fuente: [función de particiones](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/005_consumption_partition_functions.sql), [criterios documentados de operación](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/OPERACION_Y_RETENCION.md). Las recomendaciones de retención no se presentan como reglas de producto aprobadas.

## Backup y restauración

sync.backup guarda metadata; no realiza pg_dump, snapshots o restauraciones. El procedimiento se consulta en [backup y restauración](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/BACKUP_AND_RESTORE.md); su propia advertencia indica que no hay restaurabilidad demostrada.

La [guía central de copias](../../40-operacion/copias-de-seguridad.md) registra pendientes de periodicidad, retención y RPO/RTO. No se fabricó una copia ni un resultado de restauración para completar la documentación.

## Despliegue y observabilidad

El workflow de datos tiene deploy con if: false. La etapa de validación declara una base PostgreSQL 18 desechable; su presencia no prueba que la última ejecución haya pasado. El grupo concurrency no coordina automáticamente workflows de otros repositorios.

El healthcheck local usa pg_isready; el backend productivo consulta /health/ready, cuyo SELECT 1 no valida todo el historial Liquibase, todas las cuentas ni MQTT/SMTP.

Fuentes: [workflow](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/.github/workflows/ci-deploy.yml), [Compose](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml), [salud central](../../40-operacion/monitoreo-y-salud.md).

## Diagnóstico por síntoma

| Síntoma | Revisar |
| --- | --- |
| Migración falla por esquema/objeto existente | Historial y precondiciones; SQL028 rechaza ciertos objetos/roles preexistentes |
| Error de checksum | Comparar archivo aplicado y actual; no borrar historial ni marcar cambios ejecutados para ocultarlo |
| Filas invisibles | LOGIN, contexto transaccional, membresías, permisos de hogar/dispositivo y políticas |
| Error de unicidad en fabricante | Identidad activa y registro previo eliminado/revocado; no liberar una identidad sin evidencia |
| Fallo al crear partición | Rango, filas en DEFAULT, permisos y momento del mantenimiento |
| Permiso denegado en worker MQTT | Rol de propósito correcto y función vigente; SQL032 retira acceso directo a funciones antiguas |
| Guía pide logs de postgres productivo | Ese servicio no existe en el Compose de producción; la base es externa |

La [guía local de diagnóstico](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/TROUBLESHOOTING.md) aún incluye postgres en un comando de logs productivo y menciona un broker específico sin demostrar que sea el configurado. Revisar esos apartados con el Compose y el backend actuales.

## Pendientes

Probar mantenimiento/retención, restauración, roles de propósito, monitoreo y recuperación sobre un entorno identificado. No se ejecutaron comandos contra la instalación existente ni se cambió la infraestructura.

[Hallazgos](hallazgos-y-pendientes.md). [Pruebas](pruebas-y-verificacion.md).
