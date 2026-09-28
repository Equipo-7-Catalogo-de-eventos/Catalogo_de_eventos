# Contrato de interfaz: Catálogo de Eventos ↔ Entradas / Inventario

**Versión:** 2.0  
**Proveedor:** Entradas / Inventario  
**Consumidor:** Catálogo de Eventos  
**Basado en:** Diagrama de secuencia de Catálogo de Eventos  

---

## 1. Propósito

El **Catálogo de Eventos** necesita solicitar el procesamiento de compra de entradas para gestionar la reserva del cliente y mantener actualizado el inventario del evento.

Por su parte, **Entradas / Inventario** procesa la orden y devuelve la confirmación de la transacción junto con la disponibilidad restante.

---

## 2. Acuerdos confirmados y Operaciones de la interfaz

### Operación: Procesar compra de entradas

#### 2.1 Descripción
Inicia la reserva y el flujo de procesamiento de compra de las entradas seleccionadas por el cliente.

#### 2.2 Roles
* **Expone:** Equipo Entradas / Inventario
* **Consume:** Equipo Catálogo de Eventos (en el momento en que el cliente selecciona la cantidad de entradas y confirma la compra en la pantalla del evento)

#### 2.3 Endpoint
```http
POST /api/v1/entradas/procesar-compra
```

#### 2.4 Request (Body JSON)
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `id_evento` | `string` | Sí | Identificador único del evento seleccionado. |
| `tipo_entrada` | `string` | Sí | Tipo de entrada seleccionada (ej. General, VIP). |
| `cantidad` | `integer` | Sí | Cantidad de entradas a comprar. |
| `token_sesion` | `string` | Sí | Token de autenticación del cliente en sesión. |

**Ejemplo Request:**
```json
{
  "id_evento": "evt-101",
  "tipo_entrada": "General",
  "cantidad": 2,
  "token_sesion": "tok-999"
}
```

#### 2.5 Response
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `nuevo_stock` | `integer` | Sí | Cantidad de entradas que quedan disponibles tras procesar la compra. |

**Ejemplo Response:**
```json
{
  "nuevo_stock": 148
}
```

> **Nota de diseño:** Catálogo solo envía la solicitud de compra y recibe la actualización del stock, sin manejar datos sensibles de pago.

#### 2.6 Códigos de error
| Código | Tratamiento / Significado |
| :--- | :--- |
| `400` | Parámetro ausente o inválido (ej. cantidad <= 0). |
| `401` | Token de sesión del cliente no válido o expirado. |
| `404` | El evento o el tipo de entrada solicitado no existe. |
| `500` | Error interno del servicio de Entradas / Inventario. |

#### 2.7 SLA
* **Tiempo de respuesta esperado:** `< 300 ms`

---

## 3. Reglas de uso y Responsabilidades

### 3.1 Reglas del lado consumidor (Catálogo de Eventos)
1. El Catálogo de Eventos invoca el endpoint `POST /api/v1/entradas/procesar-compra` únicamente cuando el cliente confirma la selección de entradas.
2. Al recibir `200 OK`, el Catálogo actualiza la disponibilidad en la base de datos local con el valor de `nuevo_stock`.
3. El Catálogo actualiza la vista a `'AGOTADO'` en pantalla si `nuevo_stock` es 0; si ocurre un error, muestra una alerta al usuario.

### 3.2 Tabla de Responsabilidades
| Responsabilidad | Servicio |
| :--- | :--- |
| Validación de existencias y reserva de asientos/tickets | Entradas / Inventario |
| Generación de tickets e interacción con pasarela/notificaciones | Entradas / Inventario |
| Inicio del flujo de compra desde la UI del evento | Catálogo de Eventos |
| Actualización visual del stock disponible para los visitantes | Catálogo de Eventos |

---

## 4. Versionado y cambios

* Cualquier cambio en la forma del request/response de esta operación debe ser versionado (ej. `v1`, `v2`) y comunicado con anticipación al equipo consumidor.
* Cambios que rompan compatibilidad (*breaking changes*) requieren un período de transición acordado entre ambos equipos.

---

## 5. Dueños del contrato

| Rol | Equipo | Contacto |
| :--- | :--- | :--- |
| **Dueño del contrato** | Entradas / Inventario | Integrador Equipo 3 |
| **Consumidor principal** | Catálogo de Eventos | Integrador Equipo 7 |

---

## 6. Acuerdos y Decisiones Tomadas

* [x] **Protocolo de Comunicación:** La comunicación entre ambos microservicios será HTTP REST síncrono en ambas direcciones:
  * Catálogo ➔ Entradas: `POST /api/v1/entradas/procesar-compra` (para solicitar la reserva).
  * Entradas ➔ Catálogo: `PUT /api/v1/catalogo/eventos/{id_evento}/stock` (para actualizar el stock).
* [x] **Acuerdos de Nivel de Servicio (SLA):** El tiempo máximo de respuesta esperado para las solicitudes entre ambos microservicios será menor a 500 ms.
