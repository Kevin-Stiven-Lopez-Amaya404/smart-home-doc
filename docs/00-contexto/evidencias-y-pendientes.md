---
title: Evidencias, discrepancias y pendientes
status: borrador
owner: documentacion
last_reviewed: 2026-11-05
canonical_for:
  - registro-evidencias
---

# Evidencias, discrepancias y pendientes

## Método y límites

Revisión estática del 2026-10-29. Se comprobó identidad, remoto, rama, historial y estado limpio inicial de smart-home-doc; solo existía README.md. Se enumeraron árboles completos de cuatro implementaciones y se leyeron código/configuraciones pertinentes. La referencia individual previa del backend cubre sus 250 archivos de producción y otras fuentes indicadas allí.

El backend local está en 13-dev con modificaciones previas; no se alteró. El repositorio plural se consultó únicamente como antecedente externo. Las ramas docs/* y sus archivos se leyeron desde Git, no desde PR.

La revisión no compiló ni ejecutó aplicaciones, migraciones, suites, brokers o dispositivos; no inspeccionó secretos ni estado real de infraestructura. No se deduce éxito operativo de archivos existentes.

## Registro de diferencias

### E01 — Identidad documental

**Resuelto para el destino:** el usuario confirmó smart-home-doc, en singular. main inicial: dfe55be09e1a3237cc75490569969eff6b7c9586. smart-home-docs sigue siendo otro repositorio. Sus 22 archivos de ramas temáticas se [inventariaron](inventario-documental.md), sin traslado.

### E02 — SRS y renovación de sesión

**Pendiente de acuerdo de producto:** el SRS externo menciona eliminar refresh tokens o no requerirlos; el backend implementa renovación con token opaco y los clientes llaman /auth/refresh. No se eliminó ese comportamiento para coincidir con el borrador. Fuentes: [SRS en inventario](inventario-documental.md), [contrato REST](../20-contratos/api-rest/README.md), [consumidor móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/api/api-client.ts).

### E03 — Formato y duplicados de antecedentes

**Verificado, tratamiento pendiente:** el SRS .md realmente es DOCX. Dos variantes de despliegue comparten blob Git; una tercera tiene el mismo texto extraído, sin afirmar igualdad visual. Versiones y codificación requieren revisión. No se eliminó ni renombró nada. Evidencia: [inventario y hashes](inventario-documental.md).

### E04 — Aprobación no acreditada

**Pendiente de autoridad:** políticas/condiciones externas incluyen tanto borradores como etiquetas de aprobación. No se encontró evidencia independiente para adoptarlas como normas. Las historias, diseños, controles y artículo no se convirtieron en decisiones aceptadas. Fuentes: [antecedentes](inventario-documental.md), [ADR](../50-decisiones/README.md).

### E05 — Alertas y transacciones MQTT

**Pendiente de reconciliación documental:** [contrato local MQTT](../99-archivo/backend/mqtt-contract-2026-10-15.md) describe evaluación de anomalías, actualización de métricas y emisión de alertas en un flujo transaccional. El análisis del suscriptor identifica helpers sin llamadas, notifications vacío y actualización de estado fuera de la transacción de consumo. No se afirma generación automática activa. Fuente de código y detalle: [referencia backend](../10-arquitectura/backend/referencia-tecnica.md). El 2026-11-03 la divergencia quedó registrada en la [conciliación del contrato MQTT](../20-contratos/mqtt/contrato-mqtt.md#conciliación-con-el-contrato-local-del-backend); sigue pendiente confirmarla con firmware y broker.

### E06 — Variables de refresh y despliegue

**Actualización:** `JWT_REFRESH_SECRET` y `JWT_REFRESH_EXPIRES_IN` siguen en el ejemplo backend y no determinan el refresh opaco actual. El Compose actual de base de datos ya no requiere esas variables: ejecuta Liquibase `validate` contra PostgreSQL existente y no configura el backend. Revisar el entorno real del backend por separado antes de desplegar. Fuentes: [catálogo](../40-operacion/variables-de-entorno.md), [Compose productivo actual](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/docker-compose.production.yml).

### E07 — Permisos HTTP/SQL frente a realtime

**Riesgo pendiente de prueba:** las funciones SQL de detalle contemplan permisos por dispositivo; destinatarios MQTT y RealtimeAccessService no expresan los mismos filtros. Revisar MEMBER con consumo denegado. No se afirma explotación confirmada. Fuentes: [roles y referencias concretas](../60-producto-procesos/roles-y-permisos.md).

### E08 — Pairing y guía móvil

**Pendiente de sincronización:** [guía móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/BACKEND_CONNECTION.md) describe límites que no reflejan todo [pairing-service.ts](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/services/pairing-service.ts). El backend mantiene provisión legada bloqueada y nuevas rutas condicionales. Revisar perfil y flujo antes de declarar disponibilidad productiva.

### E09 — Prototipo de autenticación móvil

**Pendiente de retiro/consolidación:** [guía de flujo](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/FLUJO_USUARIO.md) contiene OTP y ejemplos demo; el contrato actual utiliza enlaces/token. No se copiaron sus credenciales de muestra ni se declararon válidos sus recorridos.

### E10 — Gate de despliegue contradictorio

**Actualización al 2026-11-05:** el workflow backend `ci-deploy.yml` fue retirado y `ci-dev.yml`/`pr-validate-dev.yml` validan sin publicar imagen ni desplegar. Base de datos reemplazó su workflow por `ci-dev.yml`, que valida y aplica a PostgreSQL 18 desechable en CI, pero no despliega. Web permite promoción `dev -> qa -> main`, valida y publica imagen solo desde push a `main`; el job `deploy` sigue con `if: false`. No se inspeccionaron secretos ni ejecuciones, y no se afirma que haya desplegado. Fuentes: [backend CI DEV](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/.github/workflows/ci-dev.yml), [database CI DEV](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/.github/workflows/ci-dev.yml) y [workflow web](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/.github/workflows/ci-deploy.yml).

### E11 — Salud y backup insuficientes para declarar operación

**Pendiente operativo:** SELECT 1 no prueba migraciones, MQTT ni SMTP. La guía de backup reconoce ausencia de restauración demostrada; no se verificó ninguna copia. Fuentes: [salud](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/health/health.controller.ts), [backup](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/BACKUP_AND_RESTORE.md).

### E12 — Pruebas y formato de errores

**Pendiente técnico:** e2e inicial espera GET / no registrado; formatos message string/arreglo y tratamiento de 429 difieren entre clientes. No se ejecutaron suites ni solicitudes para confirmar fallos. Fuentes: [pruebas](../30-desarrollo/estrategia-de-pruebas.md), [errores](../20-contratos/errores-api.md), [referencia](../10-arquitectura/backend/referencia-tecnica.md).

### E13 — Verificaciones todavía necesarias

OpenAPI generado; firmware y ACL del broker; versiones desplegadas; cookies Android/iOS; autoridad de requisitos y roles; responsables nominales; consolidación de antecedentes y revisión visual DOCX. No se inventaron ADR aceptados, endpoints, variables o resultados para cubrir estos vacíos.

## E14 — Revisión técnica de base de datos

La revisión anterior cubrió 332 archivos de smarthome-database `dev` `6caed6b`: 42 changelogs y 96 changesets. El corte `3b20c91` añade SQL035–SQL037 y llega a 45 changelogs/99 changesets, con `consumption.mqtt_ingest_dedup`. La [referencia central](../10-arquitectura/base-de-datos/README.md) actualiza migraciones y modelo; el JSON estructural sigue siendo snapshot `6caed6b`. No se ejecutó la base ni se modificó un checkout de implementación.

## E15 — Copia archivada de informes del backend

El 2026-11-03 se copiaron al [archivo del backend](../99-archivo/backend/README.md) cuatro informes con fecha de corte de smarthome-backend `1cbaca2`, idénticos en `dev` `3bfce85`. Se comprobó por diff que el contenido coincide con el original salvo la nota de estado y los enlaces relativos.

**Pendiente de coordinación:** los originales permanecen en el backend. Retirarlos o reemplazarlos por un enlace a la copia requiere acuerdo con el responsable de ese repositorio; no se modificó. Mientras tanto ambas versiones coexisten y la del backend es la de origen.

**Verificado, límite registrado:** los enlaces relativos del informe 01 se fijaron a `dc1cbfc` y los de HU09 a `bc9d3ec`, últimos commits que modificaron cada documento, porque en `1cbaca2` varios archivos citados por rango de líneas cambiaron de tamaño. Los enlaces a `../smarthome-database/` apuntaban a una copia local anidada sin commit identificable; se fijaron a `6caed6b` y sus rangos de líneas son aproximados.

**Pendiente de verificación:** la página oficial de configuración de NestJS enlazada desde la [implementación HU09](../99-archivo/backend/implementacion-hu09.md) no pudo consultarse desde el entorno de revisión. Se conserva como parte del texto histórico y figura en el manifiesto sin evidencia de lectura.

## Cierre de un pendiente

Añadir revisión/commit, evidencia ejecutada, componentes contrastados, resultado y persona/rol que acuerda el cierre. Modificar el estado solo cuando exista esa evidencia.

## E16 — Copia de los nueve documentos restantes del backend

El 2026-11-03 se copiaron a este repositorio los nueve documentos que quedaban en `docs/` de smarthome-backend (`dev` `fea0254`). La [matriz de migración](migracion-docs-backend.md) registra origen, destino, vigencia, conservación, enlaces, contradicciones y revisión de secretos.

**Pendiente de revisión:** mientras existan los originales, los destinos son copias. Cada documento requiere aprobación (`APROBADO PARA RETIRO` o `BLOQUEADO`) antes de retirar los originales del backend. Hasta entonces ambas versiones coexisten.

## E17 — Broker MQTT de producción

**Pendiente de contraste:** el antecedente HU11 de la base de datos (2026-10-15) registra EMQX Cloud Serverless como proveedor confirmado para producción; el backend se probó con Mosquitto Dynamic Security y `dev` de la base de datos incluye releases de ingesta flespi (`035`, `036`). No se decide aquí el broker de producción. Las decisiones de producto que enumera ese antecedente (vinculación solo OWNER, recuperación en el mismo hogar, transferencia entre hogares bloqueada en el MVP, conservación de históricos, sin apagado físico automático) no tienen aprobación acreditada. Fuente: [antecedente HU11](../99-archivo/base-de-datos/originales/docs/hu11-emqx-serverless-pairing-readiness.md).

## E18 — Revisión de alineación 2026-11-05

Se contrastaron los cortes backend `60297c3`, database `3b20c91` y web `7b9acdf`. Se documentan seis rutas REST nuevas de energía, los modelos SQL034, el ledger SQL035–037, el modo MQTT Flespi DEV, los flujos de CI y la reducción del Compose productivo de datos a inspección de Liquibase. El cliente web implementa las seis operaciones de energía; dependencias y `.env` web no cambiaron en la comparación. La rama móvil reporta HEAD `6b5fe36`, pero no se pudo leer su código; su última evidencia detallada sigue fijada a `bb87f62`.

El checkout local de smart-home-doc está en `e1168c8` y `origin/main` en `c9054ab`, 21 commits adelante. Un fast-forward falló por permiso denegado al escribir `.git/ORIG_HEAD`; no se cambió metadata Git. El código de `from_movil` tampoco pudo leerse: falló el conector GitHub y el acceso Git por red está restringido. Ver [revisión de alineación y acciones por componente](revision-alineacion-implementaciones-2026-11-05.md). No se ejecutaron pruebas, API, migraciones ni workflows.

Fuentes generales: [mapa](mapa-de-repositorios.md), [inventarios](inventario-documental.md) y [validaciones](validacion-documental.md).
