---
title: Documentación técnica de la base de datos
status: borrador
owner: datos
last_reviewed: 2026-10-29
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

## Revisión y autoridad

- Repositorio: [nataliachala1/smarthome-database](https://github.com/nataliachala1/smarthome-database).
- Rama analizada: **dev**, commit `6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878`.
- Se enumeraron 332 archivos y se recuperó el contenido de 288 archivos, excluidos 44 marcadores .gitkeep. La revisión combina lectura selectiva y extracción estática; no acredita una ejecución SQL.
- Se recorrieron 42 changelogs y 96 changesets desde el maestro; todos los archivos referenciados se localizaron.
- main solo contiene README.md. El árbol de feat/034-energy-tariff-budget coincide con dev; 16-dev tiene 58 archivos menos y 57 archivos con contenido distinto.

El checkout local de datos está en 03-dev con cambios previos y no representa esa instantánea. Se conservó sin alterarlo. Esta entrega se prepara en la rama **docs/db** de la central, desde origin/main `c5ba34a1f99ecaab3717fe9fe7028192262dae96`.

## Estado

Borrador verificado estáticamente. No se ejecutaron Liquibase, PostgreSQL, restauraciones o suites de integración. No se presupone una instalación productiva ni se convierten informes históricos en resultados actuales.

Fuente principal: [changelog maestro](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/changelog/changelog-master.yaml). Los [resultados estructurales](inventario-estructural.json) distinguen observaciones estáticas de catálogo instalado.

Para actualizar: elegir commit, volver a recorrer el changelog, revisar cambios y contratos con el backend y regenerar inventario/enlaces. Resolver los pendientes antes de promover el estado documental.

[Volver a persistencia y datos](../persistencia-y-datos.md).
