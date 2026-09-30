# Contrato de interfaz: Entradas / Inventario ↔ Catálogo de Eventos

**Versión:** 3.0  
**Proveedor:** Catálogo de Eventos  
**Consumidor:** Entradas / Inventario  
**Basado en:** Diagrama de Secuencia "Proceso de Compra" (Distribución Paralela)  

---

## 1. Propósito

El equipo de **Entradas / Inventario** (consumidor) necesita enviar el stock actualizado al microservicio de **Catálogo de Eventos** (proveedor) después de concretar una compra o emisión de entradas exitosa.

Esto permite que el Catálogo refresque su base de datos de lectura (vista) y muestre la disponibilidad real a los clientes que están navegando de manera rápida y sin tener que consultar a Entradas en cada momento.

---

## 2. Acuerdos confirmados y Operaciones de la interfaz

### Operación: Actualizar Stock (`confirmar_compra_exitosa`)

#### 2.1 Descripción
Actualiza la cantidad de entradas disponibles (`nuevo_stock`) de un evento específico para mantener la consistencia eventual entre la fuente de verdad (Inventario) y la vista de cliente (Catálogo).

#### 2.2 Roles
* **Expone:** Equipo Catálogo de Eventos
* **Consume:** Equipo Entradas / Inventario (en el bloque de "Distribución Paralela" de la Fase 3, inmediatamente después de descontar el stock en su propia base de datos)

#### 2.3 Endpoint
```http
PUT /api/v1/catalogo/eventos/{id_evento}/stock
```

#### 2.4 Request (URL Params y Body JSON)
| Campo | Tipo | Ubicación | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `id_evento` | `string` | URL Path | Sí | Identificador del evento a actualizar. |
| `nuevo_stock` | `integer` | Body JSON | Sí | El valor absoluto del stock restante. |
| `token_sesion` | `string` | Headers o Body | Sí | Token de sesión del usuario para trazabilidad y validación. |

**Ejemplo Body:**
```json
{
  "nuevo_stock": 148,
  "token_sesion": "eyJhbGciOiJIUzI1NiIsInR5cCI6..."
}
```

#### 2.5 Response
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `mensaje` | `string` | No | Confirmación de la actualización (o HTTP 204 No Content). |

**Ejemplo Response:**
```json
{
  "mensaje": "Stock de Catálogo actualizado correctamente"
}
```

#### 2.6 Códigos de error
| Código | Tratamiento / Significado |
| :--- | :--- |
| `400` | Datos inválidos (ej. stock con formato incorrecto o token faltante). |
| `401` | No autorizado. Token de sesión no válido o ausente. |
| `404` | Evento no existe en la base de datos de Catálogo. |
| `500` | Error interno en Catálogo al actualizar. |

#### 2.7 SLA
* **Tiempo de respuesta esperado:** `< 500 ms`

---

## 3. Reglas de uso y Responsabilidades

### 3.1 Reglas del lado consumidor (Entradas / Inventario)
1. **Valor absoluto:** Entradas debe enviar el stock exacto restante (la fuente de verdad), no la cantidad descontada.
2. **Ejecución no bloqueante:** Entradas ejecuta esta llamada en paralelo a la comunicación con Check-in y Notificaciones para no demorar la respuesta final al cliente.
3. **Resiliencia:** Si la comunicación falla, Entradas genera un log o un mecanismo de reintento para mantener la consistencia eventual.
4. **Trazabilidad de sesión:** Entradas envía explícitamente el token de sesión a Catálogo de Eventos para asegurar la procedencia y mantener la trazabilidad del usuario en la auditoría.

### 3.2 Tabla de Responsabilidades
| Responsabilidad | Servicio |
| :--- | :--- |
| Mantener la fuente de verdad del inventario de entradas | Entradas / Inventario |
| Notificar actualizaciones de stock tras transacciones confirmadas | Entradas / Inventario |
| Mantener el caché/vista optimizada de lectura para los visitantes | Catálogo de Eventos |
| Actualizar estado de visualización a 'agotado' al recibir stock 0 | Catálogo de Eventos |

---

## 4. Versionado y cambios

* Cualquier modificación en los tipos de datos del stock o el ID del evento debe comunicarse con anticipación.
* Cambios que rompan compatibilidad (*breaking changes*) requieren un período de transición acordado entre ambos equipos.

---

## 5. Dueños del contrato

| Rol | Equipo | Contacto |
| :--- | :--- | :--- |
| **Dueño del contrato** | Catálogo de Eventos | Integrador Equipo 7 |
| **Consumidor principal** | Entradas / Inventario | Sebastián Fuentes (Scrum Master - Equipo 3) |

---

## 6. Acuerdos y Decisiones Tomadas

* [x] **Resolución HU5 / Protocolo:** Se confirma entre Catálogo y Entradas que la actualización de stock se realiza estrictamente vía HTTP REST (`PUT /api/catalogo/eventos/{id_evento}/stock`). Aunque la descripción inicial de HU5 mencionaba la posibilidad de un broker de mensajería (RabbitMQ/Kafka), por mutuo acuerdo técnico y para garantizar consistencia y el SLA de respuesta (< 500 ms) sin sobrecarga de infraestructura, se descartó el broker y se formalizó el uso de HTTP REST síncrono.
* [x] **Regla de agotado automático:** Si `nuevo_stock === 0`, Catálogo actualiza de inmediato el estado del evento a `'agotado'`. Si `nuevo_stock > 0` y estaba agotado, se reactiva a `'disponible'`.
* [x] Se confirma que Catálogo no necesita ningún dato adicional del evento, solo el campo `nuevo_stock` y el `token_sesion`.

