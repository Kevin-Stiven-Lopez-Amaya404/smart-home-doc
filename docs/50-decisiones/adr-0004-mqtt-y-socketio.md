---
title: ADR-0004 — MQTT para dispositivos y Socket.IO para clientes
status: borrador
owner: arquitectura
last_reviewed: 2026-11-08
canonical_for:
  - adr-0004
---

# ADR-0004 — MQTT para dispositivos y Socket.IO para clientes

## Estado de la decisión

propuesta. Registra una decisión ya implementada; pasa a `aceptada` cuando el equipo apruebe el pull request que incorpora este documento.

- Fecha de propuesta: 2026-11-08.
- Evidencia de revisión: pull request de incorporación en smart-home-doc.

## Contexto

Los dispositivos Shelly 1PM Gen4 publican estado y telemetría por MQTT. La web y el móvil necesitan ver cambios sin recargar.

## Problema

Comunicar dispositivos y clientes en tiempo casi real sin exponer el broker a los clientes finales.

## Decisión propuesta

Solo el backend se conecta al broker MQTT (Mosquitto; flespi como opción DEV): se suscribe a los tópicos de estado y publica las órdenes de control. Tras confirmar la transacción en PostgreSQL, el backend emite eventos por Socket.IO solo a los miembros autorizados del hogar. Web y móvil nunca hablan MQTT.

## Alternativas consideradas

| Alternativa | Ventajas | Limitaciones | Motivo de selección o descarte |
| --- | --- | --- | --- |
| Clientes conectados directamente al broker | Menos saltos | Credenciales MQTT en el cliente y control de acceso duplicado | Descartada |
| Sondeo HTTP periódico | Simple | Latencia y carga | Descartada |
| Backend como puente MQTT → Socket.IO | Un solo punto de autorización | El backend es punto de paso obligatorio | Seleccionada |

## Consecuencias y compromisos

El estado `COMMAND_PUBLISHED` indica que la orden se publicó, no que el relé cambió. El vigilante de conectividad marca `OFFLINE` a los dispositivos sin telemetría reciente.

## Referencias

Fuente: elaboración propia a partir de [comunicaciones MQTT y tiempo real](../10-arquitectura/comunicaciones-mqtt-realtime.md) y del [contrato MQTT](../20-contratos/mqtt/contrato-mqtt.md).
