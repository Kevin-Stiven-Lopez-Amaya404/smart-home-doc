---
title: Mapa de repositorios y revisiones
status: borrador
owner: arquitectura
last_reviewed: 2026-10-29
canonical_for:
  - mapa-repositorios
---

# Mapa de repositorios y revisiones

## Identidad central

Repositorio: [Kevin-Stiven-Lopez-Amaya404/smart-home-doc](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-doc). Rama predeterminada e inicial inspeccionada: main. Rama local de trabajo actual: docs/organizacion, creada desde ese main conservando los cambios locales. Commit inicial inspeccionado: `dfe55be09e1a3237cc75490569969eff6b7c9586`. Único archivo previo: README.md con el nombre del repositorio. Sin cambios locales al comenzar. El inventario y el estado limpio inicial se comprobaron antes de preparar el primer commit documental.

La carpeta de trabajo es `S:\Datos\Imagenes\smart-home-doc`. Se comprobaron remoto, estado y rama antes de editar. El repositorio en plural es independiente y se usa solo como antecedente.

## Implementaciones inspeccionadas

### smarthome-backend

- Acceso: [nataliachala1/smarthome-backend](https://github.com/nataliachala1/smarthome-backend).
- Responsabilidad: Backend HTTP, sesiones, consumo, dispositivos y tiempo real.
- Tecnologías verificadas en la instantánea: NestJS 11, TypeScript, Prisma 7, PostgreSQL, MQTT y Socket.IO.
- Rama con código inspeccionado: **dev**; commit `1cbaca28e9e152d5cb5ff7643560fdfa65857486`.
- Fuente local por tema: Código, DTO, pruebas y configuración.
- Referencia comprobada: [src/main.ts](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/src/main.ts).
- La central mantiene contexto, límites e integración; los detalles de implementación se actualizan allí.

### smarthome-database

- Acceso: [nataliachala1/smarthome-database](https://github.com/nataliachala1/smarthome-database).
- Responsabilidad: Esquema, funciones, permisos y migraciones.
- Tecnologías verificadas en la instantánea: SQL PostgreSQL; Compose local postgres:16-alpine y Liquibase 4.29.
- Rama con código inspeccionado: **dev**; commit `6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878`.
- Fuente local por tema: changelog/changelog-master.yaml y SQL incluido.
- Referencia comprobada: [changelog/changelog-master.yaml](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/changelog/changelog-master.yaml).
- La central mantiene contexto, límites e integración; los detalles de implementación se actualizan allí.

### smarthome-frontend-web

- Acceso: [nataliachala1/smarthome-frontend-web](https://github.com/nataliachala1/smarthome-frontend-web).
- Responsabilidad: Cliente web.
- Tecnologías verificadas en la instantánea: React 18, TypeScript 5.6, Vite 6, Socket.IO; aplicación en web/.
- Rama con código inspeccionado: **dev**; commit `8dad6e1f805db958e1e650379ae1dd6cce3c4d57`.
- Fuente local por tema: web/package.json, cliente API y configuración Vite.
- Referencia comprobada: [web/package.json](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/package.json).
- La central mantiene contexto, límites e integración; los detalles de implementación se actualizan allí.

### from_movil

- Acceso: [Kevin-Stiven-Lopez-Amaya404/from_movil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil).
- Responsabilidad: Cliente móvil.
- Tecnologías verificadas en la instantánea: React Native 0.86, Expo 57, Expo Router y TypeScript 6.
- Rama con código inspeccionado: **dev**; commit `bb87f62c0727f22f376e56632c22bea66128a04a`.
- Fuente local por tema: package.json, app.config.js, servicios y configuración.
- Referencia comprobada: [package.json](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/package.json).
- La central mantiene contexto, límites e integración; los detalles de implementación se actualizan allí.


## Ramas y accesibilidad

En las inspecciones remotas, main de backend, base de datos y web contenía un README mínimo; se eligió dev por su implementación. En móvil la rama predeterminada era dev. Esto no identifica ramas de liberación aprobadas. Los enlaces técnicos se fijan a commits para evitar cambios silenciosos.

El backend local está en 13-dev con cambios previos del usuario y difiere de la instantánea remota. Se preservó sin modificarlo. Se encontraron carpetas locales de base de datos y web, pero su presencia no acredita igualdad con los commits remotos. No se presupone una raíz común para todos los proyectos.

## Documentación local y fuentes

- Backend: [referencia detallada fija](../10-arquitectura/backend/referencia-tecnica.md), derivada de código y configuraciones; no sustituye la fuente.
- Base de datos: [arquitectura de despliegue](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/ARCHITECTURE.md) y [backup y restauración](https://github.com/nataliachala1/smarthome-database/blob/6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878/docs/deployment/BACKUP_AND_RESTORE.md).
- Web: [configuración y proxy](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/vite.config.ts) y [scripts](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/package.json).
- Móvil: [conexión backend](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/BACKEND_CONNECTION.md); contiene apartados de pairing rezagados frente al servicio, registrados como discrepancia.

## Pendientes

Identificar versiones desplegadas, responsables acordados y política de ramas de los repositorios de implementación. Ver [evidencias](evidencias-y-pendientes.md) y [política](../../DOCUMENTATION_POLICY.md). No usar PR abiertos como aprobación automática.
