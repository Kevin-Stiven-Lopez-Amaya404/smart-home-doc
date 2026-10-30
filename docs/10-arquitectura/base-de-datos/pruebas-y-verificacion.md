---
title: Pruebas y evidencia de verificación de datos
status: borrador
owner: datos
last_reviewed: 2026-10-29
canonical_for:
  - pruebas-base-datos
---

# Pruebas y evidencia de verificación de datos

## Ejecutado en esta tarea

La revisión fue estática y documental: árboles de ramas, lectura de fuentes, recorrido de includes/SQL/rollback, extracción de tablas/columnas/funciones y comparación selectiva con consumidores backend.

Los resultados se registran en [inventario estructural](inventario-estructural.json) y [validación central](../../00-contexto/validacion-documental.md). No se ejecutaron PostgreSQL, Docker, Liquibase, SQL de prueba, purgas ni restauraciones.

## Pruebas y auditorías existentes

| Archivo | Qué comprueba según el código | Límite |
| --- | --- | --- |
| [audit-runtime-roles.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/audit-runtime-roles.sql) | Nueve diagnósticos de roles aplicación/ingesta, propietarios, RLS y DELETE de dispositivos | Lectura de catálogo; ocho tablas, no todas las reglas de negocio |
| [test-runtime-roles.ps1](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/test-runtime-roles.ps1) | Seis escenarios en contenedor aislado, positivos y negativos de la auditoría | Fixture sintética, no aplica todo el esquema |
| [session-security-fixture.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/session-security-fixture.sql) | Esquema mínimo para pruebas de sesión | No es una migración ni incluye todas las políticas |
| [consumption-access-fixture.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/consumption-access-fixture.sql) | Datos sintéticos para probar acceso a consumo con LOGIN separado | Requiere base de pruebas y esquema previo |
| [test-sql034-energy-rls.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/test-sql034-energy-rls.sql) | Roles, restricciones, denegaciones, tarifas y metas | Transacción de fixture; revisar contexto/rol antes de ejecutar |
| [test-sql034-optional-budget.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/test-sql034-optional-budget.sql) | Presupuesto/meta opcionales y restricciones | Requiere SQL034/002 |
| [audit-mqtt-revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/audit-mqtt-revocation.sql) | Aislamiento del LOGIN de revocación y contratos permitidos/prohibidos | No demuestra revocación real en broker |
| [regresión SQL032](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/tests/mqtt/sql032-reconciliation-null-retry.sql) | Ventana de reconciliación de operación incierta con retry_at nulo | Base desechable con SQL032; no prueba hardware |
| [baseline HU10](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/tests/mqtt/hu10-baseline.yaml) y [baseline revocación](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/tests/mqtt/hu11-revocation-baseline.yaml) | Subconjuntos históricos para ensayos de actualización | No representan todo el maestro actual |

## Integración que se ejecuta desde backend

Las guías de sesión y consumo remiten a runners del backend, no a scripts ausentes que deban inventarse dentro del repositorio de datos. Se verificaron sus rutas en backend dev `1cbaca28`:

- [test-session-security.ps1](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/scripts/test-session-security.ps1): usa la fixture de sesión y crea PostgreSQL desechable.
- [test-consumption-access.ps1](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/scripts/test-consumption-access.ps1): aplica el maestro, usa filtros HU16 y realiza rollback-count de un changeset antes de reaplicar.

El parámetro DatabaseRepository permite indicar una ruta de datos independiente; no se asume una carpeta común. Los informes hablan de un historial anterior de 64 changesets y resultados históricos: **no equivalen al maestro actual de 96**. Revisar el alcance de rollback-count antes del ensayo.

## Cobertura de CI declarada

[ci-deploy.yml](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/.github/workflows/ci-deploy.yml) se activa para push y PR hacia dev. Declara validate, update, comprobación del bootstrap, auditoría de LOGIN, status y validación de sintaxis Compose.

No incluye la ejecución de las suites SQL034 ni de la regresión SQL032. En el paso de auditoría, la invocación psql no activa explícitamente ON_ERROR_STOP ni exige los nueve resultados que sí exige test-runtime-roles.ps1. Revisar propagación de errores antes de considerar suficiente ese gate. No se declara un fallo de CI reproducido.

## Plan de verificación pendiente

1. Instalar todo el historial en PostgreSQL desechable con la versión elegida.
2. Contrastar databasechangelog, tablas, firmas, políticas, grants y propietarios.
3. Ejecutar las suites existentes con sus precondiciones y guardar resultados reales.
4. Probar acceso con LOGIN no privilegiados y contexto funcional real, incluyendo GUEST y denegaciones por dispositivo.
5. Contrastar HTTP/realtime y el worker broker con esa instalación.
6. Ensayar upgrade desde una versión identificada y recuperación con copia restaurada.

Los comandos disponibles de preparación están en [configuración](configuracion-y-ejecucion.md). No se incorpora una suite ficticia ni se trasladan fixtures ejecutables a la central.
