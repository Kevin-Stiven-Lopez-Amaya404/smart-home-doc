---
title: Instalación y ejecución del sistema completo
status: vigente
owner: operacion
last_reviewed: 2026-11-08
canonical_for:
  - instalacion-sistema-completo
---

# Instalación y ejecución del sistema completo

Este directorio levanta SmartHome completo con un solo comando: PostgreSQL con todas las migraciones y los usuarios de prueba, roles de base de datos de mínimo privilegio, broker MQTT, servidor de correo de pruebas (Mailpit), backend y aplicación web.

Es un entorno **local o de evaluación**. No se usa en producción: crea usuarios de demostración y usa secretos locales.

## Requisitos

- Docker Engine 24 o superior con Docker Compose v2 (`docker compose version`).
- Git.
- Puertos libres en el equipo: 8080 (web), 3000 (API) y 8025 (Mailpit).
- Para ejecutar la prueba automática: `bash`, `curl` y `python3`.

## 1. Clonar los repositorios uno al lado del otro

```bash
mkdir smarthome
cd smarthome
git clone https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-doc.git
git clone https://github.com/nataliachala1/smarthome-database.git
git clone https://github.com/nataliachala1/smarthome-backend.git
git clone https://github.com/nataliachala1/smarthome-frontend-web.git
```

Para evaluar la versión entregada, cambiar cada repositorio al tag final:

```bash
for repo in smart-home-doc smarthome-database smarthome-backend smarthome-frontend-web; do git -C "$repo" checkout final-delivery-2026; done
```

## 2. Configurar los secretos locales

```bash
cd smart-home-doc/deploy
cp .env.example .env
```

Reemplazar los cuatro valores de `.env` por cadenas aleatorias. Por ejemplo, con `openssl rand -hex 32` para cada uno. En Windows (PowerShell) se puede usar `[guid]::NewGuid().ToString('N')`.

## 3. Levantar el sistema

```bash
docker compose up -d --build --wait
```

El comando construye las imágenes del backend y de la web y espera a que todos los servicios estén sanos. La primera vez tarda varios minutos. El orden es:

| Paso | Servicio | Qué hace |
|---|---|---|
| 1 | `postgres` | Inicia PostgreSQL 18. |
| 2 | `migrations` | Aplica con Liquibase todas las migraciones y los datos de demostración (`changelog/changelog-demo.yaml`). |
| 3 | `db-roles` | Crea los usuarios `LOGIN` de mínimo privilegio con `scripts/provision-runtime-roles.sql` del repositorio de base de datos. |
| 4 | `mosquitto`, `mailpit` | Broker MQTT local y buzón de correo de pruebas. |
| 5 | `backend` | API NestJS conectada con los usuarios de mínimo privilegio. |
| 6 | `web` | Aplicación React servida por Nginx, con proxy hacia la API. |

Comprobar el estado:

```bash
docker compose ps
```

## 4. Ingresar

| Servicio | Dirección |
|---|---|
| Aplicación web | <http://localhost:8080> |
| Documentación de la API (Swagger) | <http://localhost:3000/api/docs> |
| Correos enviados (activación, recuperación) | <http://localhost:8025> |

Usuarios de prueba. Todos tienen la contraseña `SmartHome#2026`:

| Correo | Rol global | Rol en el hogar «Casa Demo» |
|---|---|---|
| `admin@example.com` | SYSTEM_ADMIN | — |
| `owner@example.com` | USER | OWNER |
| `member@example.com` | USER | MEMBER |
| `guest@example.com` | USER | GUEST |

Los datos son ficticios. Los correos usan el dominio reservado `example.com`.

También se puede crear una cuenta nueva desde «Regístrate». El correo de activación llega a Mailpit (<http://localhost:8025>).

## 5. Verificar con la prueba automática

```bash
./smoke-test.sh
```

La prueba recorre el sistema a través de la web, igual que el navegador. Comprueba:

- el ingreso con los cuatro roles;
- los permisos de cada rol;
- la gestión de hogares y dispositivos;
- el consumo y las tarifas;
- el registro con activación por correo;
- la renovación y el cierre de sesión;
- las respuestas de error 400, 401, 403, 404 y 409;
- el bloqueo de intentos repetidos de ingreso.

La última salida registrada está en [docs/40-operacion/evidencias-e2e](../docs/40-operacion/evidencias-e2e/smoke-test-output.md).

La protección contra fuerza bruta deja la IP bloqueada un minuto al terminar. Para repetir la prueba de inmediato, ejecutar antes `docker compose restart backend`.

## 6. Detener

```bash
docker compose down        # detiene y conserva los datos
docker compose down -v     # detiene y borra la base de datos local
```

## Solución de problemas

| Síntoma | Causa y solución |
|---|---|
| `Set POSTGRES_PASSWORD in .env` | Falta el archivo `.env`. Ejecutar el paso 2. |
| `migrations` termina con error | Los repositorios no están uno al lado del otro. Revisar el paso 1. |
| El puerto 8080, 3000 u 8025 está ocupado | Cambiar `WEB_PORT`, `API_PORT` o `MAILPIT_PORT` en `.env`. |
| La prueba responde 429 | El bloqueo por intentos repetidos sigue activo. Ejecutar `docker compose restart backend`. |
| Cambié el código y no se refleja | Ejecutar `docker compose up -d --build --wait`. |
