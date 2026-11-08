---
title: ADR-0002 — Autorización por recurso con PostgreSQL RLS
status: borrador
owner: arquitectura
last_reviewed: 2026-11-08
canonical_for:
  - adr-0002
---

# ADR-0002 — Autorización por recurso con PostgreSQL RLS

## Estado de la decisión

propuesta. Registra una decisión ya implementada; pasa a `aceptada` cuando el equipo apruebe el pull request que incorpora este documento.

- Fecha de propuesta: 2026-11-08.
- Evidencia de revisión: pull request de incorporación en smart-home-doc.

## Contexto

Los permisos dependen del rol en cada hogar (OWNER, MEMBER, GUEST) y de permisos por miembro y por dispositivo. Un error en un solo controlador podría exponer datos de otro hogar.

## Problema

Garantizar que un usuario nunca lea ni modifique datos de un hogar al que no pertenece, aunque falle una validación de la API.

## Decisión propuesta

La API valida el JWT y el rol global (`JwtAuthGuard`, `RolesGuard`). Cada consulta se ejecuta en una transacción que fija `app.current_user_id` (`PrismaRlsService.withUserContext`), y las políticas RLS de PostgreSQL deciden qué filas son visibles o modificables. El backend se conecta con usuarios `LOGIN` sin privilegios de propietario ni `BYPASSRLS`.

## Alternativas consideradas

| Alternativa | Ventajas | Limitaciones | Motivo de selección o descarte |
| --- | --- | --- | --- |
| Verificar permisos solo en la API | Lógica en un único lenguaje | Un olvido en una ruta expone datos | Descartada |
| RLS en PostgreSQL más guardias en la API | Defensa en profundidad; la base es la última barrera | Políticas SQL más complejas de probar | Seleccionada |

## Consecuencias y compromisos

Las pruebas deben cubrir las políticas con usuarios reales sin privilegios (CI de la base de datos y pruebas e2e del backend). Las migraciones de políticas requieren revisión cuidadosa y rollback.

## Referencias

Fuente: elaboración propia a partir de [políticas RLS](https://github.com/nataliachala1/smarthome-database/tree/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/03_dcl/02_policies) y de [seguridad y permisos](../10-arquitectura/base-de-datos/seguridad-y-permisos.md).
