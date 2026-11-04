---
title: Monitoreo y salud
status: borrador
owner: operacion
last_reviewed: 2026-11-04
canonical_for:
  - monitoreo-salud
---

# Monitoreo y salud

## Endpoints implementados

| Ruta | Verificación | Límite |
| --- | --- | --- |
| GET /health/live | Devuelve status ok | No consulta PostgreSQL; excluido del limitador |
| GET /health/ready | Ejecuta SELECT 1 mediante Prisma | Prueba la conexión de aplicación, no todos los roles o migraciones |
| GET /health | Misma comprobación de ready | No comprueba SMTP, MQTT ni dispositivos |

Fuente: [HealthController](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/health/health.controller.ts). Los fallos de consulta no se traducen expresamente a 503 en ese controlador; puede aparecer 500. No afirmar una semántica de readiness más amplia.

## Configuración operativa

Las métricas HTTP y de proceso de HU14 (`/metrics`) se exportan desde el backend y no añaden consultas, tablas, roles ni índices a la base de datos; no crear índices sin evidencia de consultas lentas medidas. Antecedente: [HU14 en la base de datos](../99-archivo/base-de-datos/originales/docs/hu14-observability-metrics.md).

El [Compose](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml) incorpora healthchecks backend/frontend y dependencias de arranque. Eso no prueba que se estén ejecutando ni que existan alertas externas. El Dockerfile backend usa una comprobación de puerto fijo según la [referencia](../10-arquitectura/backend/referencia-tecnica.md); revisar coherencia si cambia PORT.

## Procedimiento de diagnóstico propuesto

Registrar entorno, revisión, instante, ruta, estado y mensaje sin tokens. Separar fallo de proceso, base de datos, permisos, broker y correo. Tras un ready correcto comprobar el flujo afectado en un entorno permitido; SELECT 1 no valida sus tablas o funciones.

## Pendientes

No hay monitoreo verificado del trabajador de revocación MQTT. Según el [antecedente HU11](../99-archivo/base-de-datos/originales/docs/hu11-mqtt-revocation-runtime.md) (2026-10-15), el trabajador del backend está desactivado por defecto y suspende reclamos si falla su auditoría de permisos; no se comprobó en un entorno.

No se verificaron monitores activos, retención de logs, paneles, métricas ni alertas. Acordar indicadores, responsables y umbrales antes de documentarlos como vigentes. Revisar rate limiting y acceso público del endpoint de salud.

Fuentes adicionales: [diagnóstico](solucion-de-problemas.md), [configuración](variables-de-entorno.md), [evidencias](../00-contexto/evidencias-y-pendientes.md).
