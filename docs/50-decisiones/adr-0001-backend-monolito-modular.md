---
title: ADR-0001 — Backend como monolito modular NestJS
status: borrador
owner: arquitectura
last_reviewed: 2026-11-08
canonical_for:
  - adr-0001
---

# ADR-0001 — Backend como monolito modular NestJS

## Estado de la decisión

propuesta. Registra una decisión ya implementada; pasa a `aceptada` cuando el equipo apruebe el pull request que incorpora este documento.

- Fecha de propuesta: 2026-11-08.
- Evidencia de revisión: pull request de incorporación en smart-home-doc.

## Contexto

SmartHome tiene tres integrantes, un solo dominio (hogares, dispositivos, consumo y energía) y una base PostgreSQL compartida con seguridad por filas. La web y la aplicación móvil consumen la misma API REST y el mismo canal Socket.IO.

## Problema

Elegir entre servicios independientes con API gateway o una sola aplicación con módulos internos, de forma que el equipo pueda mantenerla y desplegarla.

## Decisión propuesta

Un solo proceso NestJS con módulos por subdominio (`auth`, `users`, `homes`, `devices`, `consumption`, `energy`, `notifications`, `realtime`, `admin`). Cada módulo separa `presentation`, `application`, `domain` e `infrastructure`; los controladores delegan en casos de uso y estos dependen de puertos (clases abstractas) implementados con Prisma. El proxy Nginx de la web cumple el papel de punto único de entrada (`/api/`, `/socket.io/`).

## Alternativas consideradas

| Alternativa | Ventajas | Limitaciones | Motivo de selección o descarte |
| --- | --- | --- | --- |
| Microservicios con API gateway | Despliegue independiente por servicio | Transacciones distribuidas, más infraestructura y operación | Descartada por tamaño del equipo y por compartir una sola base con RLS |
| Monolito modular | Un despliegue, transacciones locales, módulos con fronteras claras | Escala como una unidad | Seleccionada |

## Consecuencias y compromisos

Un solo artefacto que construir, probar y desplegar. Las fronteras entre módulos se respetan por convención y por inyección de dependencias. Si un módulo necesitara escalar por separado, su puerto de repositorio permite extraerlo.

## Referencias

Fuente: elaboración propia a partir de [app.module.ts](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/app.module.ts) y de la [arquitectura del backend](../10-arquitectura/backend/arquitectura.md).
