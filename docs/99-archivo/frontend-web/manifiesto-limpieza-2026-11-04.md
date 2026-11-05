---
title: Manifiesto de limpieza documental del frontend web
status: borrador
owner: documentacion
last_reviewed: 2026-11-05
canonical_for:
  - manifiesto-limpieza-frontend-web
---

# Manifiesto de limpieza del frontend web — 2026-11-04

## Alcance y base

La aplicación fuente es `nataliachala1/smarthome-frontend-web` en `dev`, commit `76ac5d0d1e73df086566cf610bf941d3efc8ccf1`. El manifiesto registra acciones verificadas sin asumir que el traslado histórico esté completo. No autoriza borrar los tres informes originales antes de una copia verificada. Repositorio de destino: `Kevin-Stiven-Lopez-Amaya404/smart-home-doc`, rama base `main`.

## Clasificación comprobada

| Archivo fuente | Acción | Justificación |
| --- | --- | --- |
| `AUDITORIA_TECNICA_FRONTEND_2026-10-25.md` | Copiar a `docs/99-archivo/frontend-web/`; luego retirar original | Histórico, no fuente canónica de arquitectura |
| `FRONTEND_WEB_REFACTOR_PLAN.md` | Copiar a archivo histórico como propuesta; luego retirar original | Plan aún sujeto a contrastación con código |
| `Informe_Auditoria_SmartHome_Frontend_Backend_2026-10-08.md` | Copiar a archivo transversal o frontend-web histórico; luego retirar original | Auditoría cruzada de versiones anteriores |
| `AUDITORIA_FRONTEND_SMARTHOME.md` | Revisar y sustituir por documentación de entorno adecuada | Contiene solo ejemplos SMTP, no una auditoría |
| `package-lock.json` (raíz) | Candidato a retirar tras comprobar CI | No existe `package.json` en raíz; lockfile contiene `packages: {}` |
| `web/guidelines/Guidelines.md` | Candidato a retirar | Plantilla genérica sin adaptar; comprobar referencias antes |
| `web/src/styles/globals.css` | Candidato a retirar | Archivo vacío; comprobar importaciones |
| `docker-compose.yml` | Mantener en revisión | Apunta a rutas externas no presentes; no eliminar sin decidir ubicación del entorno integrado |
| `web/ATTRIBUTIONS.md` | Conservar y auditar licencias | Las atribuciones de terceros no deben perderse |
| `web/package-lock.json`, `web/package.json`, `web/Dockerfile`, `web/nginx.conf`, `.github/workflows/ci-deploy.yml` | Conservar | Necesarios para build, despliegue o validación |

## Orden seguro de ejecución

1. Verificar origen y revisar posibles secretos, enlaces y referencias entrantes de cada archivo.
2. Copiar contenido íntegro a este repositorio y comparar su blob Git/huella. No declarar copia completada antes de compararla.
3. Validar metadatos documentales, navegación y `node scripts/check-docs.mjs`.
4. Aprobar el PR documental a `main` y comprobar el resultado.
5. En una rama nueva desde `smarthome-frontend-web/dev`, retirar solo archivos archivados/verificados y residuos no referenciados.
6. Desde `web/`, ejecutar `npm ci`, `npm run lint`, `npm run typecheck`, `npm run test:contracts` y `npm run build`; además validar imagen Docker y rutas.
7. Abrir PR web contra `dev` y verificar CI antes de fusionar.

## Avance verificado al 2026-11-05

- En el fork `Kevin-Stiven-Lopez-Amaya404/smarthome-frontend-web` se creó `dev` desde el commit original `76ac5d0` y la rama `chore/limpieza-frontend-web-2026-11-05`.
- PR del fork #1: retiró `AUDITORIA_FRONTEND_SMARTHOME.md`, el lockfile huérfano de raíz, la plantilla genérica de `web/guidelines/` y el CSS vacío; actualizó README.
- El commit `503f188e` restringió publicación GHCR a pushes de `dev` del upstream original, para no publicar automáticamente desde el fork.
- Validación del commit `503f188e`: GitHub Actions `validate` aprobó instalación npm, lint, typecheck, contratos, Vite build, Docker build y smoke test. Resultado: `41971736329`.
- Los tres informes originales siguen en el frontend y sus copias completas están verificadas en el archivo documental.
- El PR #1 del fork y este PR documental continúan en borrador; no hay fusión a `nataliachala1/smarthome-frontend-web/dev`.

## Incidencias abiertas

- La copia directa por integración fue bloqueada; las copias completas se obtuvieron y verificaron mediante Git local.
- El PR de limpieza del fork ya existe y su CI pasó; falta integración al upstream y completar la migración documental literal.
- Los PR preexistentes del frontend no forman parte de este traslado; no fusionarlos por efecto colateral.

## Preservacion completa verificada

Los tres documentos se conservan en [originales/](originales/README.md), con hashes Git coincidentes. Los originales no se han eliminado.
