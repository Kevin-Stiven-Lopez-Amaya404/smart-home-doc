---
title: Contrato REST de energía del hogar
status: borrador
owner: backend
last_reviewed: 2026-11-05
canonical_for:
  - contrato-api-energia
---

# Contrato REST de energía del hogar

## Fuente y alcance

Contrato derivado de los controladores, DTO y casos de uso de backend `dev` en `60297c361e4acac6e98161337ef8e149e069d441`, contrastado con SQL034 y el cliente web `dev` en `7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac`. No se generó ni ejecutó OpenAPI; los ejemplos y respuestas describen el código estático.

La API está registrada bajo `/api/v1/homes/:homeId/energy`. `homeId` es UUID y cada ruta requiere `Authorization: Bearer <accessToken>`. No hay una bandera de perfil para registrar `EnergyModule` en `AppModule`.

## Permisos

- Lectura de resumen, tarifas y metas: OWNER o MEMBER con permiso de ver el detalle de consumo (`view_consumption`). GUEST, usuarios sin membresía y miembros sin ese permiso reciben `403`.
- Escritura de tarifas y metas: solo OWNER de un hogar activo.
- JWT ausente, vencido o revocado: `401`.
- UUID, fecha, mes o DTO inválido: `400`.
- Conflicto de vigencia de tarifa o escritura simultánea de una meta: `409`.

## Rutas

| Método y ruta | Entrada | Respuesta | Uso |
| --- | --- | --- | --- |
| `GET /api/v1/homes/:homeId/energy/summary` | Query opcional `month=YYYY-MM` | `200 HomeEnergySummary` | Lecturas, consumo y costo estimado del mes. |
| `GET /api/v1/homes/:homeId/energy/tariffs` | Sin body | `200 { homeId, tariffs[] }` | Historial descendente por `effectiveFrom`. |
| `GET /api/v1/homes/:homeId/energy/tariffs/current` | Query opcional `at=YYYY-MM-DD` | `200 { homeId, at, tariff }`; `tariff` puede ser `null` | Tarifa efectiva a la fecha local. |
| `POST /api/v1/homes/:homeId/energy/tariffs` | `{ "unitPriceCopKwh": "950.2500", "effectiveFrom": "2026-11-01" }` | `201 HomeEnergyTariff` | Agrega vigencia; no reemplaza una existente para el mismo día. |
| `GET /api/v1/homes/:homeId/energy/goals` | Query opcional `month=YYYY-MM` | `200 { homeId, month, goal }`; `goal` puede ser `null` | Lee presupuesto/meta mensual. |
| `PUT /api/v1/homes/:homeId/energy/goals/:month` | Reemplazo completo: `{ "monthlyBudgetCop": "120000.00", "targetKwh": "125.000000" }` | `200 HomeEnergyGoal` | Crea o sustituye la meta del mes; operación idempotente. |

Los queries `month` usan `YYYY-MM`, años 2000–2099 y mes 01–12; si se omiten, backend usa el mes actual en `America/Bogota`. `at` usa `YYYY-MM-DD`, años 2000–2099 y por omisión la fecha actual de `America/Bogota`. La vigencia de tarifa también se interpreta con ese calendario local.

## Modelos JSON

### Tarifa

```json
{
  "id": "uuid",
  "homeId": "uuid",
  "unitPriceCopKwh": "950.2500",
  "effectiveFrom": "2026-11-01",
  "createdAt": "2026-10-29T17:00:00.000Z"
}
```

`unitPriceCopKwh` es decimal positivo como string, máximo 10 enteros y 4 decimales. `effectiveFrom` es fecha real con formato ISO. El hogar no puede tener dos tarifas con la misma fecha de vigencia.

### Meta mensual

```json
{
  "id": "uuid",
  "homeId": "uuid",
  "month": "2026-11",
  "monthlyBudgetCop": "120000.00",
  "targetKwh": "125.000000",
  "createdAt": "2026-10-30T17:00:00.000Z",
  "updatedAt": "2026-10-30T17:00:00.000Z"
}
```

El body de `PUT` exige las dos propiedades: cada valor puede ser decimal positivo o `null`; omitir una propiedad es error `400`. No se permiten ambos campos en `null`. `monthlyBudgetCop` admite hasta 12 enteros y 2 decimales; `targetKwh`, hasta 8 enteros y 6 decimales. Los decimales se conservan como texto para evitar pérdida de precisión en clientes.

### Resumen mensual

La respuesta contiene `homeId`, `month`, `timezone`, `from`, `to`, `readingsCount`, `unpricedReadings`, `totalKwh`, `costComplete`, `estimatedCostCop`, `partialCostCop`, `monthlyBudgetCop`, `targetKwh`, `budgetUsagePercent`, `targetUsagePercent` y `currency` (`COP`). Importes, kWh y porcentajes se serializan como strings decimales; los valores que pueden no existir son `null`.

`totalKwh` suma `energy_delta_kwh` de las lecturas del mes. El costo aplica a cada lectura la tarifa efectiva en su fecha local. Si existe alguna lectura con consumo sin tarifa (`unpricedReadings > 0`), `costComplete` es `false` y `estimatedCostCop` es `null`; `partialCostCop` solo suma las lecturas con tarifa. Los porcentajes no se limitan a 100. El rango mensual usa inicio inclusivo y fin exclusivo de `America/Bogota`.

Estos valores son referencias de consumo y costo estimado. El modelo no representa factura, impuestos, cargos fijos ni validación frente a la empresa eléctrica.

## Correspondencia con datos y clientes

| API | Persistencia | Cliente web |
| --- | --- | --- |
| `HomeEnergyTariff` | `config.home_energy_tariff`: `id_home_energy_tariff`, `id_home`, `unit_price_cop_kwh`, `effective_from`, `created_at` | `HomeEnergyTariff`; `listHomeEnergyTariffs`, `getCurrentHomeEnergyTariff`, `createHomeEnergyTariff` |
| `HomeEnergyGoal` | `config.home_energy_goal`: `id_home_energy_goal`, `id_home`, `month_start`, `monthly_budget_cop`, `target_kwh`, `created_at`, `updated_at` | `HomeEnergyGoal`; `getHomeEnergyGoal`, `upsertHomeEnergyGoal` |
| `HomeEnergySummary` | Agregado calculado desde lecturas, tarifas y meta; no se persiste como factura | `HomeEnergySummary`; `getHomeEnergySummary` |

La web integra estas llamadas en su módulo de consumo. La lectura actual de `from_movil` no fue posible; no se afirma que móvil ya use el contrato.

## Fuentes

- Backend: [resumen](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/energy/presentation/controllers/home-energy-summary.controller.ts), [tarifas](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/energy/presentation/controllers/home-energy-tariffs.controller.ts), [metas](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/energy/presentation/controllers/home-energy-goals.controller.ts), [respuestas](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/energy/application/dto/home-energy-summary.response.ts), [DTO de meta](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/energy/application/dto/upsert-home-energy-goal.dto.ts) y [DTO de tarifa](https://github.com/nataliachala1/smarthome-backend/blob/60297c361e4acac6e98161337ef8e149e069d441/src/modules/energy/application/dto/create-home-energy-tariff.dto.ts).
- Modelo SQL: [SQL034 tarifas y meta](https://github.com/nataliachala1/smarthome-database/blob/3b20c9177a9aabfcc285043a6d85048bb1b95b7a/releases/034_energy_tariff_budget/001_energy_tariff_budget.sql).
- Cliente web: [energy.api.ts](https://github.com/nataliachala1/smarthome-frontend-web/blob/7b9acdf12205cbc25aa3d0647cb9c60dbaaf17ac/web/src/shared/api/energy.api.ts).
