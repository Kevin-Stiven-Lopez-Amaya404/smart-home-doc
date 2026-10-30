---
title: Contribuir a la documentación
status: borrador
owner: documentacion
last_reviewed: 2026-10-29
canonical_for:
  - contribucion-documental
---

# Contribuir a la documentación

## Elegir y actualizar el tema

1. Revisar [índice](docs/README.md), [política](DOCUMENTATION_POLICY.md) e inventario antes de crear archivos.
2. Usar contexto para alcance; arquitectura para componentes; contratos para interfaces; desarrollo para entorno local; operación para entornos; decisiones para ADR; producto para reglas y procesos.
3. Actualizar primero el documento canónico. Las instrucciones particulares permanecen junto al código; enlazar rutas reales desde aquí.
4. Registrar repositorio, rama, commit y archivos inspeccionados. Un README o historia de usuario no prueba aprobación ni comportamiento por sí solo.
5. Registrar diferencias en [evidencias y pendientes](docs/00-contexto/evidencias-y-pendientes.md), citando ambas fuentes. No ajustar otros repositorios ni contratos unilateralmente.

## Contratos y decisiones

Si cambia HTTP, SQL, MQTT o realtime, revisar productores y consumidores, compatibilidad, permisos y errores. OpenAPI se obtiene del backend con la configuración identificada; revisar también rutas condicionales.

Para una decisión significativa copiar la [plantilla ADR](docs/50-decisiones/plantilla-adr.md), elegir el próximo identificador libre y conservar `propuesta` hasta acreditar aceptación explícita. No se verificó una regla de aprobadores del equipo; proponer revisión con responsables es una recomendación pendiente de acordar.

## Referencias y estado

Seguir YAML y nombres de la política. Marcar `borrador` lo no contrastado e identificar qué falta. Un Dockerfile no acredita un despliegue.

Antes de mover archivos buscar enlaces entrantes, actualizar índices y registrar vínculos externos que no puedan corregirse. Seguir [retiro documental](docs/99-archivo/README.md).

## Lista previa al Pull Request

- [ ] Directorio e índice correctos y fuente canónica identificada.
- [ ] Sin duplicaciones innecesarias; instantáneas justificadas y versionadas.
- [ ] Fuentes y commits comprobados; propuestas separadas de implementación.
- [ ] Productores y consumidores revisados ante cambios de contrato.
- [ ] Estado, rol propuesto y fecha de revisión correctos.
- [ ] Ningún ADR aceptado sin evidencia.
- [ ] Sin secretos, conexiones reales ni datos personales innecesarios.
- [ ] `node scripts/check-docs.mjs` ejecutado.
- [ ] `git diff --check` ejecutado y diferencias revisadas.
- [ ] Limitaciones y comprobaciones reales descritas en el PR.

Fuentes: [política](DOCUMENTATION_POLICY.md) y [calidad](docs/30-desarrollo/calidad-documental.md).
