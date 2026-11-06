---
title: Arquitectura y estructura del repositorio de datos
status: borrador
owner: datos
last_reviewed: 2026-11-05
canonical_for:
  - arquitectura-base-datos
---

# Arquitectura y estructura del repositorio de datos

## Qué implementa

El repositorio `smarthome-database` mantiene el esquema PostgreSQL, sus migraciones Liquibase, los roles y permisos SQL, fixtures, auditorías y scripts de operación. No contiene una aplicación HTTP. La API se implementa en el backend y su contrato común se documenta en [API REST](../../20-contratos/api-rest/README.md).

La fuente de orden es el [changelog maestro de `dev`](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/changelog/changelog-master.yaml). El corte revisado contiene 45 changelogs y 99 changesets. Los nombres numéricos de releases no sustituyen el orden definido por ese maestro.

## Arquitectura observada

- Esquemas de dominio: `auth`, `homes`, `devices`, `consumption`, `notifications`, `sync`, `config` e `identity_audit`.
- Integridad mediante claves primarias y foráneas, restricciones `UNIQUE` y `CHECK`, e índices parciales.
- RLS y privilegios por tabla/columna, además de funciones SQL de propósito específico.
- Lecturas de consumo particionadas por `read_at`; las particiones dinámicas no se cuentan como objetos versionados individuales.
- Flujos MQTT de pairing, revocación y leases respaldados por reservas, locks y auditoría persistente.
- SQL035 añade `consumption.mqtt_ingest_dedup` para deduplicación; SQL036 añade acceso acotado a timestamp de origen e índice de orden.

Son patrones observados en código, no decisiones ADR aceptadas ni evidencia de un entorno desplegado. La existencia de una tabla no demuestra que un worker activo la use.

## Estructura principal

| Ruta | Propósito |
| --- | --- |
| `01_ddl/00_extensions` a `01_ddl/11_refactors` | Esquemas, tablas, relaciones, funciones, triggers, índices y refactors. |
| `02_dml` | Catálogos iniciales y datos de referencia. |
| `03_dcl` | Roles, grants y políticas RLS. |
| `04_tcl`, `05_rollbacks` | Carpeta TCL no incluida en el maestro y rollbacks versionados. |
| `releases` | Cambios posteriores agrupados en changelog y SQL por release; incluye SQL035–SQL037. |
| `scripts` | Wrappers Liquibase, fixtures, auditorías y utilidades de roles. |
| `tests/mqtt` | Baselines reducidos, configuración de fixture Mosquitto y regresiones SQL. |
| `docs` | Guías de operación e informes propios del repositorio de datos. |
| `docker-compose.yml` | PostgreSQL 16 Alpine, Mosquitto 2 y Liquibase 4.29 para el entorno local. |
| `docker-compose.production.yml` | Servicio Liquibase de inspección sobre PostgreSQL y red externos; perfil `database-inspection`, montaje de solo lectura y `validate`. |
| `.github/workflows/ci-dev.yml` | Validación y aplicación en PostgreSQL 18 desechable; auditorías de CI, sin despliegue productivo. |

El [inventario de archivos](inventario-de-archivos.md) registra el árbol histórico completo del corte `6caed6b`. Los archivos SQL035–SQL037 y el estado actual se describen en [migraciones](migraciones-y-rollbacks.md) y en el [informe de alineación](../../00-contexto/revision-alineacion-implementaciones-2026-11-05.md).

## Entornos y operación

El Compose local usa el puerto PostgreSQL `5432` por defecto y Mosquitto en `1883`; Liquibase está en el perfil `migration-tools` y su comando inicial valida, sin aplicar cambios. El workflow actual usa PostgreSQL 18 desechable. El Compose de producción no crea la base, no aprovisiona roles ni despliega aplicaciones; valida el changelog contra una instancia existente y no publica puertos.

El script actual `scripts/update.ps1` valida configuración y SQL y requiere `-Apply` más `APLICAR-LOCAL` para ejecutar la migración. Estas características describen archivos versionados, no prueban la versión, permisos, historial o estado de una base desplegada.

Fuentes: [Compose local](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.yml), [Compose de producción](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.production.yml), [workflow CI DEV](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/.github/workflows/ci-dev.yml) y [script update.ps1](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/scripts/update.ps1).

[Modelo relacional](modelo-de-datos.md). [Configuración y ejecución](configuracion-y-ejecucion.md). [Hallazgos pendientes](hallazgos-y-pendientes.md).
