---
title: Alcance y no objetivos
status: borrador
owner: producto
last_reviewed: 2026-10-29
canonical_for:
  - alcance-verificado
---

# Alcance y no objetivos

## Alcance de esta revisión

Se inspeccionó el árbol inicial completo de smart-home-doc: README.md y una rama main, sin modificaciones locales. Se utilizaron instantáneas remotas de los cuatro componentes del [mapa](mapa-de-repositorios.md), un análisis estático detallado del backend y documentos del repositorio separado smart-home-docs.

Se documentan responsabilidades, integración, comandos declarados, permisos y condiciones de configuración. Las configuraciones de despliegue son evidencia de diseño ejecutable, no de infraestructura activa.

## Límites del producto verificables

- Existen hogares y dispositivos; la mención de zonas en borradores no basta para afirmar un módulo de zonas implementado.
- El provisionamiento legado Shelly tiene una ruta cuyo caso de uso devuelve 503. Hay flujos alternativos condicionales; no debe presentarse todo pairing como disponible en producción.
- Hay persistencia y consultas de consumo; recomendaciones, alertas automáticas y cálculos comerciales deben comprobarse por flujo.
- Los clientes contienen conectividad HTTP y realtime; eso no prueba compatibilidad integral ni funcionamiento en hardware.

Fuentes: [backend](../10-arquitectura/backend/referencia-tecnica.md), [servicio de pairing móvil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/blob/bb87f62c0727f22f376e56632c22bea66128a04a/lib/services/pairing-service.ts), [contrato cliente web](https://github.com/nataliachala1/smarthome-frontend-web/blob/8dad6e1f805db958e1e650379ae1dd6cce3c4d57/web/src/shared/api/shelly-pairing-contract.ts).

## Fuera del trabajo ejecutado

No se modificó código de implementación, no se desplegó, no se migró ninguna base, no se probaron credenciales, no se ejecutaron pruebas funcionales ni se aprobaron reglas de negocio o ADR. No se tomó contenido de Pull Requests como verdad.

## Pendiente

Acordar alcance funcional aprobado y documentar diferencias con los antecedentes sin reemplazar unilateralmente requisitos o contratos.
