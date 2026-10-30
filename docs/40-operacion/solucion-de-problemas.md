---
title: Solución de problemas
status: borrador
owner: operacion
last_reviewed: 2026-10-29
canonical_for:
  - diagnostico
---

# Solución de problemas

## Recoger evidencia

Anotar componente, rama/commit, perfil, ruta o evento, estado HTTP y momento del fallo. No adjuntar .env, cookies, Authorization ni payloads con secretos. Comparar la configuración con el consumidor del código.

| Síntoma | Comprobación útil | Fuente |
| --- | --- | --- |
| Backend no arranca | Nombres obligatorios, URL PostgreSQL, perfil, TLS y CORS; no inventar valores para superar validadores | [Variables](variables-de-entorno.md) |
| ready falla | Conexión de aplicación y permisos; distinguir de liveness | [Salud](monitoreo-y-salud.md) |
| 401 o renovación falla | JWT/sesión, cookie HttpOnly, credentials, origen, secure y sameSite | [REST](../20-contratos/api-rest/README.md) |
| 429 | Conservar Retry-After y revisar límites; no reintentar en bucle | [Errores](../20-contratos/errores-api.md) |
| Correo no llega | EMAIL_ENABLED, configuración SMTP y resultado del caso de uso; no asumir rollback completo | [Backend](../10-arquitectura/backend/referencia-tecnica.md) |
| Pairing devuelve 503 | Distinguir provision legado bloqueado de operaciones condicionales y perfil permitido | [Flujos](../60-producto-procesos/flujos-de-usuario.md) |
| Dispositivo sin actualizaciones | Broker, topic derivado, identidad, validación de payload y permisos; Socket.IO no prueba MQTT | [MQTT](../20-contratos/mqtt/contrato-mqtt.md) |
| Eventos no llegan | Token del handshake, membresía activa, sesión revocada y acceso al hogar | [Realtime](../20-contratos/eventos-realtime.md) |
| Móvil no conecta en LAN | URL accesible desde teléfono; localhost no es el equipo servidor | [guía móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/BACKEND_CONNECTION.md) |

## Escalar un hallazgo

Registrar diferencias con referencias al código productor y consumidor. No desactivar TLS, permisos o validaciones para ocultar el problema. No cambiar contratos unilateralmente. Los comandos operativos deben obtenerse de su repositorio canónico y ejecutarse en un entorno autorizado.

## Límites

La tabla es un recorrido basado en código, sin incidentes reproducidos durante esta tarea. Pendiente: ensayar casos, definir contactos y conservar registros sanitizados. Fuentes: [mapa](../00-contexto/mapa-de-repositorios.md) y [evidencias](../00-contexto/evidencias-y-pendientes.md).
