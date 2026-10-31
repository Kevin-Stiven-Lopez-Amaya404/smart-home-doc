---
title: SmartHome — documentación central
status: borrador
owner: documentacion
last_reviewed: 2026-10-29
canonical_for:
  - entrada-central
---

# SmartHome — documentación central

SmartHome reúne servicios y aplicaciones para gestionar hogares, dispositivos y datos de consumo eléctrico. Este repositorio explica el sistema y permite localizar las fuentes de implementación. No acredita una instalación productiva.

Repositorio central: **smart-home-doc**, en singular. Se conserva la identidad del README original y se amplía su navegación. El repositorio separado smart-home-docs contiene antecedentes documentales; no es el destino de este trabajo.

## Por dónde empezar

- [Contexto](docs/00-contexto/README.md): visión, alcance y mapa de repositorios.
- [Arquitectura](docs/10-arquitectura/README.md): componentes y responsabilidades.
- [Contratos](docs/20-contratos/README.md): REST, MQTT, tiempo real y errores.
- [Desarrollo](docs/30-desarrollo/README.md): entorno, comandos, pruebas y Git.
- [Operación](docs/40-operacion/README.md): despliegue, salud y recuperación.
- [Decisiones](docs/50-decisiones/README.md): registro y plantilla ADR.
- [Producto y procesos](docs/60-producto-procesos/README.md): permisos y flujos.
- [Archivo](docs/99-archivo/README.md): retiro de documentos.
- [Índice completo](docs/README.md).

## Referencias técnicas detalladas

- [Backend: arquitectura, endpoints, estructura y configuración](docs/10-arquitectura/backend/referencia-tecnica.md).
- [Base de datos: modelo, contratos SQL, migraciones, seguridad y operación](docs/10-arquitectura/base-de-datos/README.md).

## Repositorios

| Repositorio | Responsabilidad | Rama inspeccionada |
| --- | --- | --- |
| [smart-home-doc](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-doc) | Documentación central | main |
| [smarthome-backend](https://github.com/nataliachala1/smarthome-backend) | API, sesiones, dispositivos, consumo y realtime | dev |
| [smarthome-database](https://github.com/nataliachala1/smarthome-database) | Esquema, permisos y migraciones | dev |
| [smarthome-frontend-web](https://github.com/nataliachala1/smarthome-frontend-web) | Aplicación web en web/ | dev |
| [from_movil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil) | Aplicación móvil Android/iOS | dev |

El [mapa](docs/00-contexto/mapa-de-repositorios.md) registra commits, tecnologías y enlaces comprobados. Seleccionar dev por su contenido no identifica una versión desplegada o aprobada.

## Fuente de verdad y contribución

La [política documental](DOCUMENTATION_POLICY.md) define la autoridad por tema. La implementación conserva código, scripts y configuraciones; las migraciones permanecen en base de datos; los contratos requieren contraste entre productores y consumidores. Esta central explica y enlaza esas fuentes.

Consulte [CONTRIBUTING.md](CONTRIBUTING.md) para actualizar documentos y proponer decisiones.

## Estado

Documentación inicial en **borrador**, revisada estáticamente el 2026-10-29. No se generó OpenAPI ni se ejecutaron aplicaciones o pruebas funcionales. No se encontraron ADR aprobados verificables. Consulte [inventario](docs/00-contexto/inventario-documental.md), [pendientes](docs/00-contexto/evidencias-y-pendientes.md) y [validaciones](docs/00-contexto/validacion-documental.md).

Fuentes: [bootstrap backend](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/main.ts), [changelog SQL](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/changelog/changelog-master.yaml), [manifiesto web](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/package.json), [manifiesto móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/package.json).
