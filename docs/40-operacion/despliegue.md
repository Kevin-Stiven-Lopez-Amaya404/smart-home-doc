---
title: Despliegue y condiciones de operación
status: borrador
owner: operacion
last_reviewed: 2026-11-04
canonical_for:
  - despliegue
---

# Despliegue y condiciones de operación

## Configuración disponible

El [Compose de producción](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml) define Liquibase, runtime-roles, backend y frontend. Reutiliza una base PostgreSQL y redes externas: no crea ni administra su servidor o volumen. El backend depende de la provisión de roles; frontend depende de la salud del backend.

### Arquitectura prevista (no verificada)

El plan registrado el 2026-10-22 prevé desplegar el Compose desde `dev` con Dokploy solo después de auditar la base y probar una restauración. Solo el frontend tendría dominio público (Traefik hacia el puerto interno 8080, sin puertos publicados) y Nginx reenviaría `/api/v1/` y Socket.IO al backend por una red privada. El Compose usa la instancia PostgreSQL existente y no crea servidor ni volúmenes; host, base, rol de migración y redes quedaban por confirmar. Los backups deben guardarse fuera del VPS. Es un plan: no se verificó el estado del VPS ni un despliegue de la base de datos. Antecedente: [arquitectura de despliegue](../99-archivo/base-de-datos/originales/docs/deployment/architecture.md).

## Preparación antes de ejecutar

- Identificar commit e imagen inmutable de cada componente; una etiqueta dev puede cambiar.
- Auditar base, historial Liquibase, roles, redes y permisos sin modificar producción.
- Contar con backup restaurado satisfactoriamente en aislamiento.
- Revisar variables y secretos mediante [catálogo](variables-de-entorno.md).
- Revisar proxy, HTTPS, cookies, CORS y Socket.IO.
- Identificar quién autoriza y ejecuta cambios; esa asignación no está acordada aquí.

Estos pasos son una propuesta de preparación basada en los requisitos de la guía, no un procedimiento ya probado por esta entrega.

La auditoría previa propuesta el 2026-10-22 incluye: inventariar servicios, contenedores, redes y volúmenes sin tocar los directorios internos de Dokploy; identificar host, base, usuarios, red, `databasechangelog` y último changeset aplicado; crear un `pg_dump` completo fuera del servidor y restaurarlo en una instancia aislada; comparar los changesets pendientes con esa copia y no ejecutar cambios destructivos mientras haya dudas sobre el historial; y revisar «Preview Compose» antes de desplegar. Ese documento describía un acceso SSH aún no autenticado y un proyecto Dokploy sin crear; ese estado no se verificó en esta revisión. Antecedente: [Hostinger y Dokploy](../99-archivo/base-de-datos/originales/docs/deployment/hostinger-deployment.md).

## Límites conocidos

El Compose aún exige JWT_REFRESH_SECRET aunque la implementación de refresh inspeccionada utiliza token opaco y REFRESH_TOKEN_EXPIRES_DAYS. Revisar esa divergencia antes de configurar despliegue. El Compose referencia utilidades PostgreSQL 18; no acredita que el servidor existente tenga esa versión.

No se ejecuta aquí docker compose up ni Liquibase update contra un entorno existente. Las instrucciones locales se mantienen en su repositorio canónico.

## Producción frente a local

El Compose local crea PostgreSQL y un broker Mosquitto; el productivo usa servicios/redes existentes y puede dejar MQTT y correo deshabilitados. No intercambiar .env entre ambos.

Fuentes adicionales: [Compose local](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.yml), [monitoreo](monitoreo-y-salud.md), [liberación](../60-producto-procesos/proceso-de-liberacion.md).
