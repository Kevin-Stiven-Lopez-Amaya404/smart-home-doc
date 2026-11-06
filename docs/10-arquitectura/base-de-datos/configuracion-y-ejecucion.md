---
title: Configuración y ejecución del repositorio de datos
status: borrador
owner: datos
last_reviewed: 2026-11-05
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
| docker-compose.production.yml | Solo Liquibase en perfil `database-inspection`, volumen de solo lectura y `validate` como comando |
| tests/mqtt/mosquitto.conf | Configuración de fixture de pruebas, no configuración automáticamente montada por el Compose local |
| .github/workflows/ci-dev.yml | PostgreSQL 18 desechable, validación/aplicación en CI y auditoría de roles/RLS; no despliega |

Fuentes: [Compose local](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.yml), [Compose productivo de inspección](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.production.yml), [CI DEV](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/.github/workflows/ci-dev.yml).

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
| JWT_SECRET, JWT_REFRESH_SECRET | Variables de backend de ejemplos previos; el Compose productivo actual del repositorio de datos no las consume |
| CORS_ALLOWED_ORIGINS, FRONTEND_URL, COOKIE_SAME_SITE, TRUSTED_PROXY_CIDRS | Orígenes, cookies y proxy de confianza |
| MQTT_ENABLED, MQTT_BROKER_URL, MQTT_USERNAME, MQTT_PASSWORD | Transporte y autenticación del broker |
| MQTT_CLIENT_ID, MQTT_STATUS_CLIENT_ID, MQTT_TOPIC_NAMESPACE, MQTT_TLS_CA_FILE | Identidades separadas, namespace y CA |
| EMAIL_ENABLED, SMTP_USER, SMTP_APP_PASSWORD | Habilitación y autenticación del correo |
| BACKEND_IMAGE, BACKEND_IMAGE_TAG, FRONTEND_IMAGE, FRONTEND_IMAGE_TAG | Nombres aún presentes en el ejemplo de entorno; el Compose productivo actual no selecciona imágenes |
| DOKPLOY_DEPLOY_WEBHOOK, DEPLOYMENT_HEALTH_URL | No son usados por el Compose productivo actual ni por el workflow CI DEV de base de datos |

El Compose de producción actual define un único servicio Liquibase en el perfil `database-inspection`. Requiere PostgreSQL existente (`POSTGRES_HOST`, `POSTGRES_DB`, opcionalmente `POSTGRES_PORT`), usuario de migración, contraseña y una red externa. Monta el repositorio en solo lectura y ejecuta `validate`; no crea la base, no provisiona roles, no aplica `update`, no despliega backend/frontend y no publica puertos. El `.env.production.example` conserva variables de otros procedimientos; su presencia no significa que este Compose las consuma.

Fuentes: [Compose productivo](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.production.yml), [plantilla productiva](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/.env.production.example), [update.ps1](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/scripts/update.ps1), [validate.ps1](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/scripts/validate.ps1) y [catálogo central](../../40-operacion/variables-de-entorno.md).

## Inicio local documentado

Desde la raíz de un checkout de la revisión elegida, con Docker Compose disponible y un entorno local desechable identificado. Preparar `.env` de forma privada. El Compose local usa PostgreSQL 16 Alpine con puerto por defecto `5432`, Mosquitto 2 en `1883` y Liquibase 4.29 en el perfil `migration-tools`. El servicio Liquibase usa volumen de solo lectura y tiene `validate` como comando predeterminado; `docker compose up` no inicia ese servicio de migración porque está en un perfil.

```sh
docker compose up -d --wait postgres
docker compose run --rm liquibase --defaults-file=liquibase.properties validate
docker compose run --rm liquibase --defaults-file=liquibase.properties update-sql
```

Revisar destino, SQL y plan antes de aplicar. La orden de escritura documentada es:

```sh
docker compose run --rm liquibase --defaults-file=liquibase.properties update
```

Estas órdenes se contrastaron con `docker-compose.yml`, README y scripts actuales, **no se ejecutaron** en esta tarea. El script `scripts/update.ps1` valida y muestra el SQL; solo aplica migraciones con `-Apply` y la confirmación literal `APLICAR-LOCAL`. No borrar/recrear volúmenes existentes para conseguir una base limpia.

El Compose local expone Mosquitto pero no monta tests/mqtt/mosquitto.conf ni declara un mecanismo completo de autenticación/ACL. No afirmar que proporciona un broker preparado para producción.

## Script de actualización

El [script `update.ps1` actual](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/scripts/update.ps1) valida la configuración, ejecuta `validate` y `update-sql`, y comprueba los códigos de salida de los comandos nativos. Solo ejecuta `update` cuando se solicita `-Apply` y se escribe la confirmación literal `APLICAR-LOCAL`. La guía no atribuye estas garantías a otros wrappers.

## Producción y requisitos previos

El Compose productivo solo valida el historial conectado a la instancia y requiere una red externa ya existente. Para aplicar migraciones se requiere un procedimiento separado y explícito; este archivo no contiene ni ejecuta `update`. Revisar el historial instalado, roles, backup restaurado y configuración real antes de autorizar cambios.

[Operación](operacion-y-mantenimiento.md). [Migraciones](migraciones-y-rollbacks.md). [Hallazgos](hallazgos-y-pendientes.md).
