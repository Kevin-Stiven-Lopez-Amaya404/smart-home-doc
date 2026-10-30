---
title: Roles y permisos observados
status: borrador
owner: producto
last_reviewed: 2026-10-29
canonical_for:
  - roles-permisos
---

# Roles y permisos observados

## Fuente y autoridad

Roles de hogar: OWNER, MEMBER y GUEST. No equivalen al rol global del usuario. La [regla documentada backend](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/docs/ROLES_Y_PERMISOS.md) y la [implementación SQL de permisos](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql) permiten contrastar reglas, sin acreditar aprobación formal de producto.

## Comportamiento SQL identificado

| Rol | Base de consulta | Base de control | Administración y detalle |
| --- | --- | --- | --- |
| OWNER | Acceso como propietario según funciones | Permitido según función de propietario | Administración reservada en reglas y casos de uso |
| MEMBER | Consulta de dispositivos/consumo habilitada inicialmente | Habilitada inicialmente | Detalle sujeto a permisos efectivos; sin administración por ese rol |
| GUEST | Consulta inicial; consumo básico del hogar sujeto a permisos | Deshabilitado inicialmente, modificable por permiso | Sin consumo detallado por dispositivo aunque exista excepción |

Hay permisos de hogar y overrides por dispositivo; null representa herencia en las operaciones documentadas. Consultar, controlar y administrar son capacidades independientes. El cambio de rol SQL restaura valores base en el flujo definido; no presumir conservación de todas las excepciones sin revisar la función correspondiente.

La central resume; la autoridad ejecutable está en funciones SQL, guards y casos de uso, no en una segunda matriz editada independientemente.

## Discrepancia de acceso realtime

La [función de destinatarios MQTT](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/033_mqtt_ingest_realtime/001_mqtt_ingest_realtime.sql) selecciona propietario y miembros activos. [RealtimeAccessService](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/realtime/realtime-access.service.ts) restringe eventos de hogar a OWNER/MEMBER activos, aceptados y no terminados, pero no expresa el mismo filtro de permiso de consumo por dispositivo.

Riesgo pendiente: un MEMBER con consumo detallado denegado podría seguir siendo elegible para telemetría por eventos. Requiere prueba con roles, políticas RLS y overrides; no se declara una explotación confirmada ni se cambia el contrato unilateralmente.

## Pendientes

Acordar matriz funcional aprobada, contrastar todos los handlers y ejecutar pruebas de permisos positivos/negativos. No convertir historias de usuario o documentos legales en reglas aprobadas sin evidencia.
