---
title: Documentación del backend
status: borrador
owner: backend
last_reviewed: 2026-11-06
canonical_for:
  - indice-backend
---

# Documentación del backend

La [arquitectura del backend](arquitectura.md) resume el corte `dev` actual `60297c361e4acac6e98161337ef8e149e069d441`, sus módulos, límites y enlaces a los contratos actualizados.

La [referencia técnica](referencia-tecnica.md) conserva el análisis de la instantánea `dev` `1cbaca28e9e152d5cb5ff7643560fdfa65857486`: arquitectura, endpoints, árbol completo, configuración e inconsistencias. Está marcada como evidencia histórica y no sustituye la lectura del código actual.

Es una derivación de consulta con revisión fija, no una segunda fuente de implementación. Para actualizarla: identificar commit, repetir lectura de código/DTO/configuración/pruebas, comprobar rutas y enlaces, contrastar clientes y SQL y registrar los nuevos límites.

Fuentes canónicas: [bootstrap](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/main.ts) y archivos enlazados en la referencia. No se compiló ni ejecutó el backend. Las limitaciones de la primera inspección quedan identificadas como históricas; consultar los [pendientes centrales](../../00-contexto/evidencias-y-pendientes.md).

[Volver al índice de arquitectura](../README.md).


## Seguridad realtime

Consulte la [guía de seguridad para sesiones y eventos Socket.IO](seguridad-realtime.md).
