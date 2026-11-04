# Declaracion de Integraciones - Evaluacion 2 (TITEC)

Conforme a las secciones 2, 3 y 4 de la Especificacion de Evaluacion 2: Interoperabilidad, el equipo Catalogo de Eventos (Equipo 7) declara las dos integraciones efectivas implementadas para el proyecto:

---

## Tabla de Declaracion de Integraciones

| Integracion | Tipo (A, B o C) | Modulo contraparte | Servicio, endpoint o topico | Contrato (ruta en el repo) | Item en GitHub |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **I1** | **Tipo A** (Servicio Consumido) | Panel Organizador (Equipo 1) | `GET /api/v1/organizador/eventos/proximos` | [Contrato_Catalogo_PanelOrganizador.docx](docs/Contrato_Catalogo_PanelOrganizador.docx) | https://github.com/Equipo-7-Catalogo-de-eventos/Catalogo_de_eventos/issues/10 |
| **I2** | **Tipo B** (Servicio Ofrecido) | Entradas / Inventario (Equipo 2) | `PUT /api/catalogo/eventos/:id/stock` | [Contrato_Entradas_Catalogo_v4.docx](docs/Contrato_Entradas_Catalogo_v4.docx) | https://github.com/Equipo-7-Catalogo-de-eventos/Catalogo_de_eventos/issues/12 |

---

## Detalle Tecnico de las Integraciones

### Integracion I1 - Consulta de Eventos Proximos desde Panel Organizador
* **Tipo de integracion:** Tipo A (Servicio consumido por Catalogo desde Panel Organizador).
* **Proposito:** Catalogo de Eventos consume los eventos publicados por el Panel Organizador para desplegar la vitrina publica de eventos.
* **Endpoint consumido en Panel Organizador:** `GET /api/v1/organizador/eventos/proximos` (implementado en el repositorio de Panel Organizador en `backend/src/modules/integraciones/integration.routes.ts`).
* **Metodo HTTP:** GET.
* **Parametros de consulta:** `limite` (entero opcional, por defecto 6).
* **Respuesta procesada:** Lista de objetos de eventos con los campos `id_evento`, `nombre_evento`, `descripcion`, `direccion_evento`, `fecha_evento`, `hora_evento`, `imagen`, `categoria`, `precio`, `tipo_entrada` y `estado_disponibilidad`.
* **Resiliencia y tolerancia a fallos:** Implementado mediante timeout SLA de 500 ms y mecanismo de degradacion elegante (fallback local) para mantener la disponibilidad del catalogo si el servicio de Panel sufre latencia o desconexion.

---

### Integracion I2 - Actualizacion de Stock desde Entradas
* **Tipo de integracion:** Tipo B (Servicio ofrecido por Catalogo y consumido por Entradas).
* **Proposito:** Cuando el modulo de Entradas e Inventario procesa una compra o reserva, invoca este endpoint en Catalogo para descontar el stock disponible y actualizar el estado a 'agotado' si llega a cero.
* **Endpoint expuesto en Catalogo:** `PUT /api/catalogo/eventos/:id/stock` (alias retrocompatible: `/api/v1/catalogo/eventos/:id/stock`).
* **Metodo HTTP:** PUT.
* **Payload JSON recibido:**
  ```json
  {
    "nuevo_stock": 144,
    "token_sesion": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
  ```
* **Respuesta emitida:** HTTP 200 OK con mensaje de confirmacion y datos del evento actualizado.
* **Persistencia en base de datos:** Actualiza las columnas `stock_actual` y `estado_evento` en la tabla `eventos` de PostgreSQL / Supabase.
* **Manejo de errores:**
  - HTTP 400 Bad Request si el stock es invalido (negativo o no entero).
  - HTTP 401 Unauthorized si no se incluye el token de sesion.
  - HTTP 404 Not Found si el ID de evento no existe en la base de datos.
