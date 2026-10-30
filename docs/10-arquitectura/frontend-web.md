---
title: Frontend web
status: borrador
owner: web
last_reviewed: 2026-10-29
canonical_for:
  - arquitectura-web
---

# Frontend web

## Implementación verificada

Aplicación React 18 y TypeScript con Vite 6 dentro de `web/`, Socket.IO, MUI y Tailwind declarados en [package.json](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/package.json). Los comandos se ejecutan desde web/, no desde una raíz supuesta.

[vite.config.ts](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/vite.config.ts) configura proxies de desarrollo para /api, /health y /socket.io hacia VITE_BACKEND_URL. Esto no configura el proxy de producción.

## Integración

El [cliente HTTP](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/src/shared/api/api-client.ts) agrega Bearer, usa cookies con credentials: include y renueva sesión mediante POST /auth/refresh cuando corresponde. La URL base se obtiene de VITE_API_URL.

El [cliente realtime](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/src/shared/realtime/realtime-client.ts) usa auth.token y el namespace configurado por VITE_REALTIME_URL. El [contrato de pairing](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/src/shared/api/shelly-pairing-contract.ts) genera token aleatorio de sesión y requestId; no prueba por sí solo que el dispositivo o todas las rutas backend estén disponibles.

## Límites y pendientes

Las variables VITE_* son configuración visible del cliente, nunca un lugar para secretos. Confirmar rutas del proxy productivo, cookies entre orígenes y los perfiles backend que habilitan pairing. La gestión de errores del cliente no trata igual todos los formatos de message; ver [errores](../20-contratos/errores-api.md).

Fuente canónica: repositorio web en el commit del [mapa](../00-contexto/mapa-de-repositorios.md). No se ejecutaron build, pruebas ni navegador.
