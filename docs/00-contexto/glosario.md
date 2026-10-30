---
title: Glosario
status: borrador
owner: arquitectura
last_reviewed: 2026-10-29
canonical_for:
  - glosario
---

# Glosario

| Término | Uso en esta documentación |
| --- | --- |
| Hogar / home | Unidad de pertenencia de dispositivos y membresías; no equivale automáticamente a zona |
| Dispositivo / device | Entidad asociada a un hogar; identidad de fabricante usada para mensajería |
| OWNER, MEMBER, GUEST | Roles de pertenencia a un hogar; diferentes del rol global del usuario |
| DTO | Objeto que expresa datos de entrada y sus validaciones en NestJS |
| Caso de uso | Servicio de aplicación que coordina una operación del dominio |
| Repositorio | Adaptador de persistencia o repositorio Git; indicar cuál según contexto |
| RLS | Políticas de seguridad por fila PostgreSQL; su aplicación depende de sesión y rol SQL |
| Access token | JWT utilizado para autenticar solicitudes |
| Refresh token | Token opaco de renovación administrado mediante cookie HttpOnly por el backend |
| MQTT topic | Ruta de publicación/suscripción, derivada del namespace y del identificador del dispositivo |
| Socket.IO | Transporte de eventos del namespace /realtime; no es una API WebSocket genérica intercambiable |
| Pairing | Flujo de asociación de dispositivo; depende de ruta, permisos y perfil de entorno |
| ADR | Registro de una decisión con contexto, alternativas, consecuencias y evidencia de estado |
| Fuente canónica | Ubicación identificable con autoridad sobre un tema |
| Verificación estática | Lectura de código o configuración; no demuestra ejecución exitosa |

Fuentes: [mapa](mapa-de-repositorios.md), [roles](../60-producto-procesos/roles-y-permisos.md), [contratos](../20-contratos/README.md) y [backend](../10-arquitectura/backend/referencia-tecnica.md).

Pendiente: acordar vocabulario de producto y resolver el uso de zonas en documentos anteriores.
