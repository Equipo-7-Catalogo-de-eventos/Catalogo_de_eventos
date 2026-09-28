# Milestones y Planificación del Proyecto (Hitos)

Microservicio: **Catálogo de Eventos** — **Equipo 7**

---

## Resumen de Hitos

| Hito | Nombre | Estado | Descripción |
| :--- | :--- | :---: | :--- |
| **Hito 1** | Definición de Contratos y Arquitectura | **Completado** | Especificación de contratos de interfaz con Panel Organizador, Reseñas y Entradas/Inventario. Diagrama de secuencia general. |
| **Hito 2** | Modelado de Datos y Backend Base | **Completado** | Creación de modelo de datos PostgreSQL en Supabase (`schema_db.sql`), creación del microservicio Node.js/Express (`ms-catalogo-eventos`) con Swagger. |
| **Hito 3** | Integración de Servicios | **En progreso** | Consumo y validación de endpoints interservicios: consulta de eventos a Panel, calificaciones a Reseñas y reserva a Entradas. |
| **Hito 4** | Pruebas y Despliegue | **Pendiente** | Pruebas end-to-end (E2E), manejo de fallos y resiliencia (Fail-Secure / Graceful Degradation), despliegue en ambiente cloud. |

---

## Detalle de Hitos

### Hito 1: Definición de Contratos y Diagramas
* [x] Diagrama de secuencia general de Catálogo de Eventos documentado en `README.md` y `docs/diagrams/`.
* [x] Contrato de interfaz con **Panel Organizador** (`docs/CONTRATO_CATALOGO_PANEL.md`).
* [x] Contrato de interfaz con **Reseñas** (`docs/CONTRATO_CATALOGO_RESENAS.md`).
* [x] Contrato de interfaz con **Entradas / Inventario** (solicitud de compra: `docs/CONTRATO_CATALOGO_ENTRADAS.md`).
* [x] Contrato de interfaz con **Entradas / Inventario** (actualización de stock: `docs/CONTRATO_ENTRADAS_CATALOGO.md`).

### Hito 2: Base de Datos y Microservicio
* [x] Diseño relacional en Supabase con índices aceleradores (`schema_db.sql`).
* [x] Repositorio independiente de código del microservicio en [ms-catalogo-eventos](https://github.com/Equipo-7-Catalogo-de-eventos/ms-catalogo-eventos).
* [x] Endpoints CRUD para eventos, filtros de búsqueda y actualización de stock.
* [x] Documentación interactiva en Swagger OpenAPI (`/api-docs`).

### Hito 3: Integración entre Microservicios
* [ ] Conexión HTTP REST síncrona con el microservicio de Panel Organizador para carga de eventos próximos.
* [ ] Integración resiliente con el microservicio de Reseñas (fallback en caso de indisponibilidad).
* [ ] Validación de tokens de sesión y trazabilidad en la compra con Entradas/Inventario.

### Hito 4: Pruebas y Entrega Final
* [ ] Pruebas unitarias y de integración de endpoints.
* [ ] Verificación de SLAs (tiempos de respuesta menores a 500 ms).
* [ ] Despliegue en contenedor/cloud y entrega final.
