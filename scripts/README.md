---
title: Herramientas de calidad documental
status: borrador
owner: documentacion
last_reviewed: 2026-10-29
canonical_for:
  - indice-herramientas
---

# Herramientas de calidad documental

Ejecutar desde la raíz `node scripts/check-docs.mjs`. No instala paquetes ni llama APIs.

- [check-docs.mjs](check-docs.mjs): enlaces, anclas, estructura, metadatos y comprobaciones básicas.
- [source-references.json](source-references.json): fuentes externas contrastadas durante esta revisión, con evidencia de repositorio, revisión y ruta.

Estado: herramienta inicial; los límites están en [calidad documental](../docs/30-desarrollo/calidad-documental.md). Los resultados ejecutados están en el [registro](../docs/00-contexto/validacion-documental.md).

Fuente de convenciones: [política](../DOCUMENTATION_POLICY.md). Pendiente: integrar en CI solo si el equipo acuerda una configuración compatible; el repositorio inicial no tenía workflows.
