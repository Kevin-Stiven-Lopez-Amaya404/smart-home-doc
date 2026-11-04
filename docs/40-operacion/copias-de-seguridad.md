---
title: Copias de seguridad y recuperación
status: borrador
owner: operacion
last_reviewed: 2026-11-04
canonical_for:
  - copias-seguridad
---

# Copias de seguridad y recuperación

## Procedimiento propuesto

**No hay evidencia de copias automáticas activas ni de una restauración probada.** El VPS llegó a reportar un backup pequeño cuya integridad no se demostró; no usarlo como punto de recuperación.

Identificar instancia, base y usuario de mantenimiento antes de ejecutar `pg_dump`. Guardar el dump fuera del volumen de PostgreSQL y, preferiblemente, fuera del servidor, con permisos restrictivos, registrando fecha, versión, tamaño y checksum. Ejemplo, con la URL tomada del entorno y sin escribir contraseñas en el historial:

```sh
pg_dump --format=custom --no-owner --file=smarthome-YYYYMMDDTHHMMSSZ.dump "$DATABASE_URL"
pg_restore --list smarthome-YYYYMMDDTHHMMSSZ.dump >/dev/null
sha256sum smarthome-YYYYMMDDTHHMMSSZ.dump
```

La prueba de restauración usa una base aislada, nunca producción: `pg_restore --exit-on-error`, sin `--clean`, validando tablas y conteos y conservando el resultado. No eliminar el dump original. Antecedente: [backup y restauración](../99-archivo/base-de-datos/originales/docs/deployment/backup-and-restore.md).

## Preparación de una prueba

Según esa fuente, primero identificar instancia, base y cuenta de mantenimiento; conservar dump fuera del volumen y preferiblemente fuera del servidor. Registrar fecha, versión, tamaño y checksum con permisos restrictivos y sin incluir contraseñas en el historial.

La validación de listado del dump no sustituye una restauración: se requiere una base aislada, revisar errores, tablas y conteos de control y guardar el resultado. No usar una base productiva como destino de la prueba.

## Recuperación y pendientes

La recuperación requiere coordinación de escrituras y conservación del original; no forma parte automática del despliegue. Antes de recuperar, detener escrituras de la aplicación y conservar el volumen original. No ejecutar operaciones de restauración por copiar un ejemplo.

Pendiente: responsable, periodicidad, retención, cifrado, ubicación externa, alcance de roles/configuración y objetivos RPO/RTO acordados. Registrar una restauración real antes de marcar el procedimiento como verificado operativamente.

Fuentes relacionadas: [requisitos de despliegue](../99-archivo/base-de-datos/originales/docs/deployment/architecture.md), [despliegue](despliegue.md), [registro de pendientes](../00-contexto/evidencias-y-pendientes.md).
