---
title: Despliegue y condiciones de operación
status: borrador
owner: operacion
last_reviewed: 2026-11-05
canonical_for:
  - despliegue
---

# Despliegue y condiciones de operación

## Configuración disponible

El [Compose de producción actual](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.production.yml) define solo Liquibase en el perfil `database-inspection`. Monta la configuración de solo lectura y ejecuta `validate` contra PostgreSQL y una red externos. No crea la base, no provisiona roles, no despliega backend/web ni publica puertos; tampoco ejecuta `update`.

Una guía de arquitectura del corte anterior (`6caed6b`) planteaba Dokploy, imágenes GHCR y proxy público del frontend. Se registra como antecedente, no como configuración acreditada por el Compose actual. No se verificó el estado real del VPS, la disponibilidad de imágenes, el proxy ni se ejecutó un despliegue.

## Preparación antes de ejecutar

- Identificar commit e imagen inmutable de cada componente; una etiqueta dev puede cambiar.
- Auditar base, historial Liquibase, roles, redes y permisos sin modificar producción.
- Contar con backup restaurado satisfactoriamente en aislamiento.
- Revisar variables y secretos mediante [catálogo](variables-de-entorno.md).
- Revisar proxy, HTTPS, cookies, CORS y Socket.IO.
- Identificar quién autoriza y ejecuta cambios; esa asignación no está acordada aquí.

Estos pasos son una propuesta de preparación basada en los requisitos de la guía, no un procedimiento ya probado por esta entrega.

## Límites conocidos

La revisión del Compose actual ya no reproduce la exigencia `JWT_REFRESH_SECRET` observada en la configuración anterior. La autenticación de refresh del backend usa token opaco; las variables centrales describen por separado las opciones que aún aparecen en plantillas de ejemplo. El Compose referencia utilidades PostgreSQL 18, lo cual no acredita que la instancia externa use esa versión.

No se ejecuta aquí docker compose up ni Liquibase update contra un entorno existente. Las instrucciones locales se mantienen en su repositorio canónico.

## Producción frente a local

El Compose local crea PostgreSQL y Mosquitto para desarrollo; el Compose productivo actual solo valida Liquibase contra servicios existentes. El código backend permite MQTT y correo según configuración, pero este archivo de datos no despliega esos servicios ni determina el perfil activo. No intercambiar `.env` entre componentes o entornos.

Fuentes adicionales: [Compose local](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.yml), [workflow de CI DEV](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/.github/workflows/ci-dev.yml), [monitoreo](monitoreo-y-salud.md), [liberación](../60-producto-procesos/proceso-de-liberacion.md).
