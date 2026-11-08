---
title: Salida de la prueba extremo a extremo
status: vigente
owner: calidad
last_reviewed: 2026-11-08
canonical_for:
  - evidencia-smoke-test
---

# Salida de smoke-test.sh

Fuente: elaboración propia, salida real de [deploy/smoke-test.sh](../../../deploy/smoke-test.sh).

Instalación desde cero (`docker compose down -v` y luego `docker compose up -d --wait`) el 2026-11-08 a las 02:10 UTC.

Commits probados: backend `cfffd88`, web `0afce9c`, base de datos `dfcdac5` (rama `chore/final-delivery-rubric-fixes`).

```text
 Container smarthome-postgres-1 Started
 Container smarthome-mosquitto-1 Started
 Container smarthome-mailpit-1 Started
 Container smarthome-postgres-1 Healthy
 Container smarthome-migrations-1 Started
 Container smarthome-migrations-1 Exited
 Container smarthome-db-roles-1 Started
 Container smarthome-db-roles-1 Exited
 Container smarthome-backend-1 Started
 Container smarthome-backend-1 Healthy
 Container smarthome-web-1 Started
 Container smarthome-backend-1 Healthy
 Container smarthome-db-roles-1 Exited
 Container smarthome-mailpit-1 Healthy
 Container smarthome-migrations-1 Exited
 Container smarthome-mosquitto-1 Healthy
 Container smarthome-postgres-1 Healthy
 Container smarthome-web-1 Healthy
backend: Up 11 seconds (healthy)
mailpit: Up 18 seconds (healthy)
mosquitto: Up 18 seconds
postgres: Up 18 seconds (healthy)
web: Up 5 seconds (healthy)

SmartHome smoke test against http://localhost:8080
1. Web and API availability
  ok    web serves the SPA
  ok    web serves deep links (/login)
  ok    API health through the web proxy
2. Sign in with every declared role
  ok    login admin@example.com
  ok    login owner@example.com
  ok    login member@example.com
  ok    login guest@example.com
  ok    admin token carries SYSTEM_ADMIN
3. Stability and error handling
  ok    wrong password is 401
  ok    malformed body is 400
  ok    400 response has no stack trace
  ok    missing token is 401
  ok    invalid token is 401
  ok    invalid UUID is 400
  ok    unknown home is 404
  ok    empty notification list is 200
4. SYSTEM_ADMIN functions
  ok    admin lists users
  ok    admin sees the 4 demo users
  ok    admin reads the audit log
  ok    a regular user cannot reach admin routes
5. Homes and memberships (OWNER / MEMBER / GUEST)
  ok    owner lists homes
  ok    owner sees Casa Demo
  ok    owner lists the 3 members
  ok    guest also sees the shared home
6. Devices
  ok    member lists devices
  ok    member sees the demo device
  ok    owner creates a device
  ok    owner renames the device
  ok    the change is visible to the guest
  ok    member cannot create devices
  ok    controlling an offline device is 409
  ok    owner deletes the device
7. Consumption and energy permissions
  ok    owner reads the consumption summary
  ok    guest cannot read detailed consumption
  ok    owner records a tariff
  ok    member reads tariffs
  ok    guest cannot read tariffs
  ok    member cannot record tariffs
8. Registration, email activation and session refresh
  ok    a new user registers
  ok    a pending account cannot sign in
  ok    the activation email arrives
  ok    the account is activated with the emailed token
  ok    login smoke-1794103869@example.com
  ok    the new user creates a home
  ok    the refresh cookie issues a new access token
  ok    logout succeeds
  ok    refresh fails after logout
9. Brute-force protection
  ok    repeated failed logins are rate limited (429)

Result: 43 passed, 0 failed
```
