---
title: Política documental y fuentes de verdad
status: borrador
owner: documentacion
last_reviewed: 2026-10-29
canonical_for:
  - politica-documental
---

# Política documental y fuentes de verdad

Estas convenciones organizan los archivos de este repositorio. Su adopción como proceso del equipo requiere revisión; no se inventan aprobadores ni ramas obligatorias.

## Matriz canónica

| Tema | Fuente para comprobar comportamiento | Función de la central |
| --- | --- | --- |
| Arquitectura global | [Síntesis](docs/10-arquitectura/arquitectura-general.md), código y ADR aceptados cuando existan | Explicar límites y registrar acuerdos |
| Backend | Código, pruebas y configuración de smarthome-backend | [Resumen y referencia de una instantánea](docs/10-arquitectura/backend.md) |
| API REST | Controladores, DTO, servicios y OpenAPI generado del backend | [Navegación y generación](docs/20-contratos/api-rest/README.md) |
| Esquema y migraciones | Changelog y SQL de smarthome-database | [Modelo y referencia técnica](docs/10-arquitectura/base-de-datos/README.md); sin copiar migraciones |
| Web y móvil | Código y configuración de sus repositorios | [Web](docs/10-arquitectura/frontend-web.md) y [móvil](docs/10-arquitectura/aplicacion-movil.md) |
| MQTT y realtime | Acuerdo compartido y productores/consumidores contrastados | [Contratos descriptivos](docs/20-contratos/README.md); aprobación conjunta pendiente |
| Desarrollo | Scripts reales de cada implementación | [Recorrido local](docs/30-desarrollo/README.md) |
| Operación | Configuración desplegable y evidencia del entorno real | [Procedimientos](docs/40-operacion/README.md); operación activa sin verificar |
| Decisiones | ADR con evidencia explícita de aceptación | [Registro](docs/50-decisiones/README.md), actualmente sin ADR aceptados |

Los enlaces concretos y revisiones están en el [mapa](docs/00-contexto/mapa-de-repositorios.md).

## Reglas de mantenimiento

1. Localizar el documento canónico antes de crear otro. Cada identificador `canonical_for` es único.
2. Mantener README e instrucciones particulares junto al código. La central enlaza los detalles.
3. Una copia descriptiva solo se admite con propósito, commit, fecha, límites y mecanismo de actualización. La [referencia técnica del backend](docs/10-arquitectura/backend/referencia-tecnica.md) es una instantánea fija de consulta; actualizarla exige repetir el análisis y cambiar su revisión, nunca editar contratos para simular coincidencia.
   La [referencia de datos](docs/10-arquitectura/base-de-datos/README.md) sigue el mismo criterio: commit fijo, límites y repetición del análisis para actualizar modelo, diccionario, contratos e inventario. Los artefactos de extracción describen código, no un catálogo instalado.
4. Mantener migraciones en base de datos y generar OpenAPI desde el backend.
5. Registrar discrepancias con ambas fuentes, impacto y validación pendiente. No modificar unilateralmente contratos compartidos.
6. Los cambios de comportamiento requieren revisar documentación y componentes afectados.
7. Los contratos identifican rol de mantenimiento, estado, productor y consumidor. Los roles de estos borradores son **propuestos**, no asignaciones nominales acordadas.
8. No copiar secretos, conexiones reales ni datos personales innecesarios.

## Metadatos y estados

Los Markdown nuevos llevan YAML: `title`, `status`, `owner`, `last_reviewed` y lista `canonical_for`. La fecha ISO identifica revisión real del contenido; no se actualiza por un cambio mecánico de enlace.

- `borrador`: elaboración, revisión o verificación esencial pendiente.
- `vigente`: revisado y respaldado por fuentes; no equivale a aprobación de una decisión o a despliegue.
- `obsoleto`: explica motivo y reemplazo, o ausencia de sustituto, conservando referencias.

Estado ADR separado: propuesta, aceptada, rechazada, sustituida o retirada. La aceptación necesita evidencia explícita.

## Nombres, enlaces y retiro

Usar Markdown con nombres descriptivos en minúsculas y kebab-case, salvo README.md, CONTRIBUTING.md y DOCUMENTATION_POLICY.md. Cada directorio temático tiene README. Enlaces internos relativos; enlaces de implementación fijados al commit inspeccionado. Una ruta no comprobada se registra como pendiente.

Para retirar un documento seguir [archivo](docs/99-archivo/README.md): buscar referencias, identificar sustituto y preservar historial. No archivar por antigüedad. Los antecedentes de smart-home-docs se conservan en su repositorio y ramas, sin moverlos ni eliminarlos.

## Calidad

Ejecutar `node scripts/check-docs.mjs` y `git diff --check` antes del PR. El [alcance de la validación](docs/30-desarrollo/calidad-documental.md) explica qué se comprueba. Una ruta válida no prueba comportamiento, autoridad ni seguridad.

Fuentes: [inventario](docs/00-contexto/inventario-documental.md), [evidencias](docs/00-contexto/evidencias-y-pendientes.md), [mapa](docs/00-contexto/mapa-de-repositorios.md).
