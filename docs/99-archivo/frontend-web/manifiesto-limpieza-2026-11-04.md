---
title: Manifiesto de limpieza documental del frontend web
status: borrador
owner: documentacion
last_reviewed: 2026-11-04
canonical_for:
  - manifiesto-limpieza-frontend-web
---

# Manifiesto de limpieza del frontend web — 2026-11-04

## Alcance y base

La aplicación fuente es `nataliachala1/smarthome-frontend-web` en `dev`, commit `76ac5d0d1e73df086566cf610bf941d3efc8ccf1`. Esta revisión no modifica el código, no acredita build ni prueba funcional y no autoriza borrar documentos antes de una copia verificada. Repositorio de destino: `Kevin-Stiven-Lopez-Amaya404/smart-home-doc`, rama base `main`.

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

## Incidencias abiertas

- La copia automática del documento histórico fue bloqueada; **originales intactos**.
- No existe todavía un PR de limpieza del repositorio web ni resultados de pruebas posteriores.
- Los PR preexistentes del frontend no forman parte de este traslado; no fusionarlos por efecto colateral.
