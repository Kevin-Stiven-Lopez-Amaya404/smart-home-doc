---
title: Hallazgos y pendientes de base de datos
status: borrador
owner: datos
last_reviewed: 2026-11-05
canonical_for:
  - hallazgos-base-datos
---

# Hallazgos y pendientes de base de datos

Esta revisión toma como referencia la rama `dev` del repositorio de base de datos en `3b20c9177a9aabfcc285043a6d85048bb1b95b7a`, el backend en `60297c361e4acac6e98161337ef8e149e069d441` y el frontend web en `7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac`. Los puntos descritos como históricos pertenecen a la revisión anterior del 29 de octubre y no se presentan como hallazgos revalidados.

## DB01 — README y modelo de energía

**Cerrado en la rama revisada.** El [README actual](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/README.md) ya incluye tarifas y metas incorporadas por SQL034. La documentación central y el contrato REST describen por separado el esquema y los endpoints disponibles; SQL por sí solo no acredita una API.

## DB02 — Cobertura de rollback

**Confirmado.** SQL035 y SQL036 declaran rollback. SQL037 no lo declara, al igual que SQL030 y SQL031. De los 99 changesets actuales, 95 tienen rollback declarado y uno usa `SELECT 1` como rollback intencional sin revertir esquema. No documentar cobertura completa: indicar la excepción y acordar recuperación para los tres changesets sin rollback.

Fuentes: [SQL035](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/035_flespi_mqtt_ingest_idempotency/changelog.yaml), [SQL036](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/036_flespi_mqtt_event_order/changelog.yaml), [SQL037](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/037_mqtt_lease_quarantine_least_privilege/changelog.yaml), [SQL030](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/030_mqtt_enable_fencing/changelog.yaml) y [SQL031](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/031_mqtt_bootstrap_authorization/changelog.yaml).

## DB03 — Uso productivo de SQL028

**Pendiente de validar contra el entorno.** La documentación de la release SQL028 la presenta como propuesta y su inclusión en el maestro no prueba que haya sido aplicada o aprobada para producción. Antes de describir su estado operativo, contrastar la release con el historial de la base desplegada y su gate de aprobación.

Fuente: [SQL028](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/028_mqtt_preparation_secret/001_mqtt_preparation_secret.sql).

## DB04 — Wrapper de actualización

**Corregido en la rama revisada.** `scripts/update.ps1` valida configuración y migraciones y solo aplica cambios con `-Apply` más la confirmación `APLICAR-LOCAL`; comprueba `LASTEXITCODE`. La guía debe presentar ese flujo protegido y no el comportamiento observado en la instantánea anterior.

Fuente: [scripts/update.ps1](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/scripts/update.ps1).

## DB05 — CI y alcance de sus comprobaciones

**Actualizado.** El workflow de `dev` aplica las migraciones en una base PostgreSQL 18 desechable y audita roles y SQL037. Es validación de CI, no despliegue de producción ni comprobación de la instalación real. Documentar ese alcance sin atribuirle pruebas que el workflow no ejecuta.

Fuente: [workflow ci-dev](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/.github/workflows/ci-dev.yml).

## DB06 — Compose de producción

**La guía debe describir inspección, no despliegue.** El Compose actual solo define Liquibase en el perfil `database-inspection`, monta configuración en modo de solo lectura y valida el changelog. No crea PostgreSQL, no aprovisiona roles y no despliega los servicios de aplicación. La base de producción es externa a este Compose.

Fuente: [docker-compose.production.yml](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.production.yml).

## DB07 y DB08 — Permisos realtime y cobertura de auditoría

Estos dos riesgos proceden de la revisión anterior basada en `6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878`. Se conservan como pendientes de una revisión transversal con pruebas de autorización positivas y negativas; esta revisión documental no afirma que sean fallos explotables ni que hayan sido resueltos.

Fuentes históricas: [helpers de permisos](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql), [destinatarios realtime](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/033_mqtt_ingest_realtime/001_mqtt_ingest_realtime.sql) y [auditoría de roles](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/audit-runtime-roles.sql).

## DB09 — Prisma y catálogo SQL

**Alcance documentado.** El inventario estático actual contiene 34 tablas y 301 columnas; la nueva tabla `consumption.mqtt_ingest_dedup` se añade en SQL035 y `device_event_ts` se incorpora al flujo de orden en SQL036. El modelo Prisma del backend no representa necesariamente todos los objetos SQL porque parte del acceso MQTT usa SQL directo. Mantener separados el inventario físico, los modelos ORM y los contratos de API.

Fuentes: [SQL035](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/035_flespi_mqtt_ingest_idempotency/001_mqtt_ingest_dedup.sql), [SQL036](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/036_flespi_mqtt_event_order/001_flespi_event_order.sql) y [schema Prisma](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/prisma/schema.prisma).

## DB10 — Inventario y evidencia de pruebas

El maestro revisado tiene 99 changesets. Los informes históricos que describen 64 o 96 changesets son evidencia de otras revisiones, no una descripción del maestro actual. El conteo estructural de esta documentación debe actualizarse solo desde un commit identificado y no implica ejecución de pruebas en el entorno desplegado.

Fuente: [maestro de changelogs](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/changelog/changelog-master.yaml).

## DB11 — Variables de JWT en Compose

La revisión actual de `docker-compose.production.yml` ya no muestra la exigencia `JWT_REFRESH_SECRET` señalada en la instantánea anterior. Mantener la fuente central de variables enlazada a los ejemplos vigentes de cada servicio.

## DB12 — Estado de la instalación real

No se verificó el estado de una instalación desplegada: versión PostgreSQL efectiva, historial aplicado, propietarios y roles `LOGIN`, ACL del broker, certificados, tareas periódicas o restauración. Para cerrar este pendiente se requiere evidencia del entorno, con commit, fecha y procedimiento registrados.

## Criterio de cierre

Registrar commit, entorno aislado, procedimiento y resultados reales. Una corrección documental no equivale a una migración aplicada, una autorización aprobada ni un ADR aceptado.

[Pruebas y verificación](pruebas-y-verificacion.md). [Índice](README.md).
