---
title: Inicio local
status: borrador
owner: desarrollo
last_reviewed: 2026-10-29
canonical_for:
  - inicio-local
---

# Inicio local

## Preparación

Consultar [mapa](../00-contexto/mapa-de-repositorios.md) y seleccionar la revisión requerida de cada componente. No cambiar la rama ni descartar modificaciones de un checkout de otra persona. No se presupone que todos los repositorios estén juntos.

Verificar versiones de herramientas contra Dockerfile, manifiestos y lockfiles locales. Los comandos siguientes están declarados en los manifiestos inspeccionados; **no fueron ejecutados como prueba funcional** en esta tarea. La instalación puede ejecutar postinstall y necesita revisión del entorno.

## Backend

Desde la raíz de smarthome-backend: instalar dependencias usando su lockfile, configurar variables según [configuración](configuracion-entorno.md) y preparar una base de pruebas con el changelog del repositorio de datos.

```sh
npm ci
npm run start:dev
```

El script equivale a nest start --watch. El postinstall ejecuta prisma generate --config prisma7.config.ts. Prisma genera cliente; no sustituye aplicar las migraciones SQL. No se invoca aquí una base existente ni se simula una migración.

Fuente: [scripts backend](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/package.json) y [instalación en CI](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/.github/workflows/ci-deploy.yml).

## Web

Desde **web/** en smarthome-frontend-web:

```sh
npm ci
npm run dev
```

Configurar VITE_API_URL y VITE_BACKEND_URL según [ejemplo sin secretos](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/.env.example) y [proxy de Vite](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/vite.config.ts). El proxy de desarrollo apunta al backend; no configura producción.

La instalación npm ci también figura en [web/README.md](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/README.md).

## Móvil

Desde la raíz de from_movil:

```sh
npm install
npm run start:lan
```

La instalación npm install está documentada en [README móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/README.md).

Configurar EXPO_PUBLIC_API_URL con una dirección accesible desde el teléfono; localhost del teléfono es el propio dispositivo. Seguir [guía local](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/BACKEND_CONNECTION.md), contrastando su apartado pairing con el servicio actual.

## Datos e integración

El [Compose local](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docker-compose.yml) declara PostgreSQL, Mosquitto y Liquibase; su servicio Liquibase ejecuta update. Leer primero sus requisitos, roles y .env locales; no se ofrece un comando de migración genérico contra producción.

Pendientes: ensayo reproducible completo, versiones mínimas de herramientas, orden validado de instalación y configuración autenticada del broker local. El Compose declara Mosquitto sin montar configuración de autenticación; no presentarlo como broker seguro ya preparado.
