---
title: Arquitectura e implementación del backend
status: borrador
owner: backend
last_reviewed: 2026-11-06
canonical_for:
  - arquitectura-backend
---

# Arquitectura e implementación del backend

## Fuente y alcance

La referencia técnica extensa conserva el snapshot `1cbaca28e9e152d5cb5ff7643560fdfa65857486`. El corte actual de `dev` es `60297c361e4acac6e98161337ef8e149e069d441`; la [revisión de alineación](../../00-contexto/revision-alineacion-implementaciones-2026-11-05.md) y el [contrato de energía](../../20-contratos/api-rest/energia.md) documentan los cambios posteriores. El código actual declara 77 handlers HTTP, cuatro de ellos MQTT condicionales.

El checkout local del backend usa 13-dev con cambios previos; no se mezcló con la instantánea remota ni se modificó.

## Patrones observados

- Monolito modular NestJS: auth, users, homes, devices, consumption, energy, notifications y realtime.
- Separación presentation/application/domain/infrastructure en los módulos con controladores, casos de uso, abstracciones de repositorio, mapeadores y adaptadores.
- Inyección de dependencias para sustituir adaptadores; no todos los módulos aplican las mismas capas. Consumo y notificaciones tienen acceso Prisma más directo.
- Guards JWT y sesión, validación global de DTO, limitación de solicitudes, Helmet, cookies y CORS.
- Persistencia PostgreSQL con Prisma, transacciones y contexto de usuario para controles SQL/RLS.
- Adaptadores MQTT y gateway Socket.IO; trabajadores dentro del proceso para tareas concretas.

Se describen responsabilidades observables; no se atribuye una decisión formal de arquitectura hexagonal a todo el código.

## Riesgos y límites

El controlador raíz AppController no está registrado; no documentar GET / como ruta activa. El provisionamiento legado puede devolver 503 y existen rutas condicionales. Hay helpers de alertas sin llamadas y la API de notificaciones no prueba generación automática.

Fuentes: [bootstrap](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/main.ts), [AppModule actual](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/app.module.ts), [referencia histórica y rutas](referencia-tecnica.md#2-endpoints-y-contratos-de-api), [contrato actual de energía](../../20-contratos/api-rest/energia.md), [alineación de componentes](../../00-contexto/revision-alineacion-implementaciones-2026-11-05.md).

Pendiente: ejecutar pruebas y OpenAPI en checkout aislado y contrastar funciones SQL contra una base de pruebas migrada.
