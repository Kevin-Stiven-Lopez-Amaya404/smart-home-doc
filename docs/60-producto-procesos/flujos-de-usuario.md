---
title: Flujos de usuario verificados y límites
status: borrador
owner: producto
last_reviewed: 2026-10-29
canonical_for:
  - flujos-usuario
---

# Flujos de usuario verificados y límites

## Autenticación y recuperación

El registro recibe los campos definidos en DTO, crea una cuenta pendiente y requiere activación por enlace/token. Login entrega accessToken y establece cookie HttpOnly para renovación; la recuperación utiliza enlaces con token. No se adopta como contrato actual un prototipo con código OTP de seis dígitos.

Fuentes: [casos de uso, DTO y endpoints](../10-arquitectura/backend/referencia-tecnica.md#2-endpoints-y-contratos-de-api), [integración móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/BACKEND_CONNECTION.md).

Cuando falla correo o está deshabilitado, revisar el resultado del caso de uso: no asumir operación exitosa ni rollback completo. Validar cookies en navegador y dispositivos reales.

## Hogares y colaboración

El usuario autenticado puede operar conforme a su pertenencia: crear/consultar hogares, gestionar invitaciones y aceptar/rechazar membresía según endpoints. Administración y acceso a consumo/control dependen de [roles y permisos](roles-y-permisos.md), no solo de ocultar botones en el cliente.

## Dispositivos y consumo

Pairing debe distinguir setup-sessions y operaciones MQTT condicionales del provisionamiento legado que devuelve 503. El servicio móvil tiene código más reciente que parte de su guía. No presentar como disponible un recorrido completo sin comprobar flags, permisos, firmware y broker.

Las consultas de consumo y actualizaciones realtime existen; el código de emisión de notification.created no prueba que se generen alertas automáticas.

Fuentes: [pairing móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/services/pairing-service.ts), [REST](../20-contratos/api-rest/README.md), [eventos](../20-contratos/eventos-realtime.md).

## Antecedentes por revisar

[guía móvil de flujo](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/FLUJO_USUARIO.md) describe pantallas, datos demo y OTP de prototipo; no es fuente del contrato real de autenticación. No se copian sus credenciales de muestra. El documento de navegación y el SRS externos también requieren contraste; ver [inventario](../00-contexto/inventario-documental.md).

Pendiente: aprobar recorridos funcionales, criterios de aceptación y ensayos de extremo a extremo en entornos identificados.
