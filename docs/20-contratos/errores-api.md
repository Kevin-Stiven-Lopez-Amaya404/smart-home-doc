---
title: Errores de API
status: borrador
owner: backend
last_reviewed: 2026-10-29
canonical_for:
  - contrato-errores
---

# Errores de API

## Comportamiento verificado

No se identificó un único envoltorio global aplicado a toda respuesta de error. Las excepciones Nest, errores del dominio traducidos y errores sin capturar pueden tener formatos diferentes. Un ejemplo de JSON no debe convertirse en esquema obligatorio para todos los endpoints.

| Estado | Condición observada |
| --- | --- |
| 400 | Parámetros o DTO inválidos donde existen pipes/validadores |
| 401 | Acceso sin autenticación/sesión válida en handlers protegidos |
| 403 | Acceso denegado según guard o regla de autorización |
| 404 | Recurso no encontrado en flujos que lo traducen |
| 409 | Conflictos de negocio donde se traducen explícitamente |
| 429 | Guard global de límites; /health/live está excluido |
| 503 | Funcionalidad/configuración no disponible, incluido provisionamiento legado |
| 500 | Fallos no traducidos, incluidos posibles errores SQL |

No todos esos estados pertenecen a cada endpoint. La [tabla detallada REST](api-rest/README.md) identifica sus condiciones.

El límite de solicitudes emite code RATE_LIMIT_EXCEEDED y cabecera Retry-After. ValidationPipe puede producir message como arreglo. Swagger no cambia el status efectivo de un POST: se requiere HttpCode explícito.

Fuentes: [ValidationPipe y cabeceras CORS](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/main.ts), [referencia de errores y rutas](../10-arquitectura/backend/referencia-tecnica.md).

## Consumidores y diferencias

El [cliente web](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/src/shared/api/api-client.ts) da preferencia a message de tipo string; algunos arreglos quedan con mensaje genérico. El [cliente móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/api/api-client.ts) reúne mensajes de validación, pero no tiene una categoría específica para 429. Revisar tratamiento de Retry-After y códigos compartidos sin cambiar unilateralmente el formato.

## Pendientes

Acordar, si procede, un formato estable mediante propuesta y pruebas entre componentes. No se creó un esquema ficticio ni se afirmó que todos los fallos de salud devuelvan 503.
