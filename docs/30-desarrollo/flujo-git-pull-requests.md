---
title: Flujo Git y Pull Requests
status: borrador
owner: desarrollo
last_reviewed: 2026-10-29
canonical_for:
  - flujo-git
---

# Flujo Git y Pull Requests

## Flujo indicado para smart-home-doc

Según la indicación del usuario del 2026-10-29, usar main como rama principal y preparar cambios documentales en ramas de trabajo creadas desde main. El objetivo es integrar documentación revisada mediante Pull Request, con base main.

Para esta construcción se usa **docs/organizacion**, basada en el main local, en el commit dfe55be09e1a3237cc75490569969eff6b7c9586. El cambio de rama conservó los 51 archivos y el estado de los cambios locales; se compararon sus hashes SHA-256 antes y después.

No se verificaron protección de ramas, aprobadores obligatorios o reglas automáticas de merge. La indicación establece el flujo de este repositorio; no demuestra una política equivalente en los repositorios de implementación.

## Preparación inicial de la rama de trabajo

Antes de crear la rama se comprobaron remoto, estado y rama. Después se abrevió su nombre mediante:

```sh
git branch -m docs/organizacion
```

El cambio de nombre conservó la referencia de trabajo y los cambios sin confirmar. Al finalizar esa preparación, main mantenía su commit inicial y la documentación aún no se había confirmado ni publicado. El estado posterior se consulta en Git.

## Preparar la revisión e integración

1. Identificar tema y fuente canónica con la [política](../../DOCUMENTATION_POLICY.md).
2. Trabajar en docs/organizacion, manteniendo las áreas documentales dentro de la misma rama.
3. Revisar diferencias, ejecutar validaciones documentales y describir fuentes, límites y resultados.
4. Con autorización para publicar, preparar commits de alcance claro y subir la rama.
5. Abrir un Pull Request con base main y compare docs/organizacion.
6. Revisar cambios y resolver observaciones antes de autorizar el merge.
7. Actualizar el main local después de integrar y crear los siguientes trabajos desde ese main actualizado.

La creación y el cambio de nombre de la rama no incluyeron staging, commit, push, apertura del PR ni merge. Publicar requiere preparar un commit y subir la rama; la integración mediante PR se realiza después de su revisión. La revisión no convierte automáticamente requisitos o ADR en acuerdos aceptados: registrar su evidencia explícita.

## Trabajos siguientes

Cuando no existan cambios locales pendientes, la secuencia recomendada por el usuario es:

```sh
git switch main
git pull --ff-only origin main
git switch -c docs/nombre-del-trabajo
```

El último nombre es un marcador que debe sustituirse. La actualización desde origin y esta rama de ejemplo no se ejecutaron en esta entrega.

Ejemplos de futuras ramas independientes, todavía no creadas:

| Rama | Propósito |
| --- | --- |
| docs/arquitectura-sistema | Arquitectura global |
| docs/contratos-api-mqtt | Contratos de integración |
| docs/desarrollo-operacion | Guías técnicas |
| docs/producto-procesos | Documentación funcional |

Crear cada una desde main actualizado después de integrar el trabajo anterior. Git registra ramas como referencias a commits; el nombre con barras no establece una jerarquía permanente de ramas padre e hijas.

## Comandos de inspección usados

```sh
git remote -v
git status --short
git branch --show-current
git branch -a
git log -5 --oneline
git diff --check
```

Fuentes: indicación del usuario en esta sesión, [mapa y revisiones](../00-contexto/mapa-de-repositorios.md) y [contribución](../../CONTRIBUTING.md). El historial Git registra los commits y las referencias publicadas; esta guía no sustituye su consulta.
