---
title: Frontend web
status: borrador
owner: web
last_reviewed: 2026-11-06
canonical_for:
  - arquitectura-web
---

# Frontend web (`smarthome-frontend-web`)

## Implementación verificada

Aplicación React 18 y TypeScript con Vite 6 dentro de `web/`, Socket.IO, MUI y Tailwind declarados en [package.json](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/package.json). Los comandos se ejecutan desde `web/`, no desde una raíz supuesta. Frente al corte `8dad6e1`, no cambiaron las versiones declaradas de dependencias ni las variables VITE.

[vite.config.ts](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/vite.config.ts) configura proxies de desarrollo para /api, /health y /socket.io hacia VITE_BACKEND_URL. Esto no configura el proxy de producción.

## Integración

El [cliente HTTP](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/src/shared/api/api-client.ts) agrega Bearer, usa cookies con `credentials: include` y renueva sesión mediante `POST /auth/refresh` cuando corresponde. La URL base se obtiene de `VITE_API_URL`.

El [cliente realtime](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/src/shared/realtime/realtime-client.ts) usa `auth.token` y el namespace configurado por `VITE_REALTIME_URL`. El [contrato de pairing](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/src/shared/api/shelly-pairing-contract.ts) genera token aleatorio de sesión y `requestId`; no prueba por sí solo que el dispositivo o todas las rutas backend estén disponibles.

La sección de Consumo integra [HomeEnergySection](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/src/features/consumption/HomeEnergySection.tsx) y seis operaciones en [energy.api.ts](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/src/shared/api/energy.api.ts). Los montos, kWh y porcentajes se transportan como strings decimales, según el [contrato REST](../../20-contratos/api-rest/energia.md).

## Límites y pendientes

Las variables VITE_* son configuración visible del cliente, nunca un lugar para secretos. El workflow aplica promoción `dev -> qa -> main`, publica la imagen GHCR solo con push a `main` en el repositorio upstream y mantiene el deploy deshabilitado. Confirmar rutas del proxy productivo, cookies entre orígenes y los perfiles backend que habilitan pairing. La gestión de errores del cliente no trata igual todos los formatos de `message`; ver [errores](../../20-contratos/errores-api.md).

Fuente canónica: repositorio web en el commit del [mapa](../../00-contexto/mapa-de-repositorios.md). El comando `test:contracts` cambió y ahora invoca Node sin el flag `--test`. No se ejecutaron build, pruebas ni navegador.
