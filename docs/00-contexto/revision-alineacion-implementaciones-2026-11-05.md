---
title: Revisión de alineación de implementaciones
status: borrador
owner: arquitectura
last_reviewed: 2026-11-05
canonical_for:
  - revision-alineacion-implementaciones-2026-11-05
---

# Revisión de alineación de implementaciones

## Alcance y evidencia

Revisión estática de las ramas `dev` indicadas a continuación. Las conclusiones describen archivos versionados; no demuestran que una API, una migración, un broker, una aplicación o un despliegue estén operativos. No se ejecutaron aplicaciones, pruebas, SQL ni workflows.

| Componente | Rama y corte revisado | Cambio frente a la referencia documental anterior |
| --- | --- | --- |
| Backend | `dev`, `60297c361e4acac6e98161337ef8e149e069d441` | 44 commits; módulo de energía, ingesta Flespi con deduplicación/orden durable y workflows DEV de validación. |
| Base de datos | `dev`, `3b20c9177a9aabfcc285043a6d85048bb1b95b7a` | 11 commits; releases SQL035–SQL037, cambios de operación y CI. |
| Web | `dev`, `7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac` | 11 commits; pantallas de energía y cliente REST correspondiente; política CI de promoción `dev -> qa -> main`. |
| Móvil | `dev`, `6b5fe36655eb9048aa4054a914ec245810d58893` | Se pudo leer la metadata de la rama, pero no los archivos del código en esta revisión. La última evidencia de archivos disponible en esta central sigue en `bb87f62c0727f22f376e56632c22bea66128a04a`. |

El checkout documental empezó limpio en `main` (`e1168c8d76bd22e5593651e215262afe38bb2a25`) y su referencia local `origin/main` apunta a `c9054ab3c40d2f91fde1d42b26a13bf60cd8462c`, 21 commits adelante. El avance fast-forward no pudo actualizar `.git/ORIG_HEAD` por permisos del entorno. Las notas de esta revisión se escriben sobre el checkout disponible; la rama local queda pendiente de sincronización.

El conector de GitHub devolvió `Unknown tool` al leer archivos de `from_movil`, y el acceso Git por red está bloqueado en este entorno. Se conservan los datos móviles ya documentados como último corte verificable; no se infiere que sigan iguales ni que la aplicación consuma los nuevos endpoints de energía.

## Backend

Fuente: [código backend en `60297c3`](https://github.com/nataliachala1/smarthome-backend/tree/60297c361e4acac6e98161337ef8e149e069d441).

| Discrepancia | Fuente de verdad | Cambio concreto en esta documentación |
| --- | --- | --- |
| El contrato REST anterior fijaba 71 handlers en el corte `1cbaca2` y no recogía energía. El código actual declara seis rutas nuevas: resumen, historial y tarifa vigente, alta de tarifa, lectura y escritura de meta mensual. | Controladores [summary](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/energy/presentation/controllers/home-energy-summary.controller.ts), [tariffs](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/energy/presentation/controllers/home-energy-tariffs.controller.ts) y [goals](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/energy/presentation/controllers/home-energy-goals.controller.ts). | Se añade el [contrato REST de energía](../20-contratos/api-rest/energia.md) y se corrige el recuento estático a 77 handlers: 73 ordinarios, incluidos `/health` y `/health/ready`, y cuatro MQTT condicionales. `GET /` continúa excluido porque el controlador raíz no se registra. |
| La documentación de SQL034 decía que persistía tarifas/metas, pero que la API no estaba implementada. | `EnergyModule` está registrado en [AppModule](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/app.module.ts); los controladores anteriores describen la interfaz. | Se actualizan el modelo y el contrato: la API existe en el código revisado. No se presenta como facturación ni como verificación de despliegue. |
| La afirmación anterior de que todo flujo MQTT separa actualización de estado y consumo ya no describe la ruta Flespi. | [Suscriptor MQTT](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/mqtt-device-status.subscriber.ts), [contrato de topics](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/mqtt-topic-contract.ts) e [identidad de evento](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/flespi-shelly-event-key.ts). | Se distingue Mosquitto histórico de Flespi DEV. En Flespi, una transacción bloquea el dispositivo, descarta eventos duplicados o antiguos, actualiza estado y persiste consumo; `device.status.updated` y `consumption.created` salen después del commit. Las alertas/estadísticas siguen delegadas a un worker pendiente. |
| El catálogo ambiental anterior no describía el proveedor Flespi ni todas sus condiciones. | [Configuración MQTT](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/config/mqtt-config.ts), [worker de reconciliación](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/devices/infrastructure/messaging/flespi-shelly-state-sync.worker.ts) y [.env.example](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/.env.example). | Se documenta `MQTT_BROKER_PROVIDER` (`mosquitto` por defecto; `flespi` solo en VPS DEV con TLS, `MQTT_FLESPI_DEVICE_ID` y token en `MQTT_USERNAME`). Se registran conexiones de rol, administración DynSec, claves de cifrado y variables de reconciliación. `MQTT_FLESPI_DEVICE_ID` y los flags `SHELLY_FLESPI_STATE_SYNC_*` son consumidores de runtime que faltan en `.env.example`. |
| La evidencia E10 describía un webhook de despliegue posible desde el workflow del backend. | El workflow antiguo fue retirado; los actuales son [CI DEV](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/.github/workflows/ci-dev.yml) y [validación de PR](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/.github/workflows/pr-validate-dev.yml). | Se corrige la descripción: esos workflows validan sin desplegar, publicar imágenes, usar secretos ni conectarse al VPS. No se deduce estado de otros workflows o despliegues externos. |
| La referencia técnica de octubre seguía anclada a `1cbaca2`. | [Paquete](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/package.json) y rama actual `dev`. | Se conserva `1cbaca2` como base histórica y se agrega este corte. `package.json` mantiene versión `0.0.1` y las dependencias declaradas no cambiaron entre los dos cortes comparados. |

## Base de datos

Fuente: [código de base de datos en `3b20c91`](https://github.com/nataliachala1/smarthome-database/tree/3b20c9177a9aabfcc285043a6d85048bb1b95b7a).

| Discrepancia | Fuente de verdad | Cambio concreto en esta documentación |
| --- | --- | --- |
| El inventario anterior termina en SQL034, con 96 changesets, 42 changelogs, 33 tablas y 295 columnas. | [Changelog maestro](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/changelog/changelog-master.yaml) y [SQL035](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/035_flespi_mqtt_ingest_idempotency/001_mqtt_ingest_dedup.sql), [SQL036](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/036_flespi_mqtt_event_order/001_flespi_event_order.sql) y [SQL037](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/037_mqtt_lease_quarantine_least_privilege/001_mqtt_lease_quarantine_least_privilege.sql). | Se actualiza el recorrido a 99 changesets/45 changelogs. El incremento estático es una tabla y seis columnas: `consumption.mqtt_ingest_dedup` con FK dispositivo/hogar, `event_key`, topic, timestamp de origen y recepción. El inventario JSON existente se mantiene identificado como snapshot `6caed6b`, no como catálogo actual. |
| La arquitectura previa no representaba deduplicación durable ni orden de eventos Shelly. | SQL035 crea PK `(id_device,event_key)`, RLS y permisos de ingesta; SQL036 permite leer `device_event_ts` e indexa `(id_device,device_event_ts DESC)`. | Se documenta ledger idempotente y rechazo de timestamps duplicados/antiguos; no es una tabla de lecturas ni sustituye `consumption.consumption`. |
| La documentación histórica describía el Compose de producción como si preparara una instalación completa. | [Compose de producción actual](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.production.yml) contiene solo Liquibase en perfil `database-inspection`, con volumen de solo lectura y comando `validate`. | Se corrige operación: no crea PostgreSQL, usuarios, backend, red ni volumen, y no ejecuta `update`. El Compose local conserva PostgreSQL 16 Alpine y Mosquitto; la CI usa PostgreSQL 18 Alpine desechable. |
| E10 afirmaba que el gate de DB estaba deshabilitado. | [CI DEV de base de datos](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/.github/workflows/ci-dev.yml). | Se registra validación y aplicación a una base desechable en CI, auditoría de roles/RLS y validación de sintaxis Compose. No equivale a despliegue productivo ni a restauración probada. |
| La revisión anterior anotaba dos changesets sin rollback y 93 con rollback SQL. | Changelogs de SQL035–037 y archivos de reversión versionados. | Se actualiza el balance estático a 95 rollbacks SQL, un rollback inline y tres changesets sin rollback (030, 031 y 037). |

## Frontend web

Fuente: [código web en `7b9acdf`](https://github.com/nataliachala1/smarthome-frontend-web/tree/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac).

| Discrepancia | Fuente de verdad | Cambio concreto en esta documentación |
| --- | --- | --- |
| La documentación web de octubre no incluía consumo planificado. | [API de energía](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/src/shared/api/energy.api.ts) y `web/src/features/consumption/HomeEnergySection.tsx`. | Se documenta la sección de energía de Consumo y sus seis operaciones REST. Los tipos conservan decimales monetarios/energéticos como strings; no se convierten al contrato JSON en `number`. |
| La ficha de versión anterior no distinguía cambios funcionales de cambios de entorno. | [package.json](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/package.json) y [.env.example](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/.env.example). | React/TypeScript/Vite y las dependencias declaradas no cambiaron frente al corte `8dad6e1`; tampoco cambiaron las variables VITE. El comando `test:contracts` sí perdió el flag `--test`. |
| El workflow previo solo describía validación y un deploy deshabilitado. | [CI web actual](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/.github/workflows/ci-deploy.yml). | Se documenta la regla de PR `dev -> qa -> main`, validación/build en ramas del flujo, publicación de imagen solo al hacer push a `main` en el repositorio upstream y deploy con `if: false`. No se afirma que la imagen o el sitio estén desplegados. |

## Aplicación móvil

El último código que esta central pudo contrastar sigue siendo el commit `bb87f62`; allí constan React Native 0.86, Expo 57, Expo Router, TypeScript 6, `EXPO_PUBLIC_API_URL`, Bearer y refresh por cookie, además del servicio Realtime y pairing. La metadata posterior apunta a `6b5fe36655eb9048aa4054a914ec245810d58893`, cuyo mensaje indica evidencia de auditoría de dependencias, pero el cuerpo del commit y los archivos actuales no fueron accesibles desde las herramientas disponibles.

Acción documental pendiente: volver a contrastar `package.json`, `app.config.js`, cliente HTTP, cliente Realtime, `pairing-service.ts` y flujos de energía con ese commit. Hasta entonces, conservar los valores anteriores solo como último corte conocido y etiquetarlos con `bb87f62`; no afirmar que móvil implementa las rutas nuevas ni que sus dependencias siguen iguales.

## Flujos entre componentes confirmados

1. Web ejecuta el contrato `energy.api.ts` contra el cliente HTTP común y `/api/v1`; el backend valida JWT, hogar y permisos.
2. El backend obtiene lecturas/tarifas/metas mediante Prisma y SQL del esquema PostgreSQL. `home_energy_tariff` y `home_energy_goal` pertenecen a SQL034; la nueva tabla `mqtt_ingest_dedup` pertenece a SQL035.
3. En el modo Flespi opt-in de DEV, el backend consume los topics Shelly configurados, valida y ordena eventos de origen, registra idempotencia y persiste estado/consumo en la misma transacción.
4. Tras un commit correcto, el backend emite `consumption.created` y `device.status.updated` por Socket.IO a destinatarios resueltos por hogar. Web y, según el último corte conocido, móvil consumen Realtime del backend; no hay evidencia de conexión MQTT directa de esos clientes.

## Pendientes y límites

- Sin OpenAPI generado ni solicitudes de integración ejecutadas en este corte.
- Sin acceso al contenido actual de `from_movil`; sus versiones y compatibilidad requieren una nueva lectura.
- No se verificaron credenciales, servicios reales, reglas del broker, estado de migraciones aplicadas, imágenes ni despliegues.
- El checkout de documentación sigue 21 commits detrás de `origin/main`; se requiere sincronización del repositorio cuando el entorno permita escribir su metadata Git.
