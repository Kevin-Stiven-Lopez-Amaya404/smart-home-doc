---
title: Contrato MQTT descriptivo
status: borrador
owner: integracion
last_reviewed: 2026-11-04
canonical_for:
  - contrato-mqtt
---

# Contrato MQTT descriptivo

## Estado y responsables propuestos

Borrador basado en backend dev. Roles de revisión propuestos: backend y responsables de dispositivos/broker. No hay aprobación conjunta acreditada. El firmware no se inspeccionó, por lo que la compatibilidad se limita a lo que el backend publica o espera recibir.

## Topics derivados

Sea D = `<MQTT_TOPIC_NAMESPACE>/devices` cuando hay namespace. Sin namespace se usa MQTT_CONTROL_TOPIC_PREFIX o smarthome/devices. Sea S el MQTT_SHELLY_SWITCH_ID, por defecto 0.

| Uso | Ruta observada |
| --- | --- |
| Control de dispositivo no Shelly | D/id/control |
| Estado interno | D/+/status |
| Prefijo Shelly con namespace | D/id |
| Prefijo Shelly sin namespace | id |
| Control Shelly | prefijo-Shelly/rpc |
| Estado Shelly | prefijo-Shelly/status/switch:S |
| Eventos RPC Shelly | prefijo-Shelly/events/rpc |

El identificador se valida con mqttDeviceId; Shelly se distingue por prefijo de identidad sin distinguir mayúsculas. Los filtros configurados deben coincidir con los derivados; no son rutas arbitrarias.

Fuentes: [MqttTopicContract](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/modules/devices/infrastructure/messaging/mqtt-topic-contract.ts), [parseMqttConfig](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/config/mqtt-config.ts).

## Referencias locales y autoridad compartida

El [contrato local del backend](../../99-archivo/backend/mqtt-contract-2026-10-15.md), archivado como referencia histórica, y [MQTT con TLS y namespace](tls-y-namespace.md) se conservan como referencias; su descripción de alertas y transacciones requiere reconciliación con el código. La central no mantiene una segunda tabla independiente de payloads ni da por aprobado ese acuerdo.

## Conciliación con el contrato local del backend

El 2026-11-03 se copió `docs/MQTT_CONTRACT.md` del backend (`dev` `fea0254`, corte 2026-10-15). Este documento sigue siendo la **única referencia canónica** del contrato MQTT; la versión original se conserva íntegra en el [archivo](../../99-archivo/backend/mqtt-contract-2026-10-15.md). Contraste sección por sección con el código de `dev` `fea0254`:

| Sección del contrato local | Resultado de la conciliación |
| --- | --- |
| Nota HU10 y 1. Broker MQTT | Vigente en lo esencial: las variables citadas existen en el backend. TLS y namespace se detallan en [MQTT con TLS y namespace](tls-y-namespace.md); los valores de ejemplo son locales. |
| 2. Identificador del dispositivo | Incorporado en [Topics derivados](#topics-derivados) (validación del identificador). |
| 3. Tópico de control | Incorporado: corresponde a `D/id/control` en [Topics derivados](#topics-derivados). |
| 4. Payload de control | Descrito en la [referencia técnica](../../10-arquitectura/backend/referencia-tecnica.md); `TURN_ON` y `TURN_OFF` existen en el código. |
| 5. Tópico de estado y telemetría | Incorporado: corresponde a `D/+/status` en [Topics derivados](#topics-derivados). |
| 6 y 7. Payload y campos de estado | Los campos citados se leen en el suscriptor de estado; el detalle vigente se mantiene en la referencia técnica, sin una segunda tabla independiente. |
| 8. Procesamiento en el backend | **Divergente:** el contrato local incluye actualización de métricas y evaluación de anomalías dentro de la transacción. En el suscriptor, `refreshDailyDeviceMetric` y `evaluateDailyConsumptionAnomaly` no tienen llamadas y el código indica que estadísticas y alertas quedan pendientes de un worker. Se registra en [E05](../../00-contexto/evidencias-y-pendientes.md#e05--alertas-y-transacciones-mqtt). |
| 9. Flujo general | Histórico: diagrama del modo local con Mosquitto. |
| 10 y 11. Simulador y prueba local | Histórico: herramienta local (`npm run simulate:device`); no valida TLS ni ACL. |
| 12. Dispositivos físicos | Parcialmente vigente: sigue aplicando a dispositivos no Shelly que usen el contrato interno. |
| 13. Nota sobre Shelly 1PM Gen4 | **Desactualizada:** el backend ya maneja tópicos nativos Shelly (`rpc`, `status/switch:S`, `events/rpc`), descritos en [Topics derivados](#topics-derivados). No acredita compatibilidad con todo Shelly ni pairing completo. |

Divergencias pendientes: confirmar con firmware y broker reales los payloads y la semántica de alertas; no se declara aprobado ningún acuerdo compartido.

Fuente: [contrato local en el commit de origen](https://github.com/nataliachala1/smarthome-backend/blob/fea02540ae12ed7501ae2b75f6216ab00411796a/docs/MQTT_CONTRACT.md) y [suscriptor de estado](https://github.com/nataliachala1/smarthome-backend/blob/fea02540ae12ed7501ae2b75f6216ab00411796a/src/modules/devices/infrastructure/messaging/mqtt-device-status.subscriber.ts).

## Payloads y persistencia

El backend distingue estado interno, estado de switch y eventos RPC Shelly; no trata cualquier JSON como consumo válido. Los campos, validaciones, unidad energética y publicación de órdenes se describen en la [referencia técnica](../../10-arquitectura/backend/referencia-tecnica.md). Esa referencia está fijada al mismo commit para evitar dos tablas de payload independientes.

No se copian credenciales de broker a este contrato. La autorización, namespace y configuración de cada identidad deben contrastarse con las ACL reales.

## Base de datos: namespace y proveedor de broker

### Persistencia frente a namespace y TLS

Para la base de datos, el namespace MQTT identifica una instalación o entorno; no es un permiso de hogar ni existe una tabla de tópicos. El identificador persistido sigue siendo `manufacturer_device_id` sin prefijo. El prefijo de tópicos no impide que una identidad publique por otra: la autenticación, la ACL individual y la revocación dependen del broker y de los objetos de identidad de HU11. HU10 no modificó SQL, RLS ni el historial Liquibase. Antecedente: [HU10 en la base de datos](../../99-archivo/base-de-datos/originales/docs/hu10-mqtt-tls-namespace.md).

### Proveedor de broker: antecedente HU11

Un registro del 2026-10-15 indica que se eligió EMQX Cloud Serverless para producción y que su API pública, consultada entonces, no ofrecía altas y bajas automatizadas de credenciales o ACL; el trabajador de revocación del backend de esa fecha solo admitía Mosquitto Dynamic Security. No se ha verificado cuál es el broker vigente en DEV ni en producción, y no debe tomarse ese antecedente como decisión actual. Si el trabajador de revocación está desactivado, el estado SQL no equivale a una revocación ejecutada en el broker. Antecedente: [HU11 EMQX Serverless](../../99-archivo/base-de-datos/originales/docs/hu11-emqx-serverless-pairing-readiness.md). Pendiente: [registro de evidencias](../../00-contexto/evidencias-y-pendientes.md).

## Seguridad y verificación pendiente

Producción con transporte habilitado requiere mqtts, verificación TLS, credenciales y namespace. El perfil de laboratorio exige condiciones adicionales; no se propone desactivar TLS para hacerlo funcionar.

Falta contrastar firmware y broker, reglas QoS/retain, duplicados, mensajes fuera de orden, redelivery y coherencia de permisos del consumidor realtime. No se afirma entrega garantizada, alertas activas o compatibilidad con todo dispositivo Shelly.
