---
title: Persistencia y datos
status: borrador
owner: datos
last_reviewed: 2026-10-29
canonical_for:
  - persistencia-datos
---

# Persistencia y datos

## Fuente canónica

[changelog maestro](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/changelog/changelog-master.yaml) incluye DDL, DML, DCL y releases. Las migraciones permanecen en smarthome-database; esta página no replica el esquema.

El backend usa PostgreSQL mediante Prisma y SQL para funciones, permisos y operaciones de ingestión. Hay credenciales separadas por responsabilidad; consultar la configuración, sin reutilizar automáticamente un rol administrador para la aplicación.

## Modelo observado

Hogares y membresías determinan acceso a dispositivos y consultas de consumo. Las funciones SQL distinguen acceso al hogar, consumo básico, detalle y control por dispositivo. No basta un rol global USER para autorizar acceso a un hogar.

La [release 018](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql) define permisos de hogar y excepciones por dispositivo. La [release 033](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/033_mqtt_ingest_realtime/001_mqtt_ingest_realtime.sql) incorpora destinatarios realtime. Su existencia en Git no acredita que hayan sido aplicadas al entorno activo.

## Entornos

El Compose local declara PostgreSQL 16; el Compose productivo referencia una base existente y un contenedor de herramientas PostgreSQL 18 para roles, sin crear el servidor. Esto no demuestra la versión real del servidor productivo.

Fuentes: [Compose local](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.yml), [Compose de producción](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml), [referencia backend](backend/referencia-tecnica.md).

## Pendientes

Comparar historial Liquibase instalado, propietario/roles, extensiones y compatibilidad servidor/herramientas. Reconciliar permisos de consultas y destinatarios de eventos antes de afirmar equivalencia de acceso. Ver [roles](../60-producto-procesos/roles-y-permisos.md) y [copias](../40-operacion/copias-de-seguridad.md).
