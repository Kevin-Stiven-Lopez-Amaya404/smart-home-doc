---
title: Evidencias, discrepancias y pendientes
status: borrador
owner: documentacion
last_reviewed: 2026-10-29
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

**Pendiente de reconciliación documental:** [contrato local MQTT](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/docs/MQTT_CONTRACT.md) describe evaluación de anomalías, actualización de métricas y emisión de alertas en un flujo transaccional. El análisis del suscriptor identifica helpers sin llamadas, notifications vacío y actualización de estado fuera de la transacción de consumo. No se afirma generación automática activa. Fuente de código y detalle: [referencia backend](../10-arquitectura/backend/referencia-tecnica.md).

### E06 — Variables de refresh y despliegue

**Pendiente de configuración coordinada:** JWT_REFRESH_SECRET y JWT_REFRESH_EXPIRES_IN en ejemplos no determinan el refresh opaco actual; el Compose productivo todavía exige JWT_REFRESH_SECRET. Usar consumidores reales y revisar antes del despliegue. Fuentes: [catálogo](../40-operacion/variables-de-entorno.md), [Compose](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.production.yml).

### E07 — Permisos HTTP/SQL frente a realtime

**Riesgo pendiente de prueba:** las funciones SQL de detalle contemplan permisos por dispositivo; destinatarios MQTT y RealtimeAccessService no expresan los mismos filtros. Revisar MEMBER con consumo denegado. No se afirma explotación confirmada. Fuentes: [roles y referencias concretas](../60-producto-procesos/roles-y-permisos.md).

### E08 — Pairing y guía móvil

**Pendiente de sincronización:** [guía móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/BACKEND_CONNECTION.md) describe límites que no reflejan todo [pairing-service.ts](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/services/pairing-service.ts). El backend mantiene provisión legada bloqueada y nuevas rutas condicionales. Revisar perfil y flujo antes de declarar disponibilidad productiva.

### E09 — Prototipo de autenticación móvil

**Pendiente de retiro/consolidación:** [guía de flujo](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/FLUJO_USUARIO.md) contiene OTP y ejemplos demo; el contrato actual utiliza enlaces/token. No se copiaron sus credenciales de muestra ni se declararon válidos sus recorridos.

### E10 — Gate de despliegue contradictorio

**Riesgo verificado en configuración:** [guía CI/CD](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/CICD.md) afirma que los tres jobs de deploy están deshabilitados. Los workflows de [datos](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/.github/workflows/ci-deploy.yml) y [web](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/.github/workflows/ci-deploy.yml) tienen if: false. El [workflow backend](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/.github/workflows/ci-deploy.yml) no lo tiene: después de validar/publicar puede llamar al webhook si están configurados DOKPLOY_DEPLOY_WEBHOOK y DEPLOYMENT_HEALTH_URL; si faltan, omite el despliegue.

No se inspeccionaron secretos ni ejecuciones y no se afirma que haya desplegado. Resolver coordinación antes de publicar cambios a ramas que disparen esos jobs. Un grupo concurrency homónimo no coordina repositorios distintos.

### E11 — Salud y backup insuficientes para declarar operación

**Pendiente operativo:** SELECT 1 no prueba migraciones, MQTT ni SMTP. La guía de backup reconoce ausencia de restauración demostrada; no se verificó ninguna copia. Fuentes: [salud](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/health/health.controller.ts), [backup](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/BACKUP_AND_RESTORE.md).

### E12 — Pruebas y formato de errores

**Pendiente técnico:** e2e inicial espera GET / no registrado; formatos message string/arreglo y tratamiento de 429 difieren entre clientes. No se ejecutaron suites ni solicitudes para confirmar fallos. Fuentes: [pruebas](../30-desarrollo/estrategia-de-pruebas.md), [errores](../20-contratos/errores-api.md), [referencia](../10-arquitectura/backend/referencia-tecnica.md).

### E13 — Verificaciones todavía necesarias

OpenAPI generado; firmware y ACL del broker; versiones desplegadas; cookies Android/iOS; autoridad de requisitos y roles; responsables nominales; consolidación de antecedentes y revisión visual DOCX. No se inventaron ADR aceptados, endpoints, variables o resultados para cubrir estos vacíos.

## E14 — Revisión técnica de base de datos

Se amplió el análisis a los 332 archivos de smarthome-database dev 6caed6b: 42 changelogs y 96 changesets localizados. La [referencia central](../10-arquitectura/base-de-datos/README.md) documenta modelo, contratos SQL y configuración. Los [hallazgos DB01–DB12](../10-arquitectura/base-de-datos/hallazgos-y-pendientes.md) registran diferencias de README, rollback, SQL028, wrappers, CI, diagnóstico y permisos. No se ejecutó la base ni se modificó su checkout local.

## Cierre de un pendiente

Añadir revisión/commit, evidencia ejecutada, componentes contrastados, resultado y persona/rol que acuerda el cierre. Modificar el estado solo cuando exista esa evidencia.

Fuentes generales: [mapa](mapa-de-repositorios.md), [inventarios](inventario-documental.md) y [validaciones](validacion-documental.md).
