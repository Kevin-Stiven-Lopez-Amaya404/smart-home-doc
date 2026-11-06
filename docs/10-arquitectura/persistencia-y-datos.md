---
title: Persistencia y datos
status: borrador
owner: datos
last_reviewed: 2026-11-05
canonical_for:
  - persistencia-datos
---

# Persistencia y datos

## Documentación técnica central

La [documentación completa de smarthome-database](base-de-datos/README.md) vive en este repositorio junto a la [referencia del backend](backend/referencia-tecnica.md).

| Necesidad | Documento |
| --- | --- |
| Comprender organización y versiones | [Arquitectura y estructura](base-de-datos/arquitectura-y-estructura.md) |
| Consultar entidades, columnas y relaciones | [Modelo](base-de-datos/modelo-de-datos.md) y [diccionario](base-de-datos/diccionario-de-datos.md) |
| Integrar contratos SQL | [Funciones y flujos](base-de-datos/funciones-y-flujos.md) |
| Revisar autorización | [Roles, permisos y RLS](base-de-datos/seguridad-y-permisos.md) |
| Evolucionar esquema | [Migraciones y rollbacks](base-de-datos/migraciones-y-rollbacks.md) |
| Preparar entorno | [Configuración y ejecución](base-de-datos/configuracion-y-ejecucion.md) |
| Operar o probar | [Mantenimiento](base-de-datos/operacion-y-mantenimiento.md) y [pruebas](base-de-datos/pruebas-y-verificacion.md) |
| Revisar diferencias y cobertura | [Hallazgos](base-de-datos/hallazgos-y-pendientes.md) e [inventario](base-de-datos/inventario-de-archivos.md) |

## Fuente de verdad

Implementación: [changelog maestro](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/changelog/changelog-master.yaml) y SQL referenciado, rama `dev`, commit `3b20c9177a9aabfcc285043a6d85048bb1b95b7a`. El inventario estructural detallado anterior está fijado a `6caed6b` y SQL035–SQL037 se documentan como delta actual. No se inspeccionó aquí el contenido de `main` como fuente de cambios.

El recorrido estático actual tiene 99 changesets, 45 changelogs, 34 nombres de tabla incluida DEFAULT y 301 columnas declaradas. SQL035 incorpora el ledger `consumption.mqtt_ingest_dedup`; no acredita una base instalada ni migración aplicada. Las migraciones y scripts ejecutables se mantienen en smarthome-database; la explicación técnica y la navegación se mantienen aquí.

## Modelo y seguridad

Ocho esquemas separan identidad, hogares, dispositivos, consumo, notificaciones, configuración, metadata de copias y auditoría. El historial añade permisos por hogar/dispositivo, sesiones e identidades MQTT y SQL034 para tarifa referencial/meta mensual. SQL035–SQL036 agregan deduplicación durable y orden de eventos de origen para el flujo Flespi. `device_type` se elimina después de crearse en el baseline. Los endpoints de tarifa/meta/resumen están implementados por el backend y se describen en el [contrato REST de energía](../20-contratos/api-rest/energia.md).

Los roles funcionales y técnicos son distintos. RLS depende de privilegios y contexto transaccional; no está habilitado en todas las tablas. Revisar LOGIN, propietarios y contratos SQL antes de asumir aislamiento.

## Entornos y pendientes

Local declara PostgreSQL 16; la CI actual usa PostgreSQL 18 desechable. El Compose de producción define Liquibase de inspección con `validate` contra una instancia existente; la versión y estado de esa instancia no se comprobaron. No se ejecutaron migraciones, SQL de prueba o restauraciones.

Pendientes: definir recuperación para SQL030, SQL031 y SQL037 sin rollback, revisar SQL028 contra el gate real de despliegue, validar permisos entre lectura de consumo y realtime, y contrastar la instalación. Fuentes y criterios de cierre en [hallazgos](base-de-datos/hallazgos-y-pendientes.md).
