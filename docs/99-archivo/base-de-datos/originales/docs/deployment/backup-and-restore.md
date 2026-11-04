---
title: "Backup y restauración (archivado)"
status: obsoleto
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - archivo-bd-deployment-backup-and-restore
---

# Backup y restauración

> **Estado documental:** obsoleto (histórico/no canónico). Estado del punto 2: vigente como procedimiento propuesto.
>
> **Origen:** [docs/deployment/BACKUP_AND_RESTORE.md](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/deployment/BACKUP_AND_RESTORE.md), ruta original `docs/deployment/BACKUP_AND_RESTORE.md`, SHA-256 `4641f437f2a53126aac4de6bb90c337c8cbee532541fe0f912210cf1976e9b38`, blob `f8bd23c1780ccb123f0a024635baa9bb4b38911d`.
>
> **Sustituto:** [copias-de-seguridad](../../../../../40-operacion/copias-de-seguridad.md).
>
> El contenido se conserva sin cambios, salvo los enlaces relativos indicados en el punto 4 de la ficha. El original se retirará del repositorio de base de datos solo tras fusionar este PR.

El VPS reporta un backup pequeño frente al volumen PostgreSQL conocido. No se ha demostrado que ese archivo contenga una copia completa y restaurable; no debe usarse como punto de recuperación hasta probarlo.

## Crear un backup verificado

Durante la auditoría, identifica la instancia, su base y su usuario de mantenimiento antes de ejecutar `pg_dump`. Guarda el dump fuera del volumen de PostgreSQL y, preferiblemente, fuera del VPS. Conserva permisos restrictivos y registra fecha, versión del servidor, tamaño y checksum.

Ejemplo para ejecutar con los valores identificados, sin guardar contraseñas en el historial del shell:

```sh
pg_dump --format=custom --no-owner --file=smarthome-YYYYMMDDTHHMMSSZ.dump "$DATABASE_URL"
pg_restore --list smarthome-YYYYMMDDTHHMMSSZ.dump >/dev/null
sha256sum smarthome-YYYYMMDDTHHMMSSZ.dump
```

## Prueba de restauración

Restaura el dump en una base PostgreSQL aislada que no sea la producción. Usa `pg_restore --exit-on-error`, valida tablas y conteos de control y conserva el resultado de la prueba junto al registro operativo. No uses `--clean`, no apuntes la prueba a la base de producción y no elimines el dump original.

## Recuperación

Antes de recuperar, detén escrituras de la aplicación y conserva el volumen original. Restaura en una base aparte, valida los datos y coordina cualquier cambio de endpoint. La restauración no se automatiza con el despliegue.
