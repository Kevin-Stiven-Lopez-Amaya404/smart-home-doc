---
title: Arquitectura y estructura del repositorio de datos
status: borrador
owner: datos
last_reviewed: 2026-10-29
canonical_for:
  - arquitectura-base-datos
---

# Arquitectura y estructura del repositorio de datos

## Qué implementa

Repositorio de infraestructura y contratos SQL PostgreSQL, gestionado con Liquibase. No contiene una aplicación HTTP ni un directorio src/; sus interfaces ejecutables son tablas, funciones, permisos y scripts de operación.

El orden lo define [changelog/changelog-master.yaml](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/changelog/changelog-master.yaml): DDL, DML, DCL, refactors y releases. El nombre numérico del archivo no sustituye ese orden. Los procesos de aplicación residen en el backend, aunque varias reglas de autorización y las transiciones MQTT también están implementadas en SQL.

## Arquitectura observada

- Separación por esquemas: auth, homes, devices, consumption, notifications, sync, config e identity_audit.
- Integridad mediante PK, FK, UNIQUE, CHECK e índices parciales.
- Desactivación/borrado lógico de hogares y dispositivos, preservando referencias históricas.
- PostgreSQL RLS más privilegios por tabla/columna y funciones de propósito específico.
- Particionado de lecturas por read_at y una partición DEFAULT.
- Reservas, locks, leases y evidencia persistente para pairing/revocación MQTT.
- Changesets aditivos y puentes de compatibilidad; no todos tienen una reversión destructiva.

Son patrones observados en código, no ADR aceptados. La existencia de una tabla no prueba que haya una funcionalidad o trabajador activo que la use.

## Carpetas y archivos

| Ruta | Propósito comprobado |
| --- | --- |
| 01_ddl/00_extensions | Extensiones pgcrypto y btree_gist |
| 01_ddl/01_schemas | Creación de los ocho esquemas de dominio |
| 01_ddl/02_types | Changelog vacío; no hay tipos propios definidos aquí |
| 01_ddl/03_tables | Tablas base y algunas restricciones/índices |
| 01_ddl/04_alter | FK, ciclo de vida de dispositivos y persistencia de sesiones |
| 01_ddl/05_views, 06_materialized_views, 08_procedures | Marcadores/changelogs vacíos; no afirmar vistas o procedimientos activos |
| 01_ddl/07_functions | Helpers técnicos de autorización, timestamps y particiones |
| 01_ddl/09_triggers, 10_indexes | Triggers de updated_at e índices base |
| 01_ddl/11_refactors | Evolución posterior al DCL, incluida eliminación de device_type |
| 02_dml | Catálogos de roles y catálogo de tipos inicial; este último se elimina después |
| 03_dcl | Roles técnicos, grants y políticas RLS |
| 04_tcl | Estructura sin cambios activos; no incluida desde el maestro |
| 05_rollbacks | Reversiones explícitas de buena parte del historial base |
| releases | Incrementos posteriores, con changelog y SQL propio |
| scripts | Auditoría, fixtures, pruebas, provisión de LOGIN y wrappers Liquibase |
| tests/mqtt | Baselines reducidos, fixture Mosquitto y regresión SQL032 |
| docs y Markdown raíz | Guías locales e informes; autoridad/actualización por reconciliar |
| liquibase.properties | Defaults Liquibase; no es un archivo .env |
| docker-compose.yml | PostgreSQL local, Mosquitto y Liquibase |
| docker-compose.production.yml | Migraciones y aplicaciones sobre PostgreSQL/redes existentes |
| .github/workflows/ci-deploy.yml | Validación sobre PostgreSQL desechable y job deploy bloqueado |
| .env.example, .env.production.example | Nombres de configuración por entorno; nunca copiar secretos |

El [inventario completo](inventario-de-archivos.md) enlaza cada archivo no vacío y agrupa los marcadores.

## Diferencias de entorno

El Compose local usa postgres:16-alpine. CI usa PostgreSQL 18; producción declara un cliente postgres:18-alpine para roles y utiliza una instancia existente cuya versión no se comprobó. Liquibase se fija en 4.29. No se infiere equivalencia de esas instalaciones.

Fuentes: [local](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.yml), [producción](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml), [workflow](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/.github/workflows/ci-deploy.yml), [DDL](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/changelog.yaml).

Pendiente: instalar el historial en aislamiento y verificar catálogo efectivo, compatibilidad de versiones y permisos antes de documentar disponibilidad operacional.
