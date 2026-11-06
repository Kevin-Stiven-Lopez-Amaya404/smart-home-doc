---
title: Contrato MQTT descriptivo
status: borrador
owner: integracion
last_reviewed: 2026-11-05
canonical_for:
  - contrato-mqtt
---

# Contrato MQTT descriptivo

## Estado y responsables propuestos

Borrador basado en backend dev. Roles de revisión propuestos: backend y responsables de dispositivos/broker. No hay aprobación conjunta acreditada. El firmware no se inspeccionó, por lo que la compatibilidad se limita a lo que el backend publica o espera recibir.

## Topics derivados

Sea D = `<MQTT_TOPIC_NAMESPACE>/devices` cuando hay namespace. Sin namespace se usa MQTT_CONTROL_TOPIC_PREFIX o smarthome/devices. Sea S el MQTT_SHELLY_SWITCH_ID, por defecto 0.

| Uso | Ruta observada |
| --- | --- |
| Control de dispositivo no Shelly | D/id/control |
| Estado interno | D/+/status |
| Prefijo Shelly con namespace | D/id |
| Prefijo Shelly sin namespace | id |
| Control Shelly | prefijo-Shelly/rpc |
| Estado Shelly | prefijo-Shelly/status/switch:S |
| Eventos RPC Shelly | prefijo-Shelly/events/rpc |

El identificador se valida con mqttDeviceId; Shelly se distingue por prefijo de identidad sin distinguir mayúsculas. Los filtros configurados deben coincidir con los derivados; no son rutas arbitrarias.

Fuentes: [MqttTopicContract actual](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/mqtt-topic-contract.ts), [parseMqttConfig actual](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/config/mqtt-config.ts).

## Referencias locales y autoridad compartida

Los documentos locales `docs/MQTT_CONTRACT.md` y `docs/HU10_MQTT_TLS_NAMESPACE.md` existían en el snapshot `1cbaca2`, pero fueron retirados del repositorio backend antes del corte `60297c3`. La implementación vigente está en código; no usar aquellas guías como contrato actual sin consultar el historial archivado. Este archivo describe solo lo verificado estáticamente y no acredita aprobación conjunta.

## Payloads y persistencia

El backend distingue estado interno, estado de switch y eventos RPC Shelly; no trata cualquier JSON como consumo válido. Los payloads internos conservan el contrato histórico. En modo Flespi se acepta un parser Shelly estricto y los eventos RPC requieren origen temporal confiable para entrar al flujo ordenado. Los campos de consumo, unidades y eventos realtime se describen en la [referencia técnica](../../10-arquitectura/backend/referencia-tecnica.md) y en [comunicaciones](../../10-arquitectura/comunicaciones-mqtt-realtime.md).

No se copian credenciales de broker a este contrato. La autorización, namespace y configuración de cada identidad deben contrastarse con las ACL reales.

## Seguridad y verificación pendiente

Producción con transporte habilitado requiere mqtts, verificación TLS, credenciales y namespace. El proveedor Flespi solo se permite en VPS DEV con TLS, una identidad Shelly y tópicos exactos, sin suscripción wildcard. El perfil de laboratorio exige condiciones adicionales; no se propone desactivar TLS para hacerlo funcionar.

Para Flespi, la suscripción solicita QoS 1 y descarta estado retained, duplicados por clave durable y eventos con timestamp igual/anterior al watermark. Falta contrastar firmware y broker reales, redelivery, comportamiento del token ACL y coherencia de permisos del consumidor realtime. No se afirma entrega garantizada, alertas activas o compatibilidad con todo dispositivo Shelly.

## Flujo Flespi verificado estáticamente en DEV

El proveedor `flespi` escucha un único dispositivo, suscrito a `{namespace}/devices/{deviceId}/status/switch:{switchId}` y `{namespace}/devices/{deviceId}/events/rpc`. El topic RPC de control es `{namespace}/devices/{deviceId}/rpc`. En SQL035 el namespace de desarrollo validado es `smarthome/dev/v1`.

Para el evento Shelly `NotifyStatus` o `NotifyFullStatus`, el backend construye `event_key` SHA-256 desde topic, método, timestamp de origen y payload canónico del componente switch. SQL035 persiste `(id_device,event_key)` en `consumption.mqtt_ingest_dedup`; SQL036 habilita la lectura del timestamp de origen. Estado, ledger y lectura de consumo se escriben en una transacción protegida por bloqueo de fila. El backend emite `consumption.created` y `device.status.updated` después del commit. Eventos duplicados, antiguos/iguales, retained, sin identidad confiable o con más de cinco minutos de adelanto no generan una lectura en este modo.

Fuentes: [parser de identidad de evento](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/flespi-shelly-event-key.ts), [suscriptor](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/mqtt-device-status.subscriber.ts), [SQL035](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/035_flespi_mqtt_ingest_idempotency/001_mqtt_ingest_dedup.sql), [SQL036](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/036_flespi_mqtt_event_order/001_flespi_event_order.sql).


## Conciliación con el contrato local del backend

El [contrato MQTT archivado](../../99-archivo/backend/mqtt-contract-2026-10-15.md) describe un flujo Mosquitto con métricas y alertas; se conserva como evidencia histórica. La implementación observada en dev usa Flespi: registra idempotencia con SQL035, consulta el watermark SQL036 y persiste estado/consumo en una transacción. Publica el evento realtime después del commit. El worker dedicado de métricas y alertas sigue pendiente.

La revisión describe el código de dev; no acredita el broker de producción ni compatibilidad con firmware físico. Fuentes: [suscriptor backend](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/mqtt-device-status.subscriber.ts), [SQL035](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/035_flespi_mqtt_ingest_idempotency/001_mqtt_ingest_dedup.sql) y [SQL036](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/036_flespi_mqtt_event_order/001_flespi_event_order.sql).
