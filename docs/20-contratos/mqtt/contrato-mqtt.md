---
title: Contrato MQTT descriptivo
status: borrador
owner: integracion
last_reviewed: 2026-10-29
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

Fuentes: [MqttTopicContract](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/devices/infrastructure/messaging/mqtt-topic-contract.ts), [parseMqttConfig](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/config/mqtt-config.ts).

## Referencias locales y autoridad compartida

El [contrato local existente](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/docs/MQTT_CONTRACT.md) y [HU10 TLS/namespace](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/docs/HU10_MQTT_TLS_NAMESPACE.md) se conservan como referencias; su descripción de alertas y transacciones requiere reconciliación con el código. La central no mantiene una segunda tabla independiente de payloads ni da por aprobado ese acuerdo.

## Payloads y persistencia

El backend distingue estado interno, estado de switch y eventos RPC Shelly; no trata cualquier JSON como consumo válido. Los campos, validaciones, unidad energética y publicación de órdenes se describen en la [referencia técnica](../../10-arquitectura/backend/referencia-tecnica.md). Esa referencia está fijada al mismo commit para evitar dos tablas de payload independientes.

No se copian credenciales de broker a este contrato. La autorización, namespace y configuración de cada identidad deben contrastarse con las ACL reales.

## Seguridad y verificación pendiente

Producción con transporte habilitado requiere mqtts, verificación TLS, credenciales y namespace. El perfil de laboratorio exige condiciones adicionales; no se propone desactivar TLS para hacerlo funcionar.

Falta contrastar firmware y broker, reglas QoS/retain, duplicados, mensajes fuera de orden, redelivery y coherencia de permisos del consumidor realtime. No se afirma entrega garantizada, alertas activas o compatibilidad con todo dispositivo Shelly.
