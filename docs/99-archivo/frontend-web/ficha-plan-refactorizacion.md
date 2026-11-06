---
title: Ficha histórica — propuesta de refactorización web
status: borrador
owner: documentacion
last_reviewed: 2026-11-05
canonical_for:
  - ficha-historica-plan-refactorizacion-web
---

# Ficha histórica — Propuesta de refactorización del frontend web

## Procedencia

Fuente íntegra: [FRONTEND_WEB_REFACTOR_PLAN.md](https://github.com/nataliachala1/smarthome-frontend-web/blob/76ac5d0d1e73df086566cf610bf941d3efc8ccf1/FRONTEND_WEB_REFACTOR_PLAN.md), blob Git `221bf4b4a78acdd3bffa1dc774a15084add890a8`. Documento de 428 líneas en el commit `76ac5d0`. **Ficha resumida; no reemplaza la copia íntegra del original**, que permanece en el frontend.

## Propuesta que contiene el original

El texto propone una refactorización gradual, no una reescritura, para alinear el aspecto de la web con el móvil. Identifica como áreas de trabajo el shell `Sidebar`/`Navbar`/`DashboardLayout`, el contexto de tema, tokens visuales, navegación y el contexto de hogar activo.

Sus apartados examinan arquitectura y carpetas, rutas, componentes, API, Socket.IO, autenticación, roles, experiencia de usuario, código duplicado o posiblemente obsoleto y riesgos de modificar cada módulo. El plan ordena las acciones así:

1. Auditoría y base visual.
2. Shell global y diseño consistente.
3. Enrutamiento según la experiencia del producto.
4. Reutilización de componentes y reducción de duplicados.
5. Gestión de estado global y hogar activo.
6. Pulido visual y de experiencia de usuario.
7. Validación final.

## Estado y límites

Es una **propuesta histórica**. Las rutas, carpetas y descripciones de problemas que enumera necesitan contrastarse con `dev` vigente antes de usarse como tareas; no indican que esos defectos persistan o que las acciones estén aprobadas. Esta ficha no introduce nuevos requisitos ni modifica código.

Ver [arquitectura web](../../10-arquitectura/web/README.md) y [manifiesto de limpieza](manifiesto-limpieza-2026-11-04.md).
