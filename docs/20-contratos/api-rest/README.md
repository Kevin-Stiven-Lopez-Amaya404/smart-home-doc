---
title: Contrato de API REST
status: borrador
owner: backend
last_reviewed: 2026-10-29
canonical_for:
  - contrato-rest
---

# Contrato de API REST

## Fuente de implementación

El backend fija las rutas en controladores y valida DTO mediante ValidationPipe con whitelist, forbidNonWhitelisted y transform. Los servicios y adaptadores determinan respuestas y errores. La [referencia técnica](../../10-arquitectura/backend/referencia-tecnica.md#2-endpoints-y-contratos-de-api) recoge las **71 declaraciones de rutas de aplicación identificadas: 67 ordinarias y 4 condicionales**, con parámetros, cabeceras, respuestas, códigos y ejemplos deducibles del código. No es un resultado de solicitudes ejecutadas.

El GET / del AppController no registrado queda excluido. Las rutas de salud están fuera de /api/v1. No todas las rutas declaradas están disponibles en cualquier perfil.

Fuentes: [bootstrap y Swagger](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/main.ts), [inventario de endpoints](../../10-arquitectura/backend/referencia-tecnica.md#2-endpoints-y-contratos-de-api).

## OpenAPI: generación pendiente

No existe openapi.json en esta entrega. El mecanismo real del backend usa SwaggerModule.createDocument y SwaggerModule.setup('api/docs', ...), condicionado por SWAGGER_ENABLED. No se encontró un script dedicado de exportación.

Para completar la tarea:

1. Preparar un checkout aislado del commit objetivo y revisar sus scripts y dependencias.
2. Configurar PostgreSQL/roles, JWT, CORS y servicios requeridos en un entorno de pruebas, sin reutilizar credenciales de producción.
3. Inyectar antes del arranque los flags que determinan registro de controladores; anotar perfil y rutas habilitadas.
4. Activar Swagger en ese entorno y usar el mecanismo real para recuperar el documento generado. La ruta JSON efectiva debe comprobarse en ejecución; no se afirma que se haya probado.
5. Guardar el resultado generado como openapi.json en esta carpeta, junto con commit, perfil, comando y validación de correspondencia. No editarlo a mano para ajustar diferencias.

El checkout local del backend tiene cambios previos y no corresponde a dev; no se arrancó ni se instaló software allí.

## Integración

Revisar autorización Bearer, cookies HttpOnly de refresh, CORS, X-Pairing-Token, errores y rutas condicionales. Clientes contrastados: [web](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/src/shared/api/api-client.ts), [móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/api/api-client.ts).

Pendiente: generación y validación OpenAPI, pruebas de compatibilidad y ejemplos ejecutados. Ver [errores](../errores-api.md) y [pruebas](../../30-desarrollo/estrategia-de-pruebas.md).
