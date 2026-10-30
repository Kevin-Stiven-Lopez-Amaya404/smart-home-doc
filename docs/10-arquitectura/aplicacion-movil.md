---
title: Aplicación móvil
status: borrador
owner: movil
last_reviewed: 2026-10-29
canonical_for:
  - arquitectura-movil
---

# Aplicación móvil

## Implementación verificada

React Native 0.86, Expo 57, Expo Router y TypeScript 6, declarados en [package.json](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/package.json). Se identificaron servicios separados de HTTP, realtime y pairing; no se deduce disponibilidad en tiendas de aplicaciones.

La [configuración API](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/config/api-config.ts) usa EXPO_PUBLIC_API_URL y valida requisitos distintos para producción. El [cliente HTTP](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/api/api-client.ts) evita duplicar /api/v1, agrega Bearer y solicita renovación de sesión con cookies.

## Integración y navegación

[RealtimeService](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/services/realtime-service.ts) deriva el origen y conecta /realtime con auth.token. [use-realtime-sync](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/hooks/use-realtime-sync.ts) aplica cambios de estado y consumo; la conversión de energyTotalKwh a una unidad usada por el cliente requiere conservar coherencia en los modelos.

[pairing-service.ts](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/services/pairing-service.ts) contiene el nuevo flujo de setup-sessions y operaciones MQTT. La [guía de conexión](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/BACKEND_CONNECTION.md) aún describe apartados de pairing como no integrados; debe reconciliarse con ese código. No presentar la guía como contrato completo actual.

## Configuración y entrega

[app.config.js](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/app.config.js) y [eas.json](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/eas.json) definen configuración y perfiles. La guía local documenta dominio de enlaces, identificadores Android/iOS y asociación HTTPS. No se verificaron firma, dominio, publicación ni persistencia de cookies en dispositivos reales.

Pendientes: probar Android/iOS, permisos BLE/LAN, enlaces de activación/restablecimiento y flujo completo Shelly en un entorno permitido. Fuente de implementación: from_movil en el [commit inspeccionado](../00-contexto/mapa-de-repositorios.md).
