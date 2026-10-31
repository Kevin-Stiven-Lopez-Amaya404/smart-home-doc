---
title: Configuración y ejecución del repositorio de datos
status: borrador
owner: datos
last_reviewed: 2026-10-29
canonical_for:
  - configuracion-base-datos
---

# Configuración y ejecución del repositorio de datos

## Archivos de configuración

No hay directorios config/ o src/config/ en esta instantánea. El esquema SQL config es una parte del modelo de datos, no una carpeta de configuración de la herramienta.

| Archivo | Parámetros y finalidad |
| --- | --- |
| liquibase.properties | changeLogFile, url, username, driver, logLevel y showBanner; defaults de conexión local |
| .env.example | POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, POSTGRES_PORT |
| docker-compose.yml | PostgreSQL 16, volumen local, salud, Mosquitto 2 y Liquibase 4.29 |
| .env.production.example | Nombres para base existente, roles, redes y aplicaciones |
| docker-compose.production.yml | Liquibase → provisión de roles → backend → frontend |
| tests/mqtt/mosquitto.conf | Configuración de fixture de pruebas, no configuración automáticamente montada por el Compose local |
| .github/workflows/ci-deploy.yml | Entorno desechable PostgreSQL 18 y validación de migraciones |

Fuentes: [liquibase.properties](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/liquibase.properties), [Compose local](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.yml), [Compose producción](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml), [fixture MQTT](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/tests/mqtt/mosquitto.conf).

## Variables y parámetros

Solo se describen nombres y función; no se copian valores de .env ni secretos de ejemplos.

| Nombres | Función |
| --- | --- |
| POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, POSTGRES_PORT | Inicialización/conexión local y puerto publicado |
| POSTGRES_HOST, POSTGRES_PORT, POSTGRES_DB | Destino PostgreSQL ya existente en producción |
| LIQUIBASE_DB_USER, LIQUIBASE_DB_PASSWORD | Cuenta migradora productiva |
| LIQUIBASE_COMMAND_URL, LIQUIBASE_COMMAND_USERNAME, LIQUIBASE_COMMAND_PASSWORD, LIQUIBASE_COMMAND_CHANGELOG_FILE | Parámetros que los servicios Compose suministran a Liquibase |
| APP_DB_PASSWORD, IOT_DB_PASSWORD | Secretos leídos por provision-runtime-roles.sql para las cuentas LOGIN |
| DATABASE_NETWORK, DOKPLOY_NETWORK | Redes externas que deben existir y coincidir con la instalación |
| DATABASE_URL, DATABASE_IOT_URL | Conexiones backend con roles de aplicación e ingestión |
| JWT_SECRET, JWT_REFRESH_SECRET | Variables exigidas por Compose; el refresh actual del backend no usa JWT_REFRESH_SECRET como firma de su token opaco |
| CORS_ALLOWED_ORIGINS, FRONTEND_URL, COOKIE_SAME_SITE, TRUSTED_PROXY_CIDRS | Orígenes, cookies y proxy de confianza |
| MQTT_ENABLED, MQTT_BROKER_URL, MQTT_USERNAME, MQTT_PASSWORD | Transporte y autenticación del broker |
| MQTT_CLIENT_ID, MQTT_STATUS_CLIENT_ID, MQTT_TOPIC_NAMESPACE, MQTT_TLS_CA_FILE | Identidades separadas, namespace y CA |
| EMAIL_ENABLED, SMTP_USER, SMTP_APP_PASSWORD | Habilitación y autenticación del correo |
| BACKEND_IMAGE, BACKEND_IMAGE_TAG, FRONTEND_IMAGE, FRONTEND_IMAGE_TAG | Selección de imágenes; aparecen en Compose aunque no todos figuren en la plantilla |
| DOKPLOY_DEPLOY_WEBHOOK, DEPLOYMENT_HEALTH_URL | Secretos/configuración del job de despliegue, actualmente bloqueado en este workflow |

En el servicio backend productivo COOKIE_SECURE, SWAGGER_ENABLED, NODE_ENV y PORT se fijan en Compose. Las rutas de CA requieren comprobar además que el archivo esté disponible dentro del contenedor. La configuración inspeccionada no demuestra su montaje ni una conexión TLS exitosa.

Fuentes: [nombres locales](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/.env.example), [nombres productivos](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/.env.production.example), [workflow](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/.github/workflows/ci-deploy.yml) y [catálogo central](../../40-operacion/variables-de-entorno.md).

## Inicio local documentado

Desde la raíz de un checkout de la revisión elegida, con Docker Compose disponible y una base/volumen de prueba identificado. Preparar .env de forma privada usando nombres del ejemplo. El README indica:

```sh
docker compose up -d --wait postgres
docker compose run --rm liquibase --defaults-file=liquibase.properties validate
docker compose run --rm liquibase --defaults-file=liquibase.properties update-sql
```

Revisar destino, SQL y plan antes de aplicar. La orden de escritura documentada es:

```sh
docker compose run --rm liquibase --defaults-file=liquibase.properties update
```

Estas órdenes se contrastaron con README y scripts, **no se ejecutaron** en esta tarea. No borrar/recrear volúmenes existentes para conseguir una base limpia. El servicio liquibase tiene update como comando predeterminado: levantarlo sin revisar no es una acción puramente diagnóstica.

El Compose local expone Mosquitto pero no monta tests/mqtt/mosquitto.conf ni declara un mecanismo completo de autenticación/ACL. No afirmar que proporciona un broker preparado para producción.

## Diferencias de los wrappers

[update.ps1](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/update.ps1) llama validate, update-sql y update; no comprueba explícitamente LASTEXITCODE entre esas órdenes. ErrorActionPreference por sí solo no debe tomarse como prueba de interrupción de comandos nativos en todos los entornos PowerShell.

[update.bat](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/update.bat) comprueba errorlevel pero aplica update sin el paso intermedio update-sql. Los wrappers no son equivalentes; revisar el plan y los códigos de salida antes de operar. No se modificaron los scripts.

## Producción y requisitos previos

El Compose productivo no crea PostgreSQL ni su volumen; aplica cambios a la instancia indicada y requiere redes externas. Revisar historial instalado, roles, backup restaurado y configuración real antes de ejecutar su update.

[Operación](operacion-y-mantenimiento.md). [Migraciones](migraciones-y-rollbacks.md). [Hallazgos](hallazgos-y-pendientes.md).
