---
title: Diccionario de datos
status: borrador
owner: datos
last_reviewed: 2026-10-29
canonical_for:
  - diccionario-base-datos
---

# Diccionario de datos

## Alcance del diccionario

Derivación estática del commit `6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878`. Son **295 columnas declaradas en 32 tablas con definición de columnas**, más la partición DEFAULT que hereda las del padre. No se afirma que las tablas existan en una instalación.

Se incorporan ALTER de session_version, revocation_probe_at y nulabilidad de monthly_budget_cop. Las claves foráneas y restricciones añadidas/reemplazadas después del CREATE TABLE deben leerse en [modelo](modelo-de-datos.md), [seguridad](seguridad-y-permisos.md) y [migraciones](migraciones-y-rollbacks.md). La tabla de columnas no sustituye el DDL completo.

“Valor automático” significa DEFAULT o identidad en la declaración analizada; no publica valores sensibles. PK implica NOT NULL. Campos nullable pueden tener CHECK adicionales.

### auth.role

Fuente de la declaración: [01_ddl/03_tables/001_create_auth_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/001_create_auth_tables.sql#L5).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_role | UUID | No | Sí | Sí |
| name | VARCHAR(20) | No | — | — |
| description | TEXT | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |

### auth."user"

Fuente de la declaración: [01_ddl/03_tables/001_create_auth_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/001_create_auth_tables.sql#L15).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_user | UUID | No | Sí | Sí |
| id_role | UUID | No | — | Sí |
| name | VARCHAR(100) | No | — | — |
| email | VARCHAR(255) | No | — | — |
| password_hash | TEXT | No | — | — |
| status | VARCHAR(20) | No | — | Sí |
| email_verified | BOOLEAN | No | — | Sí |
| failed_login_attempts | SMALLINT | No | — | Sí |
| locked_until | TIMESTAMPTZ | Sí | — | — |
| last_login_at | TIMESTAMPTZ | Sí | — | — |
| deactivated_at | TIMESTAMPTZ | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |
| session_version | INTEGER | No | — | Sí |

session_version se añade en [011_add_user_session_version.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/04_alter/011_add_user_session_version.sql); no estaba en el CREATE TABLE inicial.

### auth.recovery_token

Fuente de la declaración: [01_ddl/03_tables/001_create_auth_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/001_create_auth_tables.sql#L44).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_recovery_token | UUID | No | Sí | Sí |
| id_user | UUID | No | — | — |
| token_hash | TEXT | No | — | — |
| type | VARCHAR(30) | No | — | — |
| expires_at | TIMESTAMPTZ | No | — | — |
| used_at | TIMESTAMPTZ | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |

### homes.home

Fuente de la declaración: [01_ddl/03_tables/002_create_homes_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/002_create_homes_tables.sql#L5).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_home | UUID | No | Sí | Sí |
| created_by | UUID | No | — | — |
| name | VARCHAR(100) | No | — | — |
| status | VARCHAR(20) | No | — | Sí |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |
| deleted_at | TIMESTAMPTZ | Sí | — | — |

### homes.home_member

Fuente de la declaración: [01_ddl/03_tables/002_create_homes_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/002_create_homes_tables.sql#L22).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_home_member | UUID | No | Sí | Sí |
| id_home | UUID | No | — | — |
| id_user | UUID | No | — | — |
| role | VARCHAR(10) | No | — | — |
| status | VARCHAR(10) | No | — | Sí |
| invited_by | UUID | Sí | — | — |
| invited_at | TIMESTAMPTZ | No | — | Sí |
| accepted_at | TIMESTAMPTZ | Sí | — | — |
| ended_at | TIMESTAMPTZ | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |

### devices.device

Fuente de la declaración: [01_ddl/03_tables/003_create_devices_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/003_create_devices_tables.sql#L17).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_device | UUID | No | Sí | Sí |
| id_home | UUID | No | — | — |
| name | VARCHAR(100) | No | — | — |
| status | VARCHAR(20) | No | — | Sí |
| connectivity_status | VARCHAR(20) | No | — | Sí |
| is_on | BOOLEAN | No | — | Sí |
| current_power_w | NUMERIC(10,2) | Sí | — | — |
| manufacturer_device_id | VARCHAR(100) | Sí | — | — |
| last_seen_at | TIMESTAMPTZ | Sí | — | — |
| transport_type | VARCHAR(20) | Sí | — | — |
| messaging_protocol | VARCHAR(20) | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |
| deleted_at | TIMESTAMPTZ | Sí | — | — |

### devices.smart_device

Fuente de la declaración: [01_ddl/03_tables/003_create_devices_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/003_create_devices_tables.sql#L50).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_smart_device | UUID | No | Sí | Sí |
| id_device | UUID | No | — | — |
| manufacturer | VARCHAR(100) | Sí | — | — |
| model | VARCHAR(100) | Sí | — | — |
| firmware_version | VARCHAR(50) | Sí | — | — |
| max_capacity_w | NUMERIC(10,2) | Sí | — | — |
| supports_matter | BOOLEAN | No | — | Sí |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |

### devices.device_schedule

Fuente de la declaración: [01_ddl/03_tables/003_create_devices_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/003_create_devices_tables.sql#L65).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_device_schedule | UUID | No | Sí | Sí |
| id_device | UUID | No | — | — |
| action | VARCHAR(10) | No | — | — |
| time_of_day | TIME | No | — | — |
| days_of_week | SMALLINT[] | No | — | — |
| is_active | BOOLEAN | No | — | Sí |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |
| deleted_at | TIMESTAMPTZ | Sí | — | — |

### devices.device_telemetry_raw

Fuente de la declaración: [01_ddl/03_tables/003_create_devices_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/003_create_devices_tables.sql#L84).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_device_telemetry_raw | UUID | No | Sí | Sí |
| id_device | UUID | No | — | — |
| payload | JSONB | No | — | — |
| captured_at | TIMESTAMPTZ | No | — | Sí |

### consumption.consumption

Fuente de la declaración: [01_ddl/03_tables/004_create_consumption_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/004_create_consumption_tables.sql#L5).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_consumption | UUID | No | Sí | Sí |
| id_device | UUID | No | — | — |
| id_home | UUID | No | — | — |
| power_w | NUMERIC(10,4) | No | — | — |
| energy_delta_kwh | NUMERIC(12,6) | No | — | Sí |
| energy_total_kwh | NUMERIC(14,6) | Sí | — | — |
| voltage_v | NUMERIC(10,4) | Sí | — | — |
| current_a | NUMERIC(10,4) | Sí | — | — |
| frequency_hz | NUMERIC(8,4) | Sí | — | — |
| temperature_c | NUMERIC(8,4) | Sí | — | — |
| read_at | TIMESTAMPTZ | No | Sí | Sí |

### consumption.consumption_default

Fuente de la declaración: [01_ddl/03_tables/004_create_consumption_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/004_create_consumption_tables.sql#L31).

Partición DEFAULT de consumption.consumption; comparte sus columnas y recibe filas que no encuentran una partición de rango. No tiene un diccionario independiente.

### consumption.consumption_metric

Fuente de la declaración: [01_ddl/03_tables/004_create_consumption_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/004_create_consumption_tables.sql#L34).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_consumption_metric | UUID | No | Sí | Sí |
| id_device | UUID | No | — | — |
| id_home | UUID | No | — | — |
| period | VARCHAR(10) | No | — | — |
| start_at | TIMESTAMPTZ | No | — | — |
| end_at | TIMESTAMPTZ | No | — | — |
| kwh_total | NUMERIC(12,6) | No | — | Sí |
| average_watts | NUMERIC(10,4) | Sí | — | — |
| max_watts | NUMERIC(10,4) | Sí | — | — |
| min_watts | NUMERIC(10,4) | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |

### notifications.alert_rule

Fuente de la declaración: [01_ddl/03_tables/005_create_notifications_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/005_create_notifications_tables.sql#L5).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_alert_rule | UUID | No | Sí | Sí |
| id_device | UUID | No | — | — |
| rule_type | VARCHAR(20) | No | — | — |
| limit_kwh | NUMERIC(10,4) | No | — | — |
| action | VARCHAR(20) | No | — | Sí |
| active | BOOLEAN | No | — | Sí |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |
| deleted_at | TIMESTAMPTZ | Sí | — | — |

### notifications.alert

Fuente de la declaración: [01_ddl/03_tables/005_create_notifications_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/005_create_notifications_tables.sql#L23).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_alert | UUID | No | Sí | Sí |
| id_alert_rule | UUID | Sí | — | — |
| id_device | UUID | No | — | — |
| id_home | UUID | No | — | — |
| alert_type | VARCHAR(20) | No | — | — |
| detected_value | NUMERIC(12,6) | Sí | — | — |
| limit_value | NUMERIC(10,4) | Sí | — | — |
| action_executed | VARCHAR(20) | Sí | — | — |
| metadata | JSONB | No | — | Sí |
| created_at | TIMESTAMPTZ | No | — | Sí |

### notifications.notification

Fuente de la declaración: [01_ddl/03_tables/005_create_notifications_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/005_create_notifications_tables.sql#L44).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_notification | UUID | No | Sí | Sí |
| id_user | UUID | No | — | — |
| id_alert | UUID | Sí | — | — |
| id_home | UUID | Sí | — | — |
| id_device | UUID | Sí | — | — |
| type | VARCHAR(30) | No | — | — |
| title | VARCHAR(200) | No | — | — |
| message | TEXT | No | — | — |
| status | VARCHAR(10) | No | — | Sí |
| priority | VARCHAR(10) | No | — | Sí |
| channel | VARCHAR(20) | No | — | Sí |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |

### sync.backup

Fuente de la declaración: [01_ddl/03_tables/006_create_sync_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/006_create_sync_tables.sql#L6).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_backup | UUID | No | Sí | Sí |
| id_user | UUID | Sí | — | — |
| type | VARCHAR(20) | No | — | — |
| scope | VARCHAR(20) | No | — | Sí |
| location | TEXT | No | — | — |
| size_bytes | BIGINT | Sí | — | — |
| status | VARCHAR(20) | No | — | Sí |
| description | TEXT | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |

### config.user_preference

Fuente de la declaración: [01_ddl/03_tables/007_create_config_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/007_create_config_tables.sql#L5).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_user_preference | UUID | No | Sí | Sí |
| id_user | UUID | No | — | — |
| language | VARCHAR(10) | No | — | Sí |
| theme | VARCHAR(10) | No | — | Sí |
| date_format | VARCHAR(20) | No | — | Sí |
| time_format | VARCHAR(5) | No | — | Sí |
| currency | VARCHAR(10) | No | — | Sí |
| temperature_unit | VARCHAR(5) | No | — | Sí |
| timezone | VARCHAR(100) | No | — | Sí |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |

### identity_audit.audit_log

Fuente de la declaración: [01_ddl/03_tables/008_create_identity_audit_tables.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/008_create_identity_audit_tables.sql#L6).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_audit_log | UUID | No | Sí | Sí |
| id_user | UUID | Sí | — | — |
| id_home | UUID | Sí | — | — |
| actor_type | VARCHAR(20) | No | — | Sí |
| action | VARCHAR(80) | No | — | — |
| module | VARCHAR(50) | No | — | — |
| entity | VARCHAR(50) | Sí | — | — |
| id_entity | UUID | Sí | — | — |
| result | VARCHAR(20) | Sí | — | — |
| metadata | JSONB | No | — | Sí |
| ip_address | INET | Sí | — | — |
| user_agent | TEXT | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |

### auth.refresh_token

Fuente de la declaración: [releases/009_session_schema/001_session_schema.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/009_session_schema/001_session_schema.sql#L4).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_refresh_token | UUID | No | Sí | Sí |
| id_user | UUID | No | — | — |
| token_hash | TEXT | No | — | — |
| family_id | UUID | No | — | Sí |
| session_version | INTEGER | No | — | — |
| expires_at | TIMESTAMPTZ | No | — | — |
| revoked_at | TIMESTAMPTZ | Sí | — | — |
| replaced_by_token_hash | TEXT | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |
| last_used_at | TIMESTAMPTZ | Sí | — | — |

La declaración inicial y sus CHECK están también en [012_create_refresh_token_table.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/04_alter/012_create_refresh_token_table.sql); el puente 009 conserva tablas compatibles existentes en lugar de recrearlas.

### devices.mqtt_identity

Fuente de la declaración: [releases/011_mqtt_revocation/mqtt-revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_revocation/mqtt-revocation.sql#L14).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_mqtt_identity | UUID | No | Sí | — |
| id_device | UUID | No | — | — |
| manufacturer_device_id | VARCHAR(100) | No | — | — |
| state | TEXT | No | — | Sí |
| created_at | TIMESTAMPTZ | No | — | Sí |
| revoke_requested_at | TIMESTAMPTZ | Sí | — | — |
| revoked_at | TIMESTAMPTZ | Sí | — | — |
| attempt_count | INTEGER | No | — | Sí |
| retry_at | TIMESTAMPTZ | Sí | — | — |
| lease_token | UUID | Sí | — | — |
| lease_until | TIMESTAMPTZ | Sí | — | — |
| last_error_code | TEXT | Sí | — | — |

### devices.mqtt_identity_event

Fuente de la declaración: [releases/011_mqtt_identity_events/mqtt-identity-events.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_identity_events/mqtt-identity-events.sql#L8).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_mqtt_identity_event | BIGINT | No | Sí | Sí |
| id_mqtt_identity | UUID | No | — | — |
| event_type | TEXT | No | — | — |
| previous_state | TEXT | Sí | — | — |
| state | TEXT | No | — | — |
| attempt_count | INTEGER | No | — | — |
| error_code | TEXT | Sí | — | — |
| occurred_at | TIMESTAMPTZ | No | — | Sí |

### homes.home_member_permission

Fuente de la declaración: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L3).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_home_member | UUID | No | Sí | — |
| can_view_devices | BOOLEAN | No | — | — |
| can_view_consumption | BOOLEAN | No | — | — |
| can_control_devices | BOOLEAN | No | — | — |
| updated_at | TIMESTAMPTZ | No | — | Sí |

### devices.device_member_permission

Fuente de la declaración: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L16).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_home_member | UUID | No | Sí | — |
| id_device | UUID | No | Sí | — |
| can_view_device | BOOLEAN | Sí | — | — |
| can_view_consumption | BOOLEAN | Sí | — | — |
| can_control_device | BOOLEAN | Sí | — | — |
| updated_at | TIMESTAMPTZ | No | — | Sí |

### devices.device_pairing_session

Fuente de la declaración: [releases/019_device_pairing_sessions/001_device_pairing_sessions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/019_device_pairing_sessions/001_device_pairing_sessions.sql#L21).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_device_pairing_session | UUID | No | Sí | Sí |
| id_home | UUID | No | — | — |
| id_user | UUID | No | — | — |
| request_key_hash | CHAR(64) | No | — | — |
| token_hash | CHAR(64) | No | — | — |
| method | VARCHAR(10) | No | — | — |
| status | VARCHAR(24) | No | — | Sí |
| manufacturer_device_id | VARCHAR(100) | Sí | — | — |
| model_code | VARCHAR(100) | Sí | — | — |
| firmware_version | VARCHAR(100) | Sí | — | — |
| identity_reported_at | TIMESTAMPTZ | Sí | — | — |
| expires_at | TIMESTAMPTZ | No | — | — |
| completed_device_id | UUID | Sí | — | — |
| failure_code | VARCHAR(64) | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |
| cancelled_at | TIMESTAMPTZ | Sí | — | — |

### devices.mqtt_pairing_operation

Fuente de la declaración: [releases/022_mqtt_pairing_operation/001_mqtt_pairing_operation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/022_mqtt_pairing_operation/001_mqtt_pairing_operation.sql#L20).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_mqtt_pairing_operation | UUID | No | Sí | Sí |
| id_device_pairing_session | UUID | No | — | — |
| id_mqtt_identity | UUID | No | — | — |
| manufacturer_device_id | VARCHAR(100) | No | — | — |
| topic_scope | VARCHAR(256) | No | — | — |
| broker_username | VARCHAR(128) | No | — | — |
| broker_client_id | VARCHAR(128) | No | — | — |
| broker_role_name | VARCHAR(128) | No | — | — |
| status | TEXT | No | — | Sí |
| id_device | UUID | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |
| authenticated_at | TIMESTAMPTZ | Sí | — | — |
| revocation_requested_at | TIMESTAMPTZ | Sí | — | — |
| revoked_at | TIMESTAMPTZ | Sí | — | — |
| retry_at | TIMESTAMPTZ | Sí | — | — |
| attempt_count | INTEGER | No | — | Sí |
| lease_token | UUID | Sí | — | — |
| lease_until | TIMESTAMPTZ | Sí | — | — |
| last_error_code | VARCHAR(64) | Sí | — | — |
| revocation_probe_at | TIMESTAMPTZ | Sí | — | — |

revocation_probe_at se añade en [SQL032](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql); los estados y leases tienen controles y triggers adicionales.

### devices.mqtt_pairing_state_event

Fuente de la declaración: [releases/024_mqtt_pairing_state_guards/001_mqtt_pairing_state_guards.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/024_mqtt_pairing_state_guards/001_mqtt_pairing_state_guards.sql#L28).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_event | BIGINT | No | Sí | Sí |
| id_mqtt_pairing_operation | UUID | No | — | — |
| from_status | TEXT | Sí | — | — |
| to_status | TEXT | No | — | — |
| occurred_at | TIMESTAMPTZ | No | — | Sí |
| transaction_id | BIGINT | No | — | Sí |

### devices.mqtt_rpc_challenge

Fuente de la declaración: [releases/026_mqtt_rpc_challenge/001_mqtt_rpc_challenge.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/026_mqtt_rpc_challenge/001_mqtt_rpc_challenge.sql#L22).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| rpc_id | UUID | No | Sí | Sí |
| id_mqtt_pairing_operation | UUID | No | — | — |
| challenge_index | SMALLINT | No | — | — |
| issued_at | TIMESTAMPTZ | No | — | — |
| expires_at | TIMESTAMPTZ | No | — | — |
| consumed_at | TIMESTAMPTZ | Sí | — | — |
| invalidated_at | TIMESTAMPTZ | Sí | — | — |

### devices.mqtt_preparation_secret

Fuente de la declaración: [releases/028_mqtt_preparation_secret/001_mqtt_preparation_secret.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/028_mqtt_preparation_secret/001_mqtt_preparation_secret.sql#L22).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_mqtt_pairing_operation | UUID | No | Sí | — |
| format_version | SMALLINT | No | — | — |
| key_id | VARCHAR(64) | No | — | — |
| nonce | VARCHAR(16) | No | — | — |
| ciphertext | VARCHAR(58) | No | — | — |
| auth_tag | VARCHAR(22) | No | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |

### devices.mqtt_broker_auth_attestation

Fuente de la declaración: [releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql#L34).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_mqtt_pairing_operation | UUID | No | Sí | — |
| rpc_id | UUID | No | — | — |
| observed_username | VARCHAR(128) | No | — | — |
| observed_client_id | VARCHAR(128) | No | — | — |
| observed_role_name | VARCHAR(128) | No | — | — |
| confirmed_at | TIMESTAMPTZ | No | — | Sí |

### devices.mqtt_bootstrap_delivery_audit

Fuente de la declaración: [releases/031_mqtt_bootstrap_authorization/001_mqtt_bootstrap_authorization.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/031_mqtt_bootstrap_authorization/001_mqtt_bootstrap_authorization.sql#L14).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_mqtt_pairing_operation | uuid | No | Sí | — |
| delivery_count | integer | No | — | Sí |
| first_delivered_at | timestamptz | Sí | — | — |
| last_delivered_at | timestamptz | Sí | — | — |

### devices.mqtt_pairing_revocation_attestation

Fuente de la declaración: [releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql#L39).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_mqtt_pairing_operation | UUID | No | Sí | — |
| broker_username | VARCHAR(128) | No | — | — |
| broker_client_id | VARCHAR(128) | No | — | — |
| broker_role_name | VARCHAR(128) | No | — | — |
| outcome | TEXT | No | — | — |
| observed_at | TIMESTAMPTZ | No | — | — |

### config.home_energy_tariff

Fuente de la declaración: [releases/034_energy_tariff_budget/001_energy_tariff_budget.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/034_energy_tariff_budget/001_energy_tariff_budget.sql#L7).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_home_energy_tariff | UUID | No | Sí | Sí |
| id_home | UUID | No | — | — |
| unit_price_cop_kwh | NUMERIC(14,4) | No | — | — |
| effective_from | DATE | No | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |

### config.home_energy_goal

Fuente de la declaración: [releases/034_energy_tariff_budget/001_energy_tariff_budget.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/034_energy_tariff_budget/001_energy_tariff_budget.sql#L25).

| Columna | Tipo | Puede ser NULL | Clave primaria | Valor automático |
| --- | --- | --- | --- | --- |
| id_home_energy_goal | UUID | No | Sí | Sí |
| id_home | UUID | No | — | — |
| month_start | DATE | No | — | — |
| monthly_budget_cop | NUMERIC(14,2) | Sí | — | — |
| target_kwh | NUMERIC(14,6) | Sí | — | — |
| created_at | TIMESTAMPTZ | No | — | Sí |
| updated_at | TIMESTAMPTZ | No | — | Sí |

La nulabilidad final de monthly_budget_cop procede de [SQL034/002](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/034_energy_tariff_budget/002_energy_goal_optional_budget.sql): debe existir presupuesto o meta, no ambos nulos.

## Actualización y pendientes

Repetir lectura del CREATE y ALTER en orden cuando cambie el commit. Contrastar PK/FK, índices, políticas y catálogos con una base migrada de pruebas antes de marcar como vigente. No copiar datos de tablas ni secretos de configuración a este diccionario.

Fuentes: archivos por commit de cada sección, [changelog maestro](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/changelog/changelog-master.yaml) e [inventario estructural](inventario-estructural.json).
