---
title: Inventario y clasificación documental
status: borrador
owner: documentacion
last_reviewed: 2026-10-29
canonical_for:
  - inventario-documental
---

# Inventario y clasificación documental

## Repositorio objetivo

smart-home-doc, main, commit inicial dfe55be09e1a3237cc75490569969eff6b7c9586: único archivo README.md, con título del repositorio. Se conserva identidad y se amplía. No había políticas, índices, CI ni contenido que mover. No se borró ni archivó ningún archivo.

## Antecedentes externos: smart-home-docs

Repositorio separado, **sin tratarlo como destino central**. main y dev solo contenían README. Se inspeccionaron las ramas docs/01 a docs/12 y se inventariaron **22 archivos**; las referencias siguientes apuntan a sus commits originales, sin usar PR como fuente.

La clasificación describe una acción recomendada, no un traslado ejecutado. Centralizar implica revisar autoridad y extraer contenido transversal; consolidar requiere elegir fuente y resolver referencias antes de mover. Ningún documento se clasificó Archivar sin evidencia suficiente.

Se extrajo texto OOXML de los DOCX para lectura y clasificación; no se aprobaron maquetación, firmas ni autoridad. XLSX/JPEG solo se identificaron por formato, sin analizar celdas o contenido visual. No se copiaron datos personales o credenciales de sus ejemplos.

| Archivo de origen comprobado | Rama | Clasificación | Tratamiento y límite |
| --- | --- | --- | --- |
| [docs/01-requisitos/SRS_SMART_HOME_ACTUALIZADO_2026 (1).md](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/c3634d74b5a3f4529105a7ff5a229f5afaf1be69/docs/01-requisitos/SRS_SMART_HOME_ACTUALIZADO_2026%20%281%29.md) | docs/01-requisitos | Pendiente de validar | SRS con extensión .md pero contenido DOCX; autoridad y contradicción sobre refresh pendientes. |
| [docs/02-analisis/Documento Navegacion Smart Home.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/9816e608dd78ad9f72b7448b14cf980479f33f05/docs/02-analisis/Documento%20Navegacion%20Smart%20Home.docx) | docs/02-analisis | Centralizar | Candidato a extraer flujos transversales tras contrastar; no se trasladó. |
| [docs/03-propuesta-tecnica/CONTENIDO PROPUESTA TECNICA Y ECONOMICA.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/44217ee2f08ad58b4d5fd54c35e5940d9194f8b9/docs/03-propuesta-tecnica/CONTENIDO%20PROPUESTA%20TECNICA%20Y%20ECONOMICA.docx) | docs/03-propuesta-tecnica | Pendiente de validar | Propuesta técnica/económica; no acredita decisiones o capacidades desplegadas. |
| [docs/03-propuesta-tecnica/costos_proyecto_smart_home (1).xlsx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/44217ee2f08ad58b4d5fd54c35e5940d9194f8b9/docs/03-propuesta-tecnica/costos_proyecto_smart_home%20%281%29.xlsx) | docs/03-propuesta-tecnica | Pendiente de validar | Solo formato identificado; costes y celdas no analizados. |
| [docs/04-diseno-software/Controles Smart Home ISO2 (1).docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/5db66c727eb5276548bf82ee025363d02f336cf7/docs/04-diseno-software/Controles%20Smart%20Home%20ISO2%20%281%29.docx) | docs/04-diseno-software | Pendiente de validar | Diseño/controles propuestos; no acredita aprobación, cumplimiento o tecnología activa. |
| [docs/04-diseno-software/INFORME DE DISEÑO.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/5db66c727eb5276548bf82ee025363d02f336cf7/docs/04-diseno-software/INFORME%20DE%20DISE%C3%91O.docx) | docs/04-diseno-software | Pendiente de validar | Diseño/controles propuestos; no acredita aprobación, cumplimiento o tecnología activa. |
| [docs/05-artefactos-codigo/WhatsApp Image 2026-10-09 at 9.55.06 AM.jpeg](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/a6762095edf73a8adff87092a3fbc69051335399/docs/05-artefactos-codigo/WhatsApp%20Image%202026-10-09%20at%209.55.06%20AM.jpeg) | docs/05-artefactos-codigo | Pendiente de validar | Imagen identificada por formato; contenido y contexto no interpretados. |
| [docs/06-pruebas/Plan e Informe de Ejecución de Pruebas - Smart Home.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/bde51ac4b7ff91a491bae70b99fa748edf9f4853/docs/06-pruebas/Plan%20e%20Informe%20de%20Ejecuci%C3%B3n%20de%20Pruebas%20-%20Smart%20Home.docx) | docs/06-pruebas | Enlazar | Informe histórico de ejecución; no acredita suites actuales ni resultados de esta entrega. |
| [docs/07-implementacion/Manual de Instalación y Despliegue (1).docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/2de556e8a939aea7dd53129e04fd48994d336f57/docs/07-implementacion/Manual%20de%20Instalaci%C3%B3n%20y%20Despliegue%20%281%29.docx) | docs/07-implementacion | Consolidar | Separar conocimiento transversal e instrucciones locales; reconciliar con código antes de adoptar. |
| [docs/08-mantenimiento/Acciones Correctivas, Preventivas y de Mejora (1).docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/58c65b198ebd6921fc792c01d51da2f93eff9e4d/docs/08-mantenimiento/Acciones%20Correctivas%2C%20Preventivas%20y%20de%20Mejora%20%281%29.docx) | docs/08-mantenimiento | Centralizar | Candidato a procedimiento transversal; vigencia y ejecución pendientes. |
| [docs/09-manuales/Documento Integrado de Manuales Técnico, de Instalación y de Usuario Final (1).docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/0e6b888eaeb68a7ea5e90b5e976a04f77f390a71/docs/09-manuales/Documento%20Integrado%20de%20Manuales%20T%C3%A9cnico%2C%20de%20Instalaci%C3%B3n%20y%20de%20Usuario%20Final%20%281%29.docx) | docs/09-manuales | Consolidar | Separar conocimiento transversal e instrucciones locales; reconciliar con código antes de adoptar. |
| [docs/10-articulo/Artículo Técnico - Sistema IoT Smart Home.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/10016cc86f28266163ae60670d0b947138a3d4d0/docs/10-articulo/Art%C3%ADculo%20T%C3%A9cnico%20-%20Sistema%20IoT%20Smart%20Home.docx) | docs/10-articulo | Enlazar | Antecedente académico; sin autoridad normativa sobre implementación. |
| [docs/11-despliegue/Documento_Despliegue_Smart_Home_SENA.1.2docx (1).docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/eaa7ae98c4c2204f144100cc6dd7141fcbe11f15/docs/11-despliegue/Documento_Despliegue_Smart_Home_SENA.1.2docx%20%281%29.docx) | docs/11-despliegue | Consolidar | Tres variantes tienen texto extraído idéntico; dos comparten blob exacto. Selección de original pendiente. |
| [docs/11-despliegue/Documento_Despliegue_Smart_Home_SENA.1.2docx.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/eaa7ae98c4c2204f144100cc6dd7141fcbe11f15/docs/11-despliegue/Documento_Despliegue_Smart_Home_SENA.1.2docx.docx) | docs/11-despliegue | Consolidar | Tres variantes tienen texto extraído idéntico; dos comparten blob exacto. Selección de original pendiente. |
| [docs/11-despliegue/Documento_Despliegue_Smart_Home_SENA.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/eaa7ae98c4c2204f144100cc6dd7141fcbe11f15/docs/11-despliegue/Documento_Despliegue_Smart_Home_SENA.docx) | docs/11-despliegue | Consolidar | Tres variantes tienen texto extraído idéntico; dos comparten blob exacto. Selección de original pendiente. |
| [docs/11-despliegue/Documento_Despliegue_Smart_Home_v1.0.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/eaa7ae98c4c2204f144100cc6dd7141fcbe11f15/docs/11-despliegue/Documento_Despliegue_Smart_Home_v1.0.docx) | docs/11-despliegue | Consolidar | Índice/variante de despliegue; reconciliar con Compose actual y evidencia de entorno. |
| [docs/11-despliegue/README.md](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/eaa7ae98c4c2204f144100cc6dd7141fcbe11f15/docs/11-despliegue/README.md) | docs/11-despliegue | Enlazar | Índice/variante de despliegue; reconciliar con Compose actual y evidencia de entorno. |
| [docs/12-terminos-y-condiciones/Politica_Tratamiento_Datos_Smart_Home.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/c9b51a2f56e1a3b3a3c3e73815c6a638975e1cc3/docs/12-terminos-y-condiciones/Politica_Tratamiento_Datos_Smart_Home.docx) | docs/12-terminos-y-condiciones | Pendiente de validar | Coexisten versiones y declaraciones de aprobación no verificadas independientemente; no adoptar como norma. |
| [docs/12-terminos-y-condiciones/README.md](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/c9b51a2f56e1a3b3a3c3e73815c6a638975e1cc3/docs/12-terminos-y-condiciones/README.md) | docs/12-terminos-y-condiciones | Pendiente de validar | Coexisten versiones y declaraciones de aprobación no verificadas independientemente; no adoptar como norma. |
| [docs/12-terminos-y-condiciones/SmartHome_Terminos_y_Condiciones_v2_BORRADOR.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/c9b51a2f56e1a3b3a3c3e73815c6a638975e1cc3/docs/12-terminos-y-condiciones/SmartHome_Terminos_y_Condiciones_v2_BORRADOR.docx) | docs/12-terminos-y-condiciones | Pendiente de validar | Se identifica como borrador; aceptación no acreditada. |
| [docs/12-terminos-y-condiciones/Terminos_y_Condiciones_SMART_HOME.docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/c9b51a2f56e1a3b3a3c3e73815c6a638975e1cc3/docs/12-terminos-y-condiciones/Terminos_y_Condiciones_SMART_HOME.docx) | docs/12-terminos-y-condiciones | Pendiente de validar | Coexisten versiones y declaraciones de aprobación no verificadas independientemente; no adoptar como norma. |
| [docs/12-terminos-y-condiciones/Terminos_y_Condiciones_Smart_Home (1).docx](https://github.com/Kevin-Stiven-Lopez-Amaya404/smart-home-docs/blob/c9b51a2f56e1a3b3a3c3e73815c6a638975e1cc3/docs/12-terminos-y-condiciones/Terminos_y_Condiciones_Smart_Home%20%281%29.docx) | docs/12-terminos-y-condiciones | Pendiente de validar | Coexisten versiones y declaraciones de aprobación no verificadas independientemente; no adoptar como norma. |

## Duplicación y formato confirmados

- Las variantes SENA.1.2docx (1).docx y SENA.1.2docx.docx comparten blob Git `1ce63260b8344a6f4f8f81877c6db0bea3b257c6`.
- SENA.docx tiene otro blob pero el mismo texto OOXML extraído que esas dos variantes: SHA-256 del texto `20D5A75DE110B1ABEC9CE3CFBCBB2C6B36184DC14D2F181FFD1FAF95F444C532`. Eso no prueba igualdad de imágenes o maquetación.
- El SRS con extensión .md es un paquete DOCX, no Markdown.
- El README de términos presenta caracteres de reemplazo; revisar codificación en su repositorio.
- Declaraciones internas de “aprobado” no se convirtieron en evidencia independiente de aprobación.

## Documentación de implementación

El [inventario de los cuatro componentes](inventario-implementaciones.md) enumera cada documento encontrado en los árboles inspeccionados, separando lectura de contenido y mera enumeración.

La [referencia backend](../10-arquitectura/backend/referencia-tecnica.md) se reutiliza como derivación de revisión fija, con política de actualización; no copia migraciones ni sustituye código.

## Antes de cualquier traslado

Buscar referencias en las ramas accesibles, identificar autoridad/reemplazo y actualizar vínculos. No se revisaron todos los enlaces externos entrantes ni se autoriza eliminar originales para simplificar el árbol.

Fuentes: enlaces por commit de la tabla y [mapa de revisiones](mapa-de-repositorios.md). Pendientes: revisión de autoridad, aprobación de consolidación y referencias fuera de los repositorios accesibles.
