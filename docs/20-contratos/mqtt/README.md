---
title: Índice del contrato MQTT
status: borrador
owner: integracion
last_reviewed: 2026-11-03
canonical_for:
  - indice-mqtt
---

# Índice del contrato MQTT

El [contrato descriptivo MQTT](contrato-mqtt.md) centraliza topics, condiciones y fuentes. Estado: borrador; no se acreditó aprobación conjunta ni validación contra firmware físico.

Fuente de comportamiento: [MqttTopicContract](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/devices/infrastructure/messaging/mqtt-topic-contract.ts) y [parseMqttConfig](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/config/mqtt-config.ts). Los payloads detallados y publicación están en la [referencia backend](../../10-arquitectura/backend/referencia-tecnica.md).

Pendientes: revisar firmware, ACL y configuración efectiva del broker, entrega, retención, unidades y operación real. Cambios compartidos requieren revisión de productor y consumidor; no se modifica el contrato unilateralmente.

Documentos relacionados:

- [MQTT con TLS y namespace (HU10)](tls-y-namespace.md), copia del documento del backend.
- [Contrato local del backend (archivado)](../../99-archivo/backend/mqtt-contract-2026-10-15.md), conciliado en el contrato central.

[Volver a contratos](../README.md).
