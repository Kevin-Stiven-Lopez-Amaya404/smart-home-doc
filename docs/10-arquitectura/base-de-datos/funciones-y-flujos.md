---
title: Funciones y contratos SQL
status: borrador
owner: datos
last_reviewed: 2026-10-29
canonical_for:
  - funciones-base-datos
---

# Funciones y contratos SQL

## Autoridad y alcance

Este repositorio no expone endpoints HTTP. Sus contratos SQL son las funciones, tablas y permisos que consumen el backend y los trabajadores.

El recorrido estático localiza 83 declaraciones de función y **73 nombres con última definición**, tras los DROP localizados. Esto no demuestra que existan 73 funciones instaladas: puede haber estado previo, ejecución condicional o firmas históricas. Las definiciones sobrecargadas y el catálogo efectivo deben contrastarse en PostgreSQL.

La firma y el retorno se transcriben del archivo fuente por commit; las concesiones listadas son GRANT/REVOKE directos localizados en este recorrido, sin simular permisos heredados o del propietario. Ausencia de GRANT en la tabla no equivale a ausencia total de privilegios.

## Flujos principales

- Usuario funcional: el backend abre una transacción y establece app.current_user_id; los helpers y políticas resuelven pertenencia y permisos.
- Control: fn_device_control_target resuelve un dispositivo autorizado para control, sin exigir que el usuario tenga todos los permisos de consulta.
- Consumo: fn_can_read_detail y fn_can_read_device_detail restringen detalle; fn_basic_home_consumption conserva un agregado para usuarios autorizados.
- Particiones: fn_ensure_consumption_partitions realiza DDL controlado; no se ejecuta periódicamente por existir la función.
- MQTT: reserva → preparación con lease → confirmación → habilitación → desafío RPC → evidencia broker → finalización. Revocación y reconciliación tienen funciones separadas.

Fuentes principales: [permisos](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql), [autenticación MQTT](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql), [revocación](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql).

## Estados MQTT y concurrencia

device_pairing_session distingue PENDING, DEVICE_IDENTIFIED, WAITING_FOR_MQTT, CONNECTED, COMPLETED y salidas EXPIRED/CANCELLED/FAILED. SQL020 permite AP, BLE y LAN en el esquema; eso no acredita un flujo BLE implementado en todos los clientes.

mqtt_pairing_operation tiene estados de reserva, preparación, habilitación, autenticación, adjunción, revocación y reconciliación. Las funciones usan FOR UPDATE, advisory locks o SKIP LOCKED según operación; lease_token y lease_until cercan confirmaciones de trabajadores obsoletos. Un resultado incierto no equivale a éxito ni autoriza liberar una identidad sin evidencia.

Las contraseñas Wi-Fi/MQTT no se guardan en las sesiones. mqtt_preparation_secret conserva un sobre cifrado con key_id, nonce, ciphertext y auth_tag, sin guardar la clave. Debe revisarse la integración de cifrado y autorización del backend; las restricciones de formato no prueban seguridad criptográfica completa.

## Catálogo por última definición

### public.fn_set_updated_at

**Firma:** `public.fn_set_updated_at()`.

**Retorno declarado:** `TRIGGER`.

Asigna updated_at en triggers de actualización; no es un proceso programado.

Seguridad: INVOKER; sin SET search_path en esta declaración. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

Fuente: [01_ddl/07_functions/001_update_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/001_update_functions.sql#L12).

### auth.fn_current_user_id

**Firma:** `auth.fn_current_user_id()`.

**Retorno declarado:** `UUID`.

Lee app.current_user_id de la transacción. Sin valor devuelve NULL; un valor no convertible a UUID puede provocar error.

Seguridad: INVOKER; sin SET search_path en esta declaración. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/004_auth_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/004_auth_security_functions.sql#L22).

### auth.fn_is_active_user

**Firma:** `auth.fn_is_active_user( p_user_id UUID )`.

**Retorno declarado:** `BOOLEAN`.

Comprueba el estado ACTIVE del usuario indicado.

Seguridad: DEFINER; search_path = pg_catalog, auth. Roles con concesión directa localizada: `smarthome_runtime_app`, `smarthome_ingest`, `smarthome_worker`.

Fuente: [01_ddl/07_functions/004_auth_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/004_auth_security_functions.sql#L42).

### auth.fn_is_system_admin

**Firma:** `auth.fn_is_system_admin()`.

**Retorno declarado:** `BOOLEAN`.

Comprueba SYSTEM_ADMIN para el usuario activo del contexto; no equivale a OWNER de un hogar.

Seguridad: DEFINER; search_path = pg_catalog, auth. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/004_auth_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/004_auth_security_functions.sql#L75).

### consumption.fn_ensure_consumption_partitions

**Firma:** `consumption.fn_ensure_consumption_partitions( p_months_ahead INT DEFAULT 2 )`.

**Retorno declarado:** `VOID`.

Crea la partición mensual actual y las futuras solicitadas; admite de 0 a 24 meses y usa UTC.

Seguridad: DEFINER; search_path = pg_catalog, consumption. Roles con concesión directa localizada: `smarthome_admin`, `smarthome_worker`.

SQLSTATE explícitos localizados: `22023`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [01_ddl/07_functions/005_consumption_partition_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/005_consumption_partition_functions.sql#L12).

### homes.fn_has_home_membership

**Firma:** `homes.fn_has_home_membership( p_home_id UUID, p_statuses TEXT[] )`.

**Retorno declarado:** `BOOLEAN`.

Consulta pertenencia al hogar para los estados de membresía solicitados.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/006_rls_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/006_rls_security_functions.sql#L23).

### homes.fn_is_home_member

**Firma:** `homes.fn_is_home_member( p_home_id UUID, p_roles TEXT[] )`.

**Retorno declarado:** `BOOLEAN`.

Comprueba pertenencia activa con uno de los roles solicitados.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/006_rls_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/006_rls_security_functions.sql#L52).

### homes.fn_is_home_owner

**Firma:** `homes.fn_is_home_owner( p_home_id UUID )`.

**Retorno declarado:** `BOOLEAN`.

Comprueba propiedad funcional mediante la membresía OWNER según el helper.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/006_rls_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/006_rls_security_functions.sql#L84).

### homes.fn_is_home_active

**Firma:** `homes.fn_is_home_active( p_home_id UUID )`.

**Retorno declarado:** `BOOLEAN`.

Comprueba estado y borrado lógico del hogar.

Seguridad: DEFINER; search_path = pg_catalog, homes. Roles con concesión directa localizada: `smarthome_runtime_app`, `smarthome_ingest`, `smarthome_worker`.

Fuente: [01_ddl/07_functions/006_rls_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/006_rls_security_functions.sql#L112).

### homes.fn_can_manage_home

**Firma:** `homes.fn_can_manage_home( p_home_id UUID )`.

**Retorno declarado:** `BOOLEAN`.

Autoriza administración del hogar según las comprobaciones de propietario y actividad.

Seguridad: DEFINER; search_path = pg_catalog, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/006_rls_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/006_rls_security_functions.sql#L136).

### homes.fn_can_create_initial_owner

**Firma:** `homes.fn_can_create_initial_owner( p_home_id UUID, p_user_id UUID )`.

**Retorno declarado:** `BOOLEAN`.

Permite la primera membresía OWNER del creador del hogar bajo sus condiciones.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/006_rls_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/006_rls_security_functions.sql#L157).

### homes.fn_owner_membership_update_allowed

**Firma:** `homes.fn_owner_membership_update_allowed( p_home_member_id UUID, p_home_id UUID, p_user_id UUID, p_new_role TEXT, p_new_status TEXT, p_new_accepted_at TIMESTAMPTZ, p_new_ended_at TIMESTAMPTZ )`.

**Retorno declarado:** `BOOLEAN`.

Valida cambios de membresía realizados por propietario; controla identidad, rol, estado y fechas.

Seguridad: DEFINER; search_path = pg_catalog, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/006_rls_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/006_rls_security_functions.sql#L201).

### homes.fn_self_membership_transition_allowed

**Firma:** `homes.fn_self_membership_transition_allowed( p_home_member_id UUID, p_home_id UUID, p_user_id UUID, p_new_role TEXT, p_new_status TEXT, p_new_accepted_at TIMESTAMPTZ, p_new_ended_at TIMESTAMPTZ )`.

**Retorno declarado:** `BOOLEAN`.

Valida transiciones propias de una membresía, como aceptación, rechazo o salida.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/006_rls_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/006_rls_security_functions.sql#L271).

### devices.fn_is_device_owner

**Firma:** `devices.fn_is_device_owner( p_device_id UUID )`.

**Retorno declarado:** `BOOLEAN`.

Relaciona el dispositivo con el propietario del hogar.

Seguridad: DEFINER; search_path = pg_catalog, devices, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/007_rls_device_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/007_rls_device_security_functions.sql#L35).

### devices.fn_can_view_device

**Firma:** `devices.fn_can_view_device(p_device_id UUID, p_roles TEXT[])`.

**Retorno declarado:** `BOOLEAN`.

Autoriza consulta del dispositivo y combina rol de hogar con permiso efectivo de lectura.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes, devices. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L132).

### devices.fn_can_manage_device

**Firma:** `devices.fn_can_manage_device( p_device_id UUID )`.

**Retorno declarado:** `BOOLEAN`.

Comprueba autorización de administración del dispositivo a través del hogar.

Seguridad: DEFINER; search_path = pg_catalog, devices, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/007_rls_device_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/007_rls_device_security_functions.sql#L88).

### devices.fn_is_ingestable_device

**Firma:** `devices.fn_is_ingestable_device( p_device_id UUID )`.

**Retorno declarado:** `BOOLEAN`.

Decide si un dispositivo/hogar está habilitado para ingestión.

Seguridad: DEFINER; search_path = pg_catalog, devices, homes. Roles con concesión directa localizada: `smarthome_ingest`.

Fuente: [01_ddl/07_functions/007_rls_device_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/007_rls_device_security_functions.sql#L111).

### devices.fn_device_belongs_to_home

**Firma:** `devices.fn_device_belongs_to_home( p_device_id UUID, p_home_id UUID )`.

**Retorno declarado:** `BOOLEAN`.

Comprueba que dispositivo y hogar coincidan; no sustituye el resto de permisos.

Seguridad: DEFINER; search_path = pg_catalog, devices. Roles con concesión directa localizada: `smarthome_ingest`, `smarthome_worker`.

Fuente: [01_ddl/07_functions/008_rls_consumption_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/008_rls_consumption_security_functions.sql#L13).

### notifications.fn_recipient_has_home_role

**Firma:** `notifications.fn_recipient_has_home_role( p_user_id UUID, p_home_id UUID, p_roles TEXT[], p_statuses TEXT[] )`.

**Retorno declarado:** `BOOLEAN`.

Verifica el rol/estado de un destinatario en el hogar antes de crear notificaciones.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes, notifications. Roles con concesión directa localizada: `smarthome_ingest`, `smarthome_worker`.

Fuente: [01_ddl/07_functions/009_rls_notification_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/009_rls_notification_security_functions.sql#L10).

### notifications.fn_can_generate_alert

**Firma:** `notifications.fn_can_generate_alert( p_alert_rule_id UUID, p_device_id UUID, p_home_id UUID, p_alert_type TEXT )`.

**Retorno declarado:** `BOOLEAN`.

Valida contexto dispositivo/hogar y tipo de alerta; no ejecuta por sí misma detección de anomalías.

Seguridad: DEFINER; search_path = pg_catalog, homes, devices, notifications. Roles con concesión directa localizada: `smarthome_ingest`.

Fuente: [01_ddl/07_functions/009_rls_notification_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/009_rls_notification_security_functions.sql#L59).

### notifications.fn_notification_status_transition_allowed

**Firma:** `notifications.fn_notification_status_transition_allowed( p_notification_id UUID, p_user_id UUID, p_new_status TEXT )`.

**Retorno declarado:** `BOOLEAN`.

Restringe la transición de estado de una notificación del usuario.

Seguridad: DEFINER; search_path = pg_catalog, auth, notifications. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [01_ddl/07_functions/009_rls_notification_security_functions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/009_rls_notification_security_functions.sql#L119).

### devices.fn_device_app_update_allowed

**Firma:** `devices.fn_device_app_update_allowed( p_device_id UUID, p_home_id UUID, p_name TEXT, p_status TEXT, p_connectivity_status TEXT, p_is_on BOOLEAN, p_transport_type TEXT, p_messaging_protocol TEXT, p_deleted_at TIMESTAMPTZ )`.

**Retorno declarado:** `BOOLEAN`.

Protege identidad, hogar y campos modificables según propietario o permiso de control; consultar la última firma de nueve parámetros.

Seguridad: DEFINER; search_path = pg_catalog, devices, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L146).

### devices.fn_register_mqtt_identity

**Firma:** `devices.fn_register_mqtt_identity(p_device UUID, p_identity UUID, p_manufacturer TEXT)`.

**Retorno declarado:** `UUID`.

Registra el vínculo persistente de identidad MQTT de un dispositivo. No crea credenciales en el broker.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_registrar`.

SQLSTATE explícitos localizados: `23514`, `23505`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/011_mqtt_revocation/mqtt-revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_revocation/mqtt-revocation.sql#L58).

### devices.fn_mqtt_identity_device_update

**Firma:** `devices.fn_mqtt_identity_device_update()`.

**Retorno declarado:** `TRIGGER`.

Trigger que solicita revocación ante cambios relevantes del ciclo de vida del dispositivo.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/011_mqtt_revocation/mqtt-revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_revocation/mqtt-revocation.sql#L92).

### devices.fn_claim_mqtt_revocation

**Firma:** `devices.fn_claim_mqtt_revocation()`.

**Retorno declarado:** `TABLE(identity_id UUID, claim_token UUID, attempt INTEGER)`.

Reserva una revocación en la implementación antigua. SQL032 revoca su EXECUTE directo al rol de revocación; no usar como contrato actual del worker.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

Fuente: [releases/011_mqtt_revocation/mqtt-revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_revocation/mqtt-revocation.sql#L117).

### devices.fn_finish_mqtt_revocation

**Firma:** `devices.fn_finish_mqtt_revocation(p_identity UUID, p_token UUID, p_error TEXT)`.

**Retorno declarado:** `BOOLEAN`.

Finaliza/reintenta una revocación antigua. SQL032 revoca su EXECUTE directo al worker para exigir evidencia reforzada.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `22023`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/011_mqtt_revocation/mqtt-revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_revocation/mqtt-revocation.sql#L137).

### devices.fn_capture_mqtt_identity_event

**Firma:** `devices.fn_capture_mqtt_identity_event()`.

**Retorno declarado:** `TRIGGER`.

Añade historia de cambios de identidad y de intentos de revocación.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

Fuente: [releases/011_mqtt_identity_events/mqtt-identity-events.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_identity_events/mqtt-identity-events.sql#L50).

### devices.fn_mqtt_identity_event_append_only

**Firma:** `devices.fn_mqtt_identity_event_append_only()`.

**Retorno declarado:** `TRIGGER`.

Rechaza modificación de eventos históricos de identidad.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `55000`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/011_mqtt_identity_events/mqtt-identity-events.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_identity_events/mqtt-identity-events.sql#L91).

### consumption.fn_can_read_detail

**Firma:** `consumption.fn_can_read_detail(p_home_id UUID)`.

**Retorno declarado:** `BOOLEAN`.

Permite detalle a OWNER o MEMBER activo con permiso de consumo; excluye GUEST.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L188).

### consumption.fn_history_devices

**Firma:** `consumption.fn_history_devices(p_home_id UUID, p_device_ids UUID[])`.

**Retorno declarado:** `TABLE(id_device UUID, name TEXT, manufacturer_device_id TEXT)`.

Devuelve identificadores y nombres de dispositivos autorizados para consultas históricas.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes, devices, consumption. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L214).

### consumption.fn_basic_home_consumption

**Firma:** `consumption.fn_basic_home_consumption(p_home_id UUID, p_from TIMESTAMPTZ, p_to TIMESTAMPTZ)`.

**Retorno declarado:** `TABLE(total_energy_delta_kwh NUMERIC)`.

Agrega energy_delta_kwh para hogar e intervalo; exige hogar operativo y permiso de consumo. No devuelve detalle de dispositivos.

Seguridad: DEFINER; search_path = pg_catalog, auth, consumption, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L225).

### homes.fn_initialize_member_permissions

**Firma:** `homes.fn_initialize_member_permissions()`.

**Retorno declarado:** `TRIGGER`.

Trigger de inserción que crea valores base para MEMBER/GUEST.

Seguridad: DEFINER; search_path = pg_catalog, homes. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L31).

### homes.fn_reset_member_permissions_on_role_change

**Firma:** `homes.fn_reset_member_permissions_on_role_change()`.

**Retorno declarado:** `TRIGGER`.

Restablece valores base y elimina excepciones de dispositivo al cambiar a MEMBER/GUEST.

Seguridad: DEFINER; search_path = pg_catalog, homes. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L49).

### homes.fn_has_permission

**Firma:** `homes.fn_has_permission(p_home_id UUID, p_permission TEXT)`.

**Retorno declarado:** `BOOLEAN`.

Evalúa view_devices, view_consumption y control_devices en el hogar.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L71).

### devices.fn_has_device_permission

**Firma:** `devices.fn_has_device_permission(p_device_id UUID, p_permission TEXT)`.

**Retorno declarado:** `BOOLEAN`.

Evalúa view, view_consumption o control con override por dispositivo y herencia de hogar.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes, devices. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L104).

### consumption.fn_can_read_device_detail

**Firma:** `consumption.fn_can_read_device_detail(p_device_id UUID)`.

**Retorno declarado:** `BOOLEAN`.

Combina el rol permitido y permiso efectivo de consumo del dispositivo.

Seguridad: DEFINER; search_path = pg_catalog, devices, consumption. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L199).

### devices.fn_device_control_target

**Firma:** `devices.fn_device_control_target(p_home_id UUID, p_device_id UUID)`.

**Retorno declarado:** `TABLE( id_device UUID, id_home UUID, name VARCHAR, status VARCHAR, connectivity_status VARCHAR, is_on BOOLEAN, current_power_w NUMERIC, manufacturer_device_id VARCHAR, transport_type VARCHAR, messaging_protocol VARCHAR, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ )`.

Devuelve el destino autorizado para control, independientemente del permiso de consulta descriptiva.

Seguridad: DEFINER; search_path = pg_catalog, auth, homes, devices. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L245).

### homes.fn_get_member_permissions

**Firma:** `homes.fn_get_member_permissions(p_home_id UUID, p_member_id UUID)`.

**Retorno declarado:** `TABLE(can_view_devices BOOLEAN, can_view_consumption BOOLEAN, can_control_devices BOOLEAN)`.

Obtiene permisos base de otra membresía mediante comprobación de administración.

Seguridad: DEFINER; search_path = pg_catalog, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L266).

### homes.fn_set_member_permissions

**Firma:** `homes.fn_set_member_permissions( p_home_id UUID, p_member_id UUID, p_can_view_devices BOOLEAN, p_can_view_consumption BOOLEAN, p_can_control_devices BOOLEAN )`.

**Retorno declarado:** `BOOLEAN`.

Modifica permisos base del miembro dentro del hogar autorizado.

Seguridad: DEFINER; search_path = pg_catalog, homes. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L277).

### homes.fn_get_device_permissions

**Firma:** `homes.fn_get_device_permissions(p_home_id UUID, p_member_id UUID, p_device_id UUID)`.

**Retorno declarado:** `TABLE(can_view_device BOOLEAN, can_view_consumption BOOLEAN, can_control_device BOOLEAN)`.

Obtiene overrides por dispositivo para la membresía indicada.

Seguridad: DEFINER; search_path = pg_catalog, homes, devices. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L298).

### homes.fn_set_device_permissions

**Firma:** `homes.fn_set_device_permissions( p_home_id UUID, p_member_id UUID, p_device_id UUID, p_can_view_device BOOLEAN, p_can_view_consumption BOOLEAN, p_can_control_device BOOLEAN )`.

**Retorno declarado:** `BOOLEAN`.

Actualiza overrides; valores nulos heredan y una excepción completamente nula se elimina.

Seguridad: DEFINER; search_path = pg_catalog, homes, devices. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/018_household_permissions/001_household_permissions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql#L311).

### devices.fn_guard_pairing_session_transition

**Firma:** `devices.fn_guard_pairing_session_transition()`.

**Retorno declarado:** `TRIGGER`.

Protege campos inmutables y transiciones de sesión; bloquea finalización sin el estado/evidencia requerida.

Seguridad: INVOKER; search_path = pg_catalog, devices. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/019_device_pairing_sessions/001_device_pairing_sessions.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/019_device_pairing_sessions/001_device_pairing_sessions.sql#L78).

### devices.fn_claim_pairing_identity

**Firma:** `devices.fn_claim_pairing_identity( p_session_id UUID, p_manufacturer_device_id TEXT, p_model_code TEXT, p_firmware_version TEXT )`.

**Retorno declarado:** `BOOLEAN`.

Reclama identidad del fabricante con bloqueo transaccional y control de sesiones/dispositivos previos; SQL021 permite registros históricos eliminados.

Seguridad: DEFINER; search_path = pg_catalog, devices, homes, auth. Roles con concesión directa localizada: `smarthome_runtime_app`.

Fuente: [releases/021_shelly_device_repairing/001_shelly_device_repairing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/021_shelly_device_repairing/001_shelly_device_repairing.sql#L21).

### devices.fn_guard_mqtt_pairing_operation_binding

**Firma:** `devices.fn_guard_mqtt_pairing_operation_binding()`.

**Retorno declarado:** `TRIGGER`.

Mantiene inmutables los identificadores y el vínculo broker de la operación.

Seguridad: INVOKER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/022_mqtt_pairing_operation/001_mqtt_pairing_operation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/022_mqtt_pairing_operation/001_mqtt_pairing_operation.sql#L113).

### devices.fn_reserve_mqtt_pairing_operation

**Firma:** `devices.fn_reserve_mqtt_pairing_operation( p_session UUID, p_topic_scope TEXT, p_actor UUID, p_token_hash TEXT )`.

**Retorno declarado:** `TABLE ( operation_id UUID, identity_id UUID, username TEXT, client_id TEXT, role_name TEXT, reserved_topic_scope TEXT )`.

Reserva operación e identidad broker para una sesión OWNER válida, su token hash y modelo permitido. Devuelve nombres, no passwords.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_reserver`.

SQLSTATE explícitos localizados: `23514`, `22023`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/022_mqtt_pairing_operation/001_mqtt_pairing_operation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/022_mqtt_pairing_operation/001_mqtt_pairing_operation.sql#L143).

### devices.fn_guard_mqtt_identity_repairing

**Firma:** `devices.fn_guard_mqtt_identity_repairing()`.

**Retorno declarado:** `TRIGGER`.

Impide mutar el vínculo de identidad o abandonar una identidad REVOKED mediante transiciones no válidas.

Seguridad: INVOKER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/023_mqtt_identity_repairing/001_mqtt_identity_repairing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/023_mqtt_identity_repairing/001_mqtt_identity_repairing.sql#L48).

### devices.fn_guard_mqtt_pairing_state_event

**Firma:** `devices.fn_guard_mqtt_pairing_state_event()`.

**Retorno declarado:** `TRIGGER`.

Protege el historial de estados contra modificaciones.

Seguridad: INVOKER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/024_mqtt_pairing_state_guards/001_mqtt_pairing_state_guards.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/024_mqtt_pairing_state_guards/001_mqtt_pairing_state_guards.sql#L53).

### devices.fn_guard_mqtt_pairing_operation_state

**Firma:** `devices.fn_guard_mqtt_pairing_operation_state()`.

**Retorno declarado:** `TRIGGER`.

Valida la máquina de estados, los leases, contadores y timestamps de la operación.

Seguridad: INVOKER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/024_mqtt_pairing_state_guards/001_mqtt_pairing_state_guards.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/024_mqtt_pairing_state_guards/001_mqtt_pairing_state_guards.sql#L69).

### devices.fn_audit_mqtt_pairing_operation_state

**Firma:** `devices.fn_audit_mqtt_pairing_operation_state()`.

**Retorno declarado:** `TRIGGER`.

Registra transiciones de operación en mqtt_pairing_state_event.

Seguridad: INVOKER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

Fuente: [releases/024_mqtt_pairing_state_guards/001_mqtt_pairing_state_guards.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/024_mqtt_pairing_state_guards/001_mqtt_pairing_state_guards.sql#L241).

### devices.fn_claim_mqtt_pairing_preparation

**Firma:** `devices.fn_claim_mqtt_pairing_preparation( p_operation UUID, p_lease_seconds INTEGER DEFAULT 60 )`.

**Retorno declarado:** `TABLE(operation_id UUID, assigned_token UUID, expires_at TIMESTAMPTZ, attempt_number INTEGER)`.

Obtiene un lease de preparación con token y vencimiento.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_lease_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/025_mqtt_lease_fencing/001_mqtt_lease_fencing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/025_mqtt_lease_fencing/001_mqtt_lease_fencing.sql#L27).

### devices.fn_report_mqtt_pairing_uncertain

**Firma:** `devices.fn_report_mqtt_pairing_uncertain( p_operation UUID, p_lease_token UUID, p_error_code TEXT )`.

**Retorno declarado:** `BOOLEAN`.

Registra un resultado incierto solo si el lease sigue siendo válido.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_lease_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/025_mqtt_lease_fencing/001_mqtt_lease_fencing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/025_mqtt_lease_fencing/001_mqtt_lease_fencing.sql#L85).

### devices.fn_quarantine_expired_mqtt_pairing_lease

**Firma:** `devices.fn_quarantine_expired_mqtt_pairing_lease(p_operation UUID)`.

**Retorno declarado:** `BOOLEAN`.

Pasa operaciones de lease vencido a reconciliación bajo sus guardas.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_lease_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/025_mqtt_lease_fencing/001_mqtt_lease_fencing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/025_mqtt_lease_fencing/001_mqtt_lease_fencing.sql#L131).

### devices.fn_guard_mqtt_rpc_challenge

**Firma:** `devices.fn_guard_mqtt_rpc_challenge()`.

**Retorno declarado:** `TRIGGER`.

Protege identidad e historia del desafío RPC.

Seguridad: INVOKER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/026_mqtt_rpc_challenge/001_mqtt_rpc_challenge.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/026_mqtt_rpc_challenge/001_mqtt_rpc_challenge.sql#L52).

### devices.fn_issue_mqtt_rpc_challenge

**Firma:** `devices.fn_issue_mqtt_rpc_challenge(p_operation UUID)`.

**Retorno declarado:** `TABLE ( rpc_id UUID, manufacturer_device_id TEXT, request_topic TEXT, response_topic TEXT, request_source TEXT, issued_at TIMESTAMPTZ, expires_at TIMESTAMPTZ, broker_username TEXT, broker_client_id TEXT, broker_role_name TEXT )`.

Emite un desafío de operación AWAITING_AUTH con topics, identidad y expiración.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_rpc_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/026_mqtt_rpc_challenge/001_mqtt_rpc_challenge.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/026_mqtt_rpc_challenge/001_mqtt_rpc_challenge.sql#L87).

### devices.fn_consume_mqtt_rpc_candidate

**Firma:** `devices.fn_consume_mqtt_rpc_candidate(p_operation UUID,p_rpc_id UUID)`.

**Retorno declarado:** `BOOLEAN`.

Consume un candidato RPC vigente una sola vez según sus comprobaciones.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_rpc_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/026_mqtt_rpc_challenge/001_mqtt_rpc_challenge.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/026_mqtt_rpc_challenge/001_mqtt_rpc_challenge.sql#L174).

### devices.fn_confirm_mqtt_pairing_prepared

**Firma:** `devices.fn_confirm_mqtt_pairing_prepared( p_operation UUID, p_lease_token UUID, p_identity UUID, p_broker_username TEXT, p_broker_client_id TEXT, p_broker_role_name TEXT )`.

**Retorno declarado:** `BOOLEAN`.

Confirma preparación contra el lease y el vínculo exacto reservado.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_prepare_confirmer`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/027_mqtt_pairing_prepared_confirmation/001_mqtt_pairing_prepared_confirmation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/027_mqtt_pairing_prepared_confirmation/001_mqtt_pairing_prepared_confirmation.sql#L28).

### devices.fn_load_mqtt_preparation_secret

**Firma:** `devices.fn_load_mqtt_preparation_secret( p_operation UUID, p_lease_token UUID )`.

**Retorno declarado:** `TABLE(operation_id UUID, format_version SMALLINT, key_id TEXT, nonce TEXT, ciphertext TEXT, auth_tag TEXT)`.

Obtiene el sobre cifrado de la operación solo con lease actual.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_secret_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/028_mqtt_preparation_secret/001_mqtt_preparation_secret.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/028_mqtt_preparation_secret/001_mqtt_preparation_secret.sql#L44).

### devices.fn_insert_mqtt_preparation_secret_if_absent

**Firma:** `devices.fn_insert_mqtt_preparation_secret_if_absent( p_operation UUID, p_lease_token UUID, p_format SMALLINT, p_key_id TEXT, p_nonce TEXT, p_ciphertext TEXT, p_tag TEXT )`.

**Retorno declarado:** `BOOLEAN`.

Inserta un sobre cifrado inmutable si falta y el lease sigue vigente.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_secret_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/028_mqtt_preparation_secret/001_mqtt_preparation_secret.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/028_mqtt_preparation_secret/001_mqtt_preparation_secret.sql#L79).

### devices.fn_block_mqtt_auth_attestation_mutation

**Firma:** `devices.fn_block_mqtt_auth_attestation_mutation()`.

**Retorno declarado:** `TRIGGER`.

Bloquea mutación de evidencia de autenticación broker.

Seguridad: INVOKER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql#L54).

### devices.fn_guard_mqtt_pairing_session_verified

**Firma:** `devices.fn_guard_mqtt_pairing_session_verified()`.

**Retorno declarado:** `TRIGGER`.

Exige atestación broker para CONNECTED y vínculo ATTACHED para COMPLETED.

Seguridad: INVOKER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql#L70).

### devices.fn_confirm_mqtt_broker_authentication

**Firma:** `devices.fn_confirm_mqtt_broker_authentication( p_operation UUID, p_rpc_id UUID, p_username TEXT, p_client_id TEXT, p_role_name TEXT )`.

**Retorno declarado:** `BOOLEAN`.

Confirma evidencia de autenticación asociada al desafío RPC, identidad y sesión vigentes.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_auth_confirmer`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql#L117).

### devices.fn_finish_verified_pairing

**Firma:** `devices.fn_finish_verified_pairing( p_session UUID, p_device UUID )`.

**Retorno declarado:** `BOOLEAN`.

Finaliza sesión/dispositivo únicamente con operación e identidad confirmadas y actor autorizado.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_runtime_app`.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql#L213).

### devices.fn_request_mqtt_enable

**Firma:** `devices.fn_request_mqtt_enable( p_operation UUID, p_actor UUID, p_token_hash TEXT )`.

**Retorno declarado:** `BOOLEAN`.

Solicita habilitación de una operación preparada con autorización de actor y token de sesión.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_lease_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/030_mqtt_enable_fencing/001_mqtt_enable_fencing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/030_mqtt_enable_fencing/001_mqtt_enable_fencing.sql#L19).

### devices.fn_claim_mqtt_enable

**Firma:** `devices.fn_claim_mqtt_enable(p_operation UUID,p_seconds INTEGER DEFAULT 60)`.

**Retorno declarado:** `TABLE(operation_id UUID, lease_token UUID, lease_until TIMESTAMPTZ, identity_id UUID, username TEXT,client_id TEXT,role_name TEXT)`.

Asigna lease para habilitar la identidad MQTT.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_lease_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/030_mqtt_enable_fencing/001_mqtt_enable_fencing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/030_mqtt_enable_fencing/001_mqtt_enable_fencing.sql#L70).

### devices.fn_confirm_mqtt_enabled

**Firma:** `devices.fn_confirm_mqtt_enabled( p_operation UUID,p_token UUID,p_username TEXT,p_client_id TEXT,p_role_name TEXT )`.

**Retorno declarado:** `BOOLEAN`.

Confirma habilitación contra lease y vínculo broker; avanza hacia espera de autenticación.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_lease_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/030_mqtt_enable_fencing/001_mqtt_enable_fencing.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/030_mqtt_enable_fencing/001_mqtt_enable_fencing.sql#L117).

### devices.fn_get_authorized_mqtt_bootstrap

**Firma:** `devices.fn_get_authorized_mqtt_bootstrap( p_operation uuid, p_actor uuid, p_token_hash text )`.

**Retorno declarado:** `TABLE(operation_id uuid, identity_id uuid, manufacturer_device_id text, broker_username text, broker_client_id text, topic_scope text, format_version smallint, key_id text, nonce text, ciphertext text, auth_tag text, expires_at timestamptz)`.

Devuelve sobre cifrado y vínculo autorizados para bootstrap; registra entrega y aplica sus límites.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_secret_worker`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/031_mqtt_bootstrap_authorization/001_mqtt_bootstrap_authorization.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/031_mqtt_bootstrap_authorization/001_mqtt_bootstrap_authorization.sql#L30).

### devices.fn_guard_mqtt_pairing_revocation_attestation

**Firma:** `devices.fn_guard_mqtt_pairing_revocation_attestation()`.

**Retorno declarado:** `TRIGGER`.

Protege la evidencia persistente de revocación frente a cambios.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `55000`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql#L63).

### devices.fn_guard_mqtt_pairing_revoked_evidence

**Firma:** `devices.fn_guard_mqtt_pairing_revoked_evidence()`.

**Retorno declarado:** `TRIGGER`.

Impide declarar REVOKED sin evidencia de broker correlacionada.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: sin GRANT explícito conservado en el análisis; revisar uso por trigger/propietario/PUBLIC.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql#L77).

### devices.fn_claim_mqtt_pairing_revocation

**Firma:** `devices.fn_claim_mqtt_pairing_revocation(p_lease_seconds INTEGER DEFAULT 60)`.

**Retorno declarado:** `TABLE(operation_id UUID, lease_token UUID, lease_until TIMESTAMPTZ, identity_id UUID, username TEXT, client_id TEXT, role_name TEXT, attempt INTEGER, revocation_probe_at TIMESTAMPTZ)`.

Reserva con lease la revocación de operaciones de pairing.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_revoke`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql#L103).

### devices.fn_finish_mqtt_pairing_revocation

**Firma:** `devices.fn_finish_mqtt_pairing_revocation( p_operation UUID,p_token UUID,p_outcome TEXT,p_error TEXT )`.

**Retorno declarado:** `TEXT`.

Finaliza/reconcilia la revocación según resultado broker y lease actual.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_revoke`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql#L200).

### devices.fn_claim_mqtt_revocation_with_binding

**Firma:** `devices.fn_claim_mqtt_revocation_with_binding()`.

**Retorno declarado:** `TABLE(identity_id UUID,claim_token UUID,attempt INTEGER, operation_id UUID,revocation_probe_at TIMESTAMPTZ, broker_username TEXT,broker_client_id TEXT,broker_role_name TEXT)`.

Reserva la revocación de identidad adjunta y expone su vínculo a operación/broker.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_revoke`.

SQLSTATE explícitos localizados: `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql#L277).

### devices.fn_finish_mqtt_revocation_evidenced

**Firma:** `devices.fn_finish_mqtt_revocation_evidenced( p_identity UUID,p_token UUID,p_error TEXT,p_outcome TEXT )`.

**Retorno declarado:** `TEXT`.

Finaliza revocación de identidad con evidencia broker y fencing de la operación asociada.

Seguridad: DEFINER; search_path = pg_catalog,pg_temp. Roles con concesión directa localizada: `smarthome_mqtt_revoke`.

SQLSTATE explícitos localizados: `22023`, `23514`. Las condiciones y mensajes exactos están en la fuente; no se traducen automáticamente a HTTP.

Fuente: [releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/032_mqtt_pairing_revocation/001_mqtt_pairing_revocation.sql#L382).

### homes.fn_mqtt_realtime_recipients

**Firma:** `homes.fn_mqtt_realtime_recipients( p_device_id UUID, p_home_id UUID )`.

**Retorno declarado:** `TABLE(id_user UUID)`.

Devuelve destinatarios del hogar para un dispositivo MQTT activo; no incluye el mismo filtro de permisos de detalle por dispositivo.

Seguridad: DEFINER; search_path = pg_catalog, pg_temp. Roles con concesión directa localizada: `smarthome_ingest`.

Fuente: [releases/033_mqtt_ingest_realtime/001_mqtt_ingest_realtime.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/033_mqtt_ingest_realtime/001_mqtt_ingest_realtime.sql#L14).

## Integración y verificación pendiente

Se contrastaron selectivamente PrismaRlsService y adaptadores de reserva, secretos y revocación del backend dev `1cbaca28`. Los nombres de función invocados por esos adaptadores se localizaron en el historial. Eso no prueba igualdad de permisos, compatibilidad de todas las firmas o éxito de una llamada real. El [gateway Lab039](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/devices/infrastructure/secrets/pg-mqtt-secret-lab039.gateway.ts) se declara aislado y sin DI productiva; no demuestra un despliegue.

El backend tiene 18 modelos Prisma en esa revisión, menos que los objetos SQL posteriores. Existen accesos SQL directos; no asumir que todo nuevo objeto necesita un modelo Prisma ni que la API ya soporta SQL034.

Referencias backend: [PrismaRlsService](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/infrastructure/database/prisma/prisma-rls.service.ts), [reserva](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/devices/infrastructure/persistence/pg-mqtt-reservation.port.ts), [revocación](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/devices/infrastructure/persistence/mqtt-revocation-pg.gateway.ts).

[Seguridad](seguridad-y-permisos.md). [Hallazgos](hallazgos-y-pendientes.md). [Pruebas](pruebas-y-verificacion.md).
