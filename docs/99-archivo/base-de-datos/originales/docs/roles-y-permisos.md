---
title: "Roles y permisos del hogar (archivado)"
status: obsoleto
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - archivo-bd-roles-y-permisos
---

# Roles y permisos del hogar

> **Estado documental:** obsoleto (histórico/no canónico). Estado del punto 2: vigente.
>
> **Origen:** [docs/ROLES_Y_PERMISOS.md](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/ROLES_Y_PERMISOS.md), ruta original `docs/ROLES_Y_PERMISOS.md`, SHA-256 `1e5a2c35f4e52864c8b09d19fdb0c61a2c79c678eb2a4c94e6b88ecd24d5e319`, blob `2cdff082405fa4594a0de6195d9843ad756e11ef`.
>
> **Sustituto:** [roles-y-permisos](../../../../60-producto-procesos/roles-y-permisos.md).
>
> El contenido se conserva sin cambios, salvo los enlaces relativos indicados en el punto 4 de la ficha. El original se retirará del repositorio de base de datos solo tras fusionar este PR.

`OWNER`, `MEMBER` y `GUEST` son roles de hogar. El rol determina las responsabilidades y permisos iniciales; los permisos concedidos determinan el acceso efectivo de `MEMBER` y `GUEST`. Administrar el hogar, consultar información y controlar dispositivos son capacidades separadas.

| Rol | Administración | Consulta | Control |
| --- | --- | --- | --- |
| `OWNER` | Administra el hogar y sus miembros; invita usuarios y administra dispositivos Shelly. | Consulta los dispositivos y el consumo del hogar. | Puede controlar los dispositivos del hogar. |
| `MEMBER` | No administra la propiedad, propietarios, miembros ni invitaciones. | Permiso base: dispositivos y consumo; puede limitarse por hogar o dispositivo. | Permiso base concedido; puede limitarse o revocarse. |
| `GUEST` | No administra el hogar, configuración, miembros ni invitaciones. | Permiso base para dispositivos. Consumo exclusivamente agregado al hogar y al período consultado. | Sin permiso base; `OWNER` puede conceder control por dispositivo. |

El permiso de consulta no concede control y el control no concede lectura. Las excepciones por dispositivo reemplazan la base del hogar para consultar información del dispositivo, consultar su consumo detallado o controlarlo. Los valores heredados usan la base del hogar. Para `GUEST`, una excepción jamás habilita lecturas o históricos de consumo por dispositivo.

Las bases iniciales se crean automáticamente al insertar una membresía `MEMBER` o `GUEST`. Un cambio de rol reinicia los valores base del rol y elimina excepciones anteriores. `OWNER` gestiona permisos con las funciones SQL protegidas `homes.fn_get_member_permissions`, `homes.fn_set_member_permissions`, `homes.fn_get_device_permissions` y `homes.fn_set_device_permissions`; las tablas internas no conceden DML directo a `smarthome_runtime_app`.

La base filtra dispositivos, consumo e historial con RLS y funciones de autorización. Las operaciones de control usan una función `SECURITY DEFINER` que entrega únicamente la fila necesaria si el usuario cuenta con permiso de control, sin ampliar el `SELECT` general.
