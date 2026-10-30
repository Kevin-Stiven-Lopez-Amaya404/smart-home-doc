---
title: Variables de entorno y configuración segura
status: borrador
owner: operacion
last_reviewed: 2026-10-29
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
| Backend | MQTT_ENABLED, MQTT_BROKER_URL, MQTT_USERNAME, MQTT_PASSWORD | Transporte y autenticación del broker |
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

## Discrepancias

JWT_REFRESH_SECRET y JWT_REFRESH_EXPIRES_IN aparecen en ejemplos antiguos, pero no son la autoridad de duración/firma del refresh opaco actual. LOG_LEVEL y LOCAL_DEVICE_DISCOVERY_ENABLED no tienen consumidor identificado en el análisis backend. El Compose productivo aún exige JWT_REFRESH_SECRET.

No asumir que MQTT_ENABLED=false desactiva MQTT en desarrollo ni que .env se carga antes de seleccionar rutas condicionales.

## Fuentes y pendientes

[validación general](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/config/runtime-config.ts), [validación MQTT](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/config/mqtt-config.ts), [web](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/.env.example), [móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/app.config.js), [Compose productivo](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml).

Pendiente: revisar variables efectivas y permisos del entorno real sin extraer valores; corregir las discrepancias mediante cambios coordinados en sus repositorios.
