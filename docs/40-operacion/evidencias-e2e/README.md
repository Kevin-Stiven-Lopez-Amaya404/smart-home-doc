---
title: Evidencias de la prueba extremo a extremo
status: vigente
owner: calidad
last_reviewed: 2026-11-08
canonical_for:
  - evidencias-e2e
---

# Evidencias de la prueba extremo a extremo

Evidencias de la instalación desde cero con [deploy/docker-compose.yml](../../../deploy/docker-compose.yml) y de la prueba automática [deploy/smoke-test.sh](../../../deploy/smoke-test.sh).

| Evidencia | Contenido |
|---|---|
| [smoke-test-output.md](smoke-test-output.md) | Salida completa de la instalación y de los 43 controles de la prueba automática. |
| [Figura 1](01-login.png) | Pantalla de ingreso de la web con el usuario OWNER de prueba. |
| [Figura 2](02-after-login.png) | Panel principal después de ingresar: el hogar «Casa Demo» y su dispositivo se leen desde PostgreSQL. |
| [Figura 3](03-homes.png) | Listado de hogares del usuario OWNER. |

Fuente de todas las figuras: elaboración propia, capturas tomadas con Playwright sobre el sistema levantado el 2026-11-08.
