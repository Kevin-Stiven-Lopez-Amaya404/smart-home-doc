---
title: Proceso de liberación
status: borrador
owner: operacion
last_reviewed: 2026-11-04
canonical_for:
  - proceso-liberacion
---

# Proceso de liberación

## Evidencia disponible

El CI de datos ejecuta Liquibase `validate`, aplica los changesets en un PostgreSQL 18 efímero de GitHub Actions, ejecuta `status` y valida el Compose; no accede al VPS. Su job de despliegue tiene `if: ${{ false }}` en [ci-deploy.yml](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/.github/workflows/ci-deploy.yml), línea 93. La guía del 2026-10-22 afirmaba que el gate estaba deshabilitado en los tres repositorios, pero el código lo contradice parcialmente: [backend](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/.github/workflows/ci-deploy.yml) no tiene `if: false` y puede disparar deploy si hay secretos. Esa guía proponía un único workflow coordinador antes de habilitar el gate, recuperar la aplicación con la etiqueta SHA de imagen anterior y recordaba que el workflow no revierte esquema ni datos. Antecedente: [CI/CD](../99-archivo/base-de-datos/originales/docs/deployment/cicd.md). [Web](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/.github/workflows/ci-deploy.yml) conserva su referencia existente. No se comprobaron secretos ni ejecuciones.

[eas.json](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/eas.json) declara perfiles development, preview y production. Su presencia no prueba builds firmados, distribución ni publicación en tiendas.

## Recorrido propuesto, pendiente de aprobación

1. Identificar revisiones compatibles de backend, SQL, web y móvil.
2. Ejecutar comprobaciones existentes y conservar resultados reales; resolver diferencias de contratos y permisos.
3. Generar/revisar OpenAPI en el perfil elegido; documentar cambios incompatibles y migraciones.
4. Validar backup restaurado y cambios de datos en aislamiento.
5. Revisar variables, imágenes inmutables y configuración del entorno.
6. Solicitar la autorización operativa que el equipo defina y realizar liberación coordinada.
7. Verificar salud y recorridos de usuario; registrar versiones, resultados y recuperación prevista.

Este recorrido no establece un número de aprobadores ni una política de ramas no verificada. Las imágenes pueden retrocederse de versión; eso no revierte automáticamente esquema o datos.

## Pendientes y límites

Reconciliar gates de workflows y verificar ejecuciones, responsable de liberación, versionado, changelog, compatibilidad hacia atrás y procedimiento de rollback. No se desplegó ni habilitó automatización en esta tarea.

Fuentes: [mapa de revisiones](../00-contexto/mapa-de-repositorios.md), [pruebas](../30-desarrollo/estrategia-de-pruebas.md), [despliegue](../40-operacion/despliegue.md), [copias](../40-operacion/copias-de-seguridad.md).
