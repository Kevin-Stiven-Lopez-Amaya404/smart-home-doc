---
title: Proceso de liberación
status: borrador
owner: operacion
last_reviewed: 2026-10-29
canonical_for:
  - proceso-liberacion
---

# Proceso de liberación

## Evidencia disponible

Hay configuraciones de construcción y despliegue en los repositorios de implementación. La [guía CI/CD](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/CICD.md) describe publicación de imágenes y un gate de despliegue deshabilitado, condicionado a auditoría y restauración. El código contradice parcialmente esa guía: [backend](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/.github/workflows/ci-deploy.yml) no tiene if: false y puede disparar deploy si hay secretos; [web](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/.github/workflows/ci-deploy.yml) y [datos](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/.github/workflows/ci-deploy.yml) sí lo bloquean explícitamente. No se comprobaron secretos ni ejecuciones y no se afirma una liberación activa.

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
