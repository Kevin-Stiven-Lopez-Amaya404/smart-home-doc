---
title: Copias de seguridad y recuperación
status: borrador
owner: operacion
last_reviewed: 2026-10-29
canonical_for:
  - copias-seguridad
---

# Copias de seguridad y recuperación

## Fuente canónica

El procedimiento vive en [BACKUP_AND_RESTORE.md](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/BACKUP_AND_RESTORE.md) de smarthome-database. La central lo enlaza para evitar mantener dos comandos de backup divergentes.

La guía advierte que una copia pequeña reportada no se ha demostrado completa ni restaurable. Esta revisión no inspeccionó el VPS, un dump ni resultados de restauración. **No hay evidencia aquí de copias automáticas activas o recuperación probada.**

## Preparación de una prueba

Según esa fuente, primero identificar instancia, base y cuenta de mantenimiento; conservar dump fuera del volumen y preferiblemente fuera del servidor. Registrar fecha, versión, tamaño y checksum con permisos restrictivos y sin incluir contraseñas en el historial.

La validación de listado del dump no sustituye una restauración: se requiere una base aislada, revisar errores, tablas y conteos de control y guardar el resultado. No usar una base productiva como destino de la prueba.

## Recuperación y pendientes

La recuperación requiere coordinación de escrituras y conservación del original; no forma parte automática del despliegue. No ejecutar operaciones de restauración por copiar un ejemplo.

Pendiente: responsable, periodicidad, retención, cifrado, ubicación externa, alcance de roles/configuración y objetivos RPO/RTO acordados. Registrar una restauración real antes de marcar el procedimiento como verificado operativamente.

Fuentes relacionadas: [requisitos de despliegue](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/ARCHITECTURE.md), [despliegue](despliegue.md), [registro de pendientes](../00-contexto/evidencias-y-pendientes.md).
