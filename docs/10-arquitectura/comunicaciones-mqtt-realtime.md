---
title: Comunicaciones MQTT y tiempo real
status: borrador
owner: integracion
last_reviewed: 2026-11-05
canonical_for:
  - arquitectura-comunicaciones
---

# Comunicaciones MQTT y tiempo real

## Dos canales con responsabilidades distintas

MQTT conecta el backend con el broker y sus dispositivos compatibles. Socket.IO comunica eventos del backend a clientes autenticados en /realtime. Una conexión Socket.IO activa no prueba que MQTT o el dispositivo estén disponibles.

El backend calcula topics según namespace, identifica el fabricante y procesa estados internos y Shelly. El modo Mosquitto conserva el comportamiento histórico, que actualiza estado fuera de la transacción de consumo. El modo Flespi para un Shelly en DEV registra identidad/orden y persiste estado y lectura dentro de una transacción; emite eventos Socket.IO después del commit.

Fuentes: [configuración MQTT](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/config/mqtt-config.ts), [MqttTopicContract](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/mqtt-topic-contract.ts), [suscriptor e ingesta](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/mqtt-device-status.subscriber.ts), [referencia de ingestión histórica](backend/referencia-tecnica.md).

## Productores y consumidores

| Canal | Productor observado | Consumidor contrastado |
| --- | --- | --- |
| Control MQTT | Backend, adaptador de publicación | Firmware/dispositivo no inspeccionado directamente |
| Estado MQTT | Formatos esperados de dispositivo | Suscriptor backend; firmware pendiente |
| Eventos Socket.IO | Gateway y servicios backend | Clientes web y móvil |
| Destinatarios | Función SQL y comprobaciones backend | Clientes reciben eventos según sesión y hogar |

## Modo Flespi de desarrollo

`MQTT_BROKER_PROVIDER` usa `mosquitto` si no se configura. El proveedor `flespi` solo se admite en el perfil VPS DEV con `NODE_ENV=production`, `APP_ENV=development`, `MQTT_ENABLED=true`, TLS, broker `mqtts://mqtt.flespi.io:8883`, una identidad Shelly indicada por `MQTT_FLESPI_DEVICE_ID` y token en `MQTT_USERNAME` sin `MQTT_PASSWORD`. El código aplica un filtro ACL de un solo dispositivo, sin wildcard.

Los topics de entrada del Shelly son `${namespace}/devices/{deviceId}/status/switch:{switchId}` y `${namespace}/devices/{deviceId}/events/rpc`; en SQL035 el namespace fijado para este corte es `smarthome/dev/v1`. El topic de control usa `${namespace}/devices/{deviceId}/rpc`. El suscriptor pide QoS 1; esto describe la suscripción, no garantiza QoS extremo a extremo.

Para deduplicar, el backend acepta notificaciones Shelly `NotifyStatus`/`NotifyFullStatus` con `params.ts` numérico y el componente `switch:{switchId}`. Calcula una clave SHA-256 a partir de una identidad lógica canónica. SQL035 persiste la clave en `consumption.mqtt_ingest_dedup`; SQL036 habilita la consulta del último timestamp de origen. El backend bloquea la fila del dispositivo, rechaza eventos duplicados o con timestamp igual/anterior y conserva `read_at` de consumo monótono. Eventos sin timestamp confiable, retenidos o con más de cinco minutos de adelanto se descartan en este perfil.

Los eventos de estado que avanzan el watermark sin lectura de potencia se guardan como eventos de solo estado; no inventan consumo. Las métricas y alertas siguen pendientes de un worker con permisos propios. La reconciliación periódica de estado Flespi es opt-in, de una réplica, y no controla el relé ni escribe energía.

Enlaces canónicos: [contrato MQTT](../20-contratos/mqtt/contrato-mqtt.md), [eventos](../20-contratos/eventos-realtime.md).

## Condiciones y pendientes

Con MQTT habilitado en producción se exigen TLS, credenciales y namespace; hay opt-ins adicionales en perfiles DEV. `MQTT_ENABLED=false` produce la salida deshabilitada de `parseMqttConfig` bajo `NODE_ENV=production`. Revisar antes de ejecutar una simulación local. El modo Flespi no equivale a una configuración productiva.

El gateway mantiene estado en memoria por proceso; no se verificó un adaptador distribuido ni garantías de reenvío o replay. Validar permisos de detalle frente a la función de destinatarios SQL, caducidad de sesión, reconexión y revocación. No se encontró evidencia suficiente para describir QoS extremo a extremo o retención como acuerdo aprobado.

Fuentes adicionales: [destinatarios SQL](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/033_mqtt_ingest_realtime/001_mqtt_ingest_realtime.sql), [SQL035 idempotencia](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/035_flespi_mqtt_ingest_idempotency/001_mqtt_ingest_dedup.sql), [SQL036 orden](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/036_flespi_mqtt_event_order/001_flespi_event_order.sql), [consumidor web](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/src/shared/realtime/realtime-client.ts), [consumidor móvil en último corte verificable](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/services/realtime-service.ts).
