---
title: Solución de problemas
status: borrador
owner: operacion
last_reviewed: 2026-11-04
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
| Compose de producción no inicia | Variables requeridas en Dokploy y acceso a GHCR; no imprimir el entorno completo al compartir logs. El Compose no incluye un servicio `postgres` | [Despliegue](despliegue.md) |
| Liquibase falla | Permisos del migrador, `POSTGRES_DB`, `DATABASECHANGELOG` y checksums; no borrar volúmenes, no usar `clear-checksums` ni marcar cambios como ejecutados sin revisar el SQL | [Migraciones](../10-arquitectura/base-de-datos/migraciones-y-rollbacks.md) |
| Frontend responde 502 | Backend sano, red compartida con Nginx, ruta `/api/v1/` y dominio apuntando a `frontend:8080` | [Despliegue](despliegue.md) |
| Dominio sin TLS o sin respuesta | DNS A/AAAA, puertos 80/443, dominio en Dokploy y logs de Traefik; un cambio de dominio requiere redeploy | [Despliegue](despliegue.md) |

Procedimientos tomados de la [guía de 2026-10-22](../99-archivo/base-de-datos/originales/docs/deployment/troubleshooting.md), excluyendo el comando de logs de `postgres` y la suposición de un broker concreto (DB06).

## Escalar un hallazgo

Registrar diferencias con referencias al código productor y consumidor. No desactivar TLS, permisos o validaciones para ocultar el problema. No cambiar contratos unilateralmente. Los comandos operativos deben obtenerse de su repositorio canónico y ejecutarse en un entorno autorizado.

## Límites

La tabla es un recorrido basado en código, sin incidentes reproducidos durante esta tarea. Pendiente: ensayar casos, definir contactos y conservar registros sanitizados. Fuentes: [mapa](../00-contexto/mapa-de-repositorios.md) y [evidencias](../00-contexto/evidencias-y-pendientes.md).
