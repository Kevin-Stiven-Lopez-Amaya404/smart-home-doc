---
title: Variables de entorno y configuración segura
status: borrador
owner: operacion
last_reviewed: 2026-11-05
canonical_for:
  - variables-entorno
---

# Variables de entorno y configuración segura

## Autoridad y valores

Los validadores y consumidores del código son la referencia efectiva; un .env.example o Compose puede quedar rezagado. Este catálogo describe nombres y funciones, sin publicar secretos ni valores reales. El [detalle exhaustivo backend por archivo](../10-arquitectura/backend/referencia-tecnica.md#4-configuracion-en-detalle) conserva los parámetros avanzados.

| Componente | Variables verificadas | Función y condición |
| --- | --- | --- |
| Backend | NODE_ENV, APP_ENV, PORT | Perfil y puerto; el perfil afecta flags y validación |
| Backend | DATABASE_URL, DATABASE_IOT_URL | Conexiones aplicación/ingestión; requeridas por validateRuntimeConfig y con el mismo nombre de base |
| Backend | JWT_SECRET, JWT_EXPIRES_IN | Firma y expiración del access token; secreto con mínimo de bytes en producción |
| Backend | REFRESH_TOKEN_EXPIRES_DAYS | Duración del refresh token opaco |
| Backend | COOKIE_SECURE, COOKIE_SAME_SITE, COOKIE_DOMAIN | Política de cookie; none exige secure |
| Backend | CORS_ALLOWED_ORIGINS, FRONTEND_URL, TRUSTED_PROXY_CIDRS | Orígenes y proxy de confianza; sin rutas en los orígenes |
| Backend | SWAGGER_ENABLED | Registro de Swagger |
| Backend | EMAIL_ENABLED, SMTP_USER, SMTP_APP_PASSWORD, SMTP_FROM | Envío de correo; no documentar valores |
| Backend | MQTT_ENABLED, MQTT_BROKER_PROVIDER, MQTT_FLESPI_DEVICE_ID, MQTT_BROKER_URL, MQTT_USERNAME, MQTT_PASSWORD | Transporte y proveedor; Flespi restringido a un dispositivo en VPS DEV |
| Backend | MQTT_TLS_CA_FILE, MQTT_TLS_REJECT_UNAUTHORIZED | CA y verificación TLS; desactivar verificación no está permitido |
| Backend | MQTT_CLIENT_ID, MQTT_STATUS_CLIENT_ID, MQTT_TOPIC_NAMESPACE, MQTT_SHELLY_SWITCH_ID, MQTT_SHELLY_RPC_SOURCE | Identidades distintas y topics derivados |
| Backend | CONSUMPTION_METRICS_WORKER_ENABLED, DATABASE_METRICS_URL | Worker opcional y conexión dedicada |
| Backend | SHELLY_LOCAL_ENABLED, SHELLY_DISCOVERY_INTERFACE | Acceso/descubrimiento local bajo condiciones del perfil |
| Web | VITE_API_URL, VITE_REALTIME_URL, VITE_BACKEND_URL, VITE_APP_ENV | URLs/configuración públicas; Vite usa backend URL para proxy de desarrollo |
| Móvil | EXPO_PUBLIC_API_URL | API pública accesible por el dispositivo; producción valida HTTPS y host |
| Móvil | APP_ENV, APP_LINK_DOMAIN, ANDROID_PACKAGE, IOS_BUNDLE_IDENTIFIER | Configuración de build y enlaces nativos |
| Datos/producción | POSTGRES_HOST, POSTGRES_PORT, POSTGRES_DB, LIQUIBASE_DB_USER, LIQUIBASE_DB_PASSWORD | Destino existente y cuenta de migración |
| Datos/producción | APP_DB_PASSWORD, IOT_DB_PASSWORD, DATABASE_NETWORK, DOKPLOY_NETWORK | Provisión de roles y redes externas |
| Datos/producción | BACKEND_IMAGE, BACKEND_IMAGE_TAG, FRONTEND_IMAGE, FRONTEND_IMAGE_TAG | Imágenes y etiquetas de despliegue |

Las variables MQTT de provisión/roles privilegiados, cifrado y perfiles DEV tienen consumidores específicos: usar el catálogo exhaustivo y sus validadores, sin habilitar flags por ensayo.

## Modo Flespi y credenciales de propósito

El proveedor predeterminado es `mosquitto`. `MQTT_BROKER_PROVIDER=flespi` solo se admite cuando `NODE_ENV=production`, `APP_ENV=development` y `MQTT_ENABLED=true`; requiere `MQTT_BROKER_URL=mqtts://mqtt.flespi.io:8883`, `MQTT_FLESPI_DEVICE_ID` para un Shelly, `MQTT_USERNAME` con el token ACL y `MQTT_PASSWORD` vacío. Es una configuración VPS DEV con TLS y topic namespace limitado a un dispositivo; no es configuración de producción.

El código consume `MQTT_FLESPI_DEVICE_ID`, pero no aparece en el `.env.example` actual. El worker opt-in de reconciliación de estado también consume `SHELLY_FLESPI_STATE_SYNC_SINGLE_REPLICA` y `SHELLY_FLESPI_STATE_SYNC_INTERVAL_SECONDS` (por defecto 30 segundos, rango 15–300); ambos faltan en el ejemplo. Añadirlos a la plantilla o documentar su provisión externa antes de activar ese worker.

Las conexiones privilegiadas de pairing MQTT usan URLs distintas por responsabilidad: `MQTT_RESERVER_DATABASE_URL`, `MQTT_LEASE_DATABASE_URL`, `MQTT_CONFIRMER_DATABASE_URL`, `MQTT_SECRET_DATABASE_URL`, `MQTT_RPC_DATABASE_URL`, `MQTT_AUTH_DATABASE_URL` y `MQTT_REVOCATION_DATABASE_URL`. No son intercambiables con `DATABASE_URL`/`DATABASE_IOT_URL`; cada usuario LOGIN recibe un rol funcional limitado. `MQTT_DYNSEC_ADMIN_URL`, `MQTT_DYNSEC_ADMIN_USERNAME`, `MQTT_DYNSEC_ADMIN_PASSWORD` y `MQTT_DYNSEC_ADMIN_CA_FILE` configuran administración de Mosquitto Dynamic Security. `MQTT_PREPARATION_AES_KEY_B64URL` y `MQTT_PREPARATION_AES_KEY_ID` protegen secretos temporales de pairing. Los nombres `SHELLY_MQTT_PRODUCTION_*` permanecen apagados por defecto en el ejemplo.

El [detalle de configuración de datos](../10-arquitectura/base-de-datos/configuracion-y-ejecucion.md) relaciona liquibase.properties, Compose local/productivo, variables de conexión y scripts. No copiar sus plantillas al backend sin revisar consumidores.

## Discrepancias

`JWT_REFRESH_SECRET` y `JWT_REFRESH_EXPIRES_IN` aparecen en `.env.example`, pero no son la autoridad de duración/firma del refresh opaco actual. El Compose productivo actual del repositorio de datos es solo un servicio Liquibase de inspección y no consume esas variables. `LOG_LEVEL` y `LOCAL_DEVICE_DISCOVERY_ENABLED` no tenían consumidor identificado en el snapshot base; su uso requiere volver a contrastar el código actual.

No asumir que MQTT_ENABLED=false desactiva MQTT en desarrollo ni que .env se carga antes de seleccionar rutas condicionales.

## Fuentes y pendientes

[validación general](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/config/runtime-config.ts), [validación MQTT](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/config/mqtt-config.ts), [.env.example backend](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/.env.example), [worker Flespi](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/flespi-shelly-state-sync.worker.ts), [web](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/.env.example), [móvil en el último corte verificable](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/app.config.js), [Compose productivo actual](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.production.yml).

Pendiente: revisar variables efectivas y permisos del entorno real sin extraer valores; corregir las discrepancias mediante cambios coordinados en sus repositorios.
