---
title: Promoción segura del frontend móvil de dev a qa y main
status: borrador
owner: movil
last_reviewed: 2026-11-05
canonical_for:
  - procedimiento-promocion-frontend-movil
---

# Promoción del frontend móvil: dev → qa → main

**Repositorio:** [from_movil](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil). **Fuente de verdad:** código, workflows y `eas.json` del repositorio móvil. **Estado:** procedimiento propuesto; integración de la política automatizada comprobada, pendiente de validación física y aprobación del equipo. No implica que se haya publicado una APK o una OTA.

## Estado comprobado al 2026-11-05

- `dev`: recibió el PR [#47](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/pull/47), que añade el check `Require dev to qa to main` y sus pruebas. Mobile CI aprobado.
- `qa`: creada inicialmente desde `dev` en `075f69cff59d2523fd73f36807f76020ec06151a`; luego incorporó el PR [#48](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/pull/48) desde `dev` (commit merge `3b33d1057d6125dee37db8074fa2457670458196`). Confirmar el CI de la rama y pruebas físicas antes de aprobarla como versión candidata.
- `main`: **no creada todavía**. Debe representar únicamente una versión validada. No crear una rama obsoleta que un sistema externo pueda desplegar accidentalmente.
- PR históricos [#1](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/pull/1) y [#36](https://github.com/Kevin-Stiven-Lopez-Amaya404/from_movil/pull/36): abiertos, **no incluidos automáticamente**.
- El workflow `Mobile CI` valida lint, TypeScript, suites funcionales y export Android JS; no sustituye APK nativa, backend real ni Shelly físico.

## Puertas de promoción

1. **Desarrollo `feature/* → dev`:** PR revisado, CI verde, documentación central actualizada si cambian flujos. No se impide este tipo de PR por la política de releases.
2. **Integración `dev → qa`:** solo mediante PR. El check de promoción rechaza otras ramas de origen y forks, pero necesita Rulesets para impedir pushes directos. Ejecutar CI y conservar URL y SHA.
3. **Validación QA:** en **Android físico con Development Build/APK**, verificar registro/inicio de sesión, recuperación de sesión, hogares/dispositivos, energía, notificaciones, conectividad/offline y permisos, vinculación Shelly por LAN/BLE y confirmación de control físico. Marcar explícitamente qué casos están probados y cuáles siguen pendientes; no declarar aprobado solo por pruebas simuladas.
4. **Producción `qa → main`:** PR exclusivamente desde `qa`, con revisión humana, CI verde, compatibilidad backend/contrato, variables productivas y evidencia QA. No usar push directo, `--force`, rebase de `main` o fusiones `dev → main`.
5. **Publicación:** seleccionar EAS Build (cambios nativos, permisos, plugins, runtime) o EAS Update (solo JS/activos compatibles) **después de aprobación explícita**. El nombre de rama Git no cambia por sí solo el canal EAS ni crea una APK.

## Comprobación local segura (PowerShell)

```powershell
git fetch origin --prune
git status --short
git log -1 --oneline origin/dev
git log -1 --oneline origin/qa
git log -1 --oneline origin/main  # Solo después de que exista

git switch qa
git pull --ff-only origin qa
npm ci
npm run lint
npm run typecheck
npm run test:mobile-config
npm run test:navigation-auth
npm run test:shelly-mqtt-pairing
npm run test:shelly-ble-rpc
npx expo export --platform android --output-dir dist-qa
```

No cambiar de rama si `git status` muestra trabajo no confirmado: guardar o respaldar los cambios antes. Los artefactos `dist-qa` no deben entrar en un PR; limpiar localmente o ignorarlos.

## Primera creación de main (operación especial)

No crear `main` desde `dev` para saltarse QA. Cuando QA cuente con **aprobación funcional y del responsable de release**, crear `main` usando un commit histórico antecesor verificado de `qa` únicamente si se necesita establecer la rama para abrir el PR `qa → main`. Antes de crearla, revisar dependencias de despliegue/automatizaciones que puedan dispararse al aparecer `main`. Un antecesor histórico no es un despliegue: no activar producción con ese árbol. Configurar Rulesets inmediatamente y promover `qa` por PR. No eliminar ni sobrescribir ramas.

## Configuración de protección en GitHub (pendiente)

En `Settings → Rules → Rulesets`, aplicar a `qa` y `main`:

- Exigir pull request y al menos una revisión de persona responsable (según acceso/plan).
- Prohibir force pushes y eliminación de la referencia.
- Requerir `Mobile CI / Lint, types and regression tests` y `Release Promotion Policy / Require dev to qa to main` para las promociones donde estén disponibles.
- Exigir resolución de conversaciones, invalidar aprobaciones obsoletas y restringir bypass según política del equipo.

**Importante:** un workflow verde sin Ruleset no bloquea `git push` directo. La protección no se pudo verificar ni configurar a través de la conexión disponible.

## Ambiente y publicación

- `eas.json` define perfiles `development`, `preview` y `production`, y canales `preview` y `production`. No significa que haya despliegue automático desde `main`.
- `app.config.js` exige `EXPO_PUBLIC_API_URL` pública HTTPS, `APP_LINK_DOMAIN`, `ANDROID_PACKAGE` e `IOS_BUNDLE_IDENTIFIER` para producción. Provisionar con EAS y revisar sin publicar secretos.
- Para una nueva APK: `eas build --platform android --profile production`, con acceso autorizado, firma y configuración de entorno confirmada.
- Para una actualización OTA compatible: `eas update --channel production --platform android --environment production --message "Release <version> (QA aprobado)"`; **esto publica** y no debe ejecutarse en una prueba de documentación.
- Confirmar `runtimeVersion` y compatibilidad nativa con el binario distribuido antes de OTA; tener plan de recuperación sobre la última versión funcional y conservar enlaces de build/update.

## Evidencia mínima de cierre

Registrar SHA exactos de `dev`, `qa`, `main`; URLs de PR y checks; checklist físico Android; ambiente y variables revisadas; tipo de publicación, build o update ID; resultado de prueba de humo posterior; responsable, fecha y método de recuperación. **Pendiente** hasta que las comprobaciones se ejecuten y queden registradas.

[Volver a operación](README.md).
