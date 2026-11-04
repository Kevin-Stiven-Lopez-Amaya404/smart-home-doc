---
title: "HU16 — Permisos de hogar y excepciones por dispositivo (archivado)"
status: obsoleto
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - archivo-bd-hu16-permisos-hogar
---

# HU16 — Permisos de hogar y excepciones por dispositivo

> **Estado documental:** obsoleto (histórico/no canónico). Estado del punto 2: vigente.
>
> **Origen:** [docs/HU16_PERMISOS_HOGAR.md](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU16_PERMISOS_HOGAR.md), ruta original `docs/HU16_PERMISOS_HOGAR.md`, SHA-256 `4399e06df3ec4e4499e4b2d08852f5d9ff421fad631d3fa887c6eb16b54c8269`, blob `93c10223a7850b1df313ea8438e722af2c96b6c5`.
>
> **Sustituto:** [seguridad-y-permisos](../../../../10-arquitectura/base-de-datos/seguridad-y-permisos.md).
>
> El contenido se conserva sin cambios, salvo los enlaces relativos indicados en el punto 4 de la ficha. El original se retirará del repositorio de base de datos solo tras fusionar este PR.

La release `018_household_permissions` añade almacenamiento de permisos base por membresía y excepciones anulables por dispositivo. Las membresías anteriores reciben valores base equivalentes a su rol: `MEMBER` puede consultar y controlar; `GUEST` puede consultar y no puede controlar. Ambos pueden consultar el resumen agregado del hogar. `OWNER` conserva la administración completa.

Las excepciones por dispositivo controlan consulta descriptiva, consumo detallado y control. `NULL` hereda el permiso del hogar. Para `GUEST`, el acceso al consumo detallado sigue denegado aunque una excepción tenga `can_view_consumption = TRUE`; el endpoint agregado solo devuelve energía total y período.

Las funciones SQL de lectura y escritura verifican `OWNER`. RLS filtra los dispositivos y filas energéticas por permiso efectivo. La lectura de un dispositivo para publicar un comando de control usa `devices.fn_device_control_target`, autorizada solo por permiso de control; el endpoint no devuelve estado previo ni conectividad.

Las rutas REST de gestión y DTO están documentados en backend `docs/ROLES_Y_PERMISOS.md`. Esta release no se aplica a ninguna base activa; debe desplegarse mediante la secuencia aprobada de Liquibase en `16-dev`.
