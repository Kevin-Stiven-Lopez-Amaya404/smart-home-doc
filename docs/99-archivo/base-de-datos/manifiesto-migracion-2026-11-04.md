---
title: Manifiesto de migración documental de base de datos
status: borrador
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - manifiesto-migracion-base-de-datos
---

# Manifiesto de migración de base de datos — 2026-11-04

> Registro de preparación del PR documental. Las fichas permanecen pendientes de revisión y aprobación; este manifiesto no certifica el retiro de originales.

## Datos de inicio

| Dato | Valor |
| --- | --- |
| Repo BD | `nataliachala1/smarthome-database`, rama base `dev` |
| SHA inicial BD | `39416a5c42d35f988689061ffca8a79f7fa21002` |
| Rama de trabajo BD | `chore/fase1-limpieza-documental-bd` |
| Repo documental | `Kevin-Stiven-Lopez-Amaya404/smart-home-doc`, rama base `main` |
| SHA inicial doc | `bcce8738c6b35926cb8b1d2a69d4a5b05b6c7523` (HEAD comprobado al iniciar esta tarea) |
| Rama de trabajo doc | `docs/fase1-migracion-smarthome-database` |
| Inventario | 23 documentos (21 en `docs/` + 2 en la raíz), comprobado el 2026-11-03 |
| Ramas con cambios documentales en BD | `13-dev` (PR #6, `HU13_SHELLY_LOCAL_RPC.md`) y `15-dev` (PR #8, `HU15_CICD_STAGING.md`); no fusionadas |
| Páginas centrales que estuvieron bloqueadas por el PR #5 (backend) | `DOCUMENTATION_POLICY.md`, `00-contexto/inventario-implementaciones.md`, `40-operacion/README.md` |

## Páginas centrales que citan los 23 documentos (actualizar en B.6)

`00-contexto/evidencias-y-pendientes.md` (2), `00-contexto/inventario-implementaciones.md` (31), `00-contexto/mapa-de-repositorios.md` (1), `10-arquitectura/backend/referencia-tecnica.md` (7, verificar si son del backend), `10-arquitectura/base-de-datos/hallazgos-y-pendientes.md` (2), `10-arquitectura/base-de-datos/inventario-de-archivos.md` (23), `10-arquitectura/base-de-datos/operacion-y-mantenimiento.md` (3), `20-contratos/mqtt/contrato-mqtt.md` (1), `40-operacion/copias-de-seguridad.md` (2), `40-operacion/despliegue.md` (1), `60-producto-procesos/proceso-de-liberacion.md` (1), `60-producto-procesos/roles-y-permisos.md` (1, apunta al backend: no tocar).

## Huellas de los 23 documentos (commit `39416a5`)

SHA-256 del contenido versionado (LF), extraído con `git cat-file blob HEAD:<ruta>`; la tercera columna (`git hash-object`) coincide con el blob original, lo que confirma la extracción. Nota: la copia de trabajo en Windows es CRLF (`core.autocrlf=true`) y daría otro SHA-256; no usarla.

| # | Ruta original | SHA-256 (contenido versionado) | Blob Git |
| ---: | --- | --- | --- |
| 1 | `OPERACION_Y_RETENCION.md` | `223e57ab21cb7efa927f026ec2eb00799c6e1aa2d5b499ce6869c50463b575c5` | `7e421b16ba5d153452a50f6e48adec5bbd4e95a0` |
| 2 | `VALIDACION_FINAL.md` | `3c3633354c3ea34bcea72fc91a26ceb7436a956cca9103bee4a6fc1d6ae17e24` | `8625dd5a10bf52a096fd39fec9ac3c175b7ec1a9` |
| 3 | `docs/HU09_SEGURIDAD_RUNTIME.md` | `0ceaba5fb27b961419bcab13a15ef87d3d567bdc7b77d3ddb09dcf6e18774c1e` | `9a869ff24282fe8e347ef397c481308fa8b1cc9b` |
| 4 | `docs/HU09_SESSION_FAMILIES.md` | `52c8b78a916fd53319db9a0e6a620581ef2bb736db031aac007ee6f744829234` | `755373df0770d44dd177cde3cea00e76e74674a6` |
| 5 | `docs/HU09_SESSION_SCHEMA_BRIDGE.md` | `2c557e183f66401eb71592d7f4690610c3c7175d8634adde06b3137caf86fb4d` | `d667f03fdad906feb81fd3089257ff93c825d43c` |
| 6 | `docs/HU10_MQTT_TLS_NAMESPACE.md` | `124cdd8bd7a7ad8570000b271a79e7ac22d4a3bafccf94d7734c2b875ae27765` | `79739947b9c0b8f727bc48fcf06eb850524e70a3` |
| 7 | `docs/HU11_EMQX_SERVERLESS_PAIRING_READINESS.md` | `dd91393f30f32281635ad4915e64ca17b17ce7f74481c2dd3613fea33f43aafb` | `fa06a93fbe20074c35b76282c441cc130aaf17d9` |
| 8 | `docs/HU11_MQTT_CREDENTIAL_PREPARATION.md` | `038267ed02fd910f59349e840d3b47693aea96d3b5f736be221c2414f3330357` | `dad6dc399e7abb18330f36bb3a221a4ea3c1f9a1` |
| 9 | `docs/HU11_MQTT_IDENTITIES.md` | `d412c4524627cc7146e93f49cfc0d246f693a5e770e026c8fcdd24f735f1f6ae` | `5517c79ffb1fe2a2ecf162b51921c4281a8d92e5` |
| 10 | `docs/HU11_MQTT_IDENTITY_HISTORY.md` | `7a1e65d0c96138da20d52178c1938c9f188ccb452925930f145ccededb33e460` | `c19da3b9c54cefd4b043ca3bc07acc1d260c5413` |
| 11 | `docs/HU11_MQTT_REVOCATION.md` | `02e89c7801db59328fa36c7a57a508fcf6b9a739399b0eeaf1770855e161d3b4` | `dc16e4c396543534fab99f2e8749e02de0c6656b` |
| 12 | `docs/HU11_MQTT_REVOCATION_RUNTIME.md` | `96f7c8bf3d94342433ac6773ced83a64efaaa069b0d1c860b20db290c258dd8f` | `5b5287bf218b7dbb51077de4b7ba409b1ed582e3` |
| 13 | `docs/HU14_OBSERVABILITY_METRICS.md` | `322e8eaed46ef5176703eb38c8ba286389d63c97b69c3226fd22009cffb19626` | `771106dc13c829eb69cddddbd8d7356d5cbd0cb3` |
| 14 | `docs/HU16_CONSUMPTION_ACCESS.md` | `eb91474326bc6039a9b8f6ab02c61345267caaaa0397770c9ca8089982258e77` | `702d9e5665644c18260e00b5d802ddc2b5fbf682` |
| 15 | `docs/HU16_DEVICE_PAIRING_SESSIONS.md` | `2215e02a47c259c0b7f41c4853c91d6be4c25fa21e940c99097a0abc882d147a` | `7d881c889597bcc1bb7eb644ab261652e04d9e70` |
| 16 | `docs/HU16_PERMISOS_HOGAR.md` | `4399e06df3ec4e4499e4b2d08852f5d9ff421fad631d3fa887c6eb16b54c8269` | `93c10223a7850b1df313ea8438e722af2c96b6c5` |
| 17 | `docs/ROLES_Y_PERMISOS.md` | `1e5a2c35f4e52864c8b09d19fdb0c61a2c79c678eb2a4c94e6b88ecd24d5e319` | `2cdff082405fa4594a0de6195d9843ad756e11ef` |
| 18 | `docs/deployment/ARCHITECTURE.md` | `1a45f52677509c1c14b93b339ccfcebfff8eee74b0fb6affe6d45a46efb6ca6f` | `1ae797aa3dff06c585e4681d57d1d27f706cdf3f` |
| 19 | `docs/deployment/BACKUP_AND_RESTORE.md` | `4641f437f2a53126aac4de6bb90c337c8cbee532541fe0f912210cf1976e9b38` | `f8bd23c1780ccb123f0a024635baa9bb4b38911d` |
| 20 | `docs/deployment/CICD.md` | `32c8d2d81bc4ea7fd98d9acee339b2da70c3a4cbac3d80cf1dabb4733ef6ecbb` | `1585e68b6791bb1c920424587c91cf5a79a8d04a` |
| 21 | `docs/deployment/ENVIRONMENT_VARIABLES.md` | `83a4d47465844701a77ce0093a9071bf985e0b8b3a7f9f1801a111961afbb3d6` | `f64c7bc6e578490682dcdacbd198a84e2b5b52d6` |
| 22 | `docs/deployment/HOSTINGER_DEPLOYMENT.md` | `e583545888bae5a2b06e562c086292c60d849c2f3cc005d3ef562caa027d7981` | `6df36bc94383bdbaf16518962887589255e19446` |
| 23 | `docs/deployment/TROUBLESHOOTING.md` | `461fb4c305a8f3889dd750d58acff48a01879a7ab2d5465de6ae6bddaa80b470` | `3ec9ad9e79d3465944f71b620cf70b983c01ec82` |

## Contradicción transversal: fuente central desfasada

Las páginas de `10-arquitectura/base-de-datos/` se basan en el snapshot `6caed6b` («42 changelogs, 96 changesets», «maestro actual de 96», «33 tablas»). `dev` está en `39416a5` e incluye al menos las releases `035_flespi_mqtt_ingest_idempotency` y `036_flespi_mqtt_event_order`. `seguridad-y-permisos.md` añade otras cifras del mismo snapshot: 13 roles de grupo, RLS en 26 tablas, 60 `CREATE POLICY`, 62 funciones `SECURITY DEFINER`, 33 tablas; `funciones-y-flujos.md`: 83 declaraciones de función y 73 nombres con última definición. **Recontar contra `39416a5` antes de actualizar cifras** (MD §4). No copiar los valores antiguos como actuales.

`migraciones-y-rollbacks.md` enumera releases solo hasta `034_energy_tariff_budget` (changesets 95–96); faltan `035` y `036`, presentes en `39416a5`.

**Para la Etapa C (README de BD):** `migraciones-y-rollbacks.md` indica que el README afirma rollback para todos los changesets activos, pero `030_mqtt_enable_fencing` y `031_mqtt_bootstrap_authorization` no declaran rollback y el puente `009` usa `SELECT 1`. El README corregido no debe repetir esa afirmación.

---

## #1 — `OPERACION_Y_RETENCION.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | `OPERACION_Y_RETENCION.md` · [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/OPERACION_Y_RETENCION.md) · SHA-256: `223e57ab21cb7efa927f026ec2eb00799c6e1aa2d5b499ce6869c50463b575c5` · blob: `7e421b16ba5d153452a50f6e48adec5bbd4e95a0` |
| 2. Fecha, propósito, HU, baseline y estado | Creado en `787f4ac` (2026-09-04, «Add project database»), sin modificaciones posteriores. Sin HU. Propósito: criterios de retención, particiones y backup del baseline. Estado: **vigente parcial**: los hechos estructurales coinciden con el SQL; los plazos de retención son recomendaciones sin implementación |
| 3. Dependencias ejecutables | `01_ddl/03_tables/003_create_devices_tables.sql:84` (`device_telemetry_raw`); `01_ddl/03_tables/004_create_consumption_tables.sql:31` (`consumption_default`); `01_ddl/07_functions/005_consumption_partition_functions.sql:12`; `03_dcl/01_grants/004_grants_consumption.sql:17-18` (EXECUTE a `smarthome_worker`); `03_dcl/01_grants/008_grants_audit.sql:1-3` (solo SELECT/INSERT sobre `audit_log` para `smarthome_runtime_app` y `smarthome_admin`; confirmado); `03_dcl/02_policies/007_rls_identity_audit.sql`. No hay job de purga ni retención en SQL/YAML/scripts (búsqueda sin resultados) |
| 4. Referencias, enlaces e imágenes | Ninguno. Es citado por `operacion-y-mantenimiento.md:32` y por la copia archivada del backend `informe-01…:108` (permalink a `6caed6b`, no tocar) |
| 5. Comparación con la página canónica | `operacion-y-mantenimiento.md` ya integra: partición DEFAULT, `fn_ensure_consumption_partitions(2)`, momento de ejecución, invocación recomendada al iniciar el worker y periódicamente, retención solo documental, `sync.backup` como metadata. **Información única no integrada**: plazo de 30 días para telemetría en desarrollo; ≥ 12 meses para `audit_log` antes de archivado/purga autorizada; `audit_log` append-only para roles de aplicación; `smarthome_worker` como rol ejecutor; ejecutar antes de habilitar la ingesta. **Contradicciones**: ninguna. **Observación**: el último párrafo del original (momento de la llamada) está bajo «Backups» aunque corresponde a «Particiones»; no se corrige en la copia archivada |
| 6. Decisión | **Integrado en documento canónico** (`operacion-y-mantenimiento.md`, sección «Particiones y retención») + **archivado con referencia**. `copias-de-seguridad.md`: sin aporte nuevo (lo de `sync.backup` ya está en la página de operación) |
| 7. Copia archivada y secretos | Destino: `99-archivo/base-de-datos/originales/operacion-y-retencion.md`. Sin secretos, tokens ni datos personales. Sin redacciones |
| 8. Evidencia y enlaces | Pendiente: PR documental. Reemplazar el enlace de `operacion-y-mantenimiento.md:32` por la copia archivada |

**Texto propuesto para integrar (B.5), no aplicar todavía:**

> Valores de referencia del documento de origen, no aprobados como regla de producto ni aplicados por un job: retener `devices.device_telemetry_raw` 30 días en desarrollo y conservar `identity_audit.audit_log` al menos 12 meses antes de cualquier archivado o purga autorizada por infraestructura. Los roles de aplicación solo tienen SELECT e INSERT sobre `audit_log`, por lo que la tabla es append-only para ellos. EXECUTE sobre la función de particiones se concede a `smarthome_worker`; el origen indica ejecutarla antes de habilitar la ingesta.

---

## #2 — `VALIDACION_FINAL.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | `VALIDACION_FINAL.md` · [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/VALIDACION_FINAL.md) · SHA-256: `3c3633354c3ea34bcea72fc91a26ceb7436a956cca9103bee4a6fc1d6ae17e24` · blob: `8625dd5a10bf52a096fd39fec9ac3c175b7ec1a9` |
| 2. Fecha, propósito, HU, baseline y estado | Historial: `787f4ac` (2026-09-04), `7e051fb` (2026-09-08), `08b88b5` (2026-10-22, Kevin, «isolate runtime app role from bootstrap superuser»: solo renombra `smarthome_app` → `smarthome_runtime_app` en dos líneas). Contenido del 2026-09-08 con nombre de rol actualizado el 2026-10-22. Sin HU. Propósito: validación estática del baseline anterior al 8/09. Baseline: **60 changeSets activos**. Estado: **histórico** (el propio documento se declara así) |
| 3. Dependencias ejecutables | `.env.example`, `docker-compose.yml`, `liquibase.properties`, `changelog/changelog-master.yaml`; roles `smarthome_runtime_app`, `smarthome_ingest`, `smarthome_worker`; `consumption.consumption_default` y `fn_ensure_consumption_partitions(2)` |
| 4. Referencias, enlaces e imágenes | Un enlace relativo: `[la validación vigente](./README.md)` (README del repo BD). **Al archivarlo se rompe** (apuntaría a `originales/README.md`). Reparación propuesta, siguiendo el precedente del archivo backend: fijarlo como permalink al README de BD en `08b88b5`, último commit que modificó el documento. Sin imágenes. Es citado por el README de BD (línea 27), `inventario-de-archivos.md:205` y `99-archivo/backend/informe-01…:107` (no tocar) |
| 5. Comparación con la página canónica | `pruebas-y-verificacion.md` **no lo menciona**. Información única: validación estática del baseline de 60 changeSets (YAML, includes, rollbacks, IDs, objetos retirados, funciones RLS y grants) y lista de correcciones de esa entrega. **Contradicción**: «60 changeSets» frente a los 96 de la central (`6caed6b`) y a los actuales de `39416a5`, que se explica por la fecha; no es un error si se presenta como histórico. La nota de particiones duplica el #1 (ya integrada) |
| 6. Decisión | **Archivado con referencia** + breve **antecedente histórico** en `pruebas-y-verificacion.md`. No se integra como validación vigente |
| 7. Copia archivada y secretos | Destino: `99-archivo/base-de-datos/originales/validacion-final.md`. Sin secretos: solo pide cambiar `POSTGRES_PASSWORD` en un `.env` local, sin valor. Contiene comandos `docker compose … update`; quedan en la copia histórica con el aviso de no ejecutarlos fuera de una base limpia y aislada |
| 8. Evidencia y enlaces | Pendiente: PR documental. Actualizar `inventario-de-archivos.md:205` |

**Texto propuesto para integrar (B.5), no aplicar todavía.** Nueva sección en `pruebas-y-verificacion.md`:

> ## Antecedente histórico: validación del baseline (2026-09-08)
>
> La [validación final del baseline](originales/validacion-final.md) registra revisiones **estáticas** sobre los 60 changeSets del baseline anterior al modelo hogar → dispositivo: carga de YAML, includes y rollbacks, IDs únicos, ausencia de objetos retirados y coherencia de funciones RLS y grants. No incluyó ejecución en PostgreSQL ni Liquibase; el propio documento la deja pendiente. Es un antecedente: no valida el maestro actual ni sustituye el plan de verificación de esta página.

---

## #3 — `docs/HU09_SEGURIDAD_RUNTIME.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | `docs/HU09_SEGURIDAD_RUNTIME.md` · [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU09_SEGURIDAD_RUNTIME.md) · SHA-256: `0ceaba5fb27b961419bcab13a15ef87d3d567bdc7b77d3ddb09dcf6e18774c1e` · blob: `9a869ff24282fe8e347ef397c481308fa8b1cc9b` |
| 2. Fecha, propósito, HU, baseline y estado | Creado en `f097a0a` (2026-10-14); incrementos el 14/10 (`6b7239e`, `da30742`, `3e6e4b9`, `c23c7f3`) y último cambio `08b88b5` (2026-10-22). HU09 (BD-01, BD-02, BD-17). Baseline: rama `09-dev` desde `03-dev`/`e18b2d0`; BD funcional `f097a0a`; backend `8235727`, `7447822`, `49d5e55`, `da0a5ca`, `6b033fe`. Estado: **histórico**: evidencia de su fecha; el propio documento marca como **SIN VERIFICAR** la instalación existente y los LOGIN reales |
| 3. Dependencias ejecutables | `scripts/audit-runtime-roles.sql`, `scripts/test-runtime-roles.ps1`; roles `smarthome_runtime_app`, `smarthome_ingest`; PostgreSQL 16 + psql; Docker para la prueba |
| 4. Referencias, enlaces e imágenes | **Relativos (se rompen al archivar, reescribir a kebab-case en la misma carpeta):** `HU16_CONSUMPTION_ACCESS.md` → `hu16-consumption-access.md`; `HU09_SESSION_SCHEMA_BRIDGE.md` → `hu09-session-schema-bridge.md`; `HU09_SESSION_FAMILIES.md` (×1) → `hu09-session-families.md`. **Externos (registrar en `scripts/source-references.json`):** backend `commit/49d5e55`, `blob/49d5e55/docs/HU09_RATE_LIMITING.md`, `commit/da0a5ca`, `blob/da0a5ca/docs/HU09_REALTIME_SECURITY.md`, `commit/6b033fe`; PostgreSQL 16 `functions-info.html` y `ddl-rowsecurity.html` (esta última ya citada en la central). Sin imágenes. Citado por README BD (línea 23) e `inventario-de-archivos.md:209` |
| 5. Comparación con la página canónica | `seguridad-y-permisos.md` no lo menciona; `pruebas-y-verificacion.md` ya describe los nueve diagnósticos, las ocho tablas y los seis escenarios de `test-runtime-roles.ps1`; `operacion-y-mantenimiento.md` ya recoge `session_user`/`current_user`/`SET ROLE`. **Información única no integrada:** procedimiento de ejecución por LOGIN con `expected_role` y `ON_ERROR_STOP`; criterio de aceptación (PASS en todas las filas, cualquier FAIL bloquea); `ON_ERROR_STOP` no convierte FAIL en código de salida; no usar conexión administrativa ni registrar URI/contraseñas; limitaciones de la auditoría. **Fuera de alcance BD (solo archivo):** límites HTTP 429 y seguridad Socket.IO, que son del backend. **Contradicción a vigilar:** la auditoría exige PostgreSQL 16, la central indica que el CI de datos usa PostgreSQL 18 desechable; registrar como pendiente de confirmar, no resolver aquí |
| 6. Decisión | **Integrado en documento canónico** (`seguridad-y-permisos.md`, nueva subsección «Auditoría de conexiones reales») + **archivado con referencia** |
| 7. Copia archivada y secretos | Destino: `99-archivo/base-de-datos/originales/docs/hu09-seguridad-runtime.md`. Sin secretos: los comandos `psql` no llevan credenciales y el texto prohíbe pegarlas. Menciona un archivo local `revision-dispositivos.txt` (no sensible). Sin redacciones |
| 8. Evidencia y enlaces | Pendiente: PR documental. Actualizar `inventario-de-archivos.md:209` |

**Texto propuesto para integrar (B.5), no aplicar todavía.** Nueva subsección en `seguridad-y-permisos.md`, dentro de «Límites y pendientes de seguridad»:

> ### Auditoría de conexiones reales
>
> [audit-runtime-roles.sql](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/scripts/audit-runtime-roles.sql) se ejecuta una vez por LOGIN (aplicación e ingesta), indicando el rol esperado con `--set=expected_role=…` y `psql -X --set=ON_ERROR_STOP=1`. Solo lee catálogos y termina con `ROLLBACK`. Para aceptar los permisos de runtime, todas las filas deben mostrar PASS; cualquier FAIL bloquea la aceptación. `ON_ERROR_STOP` solo detiene errores SQL: un consumidor automatizado debe comprobar las filas FAIL de forma explícita. No usar una conexión administrativa ni registrar URI, contraseñas o tokens. El resultado con fixtures del 14/10/2026 y el estado sin verificar de los LOGIN reales se conservan en el [antecedente HU09](originales/docs/hu09-seguridad-runtime.md).

---

## #4 — `docs/HU09_SESSION_FAMILIES.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | `docs/HU09_SESSION_FAMILIES.md` · [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU09_SESSION_FAMILIES.md) · SHA-256: `52c8b78a916fd53319db9a0e6a620581ef2bb736db031aac007ee6f744829234` · blob: `755373df0770d44dd177cde3cea00e76e74674a6` |
| 2. Fecha, propósito, HU, baseline y estado | Creado en `3e6e4b9` y actualizado en `07de82f` (ambos 2026-10-14, Kevin). HU09 / BD-17. Baseline: esquema funcional `f097a0a`, rama `09-dev`; backend `6b033fe`; historial original de **62 changesets**. Estado: **histórico**: el propio documento indica que HU09 y BD-17 siguen abiertos y que LOGIN/RLS reales están pendientes |
| 3. Dependencias ejecutables | `auth.refresh_token` (columnas listadas); `scripts/session-security-fixture.sql` (fuera de changelogs); `releases/009_session_schema/` (puente, vía #5); backend `scripts/test-session-security.ps1` |
| 4. Referencias, enlaces e imágenes | **Relativos que se rompen al archivar:** `HU09_SESSION_SCHEMA_BRIDGE.md` → `hu09-session-schema-bridge.md` (misma carpeta); `../scripts/session-security-fixture.sql` → permalink de BD en `07de82f` (último commit que modificó el documento). **Externos (registrar en `scripts/source-references.json`):** backend `commit/6b033fe`, `blob/6b033fe/scripts/test-session-security.ps1`, `blob/6b033fe/docs/HU09_SESSION_FAMILIES.md`. Sin imágenes. Citado por README BD (línea 25), `inventario-de-archivos.md:210` y por el #3 |
| 5. Comparación con la página canónica | `modelo-de-datos.md` ya recoge las columnas de `refresh_token` (`family_id`, `session_version`, revocación, reemplazo, último uso) y el puente de release 009; `pruebas-y-verificacion.md` ya cita la fixture y el runner del backend. **Información única no integrada (contrato de persistencia):** rotación y revocación de una familia comparten `pg_advisory_xact_lock(hashtextextended(family_id::text, 0))` con `ReadCommitted`; el lock es transaccional; no mezclar versiones que omitan el protocolo; el LOGIN operativo debe poder ejecutar esas operaciones y adquirir el lock (sin verificar en instalación real); `hasActiveFamily` reutiliza el índice existente por familia. **Solo archivo (backend):** claim `sid`, Socket.IO, 17 casos de prueba, compatibilidad de clientes. **Cifras:** 62 changesets (aquí) frente a 60 (#2) y 96 (central); se explican por fecha |
| 6. Decisión | **Integrado en documento canónico** (`modelo-de-datos.md`, sección «Identidad y sesiones») + **archivado con referencia** |
| 7. Copia archivada y secretos | Destino: `99-archivo/base-de-datos/originales/docs/hu09-session-families.md`. Sin secretos: nombra la variable `SESSION_TEST_DATABASE_URL` sin valor y una contraseña sintética no mostrada. Sin redacciones |
| 8. Evidencia y enlaces | Pendiente: PR documental. Actualizar `inventario-de-archivos.md:210`. Índice por `family_id` **verificado**: `01_ddl/04_alter/012_create_refresh_token_table.sql:48` y `releases/009_session_schema/001_session_schema.sql:38` (`idx_refresh_token_family`) |

**Texto propuesto para integrar (B.5), no aplicar todavía.** Párrafo al final de «Identidad y sesiones» en `modelo-de-datos.md`:

> La rotación y la revocación de una misma familia se coordinan desde la aplicación: ambas adquieren `pg_advisory_xact_lock(hashtextextended(family_id::text, 0))` dentro de una transacción `READ COMMITTED`, de modo que un logout confirmado antes impide crear un sucesor y uno confirmado después lo incluye. El lock es transaccional y no se conserva en el pool; no deben mezclarse versiones del backend que omitan este protocolo. El LOGIN operativo debe poder ejecutar esas operaciones y adquirir el lock; no está verificado en una instalación real. Antecedente: [familias de sesión HU09](originales/docs/hu09-session-families.md).

---

## #5 — `docs/HU09_SESSION_SCHEMA_BRIDGE.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | `docs/HU09_SESSION_SCHEMA_BRIDGE.md` · [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU09_SESSION_SCHEMA_BRIDGE.md) · SHA-256: `2c557e183f66401eb71592d7f4690610c3c7175d8634adde06b3137caf86fb4d` · blob: `d667f03fdad906feb81fd3089257ff93c825d43c` |
| 2. Fecha, propósito, HU, baseline y estado | Creado en `07de82f` (2026-10-14); modificado en `08b88b5` (2026-10-22; solo renombra `smarthome_app` → `smarthome_runtime_app` en dos líneas). HU09 / BD-03, preparado en `16-dev`. Changeset `hu09-session-schema-bridge-20261014` (release `009_session_schema`, n.º 74 en la central). Baseline: 62 changesets originales; PostgreSQL 16 + Liquibase 4.29.2; backend `bc9d3ec`. Estado: **histórico**, con aclaración de rama (ver punto 5) |
| 3. Dependencias ejecutables | `releases/009_session_schema/changelog.yaml` y `001_session_schema.sql` (tabla, índices `:38`, grants `:58`); `auth.refresh_token`, `auth.user.session_version`; rol `smarthome_runtime_app`; backend `scripts/test-consumption-access.ps1` |
| 4. Referencias, enlaces e imágenes | **Relativo que se rompe al archivar:** `../releases/009_session_schema/changelog.yaml` → permalink de BD en `08b88b5` (último commit que modificó el documento). **Externos (registrar):** backend `commit/bc9d3ec`, `blob/bc9d3ec/docs/HU16_CONSUMPTION_ACCESS.md`. Sin imágenes. Citado por README BD (línea 6), `inventario-de-archivos.md:211`, #3 y #4 |
| 5. Comparación con la página canónica | `migraciones-y-rollbacks.md` ya tiene la fila 74 («puente compatible…; rollback intencionalmente conserva estructura») y la cobertura `SELECT 1`. **Información única no integrada:** motivo del puente (los 62 originales no creaban esos objetos); comprobaciones de compatibilidad (tipos, nulabilidad, PK, unicidad por hash, FK sin cascada) y que una divergencia provoca error y rollback sin reescribir la tabla; esa comprobación no sustituye comparar defaults, propietarios ni políticas; grants concedidos (sin DELETE); precaución antes de aplicarlo a una base existente. **Contradicción:** el documento afirma que los 62 changesets originales no creaban `auth.refresh_token`, pero en `39416a5` existe `01_ddl/04_alter/012_create_refresh_token_table.sql` (citado también por `modelo-de-datos.md`). **Comprobado:** `012` se añadió en `5878c85` (2026-09-22, nataliachala1, «align auth schema and device lifecycle») y está incluido en `01_ddl/04_alter/changelog.yaml:151` (rollback `:156`). Es decir, ya existía en `dev` antes del 14/10. **Resuelto:** `git merge-base --is-ancestor 5878c85 e18b2d0` → 1: la base del ensayo (`03-dev` `e18b2d0`) **no** contenía `5878c85`. La afirmación era cierta para el historial de esa rama, no para `dev`. Se registra como histórica con aclaración |
| 6. Decisión | **Integrado en documento canónico** (`migraciones-y-rollbacks.md`, subsección «Dependencia del puente de sesiones») + **archivado con referencia** |
| 7. Copia archivada y secretos | Destino: `99-archivo/base-de-datos/originales/docs/hu09-session-schema-bridge.md`. Sin secretos: el comando no lleva credenciales y menciona tokens solo como sintéticos. Sin redacciones |
| 8. Evidencia y enlaces | Pendiente: PR documental. Actualizar `inventario-de-archivos.md:211` |

**Texto propuesto para integrar (B.5), no aplicar todavía:**

> ### Dependencia del puente de sesiones (009)
>
> El changeset `hu09-session-schema-bridge-20261014` crea o reconcilia `auth.refresh_token` y `auth.user.session_version`, que el backend usa para las familias de sesión. Se preparó el 2026-10-14 sobre una rama basada en `03-dev` (`e18b2d0`), cuyo historial no incluía `01_ddl/04_alter/012_create_refresh_token_table.sql`; en `dev` ese archivo ya declara la tabla desde `5878c85` (2026-09-22), y el puente conserva los objetos compatibles que encuentre. Concede a `smarthome_runtime_app` SELECT, INSERT de los campos necesarios y UPDATE de revocación, reemplazo y último uso, sin DELETE. Si encuentra objetos compatibles conserva sus filas: comprueba tipos, nulabilidad, clave primaria, unicidad por hash y FK sin cascada, y ante una divergencia falla y revierte la transacción sin reescribir la tabla. Esa comprobación no sustituye comparar defaults, propietarios y políticas del esquema instalado. Antes de aplicarlo sobre una base existente, contrastar `DATABASECHANGELOG`, checksums, esquema de sesiones y privilegios. Antecedente: [puente del esquema de sesiones HU09](originales/docs/hu09-session-schema-bridge.md).

---

## #6 — `docs/HU10_MQTT_TLS_NAMESPACE.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | `docs/HU10_MQTT_TLS_NAMESPACE.md` · [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU10_MQTT_TLS_NAMESPACE.md) · SHA-256: `124cdd8bd7a7ad8570000b271a79e7ac22d4a3bafccf94d7734c2b875ae27765` · blob: `79739947b9c0b8f727bc48fcf06eb850524e70a3` |
| 2. Fecha, propósito, HU, baseline y estado | Único commit `9b9742b` (2026-10-15, Kevin). HU10, primer incremento. Rama `10-dev` desde `09-dev` `3e6e4b9`; backend base `6b033fe`, implementación `63f4bf5`. Solo documentación, sin SQL. Estado: **histórico** (incremento de rama; el propio texto advierte que no contiene HU16 y no es un esquema completo) |
| 3. Dependencias ejecutables | Ninguna en BD (sin SQL). Objetos citados: `devices.device.manufacturer_device_id`, índice único de fabricante, filtros `status = ACTIVE` y `deleted_at IS NULL` de la consulta de ingestión (backend) |
| 4. Referencias, enlaces e imágenes | Sin enlaces relativos ni imágenes. **Externo (registrar):** backend `commit/63f4bf56a203ddb514fb53e935dc5860944f2e0a`. Citado por README BD (línea 20) e `inventario-de-archivos.md:212` |
| 5. Comparación con la página canónica | `contrato-mqtt.md` es la referencia canónica del contrato MQTT; `tls-y-namespace.md` (PR #5) es una copia íntegra del HU10 del backend y no se modifica; **información única integrada (persistencia):** el namespace identifica instalación/entorno, no un permiso de hogar; el ID persistido es `manufacturer_device_id` sin prefijo; no hay tablas de tópicos; el prefijo no impide que una identidad publique por otra (ACL/revocación dependen de HU11 y del broker); HU10 no cambió SQL, RLS ni Liquibase. **Solo archivo (backend):** 155 + 31 pruebas, bloqueo del provisioning LAN heredado |
| 6. Decisión | **Integrado** en `contrato-mqtt.md` (sección «Base de datos: namespace y proveedor de broker», destino indicado por el plan) + **archivado con referencia** |
| 7. Copia archivada y secretos | Destino: `99-archivo/base-de-datos/originales/docs/hu10-mqtt-tls-namespace.md`. Sin secretos: indica expresamente que no se usaron credenciales reales. Sin redacciones |
| 8. Evidencia y enlaces | Pendiente: PR documental. Actualizar `inventario-de-archivos.md:212` |

**Texto integrado en `contrato-mqtt.md`:**

> ### Persistencia frente a namespace y TLS
>
> Para la base de datos, el namespace MQTT identifica una instalación o entorno; no es un permiso de hogar ni existe una tabla de tópicos. El identificador persistido sigue siendo `manufacturer_device_id` sin prefijo. El prefijo de tópicos no impide que una identidad publique por otra: la autenticación, la ACL individual y la revocación dependen del broker y de los objetos de identidad de HU11. HU10 no modificó SQL, RLS ni el historial Liquibase. Antecedente: [HU10 en la base de datos](originales/docs/hu10-mqtt-tls-namespace.md).

---

## #7 — `docs/HU11_EMQX_SERVERLESS_PAIRING_READINESS.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | `docs/HU11_EMQX_SERVERLESS_PAIRING_READINESS.md` · [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU11_EMQX_SERVERLESS_PAIRING_READINESS.md) · SHA-256: `dd91393f30f32281635ad4915e64ca17b17ce7f74481c2dd3613fea33f43aafb` · blob: `fa06a93fbe20074c35b76282c441cc130aaf17d9` |
| 2. Fecha, propósito, HU, baseline y estado | `6f3a5c4` y `fd1cbaa` (ambos 2026-10-15, Kevin). HU11/HU12. Baseline: BD `11-dev` `a9589ca`; backend `11-dev` `7730ff1`; móvil `0dc85b0`; **64 changesets**. Solo documental. Estado: **histórico / pendiente de contraste** (MD §3 fila 7 y §4): registra una decisión de broker de su fecha, no el broker vigente |
| 3. Dependencias ejecutables | `devices.mqtt_identity` y su historial; `fn_register_mqtt_identity`; trabajador de revocación y sus nueve auditorías (`scripts/audit-mqtt-revocation.sql`); backend `scripts/test-mqtt-revocation.cjs` |
| 4. Referencias, enlaces e imágenes | Sin enlaces relativos ni imágenes. **Externos (registrar):** 5 páginas de EMQX Cloud (`api/serverless.html`, `api/api_deployment.html`, `deployments/auth_overview.html`, `deployments/authz_overview.html`, `deployments/default_authz.html`) y `from_movil/tree/0dc85b0…`. Las rutas de informes del backend están en texto, no enlazadas. Citado por README BD (línea 16) e `inventario-de-archivos.md:213` |
| 5. Comparación con la página canónica | `contrato-mqtt.md` no menciona proveedor de broker; `evidencias-y-pendientes.md` solo cita «firmware y ACL del broker» en E13. **Contradicciones:** (a) afirma «EMQX Cloud Serverless confirmado para producción», mientras el backend prueba con Mosquitto Dynamic Security y `dev` incluye releases `035_flespi_mqtt_ingest_idempotency`/`036_flespi_mqtt_event_order`: **no decidir el broker desde esta guía**; (b) dice que `fn_register_mqtt_identity` no es una reserva previa y que la reserva/leases se definirían «después»: las releases posteriores `022` (reserva), `025` (leases) y `027`–`032` ya lo abordan, así que esa parte está **superada** y no debe presentarse como estado actual. **Información única:** limitaciones de la API pública de EMQX Serverless consultadas el 2026-10-15; el estado SQL de revocación no equivale a revocación ejecutada en el broker si el trabajador está desactivado; decisiones de producto enumeradas (vinculación solo OWNER, recuperación en el mismo hogar con evidencia, transferencia entre hogares bloqueada en el MVP, históricos conservados, sin apagado físico automático, contraseña Wi-Fi fuera del backend), **sin aprobación acreditada**. **Solo archivo:** cifras de pruebas (317, 117, 62 → 63 → 64), estado del adaptador BLE móvil |
| 6. Decisión | **Integrado** como antecedente en `contrato-mqtt.md` + **E17** en `evidencias-y-pendientes.md` + **archivado con referencia** |
| 7. Copia archivada y secretos | Destino: `99-archivo/base-de-datos/originales/docs/hu11-emqx-serverless-pairing-readiness.md`. Sin secretos: menciona que no se tocaron credenciales ni `.env`. Sin redacciones |
| 8. Evidencia y enlaces | Pendiente: PR documental. Actualizar `inventario-de-archivos.md:213`. La evidencia nueva se registró como E17 |

**Textos integrados:**

En `contrato-mqtt.md`:

> ### Proveedor de broker: antecedente HU11
>
> Un registro del 2026-10-15 indica que se eligió EMQX Cloud Serverless para producción y que su API pública, consultada entonces, no ofrecía altas y bajas automatizadas de credenciales o ACL; el trabajador de revocación del backend de esa fecha solo admitía Mosquitto Dynamic Security. No se ha verificado cuál es el broker vigente en DEV ni en producción, y no debe tomarse ese antecedente como decisión actual. Si el trabajador de revocación está desactivado, el estado SQL no equivale a una revocación ejecutada en el broker. Antecedente: [HU11 EMQX Serverless](originales/docs/hu11-emqx-serverless-pairing-readiness.md). Pendiente: [registro de evidencias](../../00-contexto/evidencias-y-pendientes.md).

En `evidencias-y-pendientes.md` (número tras los del PR #5):

> ### E1x — Broker MQTT de producción
>
> **Pendiente de contraste:** el antecedente HU11 de la base de datos (2026-10-15) registra EMQX Cloud Serverless como proveedor confirmado para producción; el backend se probó con Mosquitto Dynamic Security y `dev` de la base de datos incluye releases de ingesta flespi (`035`, `036`). No se decide aquí el broker de producción. Las decisiones de producto que enumera ese antecedente (vinculación solo OWNER, recuperación en el mismo hogar, transferencia entre hogares bloqueada en el MVP, conservación de históricos, sin apagado físico automático) no tienen aprobación acreditada. Fuente: [antecedente HU11](originales/docs/hu11-emqx-serverless-pairing-readiness.md).

---

## #8 — `docs/HU11_MQTT_CREDENTIAL_PREPARATION.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | `docs/HU11_MQTT_CREDENTIAL_PREPARATION.md` · [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU11_MQTT_CREDENTIAL_PREPARATION.md) · SHA-256: `038267ed02fd910f59349e840d3b47693aea96d3b5f736be221c2414f3330357` · blob: `dad6dc399e7abb18330f36bb3a221a4ea3c1f9a1` |
| 2. Fecha, propósito, HU, baseline y estado | Único commit `a9589ca` (2026-10-15, Kevin; es también la base citada por el #7). HU11, quinto incremento. Baseline: BD `06b0eab`, backend `b5221db`; **64 changesets**; Mosquitto 2.0.22. Solo documental, sin DDL. Estado: **histórico, parcialmente superado** por releases posteriores |
| 3. Dependencias ejecutables | `devices.mqtt_identity` (`state`), historial de identidades (`releases/011_mqtt_identity_events/`), `fn_register_mqtt_identity`, nueve comprobaciones del trabajador; backend `scripts/test-mqtt-revocation.cjs` |
| 4. Referencias, enlaces e imágenes | **Relativo que se rompe al archivar:** `HU11_MQTT_IDENTITY_HISTORY.md` → `hu11-mqtt-identity-history.md` (misma carpeta). **Externo (registrar):** `eclipse-mosquitto/mosquitto/blob/v2.0.22/plugins/dynamic-security/clients.c`. Sin imágenes. Citado por README BD (línea 18), `inventario-de-archivos.md:214` y #7 |
| 5. Comparación con la página canónica | `funciones-y-flujos.md` ya describe el flujo MQTT completo (reserva → lease → confirmación → habilitación → RPC → evidencia → finalización), los estados de `mqtt_pairing_operation` y el sobre cifrado `mqtt_preparation_secret`. `seguridad-y-permisos.md`: sin aporte. **Superado:** «la función de registro no reserva una identidad antes de emitirla» y la lista de lo que faltaba (reserva, compensación, activación serializada) quedó cubierta por las releases `022`–`032`; «no se almacenan contraseñas… en PostgreSQL» era cierto en su fecha, pero desde `028` se guarda un **sobre cifrado** (sin la clave): no presentarlo como estado actual. **Información única aún válida:** `ENABLED`/`DISABLED` son observaciones del broker, no valores de `devices.mqtt_identity.state` ni estados de pairing; el historial de identidades de la release `011` registra operaciones SQL, no llamadas administrativas al broker. **Solo archivo (backend/broker):** adaptador Mosquitto `prepare`/inspección, `MQTT_IDENTITY_POLICY_MISMATCH`, cifras de pruebas |
| 6. Decisión | **Integrado en documento canónico** (`funciones-y-flujos.md`, sección «Estados MQTT y concurrencia») + **archivado con referencia**. No bloqueado por el PR #5 |
| 7. Copia archivada y secretos | Destino: `99-archivo/base-de-datos/originales/docs/hu11-mqtt-credential-preparation.md`. Sin secretos: describe contraseñas temporales sin mostrarlas; indica que no se tocaron `.env` ni credenciales. Sin redacciones |
| 8. Evidencia y enlaces | Pendiente: PR documental. Actualizar `inventario-de-archivos.md:214` |

**Texto propuesto para integrar (B.5), no aplicar todavía.** Párrafo al final de «Estados MQTT y concurrencia» en `funciones-y-flujos.md`:

> Los estados `ENABLED`/`DISABLED` que observa el administrador del broker no son valores de `devices.mqtt_identity.state` ni estados de pairing. El historial de identidades de la release `011` registra operaciones SQL, no las llamadas administrativas al broker; la evidencia del broker se conserva en los objetos de atestación y revocación posteriores (`029`, `032`). Antecedente: [preparación de credenciales HU11](originales/docs/hu11-mqtt-credential-preparation.md), que describe el estado del 2026-10-15, anterior a la reserva (`022`) y al sobre cifrado (`028`).

---

## #9 — `docs/HU11_MQTT_IDENTITIES.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU11_MQTT_IDENTITIES.md) · SHA-256: `d412c4524627cc7146e93f49cfc0d246f693a5e770e026c8fcdd24f735f1f6ae` · blob: `5517c79ffb1fe2a2ecf162b51921c4281a8d92e5` |
| 2. Fecha, HU, baseline y estado | `71443f2` y `eeef082` (2026-10-15, Kevin). HU11, primer incremento. Rama `11-dev` desde `10-dev` `9b9742b`; backend `a0d4158` (base `63f4bf5`); Mosquitto 2.0.22. Estado: **histórico, superado** el mismo día por el #11 (el propio texto lo indica) |
| 3. Dependencias | `tests/mqtt/mosquitto.conf` (fixture de broker TLS desechable con Dynamic Security, anónimo deshabilitado); backend `scripts/test-mqtt-identity.cjs` |
| 4. Enlaces | **Relativo:** `HU11_MQTT_REVOCATION.md` → `hu11-mqtt-revocation.md`. **Externo (registrar):** backend `commit/a0d41581c7bd2f2bdb9ac289deb5054991214ba7`. Citado por README BD (línea 18) e `inventario-de-archivos.md:215` |
| 5. Comparación | `pruebas-y-verificacion.md` lista baselines MQTT pero no `mosquitto.conf`; `inventario-de-archivos.md:310` la clasifica como soporte. **Superado:** «la identidad aún no tiene registro persistente» (lo crea la release `011_mqtt_revocation`, #11). **Único y válido:** `mosquitto.conf` es una fixture de prueba que no debe incorporarse al Compose productivo; las credenciales de negocio del backend no administran el broker; no conceder capacidad administrativa del broker al rol de ingesta; una revocación solicitada en BD no equivale a revocación aplicada en el broker (ya cubierto por #7). **Solo archivo:** 28 pruebas de broker, 195 unitarias |
| 6. Decisión | **Integrado** (fila en `pruebas-y-verificacion.md`) + **archivado con referencia** |
| 7. Copia y secretos | `originales/docs/hu11-mqtt-identities.md`. Sin secretos (credenciales de prueba aleatorias, no mostradas) |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:215` |

**Texto propuesto (B.5).** Nueva fila en la tabla «Pruebas y auditorías existentes» de `pruebas-y-verificacion.md`:

> \| [mosquitto.conf](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/tests/mqtt/mosquitto.conf) \| Broker Mosquitto TLS desechable con Dynamic Security y acceso anónimo deshabilitado, montado por el runner del backend \| Fixture de prueba: no incorporar al Compose productivo; no prueba Shelly físico. Antecedente: [HU11 identidades](originales/docs/hu11-mqtt-identities.md) \|

---

## #10 — `docs/HU11_MQTT_IDENTITY_HISTORY.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU11_MQTT_IDENTITY_HISTORY.md) · SHA-256: `7a1e65d0c96138da20d52178c1938c9f188ccb452925930f145ccededb33e460` · blob: `c19da3b9c54cefd4b043ca3bc07acc1d260c5413` |
| 2. Fecha, HU, baseline y estado | `06b0eab` (2026-10-15, Kevin). HU11, cuarto incremento. BD `ef84f7e`, backend `35ef316`. Release `011_mqtt_identity_events`, changeset `hu11-mqtt-identity-events-v1` (63 → 64). Estado: **vigente parcial** (contrato de la tabla y del rollback, verificable en SQL) con cifras históricas |
| 3. Dependencias | `releases/011_mqtt_identity_events/` (tabla `devices.mqtt_identity_event`, triggers, guard); `scripts/audit-mqtt-revocation.sql` (nueve filas) |
| 4. Enlaces | Sin enlaces. Citado por README BD (línea 18), `inventario-de-archivos.md:216`, #8 y #12 |
| 5. Comparación | `migraciones-y-rollbacks.md` fila 76 («historial append-only»); `funciones-y-flujos.md` describe los triggers `fn_capture_mqtt_identity_event` y `fn_mqtt_identity_event_append_only`. **Único:** tipos de evento (`REGISTERED`, `REVOKE_REQUESTED`, `ATTEMPT_STARTED`, `RETRY_SCHEDULED`, `REVOKED`, `BASELINE_SNAPSHOT`) en la misma transacción que la identidad; sin secretos ni JSON libre; RLS sin políticas y sin grants a roles de ejecución; guard contra UPDATE/DELETE/TRUNCATE; no protege frente a un DBA; sin retención automática; el rollback exige historial vacío (`MQTT_IDENTITY_HISTORY_ROLLBACK_REQUIRES_EMPTY_HISTORY`); aplicar BD antes que backend. **Verificar en SQL** antes de integrar (comandos al final) |
| 6. Decisión | **Integrado** en `modelo-de-datos.md` (historial) y `migraciones-y-rollbacks.md` (condición de rollback) + **archivado** |
| 7. Copia y secretos | `originales/docs/hu11-mqtt-identity-history.md`. Sin secretos |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:216` |

**Textos propuestos (B.5).** En `modelo-de-datos.md`, al final de «Hogares, dispositivos y ciclo de vida»:

> `devices.mqtt_identity_event` guarda un historial técnico append-only de la identidad MQTT (`REGISTERED`, `REVOKE_REQUESTED`, `ATTEMPT_STARTED`, `RETRY_SCHEDULED`, `REVOKED` y `BASELINE_SNAPSHOT` para identidades anteriores a la release), escrito por trigger en la misma transacción. No contiene secretos ni payloads, no tiene políticas RLS ni grants para los roles de ejecución y un guard rechaza UPDATE, DELETE y TRUNCATE; no protege frente a un administrador capaz de cambiar DDL. No hay retención automática. Antecedente: [historial HU11](originales/docs/hu11-mqtt-identity-history.md).

En `migraciones-y-rollbacks.md`, «Cobertura de rollback»:

> - El rollback de `011_mqtt_identity_events` exige historial vacío y aborta con `MQTT_IDENTITY_HISTORY_ROLLBACK_REQUIRES_EMPTY_HISTORY` si hay eventos u observaciones.

---

## #11 — `docs/HU11_MQTT_REVOCATION.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU11_MQTT_REVOCATION.md) · SHA-256: `02e89c7801db59328fa36c7a57a508fcf6b9a739399b0eeaf1770855e161d3b4` · blob: `dc16e4c396543534fab99f2e8749e02de0c6656b` |
| 2. Fecha, HU, baseline y estado | `eeef082` y `ef84f7e` (2026-10-15, Kevin). HU11, segundo incremento. Base `71443f2`; backend `20eee23`. Release `011_mqtt_revocation`, changeset `hu11-mqtt-identity-durable-revocation-v1` (62 → 63). Estado: **vigente parcial / parcialmente superado** |
| 3. Dependencias | `releases/011_mqtt_revocation/` (`devices.mqtt_identity`, `fn_register_mqtt_identity`, trigger, `fn_claim_mqtt_revocation`, `fn_finish_mqtt_revocation`); roles `smarthome_mqtt_registrar`, `smarthome_mqtt_revoke`; `tests/mqtt/hu10-baseline.yaml` |
| 4. Enlaces | **Relativo:** `HU11_MQTT_REVOCATION_RUNTIME.md` → `hu11-mqtt-revocation-runtime.md`. **Externo (registrar):** backend `commit/20eee233274bf8d89c479fdb44a2679e2a2d157a`. Citado por README BD (línea 18) e `inventario-de-archivos.md:217` |
| 5. Comparación | `seguridad-y-permisos.md` ya describe los roles registrar/revoke; `funciones-y-flujos.md` indica que **SQL032 revoca el EXECUTE directo** de `fn_claim_mqtt_revocation`/`fn_finish_mqtt_revocation`: el contrato de trabajador que describe este documento **ya no es el vigente**. **Único y aún válido:** `REGISTERED` es una referencia registrada, no prueba de posesión ni de conectividad; el trigger pasa la identidad a `REVOKE_PENDING` cuando `devices.device.deleted_at` deja de ser nulo, en la misma transacción y sin llamadas MQTT; la desactivación temporal sin `deleted_at` no revoca; el rollback aborta si hay referencias registradas y conserva los NOLOGIN. **Verificar en SQL** (comandos al final) |
| 6. Decisión | **Integrado** en `seguridad-y-permisos.md` (semántica de identidad/baja) y `migraciones-y-rollbacks.md` (rollback) + **archivado** |
| 7. Copia y secretos | `originales/docs/hu11-mqtt-revocation.md`. Sin secretos (credenciales efímeras de prueba, no mostradas) |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:217` |

**Textos propuestos (B.5).** En `seguridad-y-permisos.md`, tras el párrafo de «objetos MQTT sensibles»:

> En `devices.mqtt_identity`, `REGISTERED` indica una referencia registrada, no posesión ni conectividad comprobada. Cuando `devices.device.deleted_at` deja de ser nulo, un trigger pasa la identidad a `REVOKE_PENDING` en la misma transacción, sin llamar al broker; la desactivación temporal sin `deleted_at` no la revoca. Las funciones de reclamo y finalización de la release `011` ya no son el contrato del trabajador: SQL032 retiró su ejecución directa (ver [funciones](../../10-arquitectura/base-de-datos/funciones-y-flujos.md)). Antecedente: [revocación HU11](originales/docs/hu11-mqtt-revocation.md).

En `migraciones-y-rollbacks.md`, «Cobertura de rollback»:

> - El rollback de `011_mqtt_revocation` aborta si existe alguna identidad registrada; no vaciar la tabla para forzarlo. Con el registro vacío conserva los roles NOLOGIN.

---

## #12 — `docs/HU11_MQTT_REVOCATION_RUNTIME.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU11_MQTT_REVOCATION_RUNTIME.md) · SHA-256: `96f7c8bf3d94342433ac6773ced83a64efaaa069b0d1c860b20db290c258dd8f` · blob: `5b5287bf218b7dbb51077de4b7ba409b1ed582e3` |
| 2. Fecha, HU, baseline y estado | `ef84f7e` y `06b0eab` (2026-10-15, Kevin). HU11, tercer incremento. BD `eeef082`, backend `20eee23`. Sin changesets. Estado: **histórico**; la auditoría pasó de ocho a nueve comprobaciones (#10) |
| 3. Dependencias | `scripts/audit-mqtt-revocation.sql`; rol `smarthome_mqtt_revoke`; variables backend `DATABASE_MQTT_REVOKE_URL`, `DATABASE_MQTT_REVOKE_CA_FILE`, `MQTT_REVOCATION_ENABLED` (solo nombres) |
| 4. Enlaces | **Relativo:** `HU11_MQTT_IDENTITY_HISTORY.md` → `hu11-mqtt-identity-history.md`. Sin externos. Citado por README BD (línea 18) e `inventario-de-archivos.md:218` |
| 5. Comparación | `pruebas-y-verificacion.md` describe la auditoría («aislamiento del LOGIN de revocación… no demuestra revocación real»); `monitoreo-y-salud.md` no menciona el trabajador. **Único:** ejecutar con el LOGIN real del revocador, sin `SET ROLE` ni cuenta migradora; todas las filas `passed=true`; el LOGIN solo hereda `smarthome_mqtt_revoke`; condiciones previas de activación (LOGIN dedicado, auditoría válida, certificados, client ID exclusivo por réplica). **Planes, no ejecución:** comportamiento del trabajador backend (desactivado por defecto, suspende reclamos si falla la auditoría) del 2026-10-15, sin verificación en un entorno. **Contradicción interna:** «ocho filas» frente a nueve tras el #10; usar el número del script vigente |
| 6. Decisión | **Integrado** en `seguridad-y-permisos.md` (procedimiento de auditoría) y `monitoreo-y-salud.md` (pendiente) + **archivado** |
| 7. Copia y secretos | `originales/docs/hu11-mqtt-revocation-runtime.md`. Sin secretos (nombres de variables, sin valores) |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:218` |

**Textos propuestos (B.5).** En `seguridad-y-permisos.md`, a continuación de «Auditoría de conexiones reales» (#3):

> [audit-mqtt-revocation.sql](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/scripts/audit-mqtt-revocation.sql) se ejecuta con el LOGIN real del revocador, sin `SET ROLE` ni cuenta migradora; ese LOGIN solo debe heredar `smarthome_mqtt_revoke` y todas las filas deben devolver `passed=true`. Antes de activar el trabajador se requiere un LOGIN dedicado sin privilegios adicionales, certificados y un client ID exclusivo por réplica. Antecedente: [trabajador de revocación HU11](originales/docs/hu11-mqtt-revocation-runtime.md).

En `monitoreo-y-salud.md`, «Pendientes»:

> No hay monitoreo verificado del trabajador de revocación MQTT. Según el [antecedente HU11](originales/docs/hu11-mqtt-revocation-runtime.md) (2026-10-15), el trabajador del backend está desactivado por defecto y suspende reclamos si falla su auditoría de permisos; no se comprobó en un entorno.

---

## #13 — `docs/HU14_OBSERVABILITY_METRICS.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU14_OBSERVABILITY_METRICS.md) · SHA-256: `322e8eaed46ef5176703eb38c8ba286389d63c97b69c3226fd22009cffb19626` · blob: `771106dc13c829eb69cddddbd8d7356d5cbd0cb3` |
| 2. Fecha, HU, baseline y estado | `418057d` (2026-10-15, Kevin). HU14, rama `14-dev` desde `09-dev`. Solo documental, sin DDL. Estado: **histórico**; la afirmación central (sin impacto en BD) sigue siendo coherente |
| 3. Dependencias | Ninguna en BD |
| 4. Enlaces | Sin enlaces (la guía del backend se cita en texto). Citado por README BD (línea 3) e `inventario-de-archivos.md:219` |
| 5. Comparación | `monitoreo-y-salud.md` ya indica que readiness usa `SELECT 1`. **Único:** HU14 (métricas HTTP y de proceso en `/metrics`) pertenece al backend y no añade consultas, tablas, roles, grants, RLS ni índices; no añadir índices sin evidencia de consultas lentas. Sin contradicciones |
| 6. Decisión | **Integrado** (una frase en `monitoreo-y-salud.md`) + **archivado** |
| 7. Copia y secretos | `originales/docs/hu14-observability-metrics.md`. Sin secretos |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:219` |

**Texto propuesto (B.5).** En `monitoreo-y-salud.md`, «Configuración operativa»:

> Las métricas HTTP y de proceso de HU14 (`/metrics`) se exportan desde el backend y no añaden consultas, tablas, roles ni índices a la base de datos; no crear índices sin evidencia de consultas lentas medidas. Antecedente: [HU14 en la base de datos](originales/docs/hu14-observability-metrics.md).

---

## #14 — `docs/HU16_CONSUMPTION_ACCESS.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU16_CONSUMPTION_ACCESS.md) · SHA-256: `eb91474326bc6039a9b8f6ab02c61345267caaaa0397770c9ca8089982258e77` · blob: `702d9e5665644c18260e00b5d802ddc2b5fbf682` |
| 2. Fecha, HU, baseline y estado | `c23c7f3` (2026-10-14) y `08b88b5` (2026-10-22, renombrado de rol). HU16 / BD-04, BD-05. Rama `16-dev`; backend `bc9d3ec`; depende del puente `07de82f`. Release `016_consumption_access`, changeset `hu16-consumption-detail-access-20261014`; total del ensayo: **64 changesets**. Estado: **vigente parcial**: `fn_can_read_detail` fue redefinida después en la release `018` (según `funciones-y-flujos.md`), por lo que la tabla de contratos de este documento no es la última definición |
| 3. Dependencias | `releases/016_consumption_access/`; `scripts/consumption-access-fixture.sql`; políticas `consumption_app_select_policy`, `consumption_metric_app_select_policy`; backend `scripts/test-consumption-access.ps1` |
| 4. Enlaces | **Relativos que se rompen:** `../releases/016_consumption_access/changelog.yaml` y `../scripts/consumption-access-fixture.sql` → permalinks de BD en `08b88b5`; `HU09_SESSION_SCHEMA_BRIDGE.md` → `hu09-session-schema-bridge.md`. **Externos (registrar):** backend `commit/bc9d3ec`, `blob/bc9d3ec/docs/HU16_CONSUMPTION_ACCESS.md`. Citado por README BD (línea 6), `inventario-de-archivos.md:220`, `hallazgos-y-pendientes.md` (DB10) y #3 |
| 5. Comparación | `seguridad-y-permisos.md` ya resume GUEST/MEMBER/OWNER y consumo básico frente a detalle; `hallazgos-y-pendientes.md` DB10 ya advierte que sus 64 changesets no son el maestro actual. **Único:** OWNER/MEMBER conservan históricos tras desactivar o retirar un dispositivo; excepción histórica para OWNER de un hogar inactivo; el agregado básico no devuelve fila sin autorización y devuelve cero sin lecturas; **el rollback de `016` restaura el acceso detallado de GUEST (retroceso de seguridad)**. **Afirmación de aprobación:** «la responsable aprobó que GUEST consulte únicamente el total»: se conserva como declaración del documento, sin evidencia independiente de aprobación |
| 6. Decisión | **Integrado** en `seguridad-y-permisos.md` y `migraciones-y-rollbacks.md` + **archivado** |
| 7. Copia y secretos | `originales/docs/hu16-consumption-access.md`. Sin secretos (nombra `CONSUMPTION_TEST_DATABASE_URL` sin valor) |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:220` y el enlace de DB10 en `hallazgos-y-pendientes.md` |

**Textos propuestos (B.5).** En `seguridad-y-permisos.md`, «Permisos funcionales efectivos»:

> - OWNER y MEMBER con permiso conservan los históricos de consumo tras desactivar o retirar un dispositivo; se mantiene una excepción para OWNER de un hogar inactivo. El agregado básico no devuelve fila sin autorización y devuelve cero si no hay lecturas. Antecedente: [consumo por rol HU16](originales/docs/hu16-consumption-access.md).

En `migraciones-y-rollbacks.md`, «Cobertura de rollback»:

> - El rollback de `016_consumption_access` restaura el acceso detallado de GUEST del contrato anterior: es un retroceso de seguridad y no debe aplicarse como corrección aislada.

---

## #15 — `docs/HU16_DEVICE_PAIRING_SESSIONS.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU16_DEVICE_PAIRING_SESSIONS.md) · SHA-256: `2215e02a47c259c0b7f41c4853c91d6be4c25fa21e940c99097a0abc882d147a` · blob: `7d881c889597bcc1bb7eb644ab261652e04d9e70` |
| 2. Fecha, HU, baseline y estado | `693dc17` (2026-10-16) y `926c75b` (2026-10-19), Kevin. HU16. Releases `019_device_pairing_sessions` y `020_lan_pairing_method`, rama `16-dev`. Estado: **vigente parcial**: el contrato de persistencia sigue; la sección «Estado frente a requisitos del 18/10/2026» describe la rama `16-dev` (sin `011`), no `dev` |
| 3. Dependencias | `releases/019_device_pairing_sessions/`, `releases/020_lan_pairing_method/`; `devices.fn_claim_pairing_identity`; índice `uq_device_manufacturer_id_ci` |
| 4. Enlaces | Sin enlaces. Citado por README BD (línea 10) e `inventario-de-archivos.md:221` |
| 5. Comparación | `funciones-y-flujos.md` ya describe estados de sesión y AP/BLE/LAN (sin acreditar BLE); `migraciones-y-rollbacks.md` filas 79–80. **Único:** la sesión guarda hashes de `requestId` y token, no contraseña Wi-Fi, credenciales MQTT ni tokens en claro; la release `019` falla antes de crear objetos si hay identificadores de fabricante que solo difieren en mayúsculas; `CONNECTED` debe establecerlo un componente confiable con evidencia del broker, no un reporte de Android; los rollbacks de `019` y `020` se niegan si hay historial de pairing o sesiones `LAN`; `LAN` es coordinación de contrato, no POC completada. **Contradicción de rama:** «el código de esta rama no define `devices.mqtt_identity`» es cierto para `16-dev`, no para `dev`. Persistencia ≠ pairing físico completado (MD §3) |
| 6. Decisión | **Integrado** en `modelo-de-datos.md` y `migraciones-y-rollbacks.md` + **archivado** |
| 7. Copia y secretos | `originales/docs/hu16-device-pairing-sessions.md`. Sin secretos |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:221` |

**Textos propuestos (B.5).** En `modelo-de-datos.md`, «Hogares, dispositivos y ciclo de vida»:

> `devices.device_pairing_session` guarda hashes del `requestId` y del token de sesión, la identidad reportada, el estado y el dispositivo resultante; no guarda la contraseña Wi-Fi, credenciales MQTT ni tokens en claro. `CONNECTED` debe establecerlo un componente confiable con evidencia del broker, no el reporte del teléfono. La persistencia de sesiones no acredita un pairing físico completado; el método `LAN` es coordinación de contrato. Antecedente: [sesiones de vinculación HU16](originales/docs/hu16-device-pairing-sessions.md).

En `migraciones-y-rollbacks.md`, «Cobertura de rollback»:

> - `019_device_pairing_sessions` falla antes de crear objetos si existen identificadores de fabricante que solo difieren en mayúsculas; su rollback se niega si hay historial de pairing. El rollback de `020_lan_pairing_method` se niega si existen sesiones `LAN`; corregir hacia adelante.

---

## #16 — `docs/HU16_PERMISOS_HOGAR.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/HU16_PERMISOS_HOGAR.md) · SHA-256: `4399e06df3ec4e4499e4b2d08852f5d9ff421fad631d3fa887c6eb16b54c8269` · blob: `93c10223a7850b1df313ea8438e722af2c96b6c5` |
| 2. Fecha, HU, baseline y estado | `5d75ba4` (2026-10-16, Kevin). HU16. Release `018_household_permissions`. Estado: **vigente** en lo que coincide con el SQL; «no se aplica a ninguna base activa» es una afirmación de su fecha |
| 3. Dependencias | `releases/018_household_permissions/001_household_permissions.sql` (funciones y `fn_device_control_target`) |
| 4. Enlaces | Sin enlaces (cita `docs/ROLES_Y_PERMISOS.md` del backend en texto). Citado por README BD (línea 8) e `inventario-de-archivos.md:222` |
| 5. Comparación | `seguridad-y-permisos.md` («Permisos funcionales efectivos») y `roles-y-permisos.md` ya recogen bases, overrides, herencia `NULL`, GUEST sin detalle aunque exista excepción y `fn_device_control_target`. **Único:** las membresías existentes reciben, al migrar, valores base equivalentes a su rol. Sin contradicciones con la central |
| 6. Decisión | **Integrado** (una frase en `seguridad-y-permisos.md`, no bloqueada) + **archivado**. `roles-y-permisos.md`: sin cambio de contenido (solo enlace, tras el PR #5) |
| 7. Copia y secretos | `originales/docs/hu16-permisos-hogar.md`. Sin secretos |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:222` |

**Texto propuesto (B.5).** En `seguridad-y-permisos.md`, «Permisos funcionales efectivos»:

> - Al aplicar la release `018`, las membresías MEMBER y GUEST existentes reciben los valores base de su rol. Antecedente: [permisos de hogar HU16](originales/docs/hu16-permisos-hogar.md).

---

## #17 — `docs/ROLES_Y_PERMISOS.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/ROLES_Y_PERMISOS.md) · SHA-256: `1e5a2c35f4e52864c8b09d19fdb0c61a2c79c678eb2a4c94e6b88ecd24d5e319` · blob: `2cdff082405fa4594a0de6195d9843ad756e11ef` |
| 2. Fecha, HU, baseline y estado | `c597a19`, `5d75ba4` (2026-10-16) y `08b88b5` (2026-10-22). Matriz funcional de roles de hogar. Estado: **vigente** en coherencia con el SQL de `018`; aprobación de producto no acreditada |
| 3. Dependencias | `homes.fn_get_member_permissions`, `fn_set_member_permissions`, `fn_get_device_permissions`, `fn_set_device_permissions`; RLS de dispositivos y consumo |
| 4. Enlaces | Sin enlaces. Citado por README BD (línea 14) e `inventario-de-archivos.md:223` |
| 5. Comparación | `roles-y-permisos.md` contiene la matriz canónica única. Se integró la columna de administración (quién administra hogar, miembros, invitaciones y Shelly), la independencia entre consulta y control, y la nota de que las tablas internas no conceden DML directo a `smarthome_runtime_app`. El documento backend enlaza la matriz canónica y conserva las reglas de implementación sin duplicarla. **Sin contradicciones** con la tabla central |
| 6. Decisión | **Integrado** en `roles-y-permisos.md` (una sola matriz) + **archivado** |
| 7. Copia y secretos | `originales/docs/roles-y-permisos.md`. Sin secretos |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:223` |

**Texto integrado en `roles-y-permisos.md`:** se añadió a la tabla la columna de administración del original (OWNER: administra hogar, miembros, invitaciones y dispositivos Shelly; MEMBER y GUEST: no administran), junto con la frase:

> Consultar no concede control y controlar no concede lectura. OWNER gestiona los permisos mediante funciones SQL protegidas; las tablas internas no conceden DML directo a `smarthome_runtime_app`. Antecedente: [matriz de roles de la base de datos](originales/docs/roles-y-permisos.md).

---

## #18 — `docs/deployment/ARCHITECTURE.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/deployment/ARCHITECTURE.md) · SHA-256: `1a45f52677509c1c14b93b339ccfcebfff8eee74b0fb6affe6d45a46efb6ca6f` · blob: `1ae797aa3dff06c585e4681d57d1d27f706cdf3f` |
| 2. Fecha, HU, baseline y estado | `6496b44`, `1385f9d`, `63b511b` (2026-10-22, Kevin). Arquitectura de despliegue **prevista**. Estado: **histórico / no verificado**: describe un plan («Dokploy desplegará… cuando…») |
| 3. Dependencias | `docker-compose.production.yml`, `.github/workflows/ci-deploy.yml`, imágenes GHCR |
| 4. Enlaces | Sin enlaces; contiene un diagrama Mermaid (se conserva en la copia). Citado por `despliegue.md:16`, `copias-de-seguridad.md:30` e `inventario-de-archivos.md:224` |
| 5. Comparación | `despliegue.md` ya resume Compose, Dokploy, GHCR y proxy como plan no verificado. **Único:** solo el frontend tiene dominio público (Traefik → puerto interno 8080, sin puertos publicados); Nginx reenvía `/api/v1/` y Socket.IO al backend por red privada; el Compose no crea PostgreSQL ni volúmenes; pendientes de confirmar (host, base, rol de migración, redes); backups fuera del VPS. **Contraste requerido (MD §4):** el backend DEV ha tenido despliegues verificados en otro contexto; eso **no** certifica la BD productiva. No se obtuvo evidencia actual por componente en esta tarea |
| 6. Decisión | **Integrado** en `despliegue.md` como «Arquitectura prevista (no verificada)» + **archivado** |
| 7. Copia y secretos | `originales/docs/deployment/architecture.md`. Sin secretos ni nombres de host |
| 8. Evidencia | Pendiente. Actualizar `despliegue.md:16`, `copias-de-seguridad.md:30` e `inventario-de-archivos.md:224` |

**Texto propuesto (B.5).** En `despliegue.md`, sustituir el párrafo que enlaza la guía local por:

> ### Arquitectura prevista (no verificada)
>
> El plan registrado el 2026-10-22 prevé desplegar el Compose desde `dev` con Dokploy solo después de auditar la base y probar una restauración. Solo el frontend tendría dominio público (Traefik hacia el puerto interno 8080, sin puertos publicados) y Nginx reenviaría `/api/v1/` y Socket.IO al backend por una red privada. El Compose usa la instancia PostgreSQL existente y no crea servidor ni volúmenes; host, base, rol de migración y redes quedaban por confirmar. Los backups deben guardarse fuera del VPS. Es un plan: no se verificó el estado del VPS ni un despliegue de la base de datos. Antecedente: [arquitectura de despliegue](originales/docs/deployment/architecture.md).

---

## #19 — `docs/deployment/BACKUP_AND_RESTORE.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/deployment/BACKUP_AND_RESTORE.md) · SHA-256: `4641f437f2a53126aac4de6bb90c337c8cbee532541fe0f912210cf1976e9b38` · blob: `f8bd23c1780ccb123f0a024635baa9bb4b38911d` |
| 2. Fecha, HU, baseline y estado | `6496b44`, `1385f9d` (2026-10-22, Kevin). Procedimiento de backup/restauración. Estado: **vigente como procedimiento propuesto**; restaurabilidad **no demostrada** (lo dice el propio texto) |
| 3. Dependencias | Ninguna en el repositorio (usa `pg_dump`, `pg_restore`, `sha256sum` y `$DATABASE_URL` como marcador) |
| 4. Enlaces | Sin enlaces. Citado por `copias-de-seguridad.md:14`, `operacion-y-mantenimiento.md:36`, `evidencias-y-pendientes.md` (E11) e `inventario-de-archivos.md:225` |
| 5. Comparación | `copias-de-seguridad.md` dice que «el procedimiento vive en BACKUP_AND_RESTORE.md… la central lo enlaza para evitar dos comandos divergentes». **Al retirar el original, la central pasa a ser la única fuente**: hay que trasladar el procedimiento. Ya resume preparación y prueba. **Único:** comandos de ejemplo (`pg_dump --format=custom --no-owner`, `pg_restore --list`, `sha256sum`); restauración con `--exit-on-error`, sin `--clean`, nunca contra producción; no eliminar el dump original; detener escrituras y conservar el volumen antes de recuperar. Sin contradicciones; mantener la advertencia de restaurabilidad |
| 6. Decisión | **Integrado en documento canónico** (`copias-de-seguridad.md` reescribe «Fuente canónica» y recibe el procedimiento) + **archivado** |
| 7. Copia y secretos | `originales/docs/deployment/backup-and-restore.md`. Sin secretos: `$DATABASE_URL` es un marcador y pide no guardar contraseñas en el historial |
| 8. Evidencia | Pendiente. Actualizar `copias-de-seguridad.md:14`, `operacion-y-mantenimiento.md:36` e `inventario-de-archivos.md:225`. E11 (evidencias) es permalink fijo: revisar tras el PR #5 |

**Texto propuesto (B.5).** En `copias-de-seguridad.md`, sustituir la sección «Fuente canónica» por:

> ## Procedimiento propuesto
>
> **No hay evidencia de copias automáticas activas ni de una restauración probada.** El VPS llegó a reportar un backup pequeño cuya integridad no se demostró; no usarlo como punto de recuperación.
>
> Identificar instancia, base y usuario de mantenimiento antes de ejecutar `pg_dump`. Guardar el dump fuera del volumen de PostgreSQL y, preferiblemente, fuera del servidor, con permisos restrictivos, registrando fecha, versión, tamaño y checksum. Ejemplo, con la URL tomada del entorno y sin escribir contraseñas en el historial:
>
> ```sh
> pg_dump --format=custom --no-owner --file=smarthome-YYYYMMDDTHHMMSSZ.dump "$DATABASE_URL"
> pg_restore --list smarthome-YYYYMMDDTHHMMSSZ.dump >/dev/null
> sha256sum smarthome-YYYYMMDDTHHMMSSZ.dump
> ```
>
> La prueba de restauración usa una base aislada, nunca producción: `pg_restore --exit-on-error`, sin `--clean`, validando tablas y conteos y conservando el resultado. No eliminar el dump original. Antecedente: [backup y restauración](originales/docs/deployment/backup-and-restore.md).

Y en «Recuperación y pendientes» añadir: «Antes de recuperar, detener escrituras de la aplicación y conservar el volumen original».

---

## #20 — `docs/deployment/CICD.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/deployment/CICD.md) · SHA-256: `32c8d2d81bc4ea7fd98d9acee339b2da70c3a4cbac3d80cf1dabb4733ef6ecbb` · blob: `1585e68b6791bb1c920424587c91cf5a79a8d04a` |
| 2. Fecha, HU, baseline y estado | `6496b44`, `1385f9d` (2026-10-22, Kevin). Estado: **contradictorio**: afirma que el job de deploy está deshabilitado «en los tres workflows», pero el backend no tiene `if: false` (E10, `proceso-de-liberacion.md`) |
| 3. Dependencias | `.github/workflows/ci-deploy.yml` (BD); secretos `DOKPLOY_DEPLOY_WEBHOOK`, `DEPLOYMENT_HEALTH_URL` (solo nombres) |
| 4. Enlaces | Sin enlaces. Citado por `proceso-de-liberacion.md:14`, `evidencias-y-pendientes.md` (E10) e `inventario-de-archivos.md:226` |
| 5. Comparación | `proceso-de-liberacion.md` ya registra la contradicción del gate; `operacion-y-mantenimiento.md` ya dice que el deploy de datos tiene `if: false` y que `concurrency` no coordina repositorios. **Único:** comprobaciones de CI de la BD (Liquibase `validate`, aplicación en PostgreSQL 18 efímero, `status`, validación de Compose; nunca accede al VPS); recomendación de un único workflow coordinador antes de habilitar el gate; recuperación por etiqueta SHA de imagen anterior; el workflow no revierte esquema ni datos. **Verificar** que el `ci-deploy.yml` de BD en `39416a5` mantiene `if: false` (comando al final). **No atribuir deploy a un job deshabilitado** (MD) |
| 6. Decisión | **Integrado** en `proceso-de-liberacion.md` + **archivado** |
| 7. Copia y secretos | `originales/docs/deployment/cicd.md`. Sin secretos (nombres de secretos, sin valores) |
| 8. Evidencia | Pendiente. Actualizar `proceso-de-liberacion.md:14` e `inventario-de-archivos.md:226` |

**Texto propuesto (B.5).** En `proceso-de-liberacion.md`, sustituir la frase que enlaza la guía CI/CD por:

> El CI de datos ejecuta Liquibase `validate`, aplica los changesets en un PostgreSQL 18 efímero de GitHub Actions, ejecuta `status` y valida el Compose; no accede al VPS. Su job de despliegue tiene `if: false`. La guía del 2026-10-22 afirmaba que el gate estaba deshabilitado en los tres repositorios, pero el código lo contradice parcialmente: [backend](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/.github/workflows/ci-deploy.yml) no tiene `if: false` y puede disparar deploy si hay secretos. Esa guía proponía un único workflow coordinador antes de habilitar el gate, recuperar la aplicación con la etiqueta SHA de imagen anterior y recordaba que el workflow no revierte esquema ni datos. Antecedente: [CI/CD](originales/docs/deployment/cicd.md).

(Conservar tal cual los enlaces existentes a backend y web.)

---

## #21 — `docs/deployment/ENVIRONMENT_VARIABLES.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/deployment/ENVIRONMENT_VARIABLES.md) · SHA-256: `83a4d47465844701a77ce0093a9071bf985e0b8b3a7f9f1801a111961afbb3d6` · blob: `f64c7bc6e578490682dcdacbd198a84e2b5b52d6` |
| 2. Fecha, HU, baseline y estado | `6496b44`, `1385f9d`, `75b5474`, `63b511b`, `08b88b5` (2026-10-22, Kevin). Estado: **vigente parcial**: incluye `JWT_REFRESH_SECRET` como requerido, contradicción ya registrada (E06, DB11) |
| 3. Dependencias | `.env.production.example`, `docker-compose.production.yml` (servicio `runtime-roles`), `scripts/provision-runtime-roles.sql` |
| 4. Enlaces | Sin enlaces. Citado por #22, `inventario-de-archivos.md:227` |
| 5. Comparación | `variables-de-entorno.md` ya lista las variables «Datos/producción» y la discrepancia de `JWT_REFRESH_SECRET`. **Único:** `DATABASE_URL` corresponde al LOGIN `smarthome_app_login` (miembro de `smarthome_runtime_app`) y `DATABASE_IOT_URL` a `smarthome_ingest_login` (miembro de `smarthome_ingest`); `APP_DB_PASSWORD`/`IOT_DB_PASSWORD` distintas; los marcadores de `.env.production.example` son ficticios; codificar caracteres reservados en contraseñas de URL; ningún secreto en `VITE_*`; `TRUSTED_PROXY_CIDRS` vacío ignora cabeceras reenviadas; `MQTT_TLS_CA_FILE` vacío usa las CA del sistema; verificar los dos LOGIN antes del primer despliegue. **Sin valores ni secretos** |
| 6. Decisión | **Integrado** en `variables-de-entorno.md` + **archivado** |
| 7. Copia y secretos | `originales/docs/deployment/environment-variables.md`. Sin secretos: solo nombres y descripciones |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:227` |

**Texto propuesto (B.5).** En `variables-de-entorno.md`, tras la tabla:

> En el Compose productivo de datos, `DATABASE_URL` corresponde al LOGIN `smarthome_app_login` (miembro de `smarthome_runtime_app`) y `DATABASE_IOT_URL` a `smarthome_ingest_login` (miembro de `smarthome_ingest`); el servicio `runtime-roles` los provisiona con `APP_DB_PASSWORD` e `IOT_DB_PASSWORD`, que deben ser distintas. Verificar que ambos LOGIN existen con los permisos correctos antes del primer despliegue. Los valores de `.env.production.example` son marcadores ficticios: no copiarlos. Codificar los caracteres reservados de las contraseñas dentro de las URL y no poner secretos en variables `VITE_*`, que se publican en el navegador. `TRUSTED_PROXY_CIDRS` vacío ignora las cabeceras de IP reenviadas, y `MQTT_TLS_CA_FILE` vacío usa las CA del sistema. Antecedente: [variables de producción](originales/docs/deployment/environment-variables.md).

---

## #22 — `docs/deployment/HOSTINGER_DEPLOYMENT.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/deployment/HOSTINGER_DEPLOYMENT.md) · SHA-256: `e583545888bae5a2b06e562c086292c60d849c2f3cc005d3ef562caa027d7981` · blob: `6df36bc94383bdbaf16518962887589255e19446` |
| 2. Fecha, HU, baseline y estado | `6496b44`, `1385f9d` (2026-10-22, Kevin). Estado: **histórico / desactualizado** (MD §3 fila 22 y §4): describe que SSH no autenticaba y que no debía conectarse Dokploy; no presentarlo como despliegue ejecutado ni como estado actual |
| 3. Dependencias | `docker-compose.production.yml`, variables del #21 |
| 4. Enlaces | **Relativo:** `ENVIRONMENT_VARIABLES.md` → `environment-variables.md` (misma carpeta `deployment/`). Citado por `inventario-de-archivos.md:228` |
| 5. Comparación | `despliegue.md` ya incluye una lista de preparación similar. **Único:** los cinco pasos de auditoría previa (servicios, PostgreSQL y `databasechangelog`, `pg_dump` fuera del VPS y restauración aislada, comparación de changesets pendientes, sin cambios destructivos); revisar «Preview Compose» antes de desplegar. **Contradicción:** afirma «PostgreSQL 18 que ya existe»; la auditoría de roles exige PostgreSQL 16 (ver #3): pendiente de confirmar, no resolver aquí. **Información operativa:** sistema operativo del VPS y uso de Dokploy/Hostinger; sin IP, dominio, usuarios ni claves |
| 6. Decisión | **Integrado** (pasos de auditoría en `despliegue.md`) + **archivado** |
| 7. Copia y secretos | `originales/docs/deployment/hostinger-deployment.md`. Sin secretos. **Para revisión:** confirmar con la persona responsable que publicar el SO del VPS y el proveedor no es sensible; no se redacta nada |
| 8. Evidencia | Pendiente. Actualizar `inventario-de-archivos.md:228` |

**Texto propuesto (B.5).** En `despliegue.md`, «Preparación antes de ejecutar»:

> La auditoría previa propuesta el 2026-10-22 incluye: inventariar servicios, contenedores, redes y volúmenes sin tocar los directorios internos de Dokploy; identificar host, base, usuarios, red, `databasechangelog` y último changeset aplicado; crear un `pg_dump` completo fuera del servidor y restaurarlo en una instancia aislada; comparar los changesets pendientes con esa copia y no ejecutar cambios destructivos mientras haya dudas sobre el historial; y revisar «Preview Compose» antes de desplegar. Ese documento describía un acceso SSH aún no autenticado y un proyecto Dokploy sin crear; ese estado no se verificó en esta revisión. Antecedente: [Hostinger y Dokploy](originales/docs/deployment/hostinger-deployment.md).

---

## #23 — `docs/deployment/TROUBLESHOOTING.md`

| Punto | Registro |
| --- | --- |
| 1. Ruta, commit y SHA | [permalink](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/deployment/TROUBLESHOOTING.md) · SHA-256: `461fb4c305a8f3889dd750d58acff48a01879a7ab2d5465de6ae6bddaa80b470` · blob: `3ec9ad9e79d3465944f71b620cf70b983c01ec82` |
| 2. Fecha, HU, baseline y estado | `6496b44` (2026-10-22, Kevin). Estado: **contradictorio en parte**: pide logs del servicio `postgres`, ausente del Compose productivo, y presupone EMQX (DB06) |
| 3. Dependencias | `docker-compose.production.yml` |
| 4. Enlaces | Sin enlaces. Citado por `operacion-y-mantenimiento.md:60`, `hallazgos-y-pendientes.md` (DB06) e `inventario-de-archivos.md:229` |
| 5. Comparación | `solucion-de-problemas.md` cubre síntomas de backend, MQTT y realtime, pero no de Compose, Liquibase, 502 ni TLS del dominio. **Único y compatible:** Compose no inicia (variables en Dokploy, acceso a GHCR, no imprimir el entorno completo); Liquibase falla (permisos del migrador, `POSTGRES_DB`, `DATABASECHANGELOG` y checksums; **no borrar volúmenes, no `clear-checksums`, no marcar cambios ejecutados**); frontend 502 (backend sano, red de Nginx, `/api/v1/`, dominio hacia `frontend:8080`); dominio sin TLS (DNS, puertos 80/443, logs de Traefik; un cambio de dominio requiere redeploy). **Excluir:** el comando de logs con `postgres` y la suposición de EMQX. **Comandos peligrosos:** ninguno destructivo; el documento prohíbe los peligrosos |
| 6. Decisión | **Integrado** en `solucion-de-problemas.md` + **archivado** |
| 7. Copia y secretos | `originales/docs/deployment/troubleshooting.md`. Sin secretos |
| 8. Evidencia | Pendiente. Actualizar `operacion-y-mantenimiento.md:60`, el enlace de DB06 e `inventario-de-archivos.md:229` |

**Texto propuesto (B.5).** Nuevas filas en la tabla de `solucion-de-problemas.md`:

> \| Compose de producción no inicia \| Variables requeridas en Dokploy y acceso a GHCR; no imprimir el entorno completo al compartir logs. El Compose no incluye un servicio `postgres` \| [Despliegue](../../40-operacion/despliegue.md) \|
> \| Liquibase falla \| Permisos del migrador, `POSTGRES_DB`, `DATABASECHANGELOG` y checksums; no borrar volúmenes, no usar `clear-checksums` ni marcar cambios como ejecutados sin revisar el SQL \| [Migraciones](../../10-arquitectura/base-de-datos/migraciones-y-rollbacks.md) \|
> \| Frontend responde 502 \| Backend sano, red compartida con Nginx, ruta `/api/v1/` y dominio apuntando a `frontend:8080` \| [Despliegue](../../40-operacion/despliegue.md) \|
> \| Dominio sin TLS o sin respuesta \| DNS A/AAAA, puertos 80/443, dominio en Dokploy y logs de Traefik; un cambio de dominio requiere redeploy \| [Despliegue](../../40-operacion/despliegue.md) \|

Y bajo la tabla: «Procedimientos tomados de la [guía de 2026-10-22](originales/docs/deployment/troubleshooting.md), excluyendo el comando de logs de `postgres` y la suposición de un broker concreto (DB06)».

---

## Verificaciones en SQL pendientes antes de integrar (B.5)

Ejecutar en `smarthome-database` (solo lectura):

```powershell
git grep -n -E "BASELINE_SNAPSHOT|REQUIRES_EMPTY_HISTORY|lock_timeout" -- releases/011_mqtt_identity_events
git grep -n -E "REVOKE_PENDING|deleted_at" -- releases/011_mqtt_revocation/mqtt-revocation.sql | Select-Object -First 8
git grep -n -E "REVOKE .*fn_(claim|finish)_mqtt_revocation" -- releases/032_mqtt_pairing_revocation
git grep -n "uq_device_manufacturer_id_ci" -- releases | Select-Object -First 3
git grep -n "if: false" -- .github/workflows/
```

## Resumen de decisiones y bloqueos

| # | Decisión | Página(s) destino | ¿Bloqueado por PR #5? |
| ---: | --- | --- | --- |
| 1 | Integrado + archivado | operacion-y-mantenimiento | No |
| 2 | Archivado + antecedente | pruebas-y-verificacion | No |
| 3 | Integrado + archivado | seguridad-y-permisos | No |
| 4 | Integrado + archivado | modelo-de-datos | No |
| 5 | Integrado + archivado | migraciones-y-rollbacks | No |
| 6 | Integrado + archivado | contrato-mqtt | No |
| 7 | Integrado + pendiente + archivado | contrato-mqtt, evidencias E17 | No |
| 8 | Integrado + archivado | funciones-y-flujos | No |
| 9 | Integrado + archivado | pruebas-y-verificacion | No |
| 10 | Integrado + archivado | modelo-de-datos, migraciones-y-rollbacks | No |
| 11 | Integrado + archivado | seguridad-y-permisos, migraciones-y-rollbacks | No |
| 12 | Integrado + archivado | seguridad-y-permisos, monitoreo-y-salud | No |
| 13 | Integrado + archivado | monitoreo-y-salud | No |
| 14 | Integrado + archivado | seguridad-y-permisos, migraciones-y-rollbacks | No |
| 15 | Integrado + archivado | modelo-de-datos, migraciones-y-rollbacks | No |
| 16 | Integrado + archivado | seguridad-y-permisos | No |
| 17 | Integrado + archivado | roles-y-permisos | No |
| 18 | Integrado + archivado | despliegue | No |
| 19 | Integrado + archivado | copias-de-seguridad | No |
| 20 | Integrado + archivado | proceso-de-liberacion | No |
| 21 | Integrado + archivado | variables-de-entorno | No |
| 22 | Integrado + archivado | despliegue | No |
| 23 | Integrado + archivado | solucion-de-problemas | No |

Además, en B.6: `inventario-de-archivos.md` (23 filas), `hallazgos-y-pendientes.md` (DB06, DB10), `operacion-y-mantenimiento.md` (líneas 32, 36, 60), `README.md` de `10-arquitectura/base-de-datos` (índice), `99-archivo/README.md` (bloqueado por PR #5) y `scripts/source-references.json` (enlaces externos nuevos).
