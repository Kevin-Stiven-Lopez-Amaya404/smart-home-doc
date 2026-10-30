---
title: Eventos en tiempo real
status: borrador
owner: integracion
last_reviewed: 2026-10-29
canonical_for:
  - contrato-realtime
---

# Eventos en tiempo real

## Conexión y autenticación

Socket.IO, namespace /realtime. El gateway admite handshake auth.token o cabecera Authorization: Bearer; los dos clientes inspeccionados usan auth.token. Tras registro válido emite realtime.connected con userId. No hay una ruta HTTP para suscribirse a estos eventos.

La sesión se revalida al registrar, periódicamente y antes de entregas. El estado por proceso y las entregas best effort no garantizan replay ni coordinación entre réplicas.

Fuentes: [gateway](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/realtime/realtime.gateway.ts), [entrega](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/realtime/realtime-events.service.ts), [detalle de sesiones](../10-arquitectura/backend/referencia-tecnica.md).

## Eventos observados

| Evento | Contenido principal | Productor y límite |
| --- | --- | --- |
| realtime.connected | userId | Gateway tras autenticar |
| realtime.error | code, message | Sesión inválida/no disponible; puede desconectar |
| device.status.updated | id, homeId, connectivityStatus, isOn, currentPowerW, updatedAt | Suscriptor MQTT y watchdog |
| consumption.created | id, homeId, deviceId, deviceName, manufacturerDeviceId, powerW, energyDeltaKwh, energyTotalKwh, voltageV, currentA, frequencyHz, temperatureC, readAt | Ingestión tras persistir lectura |
| notification.unread_count.updated | unreadCount | Actualización individual o masiva |
| notification.created | Estructura prevista en suscriptor | El flujo actual no llena notifications; no se acredita generación automática |

Los campos y nulabilidad detallados se consultan en la [referencia de versión fija](../10-arquitectura/backend/referencia-tecnica.md). Las fechas de objetos Date se serializan; no se promete orden global de eventos.

## Contraste entre componentes

- Web conecta mediante [realtime-client.ts](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/src/shared/realtime/realtime-client.ts).
- Móvil define [RealtimeEventMap](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/services/realtime-service.ts) y procesa eventos en [use-realtime-sync](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/hooks/use-realtime-sync.ts). Acepta id o deviceId para estado; su tipo realtime.error solo expresa message y debe revisarse frente a code.
- SQL selecciona destinatarios mediante [fn_mqtt_realtime_recipients](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/033_mqtt_ingest_realtime/001_mqtt_ingest_realtime.sql); el backend agrega restricciones de membresía en [RealtimeAccessService](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/realtime/realtime-access.service.ts).

## Pendientes de acuerdo

Validar que un MEMBER sin permiso de detalle no reciba telemetría equivalente mediante eventos; las reglas observadas no expresan el mismo filtro por dispositivo. Revisar reconexión con token renovado, revocación, pérdida de eventos y multiinstancia. Roles propuestos para revisar: backend, datos, web y móvil; aprobación conjunta no acreditada.
