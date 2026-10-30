---
title: Pruebas y verificaciones
status: borrador
owner: desarrollo
last_reviewed: 2026-10-29
canonical_for:
  - estrategia-pruebas
---

# Pruebas y verificaciones

## Scripts existentes

| Repositorio y directorio | Comandos declarados |
| --- | --- |
| Backend, raíz | npm test; npm run test:cov; npm run test:e2e; npm run build; npm run lint |
| Web, web/ | npm run test:contracts; npm run typecheck; npm run lint; npm run build |
| Móvil, raíz | npm run test:mobile-config; npm run test:shelly-mqtt-pairing; npm run test:shelly-ble-rpc; npm run test:navigation-auth; npm run test:alerts; npm run test:realtime-device-status; npm run typecheck; npm run lint |

Fuentes: [backend](https://github.com/nataliachala1/smarthome-backend/blob/1cbaca28e9e152d5cb5ff7643560fdfa65857486/package.json), [web](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/package.json), [móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/package.json). La existencia de un script no acredita éxito, cobertura o compatibilidad con servicios activos.

## Propuesta de verificación de integración

Pendiente de ejecutar y acordar con el equipo:

1. Aplicar migraciones a una base aislada y verificar roles/permisos.
2. Probar registro, correo, activación, login, renovación, revocación y errores.
3. Comparar OpenAPI generado con rutas y DTO efectivos de cada perfil.
4. Contrastar permisos OWNER/MEMBER/GUEST y overrides en HTTP y eventos.
5. Ensayar pairing y control con firmware y broker autorizados; comprobar desconexión y recuperación.
6. Validar cookies y enlaces en navegador, Android e iOS reales.

La prueba e2e inicial del backend espera GET /, pero AppController no está registrado: hay una discrepancia estática, no un fallo de ejecución declarado aquí. Los informes DOCX de pruebas son antecedentes históricos y no sustituyen resultados actuales.

## Resultado de esta entrega

Se ejecutan únicamente las [validaciones documentales](calidad-documental.md); resultados en el [registro](../00-contexto/validacion-documental.md). No se ejecutaron las suites de implementación.
