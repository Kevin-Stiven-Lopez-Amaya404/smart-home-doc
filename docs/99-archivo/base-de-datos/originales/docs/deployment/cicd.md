---
title: "CI/CD en la rama `dev` (archivado)"
status: obsoleto
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - archivo-bd-deployment-cicd
---

# CI/CD en la rama `dev`

> **Estado documental:** obsoleto (histórico/no canónico). Estado del punto 2: contradictorio.
>
> **Origen:** [docs/deployment/CICD.md](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/deployment/CICD.md), ruta original `docs/deployment/CICD.md`, SHA-256 `32c8d2d81bc4ea7fd98d9acee339b2da70c3a4cbac3d80cf1dabb4733ef6ecbb`, blob `1585e68b6791bb1c920424587c91cf5a79a8d04a`.
>
> **Sustituto:** [proceso-de-liberacion](../../../../../60-producto-procesos/proceso-de-liberacion.md).
>
> El contenido se conserva sin cambios, salvo los enlaces relativos indicados en el punto 4 de la ficha. El original se retirará del repositorio de base de datos solo tras fusionar este PR.

Cada repositorio tiene `.github/workflows/ci-deploy.yml`, activado por push a `dev`.

| Repositorio | Comprobaciones |
| --- | --- |
| Backend | `npm ci`, ESLint, TypeScript, pruebas Jest, build NestJS y publicación en GHCR. |
| Frontend | `npm ci`, ESLint, TypeScript, build Vite y publicación en GHCR. |
| Base de datos | Liquibase `validate`, aplicación de changesets en PostgreSQL 18 efímero, `status` y validación de Compose. |

Los repositorios de backend y frontend publican etiquetas `dev` y SHA después de pasar sus comprobaciones. Las comprobaciones de base de datos solo usan una base temporal de GitHub Actions; nunca acceden al VPS.

## Gate de producción

El job que contacta al webhook de Dokploy está deshabilitado en los tres workflows. No lo habilites hasta identificar la instancia PostgreSQL existente y sus redes, revisar `databasechangelog`, crear y restaurar un backup verificable en aislamiento, revisar las migraciones pendientes y completar la configuración de Dokploy.

GitHub limita cada grupo `concurrency` al repositorio que declara el workflow. Por ello, el grupo usado aquí no serializa despliegues de repositorios distintos. Antes de habilitar el gate se debe mover el disparo de Dokploy a un único workflow coordinador, para que dos repositorios no inicien despliegues simultáneos.

## Secretos requeridos cuando se habilite el deploy

- `DOKPLOY_DEPLOY_WEBHOOK`: URL privada de despliegue del servicio Compose en Dokploy.
- `DEPLOYMENT_HEALTH_URL`: URL HTTPS del frontend con ruta `/health/live`, que Nginx reenvía al backend.

El token `GITHUB_TOKEN` que usa Actions permite publicar paquetes. No se guarda un token personal en el repositorio.

## Fallos y recuperación

Si lint, tipos, pruebas, compilación o validación de migraciones falla, no se debe iniciar el despliegue. Si el chequeo de salud falla tras habilitarlo, revisa Dokploy y selecciona la etiqueta SHA de imagen anterior para restaurar la aplicación.

El workflow no revierte cambios de esquema ni restaura datos. Los cambios Liquibase deben ser compatibles hacia atrás y tener rollback revisado. Antes de ejecutar una migración contra la instancia existente debe haber un backup restaurado con éxito en aislamiento.
