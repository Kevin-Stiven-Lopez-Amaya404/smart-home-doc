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
- Es una copia: los originales siguen en `smarthome-backend` (`dev` `3bfce85`). Retirarlos allí o reemplazarlos por un enlace a este archivo requiere acuerdo con el responsable del backend; no se modificó ese repositorio.
- Los demás documentos de `docs/` del backend se mantienen junto al código y se enlazan desde esta documentación.
- No existe un documento sustituto equivalente; para el estado actual consultar la [arquitectura del backend](../../10-arquitectura/backend.md).

Fuente: [árbol del backend en el commit de origen](https://github.com/nataliachala1/smarthome-backend/tree/1cbaca28e9e152d5cb5ff7643560fdfa65857486).

[Volver al archivo](../README.md).
