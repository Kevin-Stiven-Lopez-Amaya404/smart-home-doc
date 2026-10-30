---
title: Comunicaciones MQTT y tiempo real
status: borrador
owner: integracion
last_reviewed: 2026-10-29
canonical_for:
  - arquitectura-comunicaciones
---

# Comunicaciones MQTT y tiempo real

## Dos canales con responsabilidades distintas

MQTT conecta el backend con el broker y sus dispositivos compatibles. Socket.IO comunica eventos del backend a clientes autenticados en /realtime. Una conexión Socket.IO activa no prueba que MQTT o el dispositivo estén disponibles.

El backend calcula topics según namespace, identifica el fabricante y procesa estados internos y Shelly. La ingestión puede persistir consumo y emitir eventos; no debe asumirse que toda actualización de estado y consumo comparte una única transacción.

Fuentes: [configuración MQTT](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/config/mqtt-config.ts), [MqttTopicContract](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/devices/infrastructure/messaging/mqtt-topic-contract.ts), [referencia de ingestión](backend/referencia-tecnica.md).

## Productores y consumidores

| Canal | Productor observado | Consumidor contrastado |
| --- | --- | --- |
| Control MQTT | Backend, adaptador de publicación | Firmware/dispositivo no inspeccionado directamente |
| Estado MQTT | Formatos esperados de dispositivo | Suscriptor backend; firmware pendiente |
| Eventos Socket.IO | Gateway y servicios backend | Clientes web y móvil |
| Destinatarios | Función SQL y comprobaciones backend | Clientes reciben eventos según sesión y hogar |

Enlaces canónicos: [contrato MQTT](../20-contratos/mqtt/contrato-mqtt.md), [eventos](../20-contratos/eventos-realtime.md).

## Condiciones y pendientes

Con MQTT habilitado en producción se exigen TLS, credenciales y namespace; hay opt-ins adicionales en perfiles DEV. MQTT_ENABLED=false solo produce la salida deshabilitada de parseMqttConfig bajo NODE_ENV=production. Revisar antes de ejecutar una simulación local.

El gateway mantiene estado en memoria por proceso; no se verificó un adaptador distribuido ni garantías de reenvío o replay. Validar permisos de detalle frente a la función de destinatarios SQL, caducidad de sesión, reconexión y revocación. No se encontró evidencia suficiente para describir QoS extremo a extremo o retención como acuerdo aprobado.

Fuentes adicionales: [destinatarios SQL](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/033_mqtt_ingest_realtime/001_mqtt_ingest_realtime.sql), [consumidor web](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/src/shared/realtime/realtime-client.ts), [consumidor móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/services/realtime-service.ts).
