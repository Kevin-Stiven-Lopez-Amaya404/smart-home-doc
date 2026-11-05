---
title: Archivo
status: borrador
owner: documentacion
last_reviewed: 2026-11-04
canonical_for:
  - indice-99-archivo
---

# Archivo

Retiro de referencias con preservación de historial.

## Documentos

- [Archivo del backend](backend/README.md): copia archivada de cuatro informes históricos de `smarthome-backend`, del 2026-11-03. Los originales se retiraron del backend en el PR #18 (merge `fea0254`). También contiene una copia del contrato MQTT local, conciliado en el contrato central; su original sigue en el backend hasta el retiro registrado en E16.
- [Archivo del frontend web](frontend-web/README.md): inventario de documentos históricos, origen verificado y manifiesto de limpieza; copias íntegras aún pendientes.
- [Archivo de frontend móvil](movil/README.md): copias sanitizadas de 26 documentos de `from_movil` con manifiesto, fecha y hash de origen.
- [Archivo de base de datos](base-de-datos/README.md): copias archivadas y manifiesto de migración de `smarthome-database`.

## Fuentes y pendientes

Estado inicial: borrador. Consultar [mapa de fuentes](../00-contexto/mapa-de-repositorios.md) y [pendientes](../00-contexto/evidencias-y-pendientes.md). Los roles de mantenimiento se proponen por tema y su asignación está pendiente.

[Volver al índice](../README.md).

## Procedimiento de retiro

1. Identificar motivo verificable y reemplazo; la antigüedad no basta.
2. Buscar referencias entrantes en archivos y ramas accesibles. Registrar referencias externas fuera de control.
3. Proponer estado obsoleto con fecha, motivo y enlace al sustituto; explicar el vacío si no existe.
4. Si se autoriza el traslado, preservar historial con Git y actualizar índices y vínculos. Considerar una referencia corta en la ruta anterior.
5. Comprobar enlaces y revisar diferencias antes del PR. No eliminar irreversiblemente originales.

Los antecedentes del repositorio separado smart-home-docs permanecen en sus ramas y están [inventariados](../00-contexto/inventario-documental.md).
