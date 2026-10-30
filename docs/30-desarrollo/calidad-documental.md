---
title: Calidad documental
status: borrador
owner: documentacion
last_reviewed: 2026-10-29
canonical_for:
  - calidad-documental
---

# Calidad documental

## Herramienta mínima

El repositorio inicial no tenía CI, package.json ni validadores. Se utiliza Node.js sin dependencias externas y sin añadir una plataforma de publicación o un workflow.

Desde la raíz:

```sh
node scripts/check-docs.mjs
git diff --check
```

En esta máquina se ejecutó Node con su ruta absoluta; no requiere instalación de paquetes ni acceso a servicios. Consulte [resultados reales](../00-contexto/validacion-documental.md).

## Comprobaciones

- Archivos requeridos por la estructura objetivo e índices README.
- Nombres Markdown, un título principal y bloques de código balanceados.
- Metadatos YAML del subconjunto establecido: título, estado, rol, fecha y canonical_for único.
- Destinos relativos y anclas explícitas o derivadas de encabezados.
- Ejemplos y archivos JSON sintácticamente válidos, formato del registro de fuentes y estructura básica de tablas. El inventario de datos se contrasta internamente por cantidades, secuencia y rutas de changesets verificadas.
- Referencias externas contra [el manifiesto de fuentes comprobadas](../../scripts/source-references.json), fijado a rutas y commits de los árboles inspeccionados.
- Señales simples de claves privadas o asignaciones de secretos; no es un escáner de seguridad exhaustivo.

El [script](../../scripts/check-docs.mjs) es deliberadamente pequeño: no implementa un parser Markdown/YAML completo, no renderiza Mermaid ni DOCX y no hace solicitudes HTTP. El manifiesto registra comprobación de acceso y rutas en Git, además de páginas oficiales consultadas; no garantiza disponibilidad futura o funcionamiento de servicios.

## Actualizar fuentes

Si cambia un enlace externo, comprobar repositorio, commit y ruta real antes de registrarlo. Añadir su evidencia al manifiesto; no silenciar un fallo inventando una verificación. Si no se puede comprobar, dejar el pendiente en texto y no presentar la URL como fiable.

La validación no sustituye revisión técnica, acuerdo de producto ni pruebas entre componentes. Un documento vigente debe indicar fuentes; los borradores no se promueven de estado automáticamente.

Fuentes: [política](../../DOCUMENTATION_POLICY.md), [script](../../scripts/check-docs.mjs), [mapa](../00-contexto/mapa-de-repositorios.md).
