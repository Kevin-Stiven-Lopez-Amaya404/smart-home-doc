---
title: Archivo del backend
status: borrador
owner: backend
last_reviewed: 2026-11-03
canonical_for:
  - indice-archivo-backend
---

# Archivo del backend

Copia archivada de documentos históricos de `nataliachala1/smarthome-backend` (commit `1cbaca2`, contenido idéntico en `dev` `3bfce85`). Registran decisiones y resultados de su fecha y están marcados como `obsoleto`; no describen el estado actual del backend.

## Documentos

| Documento | Corte original | Origen en el backend |
| --- | --- | --- |
| [Alcance del backend del 8 de septiembre de 2026](alcance-2026-09-08.md) | 2026-09-08 | [`ALCANCE_2026_09_08.md`](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/ALCANCE_2026_09_08.md) |
| [Implementación HU 09-dev](implementacion-hu09.md) | 2026-10-14 | [`docs/IMPLEMENTACION_HU09.md`](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/docs/IMPLEMENTACION_HU09.md) |
| [Informe 01 de auditoría de backend y base de datos](informe-01-auditoria-backend-bd-2026-10-12.md) | 2026-10-12 | [`docs/INFORME_01_AUDITORIA_BACKEND_BD_2026-10-12.md`](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/docs/INFORME_01_AUDITORIA_BACKEND_BD_2026-10-12.md) |
| [Reporte de avance HU09](reporte-avance-hu09-2026-10-14.md) | 2026-10-14 | [`docs/REPORTE_AVANCE_HU09_2026-10-14.md`](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/docs/REPORTE_AVANCE_HU09_2026-10-14.md) |
| [Contrato MQTT local del backend](mqtt-contract-2026-10-15.md) | 2026-10-15 | [`docs/MQTT_CONTRACT.md`](https://github.com/nataliachala1/smarthome-backend/blob/fea02540ae12ed7501ae2b75f6216ab00411796a/docs/MQTT_CONTRACT.md) |

## Criterio del traslado

- Clasificados como pendientes de validar en el [inventario de implementaciones](../../00-contexto/inventario-implementaciones.md#nataliachala1smarthome-backend); se archivan por ser informes con fecha de corte, no por antigüedad.
- Contenido conservado sin cambios; se agregó una nota de estado y los enlaces relativos se fijaron al último commit que modificó cada documento (`dc1cbfc` para el informe 01, `bc9d3ec` para HU09), de modo que los rangos de líneas citados correspondan al código de su fecha.
- Los cuatro informes originales se retiraron de `smarthome-backend` en el PR #18 de `smarthome-backend` (commit `5615d37`, merge `fea0254` en `dev`), revisado y fusionado por la responsable del backend; estas copias son la única versión ([E15](../../00-contexto/evidencias-y-pendientes.md#e15--copia-archivada-de-informes-del-backend)).
- El contrato MQTT local y los otros ocho documentos de `docs/` del backend tienen copia en este repositorio ([matriz](../../00-contexto/migracion-docs-backend.md)); sus originales siguen en el backend hasta el retiro registrado en [E16](../../00-contexto/evidencias-y-pendientes.md#e16--copia-de-los-nueve-documentos-restantes-del-backend).
- No existe un documento sustituto equivalente; para el estado actual consultar la [arquitectura del backend](../../10-arquitectura/backend/README.md).

Fuente: [árbol del backend en el commit de origen](https://github.com/nataliachala1/smarthome-backend/tree/1cbaca28e9e152d5cb5ff7643560fdfa65857486).

[Volver al archivo](../README.md).
