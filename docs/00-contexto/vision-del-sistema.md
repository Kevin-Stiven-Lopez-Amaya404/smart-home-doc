---
title: Visión del sistema
status: borrador
owner: producto
last_reviewed: 2026-10-29
canonical_for:
  - vision-del-sistema
---

# Visión del sistema

SmartHome aborda la gestión de hogares y dispositivos conectados, el control de dispositivos compatibles y la consulta de consumo eléctrico. Esta descripción se apoya en módulos backend y clientes; no convierte todas las aspiraciones de los documentos académicos en funcionalidades disponibles.

## Capacidades observadas

- Autenticación, activación de cuenta, recuperación de contraseña y sesiones con renovación.
- Hogares, invitaciones, membresías y permisos de acceso.
- Dispositivos, órdenes de encendido/apagado y flujos Shelly con condiciones de entorno.
- Consultas de consumo y actualización de datos mediante MQTT y Socket.IO.
- API de notificaciones; su existencia no demuestra generación automática de alertas.

Fuentes: [referencia técnica backend](../10-arquitectura/backend/referencia-tecnica.md), [entrada HTTP](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/main.ts), [permisos SQL](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql).

## Contexto documental

El SRS externo habla de monitoreo energético y objetivos más amplios. Su autoridad y correspondencia con la implementación deben resolverse antes de incorporarlo como requisito aprobado. Véanse [inventario](inventario-documental.md) y [alcance](alcance-y-no-objetivos.md).

## Pendientes

Validar objetivos de producto, dispositivos soportados en campo, criterios de aceptación y versión realmente desplegada con las personas responsables. Este documento describe una instantánea; no es una promesa comercial.
