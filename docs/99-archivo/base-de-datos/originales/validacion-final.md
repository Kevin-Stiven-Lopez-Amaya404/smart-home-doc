---
title: "Validación final del baseline Smart Home (archivado)"
status: obsoleto
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - archivo-bd-validacion-final
---

# Validación final del baseline Smart Home

> **Estado documental:** obsoleto (histórico/no canónico). Estado del punto 2: histórico.
>
> **Origen:** [VALIDACION_FINAL.md](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/VALIDACION_FINAL.md), ruta original `VALIDACION_FINAL.md`, SHA-256 `3c3633354c3ea34bcea72fc91a26ceb7436a956cca9103bee4a6fc1d6ae17e24`, blob `8625dd5a10bf52a096fd39fec9ac3c175b7ec1a9`.
>
> **Sustituto:** [pruebas-y-verificacion](../../../10-arquitectura/base-de-datos/pruebas-y-verificacion.md).
>
> El contenido se conserva sin cambios, salvo los enlaces relativos indicados en el punto 4 de la ficha. El original se retirará del repositorio de base de datos solo tras fusionar este PR.

> Documento histórico del baseline anterior al 8 de septiembre de 2026. Para el modelo vigente hogar → dispositivo y las validaciones de esta entrega, consultar [la validación vigente](https://github.com/nataliachala1/smarthome-database/blob/08b88b5/README.md).

## Estado

Este paquete fue reconstruido a partir de la carpeta nueva entregada y depurado para eliminar restos del modelo anterior y conflictos de merge.

### Corregido

- `sync.synchronization` y la cola offline fueron retiradas; `sync.backup` conserva solo metadata.
- Se retiraron del baseline las views, materialized views y stored procedures heredadas que referenciaban tablas/columnas obsoletas.
- Se conservaron únicamente triggers técnicos de `updated_at`.
- Se reconstruyeron los índices con nombres y columnas del modelo vigente.
- Se corrigieron todas las rutas de changelog y rollback activas.
- Todos los changeSets activos tienen rollback y IDs únicos con formato UUID.
- Se corrigió la escalación de rol global: `smarthome_runtime_app` no puede insertar ni actualizar `auth."user".id_role`; el rol por defecto es `USER`.
- `auth."user"` usa email único case-insensitive, bloqueo temporal, soft deactivation y hash de contraseña.
- Se añadieron `voltage_v`, `current_a`, `frequency_hz` y `temperature_c` a las lecturas de consumo.
- Se reforzó integridad HOME -> ZONE -> DEVICE y DEVICE -> HOME en consumo/notificaciones.
- Se corrigió el modelo `alert_rule -> alert -> notification`.
- Las funciones RLS `SECURITY DEFINER` mantienen `search_path` controlado y `EXECUTE` se concede de forma centralizada.
- Se eliminó `FORCE ROW LEVEL SECURITY` para evitar recursión/denegación en helpers `SECURITY DEFINER`; los roles funcionales siguen siendo `NOBYPASSRLS`.
- Se corrigieron Docker Compose, `.env.example`, `liquibase.properties` y scripts de Windows.
- TCL permanece fuera del changelog master; las transacciones de negocio pertenecen a NestJS + Prisma.

## Validaciones estáticas ejecutadas

- Todos los YAML cargan correctamente.
- No existen referencias de `include` o `sqlFile` rotas.
- Todos los 60 changeSets activos tienen rollback.
- No existen IDs de changeSet duplicados en el baseline activo.
- No quedan marcadores `<<<<<<<`, `=======`, `>>>>>>>`.
- No quedan referencias activas a `configuration_user`, `sync.synchronization`, `threshold_rule`, `user_role`, `auth.session`, `token_blacklist`, `device_status_history` ni otros objetos retirados.
- Todas las funciones invocadas por las policies RLS existen.
- Las firmas de funciones concedidas/revocadas coinciden con sus definiciones.
- Los GRANT por columnas y los triggers `updated_at` referencian columnas existentes.

## Validación de ejecución pendiente

La validación estática no sustituye una ejecución real de PostgreSQL/Liquibase. En una base limpia ejecutar:

```powershell
Copy-Item .env.example .env
# Cambiar POSTGRES_PASSWORD en .env

docker compose up -d postgres
docker compose run --rm liquibase --defaults-file=liquibase.properties validate
docker compose run --rm liquibase --defaults-file=liquibase.properties update-sql
docker compose run --rm liquibase --defaults-file=liquibase.properties update
docker compose run --rm liquibase --defaults-file=liquibase.properties history
```

Después deben ejecutarse pruebas funcionales RLS con conexiones miembros de `smarthome_runtime_app`, `smarthome_ingest` y `smarthome_worker`, y una prueba de rollback sobre una base de prueba sin datos operacionales.

## Nota de particiones

`consumption.consumption_default` funciona como red de seguridad. Antes de habilitar la ingesta, el worker debe ejecutar:

```sql
SELECT consumption.fn_ensure_consumption_partitions(2);
```

La creación de particiones no se programa como parche mensual de Liquibase.
