---
title: Documentación de la aplicación móvil
status: borrador
owner: movil
last_reviewed: 2026-11-06
canonical_for:
  - arquitectura-movil
---

# Aplicación móvil (`from_movil`)

## Estado de la revisión

La metadata disponible indica que `dev` llegó a `6b5fe36655eb9048aa4054a914ec245810d58893`, pero no fue posible leer el árbol ni los archivos de ese commit. La información técnica de esta página corresponde al último snapshot con código verificable, `bb87f62c0727f22f376e56632c22bea66128a04a`. Debe tratarse como referencia histórica hasta volver a contrastarla con el código actual.

## Plataforma y configuración — último snapshot verificable

En `bb87f62` el proyecto declaraba React Native 0.86, Expo 57, Expo Router y TypeScript 6 en [package.json](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/package.json). Esto no acredita la versión del HEAD posterior, ni disponibilidad en tiendas.

La [configuración API](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/config/api-config.ts) usaba `EXPO_PUBLIC_API_URL` y validaba requisitos distintos para producción. El [cliente HTTP](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/api/api-client.ts) evitaba duplicar `/api/v1`, agregaba Bearer y solicitaba renovación con cookies.

## HTTP y tiempo real — último snapshot verificable

El [RealtimeService](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/services/realtime-service.ts) derivaba el origen y conectaba a `/realtime` con `auth.token`. El [hook de sincronización](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/hooks/use-realtime-sync.ts) aplicaba cambios de estado y consumo. La conversión de `energyTotalKwh` a una unidad de presentación requiere mantener coherencia con los modelos del cliente.

Este snapshot no confirma que la aplicación móvil consuma la nueva API de tarifas, metas o resumen de energía. Consultar el [contrato REST compartido](../../20-contratos/api-rest/energia.md) y registrar la compatibilidad móvil solo después de inspeccionar el cliente actual.

## Pairing y flujo Shelly — último snapshot verificable

`pairing-service.ts` contenía el flujo de setup sessions y operaciones MQTT en el snapshot `bb87f62`. La [guía de conexión](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/BACKEND_CONNECTION.md) aún describía apartados de pairing como no integrados; esa diferencia quedó registrada en la [revisión de alineación](../../00-contexto/revision-alineacion-implementaciones-2026-11-05.md). No tratar aquella guía como contrato completo ni asumir que su contenido sigue igual en `6b5fe36`.

## Pendiente de alineación con el código actual

Cuando el repositorio vuelva a estar accesible, revisar `package.json`, `app.config.js`, el cliente HTTP y Realtime, `pairing-service.ts`, las pantallas de consumo y la configuración de enlaces. Comparar nombres de rutas, cuerpos, errores, autenticación y variables con backend y web; indicar el commit y actualizar este documento. Contrastar también permisos BLE/LAN, enlaces de activación/restablecimiento y cookies en dispositivos Android/iOS reales antes de describir esos flujos como validados.

Fuente de implementación: repositorio [from_movil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil). Para el corte accesible y los límites de evidencia, consulta el [mapa de repositorios](../../00-contexto/mapa-de-repositorios.md).
