---
title: "Hostinger y Dokploy (archivado)"
status: obsoleto
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - archivo-bd-deployment-hostinger-deployment
---

# Hostinger y Dokploy

> **Estado documental:** obsoleto (histórico/no canónico). Estado del punto 2: histórico / desactualizado.
>
> **Origen:** [docs/deployment/HOSTINGER_DEPLOYMENT.md](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/deployment/HOSTINGER_DEPLOYMENT.md), ruta original `docs/deployment/HOSTINGER_DEPLOYMENT.md`, SHA-256 `e583545888bae5a2b06e562c086292c60d849c2f3cc005d3ef562caa027d7981`, blob `6df36bc94383bdbaf16518962887589255e19446`.
>
> **Sustituto:** [despliegue](../../../../../40-operacion/despliegue.md).
>
> El contenido se conserva sin cambios, salvo los enlaces relativos indicados en el punto 4 de la ficha. El original se retirará del repositorio de base de datos solo tras fusionar este PR.

El VPS tiene Ubuntu 24.04 con Docker y Dokploy. La integración de Hostinger no permite inspeccionar contenedores en este sistema operativo y el acceso SSH desde este entorno aún no autentica. Por ahora, no se debe crear un proyecto ni activar un despliegue desde Dokploy.

## Auditoría requerida antes de conectar Dokploy

1. Accede al VPS por SSH desde una sesión de VS Code Remote-SSH usando la clave local ya registrada en Hostinger.
2. Inspecciona los servicios, contenedores, redes, volúmenes y la instancia de PostgreSQL 18 que ya existe. No modifiques los directorios internos de Dokploy.
3. Identifica el host de PostgreSQL, base, usuarios, red compartida, esquema, tabla `databasechangelog` y último changeset aplicado.
4. Crea un `pg_dump` completo y guárdalo fuera del VPS. Restaura una copia en una instancia aislada y verifica tablas y conteos.
5. Compara los changesets pendientes con la base restaurada. No ejecutes cambios destructivos ni migres producción mientras existan dudas sobre el historial.

## Configuración después de la auditoría

El Compose de este repositorio no crea un servidor PostgreSQL. Completa las variables de [ENVIRONMENT_VARIABLES.md](environment-variables.md) con los nombres reales de la base existente y las redes identificadas. Revisa **Preview Compose** para confirmar que Liquibase y el backend llegan a la base existente y solo el frontend recibe el dominio público de Dokploy.

Configura acceso a los paquetes GHCR, dominio frontend, TLS y secretos en Dokploy. Mantén deshabilitado el job de despliegue de GitHub Actions hasta terminar estas comprobaciones y crear un único workflow coordinador que serialice las publicaciones de los tres repositorios.

La IP del VPS y el DNS del dominio ya se habían comprobado en la cuenta. No se han realizado cambios de despliegue en el VPS desde este repositorio.
