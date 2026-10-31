---
title: Persistencia y datos
status: borrador
owner: datos
last_reviewed: 2026-10-29
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

Implementación: [changelog maestro](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/changelog/changelog-master.yaml) y SQL referenciado, commit `6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878` de dev. main de datos solo contiene README. El checkout local 03-dev tiene cambios previos y se conservó.

El recorrido estático localiza 96 changesets, 33 nombres de tabla incluida DEFAULT y contratos de permisos/pairing. No acredita una base instalada. Las migraciones y scripts ejecutables se mantienen en smarthome-database; la explicación técnica y la navegación se mantienen aquí.

## Modelo y seguridad

Ocho esquemas separan identidad, hogares, dispositivos, consumo, notificaciones, configuración, metadata de copias y auditoría. El historial añade permisos por hogar/dispositivo, sesiones e identidades MQTT y SQL034 para tarifa referencial/meta mensual. device_type se elimina después de crearse en el baseline.

Los roles funcionales y técnicos son distintos. RLS depende de privilegios y contexto transaccional; no está habilitado en todas las tablas. Revisar LOGIN, propietarios y contratos SQL antes de asumir aislamiento.

## Entornos y pendientes

Local declara PostgreSQL 16; CI usa 18; producción utiliza un servidor existente de versión no comprobada. No se ejecutaron migraciones, SQL de prueba o restauraciones.

Resolver SQL028 incluida aunque se comenta como propuesta separada, ausencia de rollback en 030/031, diferencias de wrappers/CI y permisos de detalle frente a realtime. Fuentes y criterios de cierre en [hallazgos](base-de-datos/hallazgos-y-pendientes.md).
