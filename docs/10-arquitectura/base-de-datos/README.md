---
title: Documentación técnica de la base de datos
status: borrador
owner: datos
last_reviewed: 2026-11-05
canonical_for:
  - indice-base-datos
---

# Documentación técnica de la base de datos

La documentación técnica de smarthome-database se mantiene aquí, en **smart-home-doc**, junto a la del backend. La implementación SQL, los scripts ejecutables y las migraciones conservan su fuente en el repositorio de datos.

## Recorrido de lectura

1. [Arquitectura, alcance y estructura](arquitectura-y-estructura.md).
2. [Modelo relacional y reglas de integridad](modelo-de-datos.md).
3. [Diccionario de columnas](diccionario-de-datos.md).
4. [Funciones, contratos SQL y flujos](funciones-y-flujos.md).
5. [Roles, permisos y RLS](seguridad-y-permisos.md).
6. [Migraciones, orden y rollbacks](migraciones-y-rollbacks.md).
7. [Configuración y ejecución](configuracion-y-ejecucion.md).
8. [Operación y mantenimiento](operacion-y-mantenimiento.md).
9. [Pruebas y verificación](pruebas-y-verificacion.md).
10. [Hallazgos y pendientes](hallazgos-y-pendientes.md).
11. [Inventario de archivos](inventario-de-archivos.md).
12. [Archivo de documentos migrados](../../99-archivo/base-de-datos/README.md).

## Revisión y autoridad

- Repositorio: [nataliachala1/smarthome-database](https://github.com/nataliachala1/smarthome-database).
- Rama analizada en este corte: **dev**, commit `3b20c9177a9aabfcc285043a6d85048bb1b95b7a`. El snapshot estructural detallado del commit `6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878` se conserva como histórico.
- El corte actual incluye SQL035–SQL037. El recorrido del changelog maestro tiene 45 changelogs y 99 changesets; SQL035 agrega `consumption.mqtt_ingest_dedup`.
- El conteo de 332 archivos, 33 tablas y 295 columnas pertenece al inventario anterior; no debe leerse como el estado del commit actual.
- La rama predeterminada es `main`; se inspeccionó `dev`, donde están las migraciones descritas. La revisión no acredita una instalación PostgreSQL ni una migración aplicada.

El checkout local de datos está en 03-dev con cambios previos y no representa esa instantánea. Se conservó sin alterarlo. La documentación se edita en el checkout disponible de `smart-home-doc` (`main`, `e1168c8`); `origin/main` está en `c9054ab`, 21 commits adelante. La sincronización local quedó pendiente porque el entorno denegó escribir `.git/ORIG_HEAD`.

## Estado

Borrador verificado estáticamente. No se ejecutaron Liquibase, PostgreSQL, restauraciones o suites de integración. No se presupone una instalación productiva ni se convierten informes históricos en resultados actuales.

Fuente principal: [changelog maestro actual](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/changelog/changelog-master.yaml). Los [resultados estructurales](inventario-estructural.json) distinguen observaciones estáticas del commit `6caed6b` frente a un catálogo instalado; el [registro de alineación](../../00-contexto/revision-alineacion-implementaciones-2026-11-05.md) describe los deltas SQL035–037.

Para actualizar: elegir commit, volver a recorrer el changelog, revisar cambios y contratos con el backend y regenerar inventario/enlaces. La operación productiva actual es solo validación de Liquibase en una red existente; ver [configuración](configuracion-y-ejecucion.md).

[Volver a persistencia y datos](../persistencia-y-datos.md).
