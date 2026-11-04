---
title: "Solución de problemas (archivado)"
status: obsoleto
owner: datos
last_reviewed: 2026-11-04
canonical_for:
  - archivo-bd-deployment-troubleshooting
---

# Solución de problemas

> **Estado documental:** obsoleto (histórico/no canónico). Estado del punto 2: contradictorio en parte.
>
> **Origen:** [docs/deployment/TROUBLESHOOTING.md](https://github.com/nataliachala1/smarthome-database/blob/39416a5c42d35f988689061ffca8a79f7fa21002/docs/deployment/TROUBLESHOOTING.md), ruta original `docs/deployment/TROUBLESHOOTING.md`, SHA-256 `461fb4c305a8f3889dd750d58acff48a01879a7ab2d5465de6ae6bddaa80b470`, blob `3ec9ad9e79d3465944f71b620cf70b983c01ec82`.
>
> **Sustituto:** [solucion-de-problemas](../../../../../40-operacion/solucion-de-problemas.md).
>
> El contenido se conserva sin cambios, salvo los enlaces relativos indicados en el punto 4 de la ficha. El original se retirará del repositorio de base de datos solo tras fusionar este PR.

## La aplicación Compose no inicia

Revisa primero que todas las variables requeridas estén definidas en Dokploy y que Docker pueda descargar los paquetes GHCR. No imprimas el entorno completo al compartir logs.

```sh
docker compose -f docker-compose.production.yml ps -a
docker compose -f docker-compose.production.yml logs --tail=200 postgres liquibase backend frontend
```

## Liquibase falla

Confirma que el usuario migrador tiene permisos y que `POSTGRES_DB` apunta a la base correcta. Revisa `DATABASECHANGELOG` y checksums antes de reintentar. No borres volúmenes, no ejecutes `clear-checksums` y no marques cambios como ejecutados sin revisar el SQL.

## Backend no está listo

Comprueba que las cuentas LOGIN de `DATABASE_URL` y `DATABASE_IOT_URL` son miembros de los roles mínimos correspondientes, que los secrets JWT están completos y que EMQX es accesible por TLS.

```sh
docker compose -f docker-compose.production.yml exec backend node -e "fetch('http://127.0.0.1:3000/health/ready').then(async r=>{console.log(r.status, await r.text()); process.exit(r.ok?0:1)})"
```

## Frontend da 502

Confirma que `backend` está saludable y que Nginx comparte la red de Compose. Revisa que el path API publicado comienza con `/api/v1/` y que el dominio configurado en Dokploy apunta al servicio `frontend:8080`.

## El dominio no tiene TLS o no responde

Confirma DNS A/AAAA, puertos 80/443 del VPS, dominio configurado en Dokploy y logs del proxy Traefik. El cambio de dominio de un Compose requiere redeployment en Dokploy.
