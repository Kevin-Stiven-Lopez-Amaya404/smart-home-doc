---
title: Mapa de repositorios y revisiones
status: borrador
owner: arquitectura
last_reviewed: 2026-11-06
canonical_for:
  - mapa-repositorios
---

# Mapa de repositorios y revisiones

## Identidad central

Repositorio: [Kevin-Stiven-Lopez-Amaya404/smart-home-doc](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-doc). La rama predeterminada es `main`; el historial conserva una integración inicial mediante PR #1 y el bootstrap documental descrito en revisiones previas. En este corte el checkout está en `main`, commit `e1168c8d76bd22e5593651e215262afe38bb2a25`, con `origin/main` en `c9054ab3c40d2f91fde1d42b26a13bf60cd8462c`, 21 commits adelante. La sincronización no se pudo completar porque el entorno denegó la escritura de `.git/ORIG_HEAD`; los cambios actuales están en el árbol de trabajo.

La carpeta de trabajo es `S:\Datos\Imagenes\smart-home-doc`. Se comprobaron remoto, estado y rama antes de editar. El repositorio en plural es independiente y se usa solo como antecedente.

## Implementaciones inspeccionadas

### smarthome-backend

- Acceso: [nataliachala1/smarthome-backend](https://github.com/nataliachala1/smarthome-backend).
- Responsabilidad: Backend HTTP, sesiones, consumo, dispositivos y tiempo real.
- Tecnologías verificadas: NestJS 11, TypeScript, Prisma 7, PostgreSQL, MQTT y Socket.IO. El módulo de energía está registrado en la rama inspeccionada.
- Rama con código inspeccionado: **dev**; commit actual de este corte `60297c361e4acac6e98161337ef8e149e069d441` (la referencia detallada de octubre conserva `1cbaca28e9e152d5cb5ff7643560fdfa65857486` como snapshot histórico).
- Fuente local por tema: Código, DTO, pruebas y configuración.
- Referencia comprobada: [EnergyModule](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/app.module.ts) y [contrato energético](../20-contratos/api-rest/energia.md).
- La central mantiene contexto, límites e integración; los detalles de implementación se actualizan allí.

### smarthome-database

- Acceso: [nataliachala1/smarthome-database](https://github.com/nataliachala1/smarthome-database).
- Responsabilidad: Esquema, funciones, permisos y migraciones.
- Tecnologías verificadas en la instantánea: SQL PostgreSQL; Compose local postgres:16-alpine y Liquibase 4.29.
- Rama con código inspeccionado: **dev**; commit actual de este corte `3b20c9177a9aabfcc285043a6d85048bb1b95b7a` (la instantánea estructural anterior conserva `6caed6bdfdcc89105a9f0e221e5b2dc8aad4d878`).
- Fuente local por tema: changelog/changelog-master.yaml y SQL incluido.
- Referencia comprobada: [changelog/changelog-master.yaml](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/changelog/changelog-master.yaml).
- La central mantiene contexto, límites e integración; los detalles de implementación se actualizan allí.

### smarthome-frontend-web

- Acceso: [nataliachala1/smarthome-frontend-web](https://github.com/nataliachala1/smarthome-frontend-web).
- Responsabilidad: Cliente web.
- Tecnologías verificadas en la instantánea: React 18, TypeScript 5.6, Vite 6, Socket.IO; aplicación en web/.
- Rama con código inspeccionado: **dev**; commit actual de este corte `7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac` (la instantánea anterior conserva `8dad6e1f805db958e1e650379ae1dd6cce3c4d57`).
- Fuente local por tema: web/package.json, cliente API y configuración Vite.
- Referencia comprobada: [cliente REST de energía](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/src/shared/api/energy.api.ts).
- La central mantiene contexto, límites e integración; los detalles de implementación se actualizan allí.

### from_movil

- Acceso: [Kevin-Stiven-Lopez-Amaya404/from_movil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil).
- Responsabilidad: Cliente móvil.
- Tecnologías verificadas en la instantánea: React Native 0.86, Expo 57, Expo Router y TypeScript 6.
- Último commit con archivos inspeccionados en esta central: **dev**; `bb87f62c0727f22f376e56632c22bea66128a04a`. La metadata posterior indica HEAD `6b5fe36655eb9048aa4054a914ec245810d58893`; su código no fue accesible durante esta revisión.
- Fuente local por tema: package.json, app.config.js, servicios y configuración.
- Referencia comprobada: [package.json](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/package.json).
- La central mantiene contexto, límites e integración; los detalles de implementación se actualizan allí.


## Ramas y accesibilidad

En el corte actual, `main` es la rama predeterminada de backend, base de datos y web; se revisó `dev` porque es el código que contiene las implementaciones descritas. `dev` también es la rama predeterminada móvil. Esto no identifica ramas de liberación aprobadas. Los enlaces técnicos se fijan a commits para evitar cambios silenciosos.

El backend local está en 13-dev con cambios previos del usuario y difiere de la instantánea remota. Se preservó sin modificarlo. La base de datos local está en 03-dev (`e18b2d0`) con cambios previos; se preservó. Su rama local también difiere del remoto `dev` revisado en `3b20c9177a9aabfcc285043a6d85048bb1b95b7a`. La presencia de carpetas locales no acredita igualdad con los commits inspeccionados. No se presupone una raíz común para todos los proyectos.

## Documentación local y fuentes

- Backend: [referencia detallada fija](../10-arquitectura/backend/referencia-tecnica.md), derivada de código y configuraciones; no sustituye la fuente.
- Base de datos: [documentación técnica central](../10-arquitectura/base-de-datos/README.md); Compose y migraciones de la fuente actual están enlazados desde arquitectura, configuración y operación de datos. Las guías de despliegue y backup del corte anterior se tratan como antecedentes, no como instrucciones operativas actuales.
- Web: [documentación central](../10-arquitectura/web/README.md), [cliente de energía](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/src/shared/api/energy.api.ts) y [workflow de promoción](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/.github/workflows/ci-deploy.yml).
- Móvil: [documentación central](../10-arquitectura/from_movil/README.md) y [guía de conexión en el último snapshot verificable](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/docs/BACKEND_CONNECTION.md); la guía contiene apartados de pairing que no se pudieron revalidar frente al código actual.

## Pendientes

Sincronizar el checkout documental local con `origin/main` (está 21 commits atrás; el fast-forward se bloqueó al intentar escribir `.git/ORIG_HEAD`), volver a leer los archivos actuales de móvil, identificar versiones desplegadas, responsables acordados y política de ramas. Ver [evidencias](evidencias-y-pendientes.md), [revisión de alineación](revision-alineacion-implementaciones-2026-11-05.md) y [política](../../DOCUMENTATION_POLICY.md). No usar PR abiertos como aprobación automática.
