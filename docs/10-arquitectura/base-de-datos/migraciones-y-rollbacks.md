---
title: Migraciones, orden y rollbacks
status: borrador
owner: datos
last_reviewed: 2026-10-29
canonical_for:
  - migraciones-base-datos
---

# Migraciones, orden y rollbacks

## Fuente y recorrido

Fuente única de evolución: [changelog maestro](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/changelog/changelog-master.yaml). La revisión estática recorrió **42 changelogs, 96 changesets y 96 referencias SQL de avance**. Todas sus rutas de avance y rollback referenciado existen; no se detectaron ciclos ni id repetido en el mismo archivo.

No es un resultado de liquibase validate/update, una comparación de checksums instalados o una aprobación de migración productiva. El [inventario estructural](inventario-estructural.json) conserva secuencia e identificadores.

## Orden efectivo

1. Extensiones y ocho esquemas.
2. Tablas base, ALTER, funciones, triggers e índices.
3. Catálogos DML.
4. Roles, grants y RLS.
5. Refactors posteriores al DCL.
6. Releases, en el orden explícito del maestro.

No ordenar releases alfabéticamente para ejecutarlas: el maestro incluye 011_mqtt_revocation antes de 011_mqtt_identity_events. Los números repetidos o el prefijo 020a no sustituyen las dependencias.

Los includes DDL/DCL tienen labels/contextFilter. Revisar los filtros del comando antes de asumir que se aplicó el conjunto completo. Los scripts verificados no filtran esas secciones.

## Releases y finalidad

| Orden de changeset | Changelog | Finalidad |
| --- | --- | --- |
| 74 | [009_session_schema](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/009_session_schema/changelog.yaml) | Puente compatible de session_version/refresh_token; rollback intencionalmente conserva estructura. |
| 75 | [011_mqtt_revocation](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_revocation/changelog.yaml) | Identidades persistentes y cola de revocación. |
| 76 | [011_mqtt_identity_events](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_identity_events/changelog.yaml) | Historial append-only de identidades/intentos. |
| 77 | [016_consumption_access](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/016_consumption_access/changelog.yaml) | Separación de detalle y resumen básico de consumo. |
| 78 | [018_household_permissions](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/changelog.yaml) | Permisos de hogar, overrides por dispositivo y helpers. |
| 79 | [019_device_pairing_sessions](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/019_device_pairing_sessions/changelog.yaml) | Sesiones y transiciones de asociación de dispositivo. |
| 80 | [020_lan_pairing_method](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/020_lan_pairing_method/changelog.yaml) | Añade LAN a los métodos de sesión. |
| 81 | [020a_device_schema_reconciliation](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/020a_device_schema_reconciliation/changelog.yaml) | Reconcilia FK dispositivo/hogar si falta. |
| 82 | [021_shelly_device_repairing](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/021_shelly_device_repairing/changelog.yaml) | Permite re-asociar fabricante de registros eliminados. |
| 83 | [022_mqtt_pairing_operation](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/022_mqtt_pairing_operation/changelog.yaml) | Reserva de operación e identidad MQTT. |
| 84 | [023_mqtt_identity_repairing](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/023_mqtt_identity_repairing/changelog.yaml) | Unicidad parcial e historia de identidades revocadas. |
| 85 | [024_mqtt_pairing_state_guards](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/024_mqtt_pairing_state_guards/changelog.yaml) | Máquina de estados y auditoría de transiciones. |
| 86 | [025_mqtt_lease_fencing](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/025_mqtt_lease_fencing/changelog.yaml) | Claims, tokens de lease y reconciliación. |
| 87 | [026_mqtt_rpc_challenge](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/026_mqtt_rpc_challenge/changelog.yaml) | Desafíos RPC de posesión/conexión. |
| 88 | [027_mqtt_pairing_prepared_confirmation](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/027_mqtt_pairing_prepared_confirmation/changelog.yaml) | Confirmación cercada de preparación. |
| 89 | [028_mqtt_preparation_secret](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/028_mqtt_preparation_secret/changelog.yaml) | Sobre cifrado y acceso protegido por lease. |
| 90 | [029_mqtt_authenticated_pairing](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/029_mqtt_authenticated_pairing/changelog.yaml) | Atestación broker y finalización verificada. |
| 91 | [030_mqtt_enable_fencing](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/030_mqtt_enable_fencing/changelog.yaml) | Solicitud/claim/confirmación de habilitación; sin rollback declarado. |
| 92 | [031_mqtt_bootstrap_authorization](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/031_mqtt_bootstrap_authorization/changelog.yaml) | Entrega autorizada de bootstrap y auditoría; sin rollback declarado. |
| 93 | [032_mqtt_pairing_revocation](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/032_mqtt_pairing_revocation/changelog.yaml) | Revocación con evidencia broker y cercado reforzado. |
| 94 | [033_mqtt_ingest_realtime](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/033_mqtt_ingest_realtime/changelog.yaml) | Permiso de hogar en lectura de consumo y destinatarios encapsulados. |
| 95–96 | [034_energy_tariff_budget](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/034_energy_tariff_budget/changelog.yaml) | Tarifas y objetivos; segundo changeset permite presupuesto opcional. |

## Cobertura de rollback

- 93 changesets referencian SQL de rollback localizado.
- El puente 009 declara SQL inline SELECT 1 y conserva intencionalmente tablas/datos/grants de sesión.
- 030 y 031 **no declaran rollback**; no afirmar cobertura total de reversión.
- Un archivo de rollback existente no acredita ejecución correcta ni conservación de datos. Hay DROP de objetos; revisar dependencias y alcance antes de usarlo.
- No se ejecutó rollback ni se propone una orden genérica contra producción.

El README del repositorio afirma rollback para todos los changesets activos; requiere actualizarse frente a esos dos casos.

## SQL sin efecto y rutas fuera del recorrido

01_ddl/10_indexes/007_config_indexes.sql está vacío aunque su changeset se incluye. Los directorios de tipos, vistas, vistas materializadas y procedimientos tienen changelogs vacíos. 04_tcl y las fixtures tests/mqtt no forman parte del maestro. El marcador de política de zonas vacío no demuestra que haya modelo de zonas.

## Trabajar sobre una instalación existente

Identificar versión y propietario de la base, tabla databasechangelog, parámetros de conexión y changesets ya aplicados. Los puentes usan IF NOT EXISTS y validaciones de compatibilidad; eso no convierte un esquema divergente en compatible automáticamente.

Antes de migrar, revisar validate, update-sql, plan y copia restaurada en aislamiento conforme a la [configuración](configuracion-y-ejecucion.md) y [operación](operacion-y-mantenimiento.md). La migración debe publicarse mediante cambios coordinados del repositorio de implementación, no desde copias en esta central.

No modificar un changeset ya aplicado para corregir su checksum. Esta guía explica el criterio de evolución aditiva observado; no autoriza tocar un historial instalado.

## Riesgos por resolver

SQL028 se comenta como propuesta separada y “no ejecutar en producción”, pero el maestro la incluye sin separación por contexto propia de esa release. Revisar la intención y el gate operativo antes de aplicar todo el historial. SQL022/otros comentarios describen etapas inicialmente pendientes que fueron ampliadas después: leer el recorrido completo.

Fuentes: [SQL028](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/028_mqtt_preparation_secret/001_mqtt_preparation_secret.sql), [rollback compatible](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/009_session_schema/changelog.yaml), [hallazgos](hallazgos-y-pendientes.md).
