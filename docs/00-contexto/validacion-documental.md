---
title: Registro de validación documental
status: borrador
owner: documentacion
last_reviewed: 2026-10-29
canonical_for:
  - resultados-validacion
---

# Registro de validación documental

## Resultado y reproducción

Revisión del 2026-10-29. El validador documental se ejecutó con Node.js **v24.20.0**, sin instalar dependencias. Los [resultados JSON de la última ejecución](resultados-validacion.json) contienen contadores y errores; no son pruebas del sistema SmartHome.

Comando reproducible desde la raíz:

```sh
node scripts/check-docs.mjs
git diff --check
```

En esta máquina se utilizó la ruta absoluta de node.exe porque no está en PATH. El script y su [manifiesto de fuentes](../../scripts/source-references.json) están versionables junto a los documentos.

## Resultado de la organización inicial

- 48 Markdown con metadatos e identificadores canónicos únicos.
- 241 enlaces internos, incluidas 13 referencias a anclas, comprobados sin errores.
- 233 referencias externas únicas registradas con evidencia de Git.
- 6 ejemplos JSON válidos y 2 bloques Mermaid sin renderizado.
- 14 directorios comprobados con README, incluida la raíz.

## Revisión de base de datos

La ampliación de datos se prepara en docs/db desde origin/main c5ba34a1f99ecaab3717fe9fe7028192262dae96, después de integrar PR #1. Sus [12 guías](../10-arquitectura/base-de-datos/README.md) reúnen la documentación junto a la del backend.

Resultados estáticos ejecutados:

- 332 archivos enumerados; 288 contenidos recuperados, excluidos 44 .gitkeep.
- 42 changelogs y 96 changesets recorridos; cero rutas de avance/rollback faltantes o ciclos localizados.
- 93 referencias a rollback SQL, un rollback inline de conservación y dos changesets sin rollback.
- Inventario consistente: 33 nombres de tabla, incluida DEFAULT; 73 nombres de función con última definición.
- 295 nombres de columna y 73 posiciones de definición de función contrastados con las fuentes recuperadas, sin discrepancias en esa comprobación.
- 60 Markdown, 323 enlaces internos y 13 referencias a anclas; 495 referencias externas únicas registradas.
- 3 archivos JSON y 6 ejemplos JSON válidos. Tres bloques Mermaid contabilizados, sin renderizar.

La primera comprobación de la ampliación detectó un formato incorrecto al incorporar referencias al manifiesto. Se corrigió y se volvió a ejecutar el validador con resultado satisfactorio. El [inventario estructural](../10-arquitectura/base-de-datos/inventario-estructural.json) registra alcance y límites; no representa un catálogo PostgreSQL instalado.

Los resultados JSON enlazados al inicio corresponden a la última ejecución, no a la organización inicial. La comprobación git diff --check cubre archivos seguidos; el validador recorre también los nuevos.

## Estado registrado antes del primer commit

Al terminar la construcción inicial, docs/organizacion y main apuntaban a dfe55be09e1a3237cc75490569969eff6b7c9586. Se comprobó que el cambio de rama conservó el estado y los hashes SHA-256 de los 51 archivos. En ese momento: README.md modificado y 50 archivos nuevos sin seguimiento; cero archivos movidos o eliminados. Durante esa fase no se hizo staging, commit, push ni merge. Este apartado conserva la inspección previa; el estado posterior debe consultarse en Git. El repositorio plural y el código de las implementaciones se conservaron.

## Comprobaciones ejecutadas

- Git: remoto correcto, main, commit inicial dfe55be09e1a3237cc75490569969eff6b7c9586 y estado limpio antes de editar.
- Lectura de todos los archivos iniciales: únicamente README.md.
- Enumeración de árboles completos de cuatro implementaciones y contraste de rutas por commit.
- Inventario de 22 antecedentes externos y 70 documentos de implementación localizados.
- Detección por blob de dos DOCX idénticos y por hash de texto extraído de tres variantes.
- Script documental: archivos esperados, índices, nombres, metadatos, canonical_for único, enlaces y anclas, referencias externas registradas, tablas, fences y ejemplos JSON.
- git diff --check: ejecutado; sin errores de espacio en el diff del archivo seguido README.md. Git informa conversión futura LF a CRLF según configuración local; no se cambió esa configuración.

La primera comprobación sin staging solo cubría README.md. Antes de publicar se prepararon los 51 archivos y se ejecutó git diff --cached --check sobre todo el contenido. Detectó una línea vacía adicional al final de la referencia técnica del backend; se corrigió y la comprobación volvió a ejecutarse sin errores.

## Alcance real de las referencias externas

La organización inicial registró 233 referencias únicas. La revisión de datos amplió ese manifiesto con rutas y commits contrastados y dos páginas oficiales de PostgreSQL. El validador local compara con el registro: no hace solicitudes HTTP ni demuestra disponibilidad futura o funcionamiento de servicios.

## Límites

No se ejecutaron aplicaciones, suites, migraciones, brokers, firmware, despliegues ni restauraciones. No se generó OpenAPI. Los dos bloques Mermaid se contabilizan y sus fences se comprueban; no se renderizaron. La lectura DOCX fue textual para clasificación, sin aprobación visual o formal.

No hay evidencia aquí de ADR aceptados, aprobación de producto, pruebas funcionales aprobadas, alertas activas o backups restaurados.

## Fuentes

[Mapa](mapa-de-repositorios.md), [inventario](inventario-documental.md), [discrepancias](evidencias-y-pendientes.md), [script](../../scripts/check-docs.mjs), [alcance del validador](../30-desarrollo/calidad-documental.md).

Pendientes funcionales y operativos permanecen en el registro; un resultado documental satisfactorio no los cierra.
