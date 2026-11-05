---
title: Archivo historico del frontend movil
status: obsoleto
owner: movil
last_reviewed: 2026-11-04
canonical_for:
  - archivo-movil-2026-11-04
---

# Archivo histórico del frontend móvil

Se conserva una copia documental de **26 archivos** del repositorio `Kevin-Stiven-Lopez-Amaya404/from_movil`, procedentes del commit `46845ffb908c11e250596368bc73651ba5ef56e7` de `dev`. Las fuentes se contrastan mediante los hashes de blob Git registrados en el [manifiesto](manifiesto-migracion.json).

## Alcance y límites

- Los originales están como archivos `.txt` bajo [originales](originales/README.md) para preservar texto sin presentar Markdown legado como documentación canónica ni romper las comprobaciones formales.
- Se redactaron **22 referencias** a un usuario o clave de demostración conocidos. El contenido de las copias no es byte por byte idéntico al origen cuando hay redacciones. Los hashes `git_blob_origen` identifican el archivo exacto del origen para auditoría, **no son hashes del contenido sanitizado**.
- La información puede contener rutas, credenciales demostrativas, capturas o afirmaciones obsoletas. No se considera prueba de vigencia técnica ni de un despliegue.
- Los documentos `BACKEND_CONNECTION.md` y `BLE_POC_ANDROID.md` tienen copias de archivo por trazabilidad, pero sus versiones **operativas** siguen junto al código móvil y no deben retirarse sin reemplazo.
- La documentación funcional y la configuración siguen teniendo como fuente de verdad los archivos de `from_movil/dev`. La [síntesis de arquitectura móvil](../../10-arquitectura/aplicacion-movil.md) es una instantánea que necesita actualización tras cambios posteriores.
- El PR #36 de producción QA no forma parte de estas fuentes.
- Las cuentas, claves u otros valores expuestos en el historial Git no se revocan mediante esta operación; confirmar si alguna vez fueron reales y rotarlos si corresponde.

## Ruta de actualización

Para retirar originales no operativos del móvil, primero verificar que este PR esté fusionado, que el manifiesto incluya la ruta y SHA del origen y que los enlaces operativos se actualicen. No borrar `app/terms.tsx` ni `lib/legal/terms-content.ts`, que son parte del runtime.

El documento canónico para ejecutar la aplicación sigue siendo el README de `from_movil`; este archivo es de **consulta histórica**.
