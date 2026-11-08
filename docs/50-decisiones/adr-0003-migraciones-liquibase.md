---
title: ADR-0003 — Esquema versionado con Liquibase en un repositorio propio
status: borrador
owner: arquitectura
last_reviewed: 2026-11-08
canonical_for:
  - adr-0003
---

# ADR-0003 — Esquema versionado con Liquibase en un repositorio propio

## Estado de la decisión

propuesta. Registra una decisión ya implementada; pasa a `aceptada` cuando el equipo apruebe el pull request que incorpora este documento.

- Fecha de propuesta: 2026-11-08.
- Evidencia de revisión: pull request de incorporación en smart-home-doc.

## Contexto

El esquema incluye funciones `SECURITY DEFINER`, políticas RLS, roles y particiones que Prisma Migrate no modela.

## Problema

Versionar y revertir cambios de esquema de forma reproducible y auditable en DEV, QA y producción.

## Decisión propuesta

El repositorio `smarthome-database` es la fuente de verdad del esquema. Cada cambio es un changeset de Liquibase con su rollback. Prisma solo se usa como cliente (`schema.prisma` refleja el esquema; no genera migraciones). Los datos de demostración se aplican únicamente con `changelog/changelog-demo.yaml`.

## Alternativas consideradas

| Alternativa | Ventajas | Limitaciones | Motivo de selección o descarte |
| --- | --- | --- | --- |
| Prisma Migrate | Integrado con el cliente | No expresa RLS, roles ni funciones avanzadas | Descartada |
| Liquibase con SQL explícito | Control total, rollback por changeset, validación de checksums | Mantener `schema.prisma` sincronizado a mano | Seleccionada |

## Consecuencias y compromisos

El CI aplica todas las migraciones sobre una base vacía, prueba los últimos rollbacks y audita los roles. Un cambio de comentario en un changeset ya aplicado declara su checksum anterior con `validCheckSum`.

## Referencias

Fuente: elaboración propia a partir de [changelog-master.yaml](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/changelog/changelog-master.yaml) y de [migraciones y rollbacks](../10-arquitectura/base-de-datos/migraciones-y-rollbacks.md).
