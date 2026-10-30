---
title: Configuración del entorno de desarrollo
status: borrador
owner: desarrollo
last_reviewed: 2026-10-29
canonical_for:
  - configuracion-desarrollo
---

# Configuración del entorno de desarrollo

## Dónde configurar

| Componente | Fuente inspeccionada | Uso |
| --- | --- | --- |
| Backend | [runtime-config.ts](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/config/runtime-config.ts) y [mqtt-config.ts](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/config/mqtt-config.ts) | Validación de sesión, CORS, correo y MQTT |
| Web | [web/.env.example](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/.env.example) y [Vite](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/vite.config.ts) | URLs públicas y proxy local |
| Móvil | [api-config.ts](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/config/api-config.ts) y [app.config.js](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/app.config.js) | URL API y configuración por entorno |
| Datos | [Compose local](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.yml) | Parámetros PostgreSQL y Liquibase |

No copiar valores de .env al repositorio. Crear configuración privada siguiendo nombres y validadores reales; introducir secretos mediante el mecanismo seguro del entorno. VITE_* y EXPO_PUBLIC_* son visibles en las aplicaciones cliente.

## Condiciones que afectan el arranque

- CORS_ALLOWED_ORIGINS y FRONTEND_URL deben corresponder a orígenes del entorno; credentials: include necesita cookies compatibles.
- DATABASE_URL requiere el esquema/roles esperados; no basta un servidor vacío.
- MQTT_ENABLED=false no deshabilita de la misma forma todos los perfiles; consultar parseMqttConfig.
- Algunos controladores MQTT se seleccionan al cargar módulos, antes de ConfigModule. Los flags deben estar disponibles al evaluar el proceso, no asumirse cargados a tiempo desde .env.
- SMTP no configurado puede impedir operaciones que requieren correo; no documentar activación exitosa sin probar el recorrido.

## Referencias y pendientes

El catálogo de nombres y diferencias con ejemplos está en [variables operativas](../40-operacion/variables-de-entorno.md); el detalle exhaustivo por archivo está en [configuración backend](../10-arquitectura/backend/referencia-tecnica.md#4-configuracion-en-detalle).

Pendiente: validar un conjunto mínimo reproducible sin secretos y sus perfiles local/DEV/producción. No se inventó una plantilla .env global para los cinco repositorios.
