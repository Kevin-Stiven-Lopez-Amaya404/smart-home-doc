---
title: Despliegue y condiciones de operación
status: borrador
owner: operacion
last_reviewed: 2026-10-29
canonical_for:
  - despliegue
---

# Despliegue y condiciones de operación

## Configuración disponible

El [Compose de producción](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml) define Liquibase, runtime-roles, backend y frontend. Reutiliza una base PostgreSQL y redes externas: no crea ni administra su servidor o volumen. El backend depende de la provisión de roles; frontend depende de la salud del backend.

La [guía de arquitectura operativa](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/ARCHITECTURE.md) plantea Dokploy, imágenes GHCR y proxy público del frontend. Declara auditoría y restauración de prueba como requisitos previos. Son planes/configuraciones; no se verificó el estado real del VPS ni se ejecutó un despliegue.

## Preparación antes de ejecutar

- Identificar commit e imagen inmutable de cada componente; una etiqueta dev puede cambiar.
- Auditar base, historial Liquibase, roles, redes y permisos sin modificar producción.
- Contar con backup restaurado satisfactoriamente en aislamiento.
- Revisar variables y secretos mediante [catálogo](variables-de-entorno.md).
- Revisar proxy, HTTPS, cookies, CORS y Socket.IO.
- Identificar quién autoriza y ejecuta cambios; esa asignación no está acordada aquí.

Estos pasos son una propuesta de preparación basada en los requisitos de la guía, no un procedimiento ya probado por esta entrega.

## Límites conocidos

El Compose aún exige JWT_REFRESH_SECRET aunque la implementación de refresh inspeccionada utiliza token opaco y REFRESH_TOKEN_EXPIRES_DAYS. Revisar esa divergencia antes de configurar despliegue. El Compose referencia utilidades PostgreSQL 18; no acredita que el servidor existente tenga esa versión.

No se ejecuta aquí docker compose up ni Liquibase update contra un entorno existente. Las instrucciones locales se mantienen en su repositorio canónico.

## Producción frente a local

El Compose local crea PostgreSQL y un broker Mosquitto; el productivo usa servicios/redes existentes y puede dejar MQTT y correo deshabilitados. No intercambiar .env entre ambos.

Fuentes adicionales: [Compose local](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.yml), [monitoreo](monitoreo-y-salud.md), [liberación](../60-producto-procesos/proceso-de-liberacion.md).
