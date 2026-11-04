# Pruebas de Calidad — Evaluación 2

**Proyecto:** TicketU — Catálogo de Eventos  
**Equipo:** 7  
**Rol:** Calidad (QA)

## 1. Objetivo

Verificar el funcionamiento de las integraciones entre Catálogo de Eventos y los módulos externos, mediante pruebas exitosas y de error, comprobando que las respuestas obtenidas coincidan con los resultados esperados.

## 2. Casos de prueba

### Integración I1 — Panel Organizador

**Tipo A: Servicio consumido**

Endpoint: `GET /api/v1/organizador/eventos/proximos`

| ID | Caso de prueba | Resultado esperado |
|---|---|---|
| CP01 | Consultar eventos próximos desde Catálogo | HTTP 200 del servicio de Panel y visualización correcta de los eventos recibidos en Catálogo. |
| CP02 | Servicio de Panel no disponible | Catálogo maneja el error sin interrumpir inesperadamente la aplicación. |

### Integración I2 — Entradas/Inventario

**Tipo B: Servicio ofrecido**

Endpoint: `PUT /api/catalogo/eventos/:id/stock`

| ID | Caso de prueba | Resultado esperado |
|---|---|---|
| CP03 | Actualización válida de stock solicitada por Entradas | HTTP 200 y stock actualizado correctamente en la base de datos. |
| CP04 | Actualización con stock negativo | HTTP 400 y el stock del evento permanece sin cambios. |
| CP05 | Actualización de evento inexistente | HTTP 404. |
| CP06 | Solicitud sin token de sesión | HTTP 401. |

## 3. Registro de resultados

| Prueba | Resultado obtenido | Estado | Evidencia |
|---|---|---|---|
| CP01 | Pendiente | No ejecutada | Pendiente |
| CP02 | Pendiente | No ejecutada | Pendiente |
| CP03 | Pendiente | No ejecutada | Pendiente |
| CP04 | Pendiente | No ejecutada | Pendiente |
| CP05 | Pendiente | No ejecutada | Pendiente |
| CP06 | Pendiente | No ejecutada | Pendiente |

## 4. Evidencias

Las pruebas se ejecutarán mediante Postman y se documentarán mediante capturas de pantalla o resultados exportados, indicando la fecha de ejecución.

Para cada integración se verificará su comunicación efectiva con el microservicio real correspondiente.

**Nota:** Los casos se marcarán como aprobados únicamente cuando el resultado obtenido coincida con el esperado y exista evidencia de ejecución.
