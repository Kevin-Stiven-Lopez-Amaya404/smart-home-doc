---
title: Modelo relacional de SmartHome
status: borrador
owner: datos
last_reviewed: 2026-11-05
canonical_for:
  - modelo-base-datos
---

# Modelo relacional de SmartHome

## Cómo leer el modelo

La base del inventario es dev `6caed6b`; el delta se contrastó con dev `3b20c91`. No es una introspección de una base instalada. SQL035 agrega `consumption.mqtt_ingest_dedup`: el modelo estático pasa de **33 a 34 nombres de tabla** (incluida `consumption.consumption_default`) y de 295 a 301 columnas declaradas. Las particiones mensuales creadas dinámicamente no se cuentan como tablas instaladas.

El [diccionario](diccionario-de-datos.md) recoge las 295 columnas del snapshot anterior y añade las seis columnas de SQL035 en una sección separada. Las FK, políticas y revisiones se consultan en sus fuentes; no se copian migraciones.

## Esquemas y responsabilidad

| Esquema | Objetos y responsabilidad |
| --- | --- |
| auth | role, user, recovery_token y refresh_token; identidad, recuperación y familias de sesión |
| homes | home, home_member y home_member_permission; pertenencia y permisos base |
| devices | device, datos técnicos, horarios, telemetría cruda y objetos de pairing/identidad MQTT |
| consumption | Lecturas particionadas, métricas agregadas y ledger idempotente de eventos MQTT |
| notifications | Reglas, alertas y notificaciones personales |
| config | Preferencias de usuario, tarifas referenciales y objetivos mensuales |
| sync | Metadata de copias en backup; no ejecuta una copia |
| identity_audit | audit_log con eventos semánticos; presencia de tabla no prueba emisión desde todos los casos de uso |

Fuentes base: [tablas](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/changelog.yaml), [relaciones](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/04_alter/changelog.yaml) y [evolución](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/changelog/changelog-master.yaml).

## Relaciones principales

Las flechas indican padre → dependiente según FK. El diagrama es parcial para conservar legibilidad.

```mermaid
flowchart LR
  U["auth.user"] --> H["homes.home"]
  U --> M["homes.home_member"]
  H --> M
  H --> D["devices.device"]
  D --> C["consumption.consumption"]
  D --> CM["consumption.consumption_metric"]
  U --> RT["auth.refresh_token"]
  H --> T["config.home_energy_tariff"]
  H --> G["config.home_energy_goal"]
  M --> MP["homes.home_member_permission"]
  MP --> DP["devices.device_member_permission"]
  D --> DP
```

Las lecturas y métricas usan FK compuesta (id_device, id_home) hacia devices.device, evitando combinar un dispositivo con un hogar diferente. Las alertas/notificaciones también relacionan contexto de hogar/dispositivo. Fuentes: [consumo](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/04_alter/004_add_alter_consumption.sql), [notificaciones](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/04_alter/005_add_alter_notifications.sql).

## Identidad y sesiones

auth."user" tiene correo único mediante LOWER(email), password_hash y estados PENDING, ACTIVE, DEACTIVATED, LOCKED. CHECK exige coherencia de deactivated_at y locked_until; esto no realiza el login ni verifica una contraseña.

recovery_token guarda token_hash, tipo, vencimiento y uso. refresh_token guarda token_hash único, family_id, session_version, expiración, revocación, reemplazo y último uso. Son datos de sesión, no JWT en texto plano. La versión de usuario se añade mediante ALTER y se reconcilia en release 009.

Fuentes: [auth](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/001_create_auth_tables.sql), [refresh](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/04_alter/012_create_refresh_token_table.sql), [puente de sesión](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/009_session_schema/001_session_schema.sql).

## Hogares, dispositivos y ciclo de vida

home mantiene created_by y membresías separadas. home_member distingue OWNER/MEMBER/GUEST y PENDING/ACTIVE/REVOKED/LEFT; sus CHECK relacionan aceptación y fin.

device pertenece a un hogar. DEACTIVATED con deleted_at nulo representa desactivación temporal; con deleted_at informado, borrado lógico. El nombre y fabricante tienen reglas de unicidad que cambian durante las migraciones. Release 021 permite reutilizar una identidad física cuando el registro anterior fue eliminado lógicamente, conservando los históricos. Release 023 hace lo equivalente para identidades MQTT ya revocadas.

Fuentes: [hogares](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/002_create_homes_tables.sql), [ciclo de vida](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/04_alter/010_align_device_lifecycle.sql), [re-pairing físico](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/021_shelly_device_repairing/001_shelly_device_repairing.sql), [identidad MQTT](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/023_mqtt_identity_repairing/001_mqtt_identity_repairing.sql).

## Consumo y unidades

consumption.consumption usa watts, kWh y magnitudes eléctricas en NUMERIC; la PK incluye id_consumption y read_at, y la tabla se particiona por rango de read_at. energy_delta_kwh no puede ser negativo; energy_total_kwh puede ser nulo. La DB no calcula automáticamente el delta ni detecta por sí sola reinicios del contador.

consumption_metric permite periodos **hora, dia, semana, mes**, con unicidad por dispositivo/periodo/inicio. El nombre de la tabla no acredita un job activo o actualización instantánea.

Fuente: [tipos, unidades y restricciones](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/03_tables/004_create_consumption_tables.sql).

## Ledger de eventos MQTT (SQL035–SQL036)

`consumption.mqtt_ingest_dedup` no sustituye las lecturas de `consumption.consumption`. Sus seis columnas son `id_device UUID`, `id_home UUID`, `event_key VARCHAR(64)`, `source_topic VARCHAR(256)`, `device_event_ts NUMERIC(18,6)` y `first_received_at TIMESTAMPTZ`. La clave primaria `(id_device,event_key)` evita procesar otra vez una misma identidad de evento; la FK compuesta garantiza correspondencia de dispositivo y hogar.

SQL035 habilita RLS y concede a `smarthome_ingest` inserción y lectura por columnas; las políticas exigen dispositivo ingestable y relación dispositivo/hogar válida. `event_key` debe ser SHA-256 hexadecimal, el topic debe pertenecer al namespace de desarrollo y el timestamp debe ser positivo. SQL036 agrega lectura limitada de `device_event_ts` e índice `(id_device,device_event_ts DESC)` para ordenar eventos por dispositivo. No se calcula una medición de consumo en el ledger.

Fuentes: [SQL035](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/035_flespi_mqtt_ingest_idempotency/001_mqtt_ingest_dedup.sql), [SQL036](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/036_flespi_mqtt_event_order/001_flespi_event_order.sql).

## Tarifas y metas de energía

SQL034 añade home_energy_tariff con unit_price_cop_kwh positivo, fecha effective_from y unicidad hogar/fecha. Es una tarifa referencial COP/kWh: no almacena facturas calculadas, impuestos o cargos fijos.

home_energy_goal tiene unicidad hogar/month_start y exige primer día del mes. Después del segundo changeset, monthly_budget_cop puede ser nulo; se requiere al menos uno de monthly_budget_cop o target_kwh, y los valores presentes deben ser positivos. El backend implementa rutas para consultar y modificar tarifas y metas y para obtener un resumen estimado; ese contrato no representa facturación ni cargos de la empresa eléctrica.

Fuente: [tarifas y metas](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/034_energy_tariff_budget/001_energy_tariff_budget.sql), [presupuesto opcional](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/034_energy_tariff_budget/002_energy_goal_optional_budget.sql).

## Objetos sin disponibilidad funcional acreditada

device_schedule, alert_rule, audit_log y sync.backup definen persistencia. No prueban programación de acciones, generación automática de alertas, cobertura total de auditoría o backups activos. No se detectó un modelo de zonas en este historial. device_type se crea y se carga al inicio, pero se elimina en un refactor posterior.

[Seguridad](seguridad-y-permisos.md). [Operación](operacion-y-mantenimiento.md). [Hallazgos](hallazgos-y-pendientes.md).
