---
title: Arquitectura e implementación del backend
status: borrador
owner: backend
last_reviewed: 2026-10-29
canonical_for:
  - arquitectura-backend
---

# Arquitectura e implementación del backend

## Fuente y alcance

Instantánea dev `1cbaca28e9e152d5cb5ff7643560fdfa65857486`. La [referencia técnica completa](backend/referencia-tecnica.md) contiene las cuatro secciones solicitadas: patrones, todos los endpoints identificados, carpetas/archivos y configuración detallada, además de inconsistencias.

El checkout local del backend usa 13-dev con cambios previos; no se mezcló con la instantánea remota ni se modificó.

## Patrones observados

- Monolito modular NestJS: auth, users, homes, devices, consumption, notifications y realtime.
- Separación presentation/application/domain/infrastructure en los módulos con controladores, casos de uso, abstracciones de repositorio, mapeadores y adaptadores.
- Inyección de dependencias para sustituir adaptadores; no todos los módulos aplican las mismas capas. Consumo y notificaciones tienen acceso Prisma más directo.
- Guards JWT y sesión, validación global de DTO, limitación de solicitudes, Helmet, cookies y CORS.
- Persistencia PostgreSQL con Prisma, transacciones y contexto de usuario para controles SQL/RLS.
- Adaptadores MQTT y gateway Socket.IO; trabajadores dentro del proceso para tareas concretas.

Se describen responsabilidades observables; no se atribuye una decisión formal de arquitectura hexagonal a todo el código.

## Riesgos y límites

El controlador raíz AppController no está registrado; no documentar GET / como ruta activa. El provisionamiento legado puede devolver 503 y existen rutas condicionales. Hay helpers de alertas sin llamadas y la API de notificaciones no prueba generación automática.

Fuentes: [bootstrap](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/main.ts), [referencia y rutas](backend/referencia-tecnica.md#2-endpoints-y-contratos-de-api), [configuración detallada](backend/referencia-tecnica.md#4-configuracion-en-detalle).

Pendiente: ejecutar pruebas y OpenAPI en checkout aislado y contrastar funciones SQL contra una base de pruebas migrada.
