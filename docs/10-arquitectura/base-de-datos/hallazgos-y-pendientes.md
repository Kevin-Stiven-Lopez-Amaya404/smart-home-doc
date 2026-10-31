---
title: Hallazgos y pendientes de base de datos
status: borrador
owner: datos
last_reviewed: 2026-10-29
canonical_for:
  - hallazgos-base-datos
---

# Hallazgos y pendientes de base de datos

Cada hallazgo corresponde a la instantánea dev `6caed6b`. Las diferencias estáticas no se presentan como fallos reproducidos ni se corrigen modificando otro repositorio.

## DB01 — README rezagado frente a SQL034

**Confirmado en archivos; consolidación pendiente.** El README excluye tarifas, pero el maestro incluye dos changesets de tarifas/metas. monthly_budget_cop termina siendo opcional con al menos un presupuesto o target_kwh presente.

Fuentes: [README](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/README.md), [SQL034](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/034_energy_tariff_budget/changelog.yaml). La central describe el [modelo derivado](modelo-de-datos.md), sin afirmar soporte REST o facturación.

## DB02 — Cobertura incompleta de rollback

**Confirmado en changelogs.** README afirma rollback de todos los changesets activos, pero 030 y 031 no lo declaran. 009 usa SELECT 1 intencional, no una reversión de esquema.

Fuentes: [030](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/030_mqtt_enable_fencing/changelog.yaml), [031](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/031_mqtt_bootstrap_authorization/changelog.yaml), [009](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/009_session_schema/changelog.yaml). Cierre: definir recuperación/compatibilidad y verificarla en aislamiento; no crear rollback ficticio.

## DB03 — SQL028 se comenta separada pero se incluye en maestro

**Riesgo de operación pendiente de decisión.** El encabezado indica propuesta, separación y no ejecución productiva; el maestro la incluye en el recorrido normal. La implementación está presente, pero no acredita aprobación para aplicarla a producción.

Fuentes: [SQL028](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/028_mqtt_preparation_secret/001_mqtt_preparation_secret.sql), [maestro](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/changelog/changelog-master.yaml). Verificar gate y propósito de la release antes de una migración.

## DB04 — Wrappers de actualización distintos

**Diferencia estática.** update.ps1 ejecuta validate/update-sql/update sin comprobar LASTEXITCODE entre comandos. update.bat comprueba errorlevel, pero no muestra update-sql. No se garantiza la misma interrupción/inspección del plan.

Fuentes: [PowerShell](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/update.ps1), [BAT](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/update.bat). Revisar comportamiento en el entorno de ejecución; no se probó un fallo nativo para afirmar un resultado concreto.

## DB05 — CI no reproduce todas las pruebas ni asegura el mismo diagnóstico

**Revisión pendiente.** CI aplica migraciones y ejecuta auditoría de roles, pero no corre suites SQL034 o regresión SQL032. La invocación psql de auditoría no fija ON_ERROR_STOP y no valida que haya nueve resultados, a diferencia del runner PowerShell. Revisar cómo se propagan errores SQL o una salida vacía.

Fuentes: [workflow](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/.github/workflows/ci-deploy.yml), [runner](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/test-runtime-roles.ps1). No se declara un fallo de pipeline observado ni una ejecución aprobada.

## DB06 — Guía de diagnóstico y Compose productivo no coinciden

**Confirmado en archivos.** TROUBLESHOOTING pide logs de postgres, servicio ausente del Compose productivo, que usa PostgreSQL externo. También presupone un broker específico; la configuración actual solo declara una URL y flags que deben auditarse.

Fuentes: [guía](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/TROUBLESHOOTING.md), [Compose](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml). Resolver instrucciones después de identificar la instalación real.

## DB07 — Permisos de consumo frente a destinatarios realtime

**Riesgo pendiente de prueba entre componentes.** Los helpers de detalle aplican permiso por dispositivo; fn_mqtt_realtime_recipients devuelve propietario/miembros activos sin ese filtro. El backend agrega restricciones de membresía, pero no expresa allí el mismo control por dispositivo.

Fuentes: [permisos](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql), [destinatarios](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/033_mqtt_ingest_realtime/001_mqtt_ingest_realtime.sql), [registro transversal E07](../../00-contexto/evidencias-y-pendientes.md). No se afirma una explotación comprobada.

## DB08 — Auditoría general no cubre todos los nuevos objetos

**Límite confirmado.** audit-runtime-roles evalúa aplicación/ingesta y ocho tablas. Hay 13 roles de grupo, contratos de propósito y tablas nuevas. No generalizar su PASS a toda la base o a corrección semántica de cada política.

Fuente: [auditoría](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/audit-runtime-roles.sql). Usar también la auditoría de revocación y definir cobertura faltante con pruebas positivas/negativas.

## DB09 — Modelo Prisma y DDL no son equivalentes completos

**Diferencia de alcance.** Se localizaron 18 modelos Prisma en el backend revisado y 33 nombres de tabla en el recorrido SQL, incluida DEFAULT. Hay acceso SQL directo a objetos MQTT; esto no prueba incompatibilidad por sí solo. SQL034 tampoco demuestra endpoints disponibles.

Fuentes: [schema.prisma](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/prisma/schema.prisma), [catálogo de funciones](funciones-y-flujos.md). Contrastar firma, permisos y consumidores por flujo.

## DB10 — Evidencia histórica de pruebas no representa el maestro actual

**Confirmado en alcance.** Las guías de consumo describen 64 changesets y ensayos anteriores. El maestro actual contiene 96. El runner backend usa el maestro recibido y rollback-count de un changeset; no se debe describir como una prueba congelada de la antigua release.

Fuentes: [informe](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/HU16_CONSUMPTION_ACCESS.md), [runner backend](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/scripts/test-consumption-access.ps1). Repetir con revisión identificada.

## DB11 — Configuración de refresh aún exigida por Compose

**Pendiente ya registrado transversalmente.** JWT_REFRESH_SECRET se exige en Compose, mientras el backend utiliza refresh opaco. Configuración y validador deben reconciliarse por sus propietarios.

Fuentes: [Compose](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml), [variables centrales](../../40-operacion/variables-de-entorno.md).

## DB12 — Instalación, roles y servicios no verificados

El checkout local está en 03-dev con modificaciones previas; no se usó como espejo de dev ni se modificó. Se encontraron referencias de worktree antiguas; no se podaron ni repararon. No se inspeccionaron .env, copias privadas o reportes temporales de infraestructura.

Falta comprobar versión PostgreSQL real, historial aplicado, propietarios y LOGIN, ACL broker, montaje de certificados, mantenimiento periódico y restauración. Las fuentes canónicas siguen siendo código y configuración más evidencia del entorno real.

## Criterio de cierre

Registrar commit, entorno aislado, procedimiento, resultados reales y acuerdo cuando corresponda. Un documento no se promueve a vigente por resolver enlaces, ni se acepta un ADR a partir de estos hallazgos.

[Pruebas](pruebas-y-verificacion.md). [Índice](README.md).
