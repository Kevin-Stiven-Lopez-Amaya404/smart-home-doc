---
title: Seguridad, roles y políticas de datos
status: borrador
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - seguridad-base-datos
---

# Seguridad, roles y políticas de datos

## Tres niveles de identidad

1. Rol global de producto en auth.role: SYSTEM_ADMIN o USER.
2. Rol de hogar en home_member: OWNER, MEMBER o GUEST.
3. Roles técnicos PostgreSQL: privilegios de la conexión y funciones ejecutables.

No intercambiar esos niveles. Un JWT no establece por sí solo el rol PostgreSQL ni el contexto RLS.

## Roles técnicos localizados

Los 13 roles de grupo aparecen en las migraciones. No contienen contraseñas ni son cuentas LOGIN de usuario final.

| Rol | Responsabilidad | Declaración |
| --- | --- | --- |
| smarthome_admin | Administración técnica; NOLOGIN y BYPASSRLS. No usar como conexión normal del backend. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/03_dcl/00_roles/001_create_roles.sql) |
| smarthome_runtime_app | Grupo de aplicación NestJS; NOLOGIN y NOBYPASSRLS; permisos por objeto/columna. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/03_dcl/00_roles/001_create_roles.sql) |
| smarthome_readonly | Lectura técnica expresamente concedida; no equivale a un usuario funcional autorizado. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/03_dcl/00_roles/001_create_roles.sql) |
| smarthome_ingest | Lectura/escritura limitada para dispositivos y consumo MQTT; separado de aplicación. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/03_dcl/00_roles/001_create_roles.sql) |
| smarthome_worker | Agregaciones y mantenimiento de particiones con grants propios. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/03_dcl/00_roles/001_create_roles.sql) |
| smarthome_mqtt_registrar | Registro de identidad persistente asociada a dispositivo. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_revocation/mqtt-revocation.sql) |
| smarthome_mqtt_revoke | Revocación con contratos reforzados de SQL032 y evidencia broker. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/011_mqtt_revocation/mqtt-revocation.sql) |
| smarthome_mqtt_reserver | Reserva pre-registro; sin permiso general para registrar identidades de dispositivos. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/022_mqtt_pairing_operation/001_mqtt_pairing_operation.sql) |
| smarthome_mqtt_lease_worker | Claims de preparación/habilitación, fences y resultados inciertos. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/025_mqtt_lease_fencing/001_mqtt_lease_fencing.sql) |
| smarthome_mqtt_rpc_worker | Emisión y consumo de desafíos RPC. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/026_mqtt_rpc_challenge/001_mqtt_rpc_challenge.sql) |
| smarthome_mqtt_prepare_confirmer | Confirmación de preparación contra lease y vínculo broker. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/027_mqtt_pairing_prepared_confirmation/001_mqtt_pairing_prepared_confirmation.sql) |
| smarthome_mqtt_secret_worker | Lectura/inserción del sobre cifrado y bootstrap autorizado; NOLOGIN NOINHERIT. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/028_mqtt_preparation_secret/001_mqtt_preparation_secret.sql) |
| smarthome_mqtt_auth_confirmer | Confirmación de autenticación broker ligada al desafío y sesión. | [fuente](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/029_mqtt_authenticated_pairing/001_mqtt_authenticated_pairing.sql) |

El baseline aplica ALTER ROLE a sus cinco grupos para fijar atributos; las releases tienen distintas precondiciones de creación. No asumir que roles preexistentes tienen configuración segura sin auditarla.

[provision-runtime-roles.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/provision-runtime-roles.sql) crea/configura smarthome_app_login y smarthome_ingest_login leyendo secretos del entorno. Separa sus membresías básicas. No provisiona todas las cuentas de propósito MQTT ni acredita que existan en un servidor.

## Contexto transaccional

PrismaRlsService.withUserContext establece app.current_user_id con set_config(..., true) dentro de una transacción. No usar un SET persistente en una conexión compartida del pool.

Contrato documentado por el repositorio, con marcador de UUID que debe sustituirse en un entorno de prueba:

```sql
SELECT set_config('app.current_user_id', '<uuid>', true);
```

auth.fn_current_user_id devuelve NULL sin contexto; el cast de un valor inválido a UUID puede fallar. La función no autentica una identidad enviada por el cliente: el backend debe derivarla de su sesión validada.

Fuentes: [helper de contexto](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/01_ddl/07_functions/004_auth_security_functions.sql), [PrismaRlsService](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/infrastructure/database/prisma/prisma-rls.service.ts).

## RLS y grants

El recorrido identifica ENABLE ROW LEVEL SECURITY sobre 26 nombres de tabla; se localizaron 60 declaraciones CREATE POLICY, incluidas sustituciones posteriores. No son conteos de políticas instaladas.

En PostgreSQL, RLS complementa los privilegios SQL: con RLS habilitado y sin política aplicable se deniega el acceso normal. Superusuarios, BYPASSRLS y normalmente el propietario pueden omitir sus filtros. No basta comprobar el nombre del rol; revisar atributos, membresías y propietarios. Fuente de esta semántica: [PostgreSQL 16 — Row Security Policies](https://www.postgresql.org/docs/16/ddl-rowsecurity.html).

No se localizó ENABLE RLS para auth.role, auth."user", auth.recovery_token o auth.refresh_token en este recorrido. Esas tablas tienen grants específicos y dependen de controles de aplicación; no se afirma aislamiento por usuario en toda la base.

Las tablas home_member_permission y device_member_permission tampoco activan RLS aquí: se revoca acceso directo al runtime y se usan funciones controladas. Los objetos MQTT sensibles combinan revocación de acceso directo, RLS y funciones de propósito específico.

Fuentes: [grants auth](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/03_dcl/01_grants/001_grants_auth.sql), [políticas base](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/03_dcl/02_policies/changelog.yaml), [permisos](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/releases/018_household_permissions/001_household_permissions.sql).

## Permisos funcionales efectivos

- OWNER y MEMBER con permiso conservan los históricos de consumo tras desactivar o retirar un dispositivo; se mantiene una excepción para OWNER de un hogar inactivo. El agregado básico no devuelve fila sin autorización y devuelve cero si no hay lecturas. Antecedente: [consumo por rol HU16](../../99-archivo/base-de-datos/originales/docs/hu16-consumption-access.md).
- Al aplicar la release `018`, las membresías MEMBER y GUEST existentes reciben los valores base de su rol. Antecedente: [permisos de hogar HU16](../../99-archivo/base-de-datos/originales/docs/hu16-permisos-hogar.md).

### Auditoría de conexiones reales

[audit-runtime-roles.sql](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/scripts/audit-runtime-roles.sql) se ejecuta una vez por LOGIN (aplicación e ingesta), indicando el rol esperado con `--set=expected_role=…` y `psql -X --set=ON_ERROR_STOP=1`. Solo lee catálogos y termina con `ROLLBACK`. Para aceptar los permisos de runtime, todas las filas deben mostrar PASS; cualquier FAIL bloquea la aceptación. `ON_ERROR_STOP` solo detiene errores SQL: un consumidor automatizado debe comprobar las filas FAIL de forma explícita. No usar una conexión administrativa ni registrar URI, contraseñas o tokens. El resultado con fixtures del 14/10/2026 y el estado sin verificar de los LOGIN reales se conservan en el [antecedente HU09](../../99-archivo/base-de-datos/originales/docs/hu09-seguridad-runtime.md).

[audit-mqtt-revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/scripts/audit-mqtt-revocation.sql) se ejecuta con el LOGIN real del revocador, sin `SET ROLE` ni cuenta migradora; ese LOGIN solo debe heredar `smarthome_mqtt_revoke` y todas las filas deben devolver `passed=true`. Antes de activar el trabajador se requiere un LOGIN dedicado sin privilegios adicionales, certificados y un client ID exclusivo por réplica. Antecedente: [trabajador de revocación HU11](../../99-archivo/base-de-datos/originales/docs/hu11-mqtt-revocation-runtime.md).

En `devices.mqtt_identity`, `REGISTERED` indica una referencia registrada, no posesión ni conectividad comprobada. Cuando `devices.device.deleted_at` deja de ser nulo, un trigger pasa la identidad a `REVOKE_PENDING` en la misma transacción, sin llamar al broker; la desactivación temporal sin `deleted_at` no la revoca. Las funciones de reclamo y finalización de la release `011` ya no son el contrato del trabajador: SQL032 retiró su ejecución directa (ver [funciones](funciones-y-flujos.md)). Antecedente: [revocación HU11](../../99-archivo/base-de-datos/originales/docs/hu11-mqtt-revocation.md).

- OWNER administra según helpers; las consultas históricas tienen reglas específicas.
- MEMBER inicia con consulta y control habilitados, sujetos a cambios del propietario.
- GUEST inicia con consulta y sin control; se puede conceder control, pero no detalle energético por dispositivo.
- Un override no nulo prevalece sobre la base del hogar; null hereda.
- Al cambiar a MEMBER/GUEST se restablecen bases y se eliminan overrides del dispositivo.
- El consumo básico y el detalle son contratos distintos. Tarifa/meta SQL034 usa fn_can_read_detail y limita escritura a administración del hogar.

La [matriz funcional central](../../60-producto-procesos/roles-y-permisos.md) mantiene la navegación del tema. La autoridad ejecutable está en SQL y en los consumidores backend.

## Funciones con privilegios del propietario

Se localizaron 62 últimas definiciones SECURITY DEFINER, todas con SET search_path. Eso no prueba que su propietario, esquemas y grants instalados sean correctos.

SECURITY DEFINER ejecuta con privilegios del propietario; requiere revisar rutas de búsqueda y quién puede ejecutar la función. Fuente: [PostgreSQL 16 — CREATE FUNCTION](https://www.postgresql.org/docs/16/sql-createfunction.html). El [catálogo](funciones-y-flujos.md) muestra fuente, firma, seguridad y grants directos localizados.

## Límites y pendientes de seguridad

Auditar cuentas reales con [audit-runtime-roles.sql](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/scripts/audit-runtime-roles.sql). Ese script revisa dos roles esperados y ocho tablas protegidas; no cubre todos los roles MQTT ni las 33 tablas de esta referencia.

Validar denegaciones y permisos positivos con LOGIN no privilegiados, no solo con el migrador. Revisar el desfase SQL/realtime: la selección de destinatarios no incorpora el mismo filtro por dispositivo que las consultas de detalle. No se modifica unilateralmente esa regla.

[Pruebas](pruebas-y-verificacion.md). [Hallazgos](hallazgos-y-pendientes.md).
