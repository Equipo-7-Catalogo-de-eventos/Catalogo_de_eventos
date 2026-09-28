# Contrato de interfaz: Catálogo de Eventos ↔ Reseñas

**Versión:** 1.0  
**Proveedor:** Reseñas  
**Consumidor:** Catálogo de Eventos  
**Basado en:** Diagrama de secuencia de Catálogo de Eventos  

---

## 1. Propósito

El **Catálogo de Eventos** necesita solicitar las calificaciones básicas y reseñas detalladas para desplegar puntajes y opiniones en sus listados y vista de detalle.

Por su parte, el microservicio de **Reseñas** entrega los promedios de estrellas, la cantidad total de valoraciones y el listado de comentarios registrados para cada evento.

---

## 2. Acuerdos confirmados y Operaciones de la interfaz

### Operación 1: Solicitar calificaciones básicas

#### 2.1 Descripción
Obtiene la calificación promedio y la cantidad total de opiniones para una lista de eventos en la carga inicial y en los filtros de búsqueda.

#### 2.2 Roles
* **Expone:** Equipo Reseñas
* **Consume:** Equipo Catálogo de Eventos (en la carga inicial de eventos próximos o filtros de búsqueda)

#### 2.3 Endpoint
```http
POST /api/v1/resenas/calificaciones-basicas
```

#### 2.4 Request (Body JSON)
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `lista_id_eventos` | `array [string]` | Sí | Lista con los identificadores de los eventos a consultar. |

**Ejemplo Request:**
```json
{
  "lista_id_eventos": ["evt-101", "evt-102"]
}
```

#### 2.5 Response
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `calificaciones` | `object` | Sí | Mapa de resultados organizado por `id_evento` con su `promedio` (`number \| null`) y `total_resenas` (`integer`). |

**Ejemplo Response:**
```json
{
  "calificaciones": {
    "evt-101": {
      "promedio": 4.5,
      "total_resenas": 12
    },
    "evt-102": {
      "promedio": null,
      "total_resenas": 0
    }
  }
}
```

> **Nota de diseño:** No se comparten comentarios ni identidades de usuarios para evitar cargas pesadas de red durante la renderización inicial del catálogo.

#### 2.6 Códigos de error
| Código | Tratamiento / Significado |
| :--- | :--- |
| `400` | Parámetro ausente o inválido (ej. `lista_id_eventos` vacía). |
| `404` | Recurso no encontrado. |
| `500` | Error interno del servicio de Reseñas. |

#### 2.7 SLA
* **Tiempo de respuesta esperado:** `< 500 ms`

---

### Operación 2: Consultar reseñas completas de un evento

#### 2.1 Descripción
Entrega la calificación promedio, el total de opiniones y el listado de comentarios ordenados de más reciente a menos reciente para la vista de detalle de un evento específico.

#### 2.2 Roles
* **Expone:** Equipo Reseñas
* **Consume:** Equipo Catálogo de Eventos (cuando el usuario selecciona un evento para ver su detalle)

#### 2.3 Endpoint
```http
GET /api/v1/resenas/evento/{id_evento}
```

#### 2.4 Request (Path Parameter)
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `id_evento` | `string (path)` | Sí | Identificador único del evento a consultar. |

**Ejemplo Request:**
```http
GET /api/v1/resenas/evento/evt-101
```

#### 2.5 Response
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `id_evento` | `string` | Sí | Identificador único del evento. |
| `promedio` | `number \| null` | Sí | Calificación promedio del evento (`null` si no tiene reseñas aún). |
| `total_resenas` | `integer` | Sí | Cantidad total de reseñas del evento. |
| `resenas` | `array [object]` | Sí | Listado de reseñas ordenado de más reciente a menos reciente (`[]` si no hay). |

Cada elemento dentro de `resenas` contiene:

| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `usuario_id` | `string` | Sí | Identificador del usuario que escribió la reseña. |
| `calificacion` | `integer` | Sí | Calificación en estrellas (1 a 5). |
| `comentario` | `string` | No | Comentario opcional dejado por el usuario. |
| `fecha` | `string (ISO 8601)` | Sí | Fecha y hora de publicación de la reseña. |

**Ejemplo Response (evento con reseñas):**
```json
{
  "id_evento": "evt-101",
  "promedio": 4.8,
  "total_resenas": 3,
  "resenas": [
    {
      "usuario_id": "usr-501",
      "calificacion": 5,
      "comentario": "Excelente organización y gran nivel de expositores.",
      "fecha": "2026-09-08T18:30:00Z"
    }
  ]
}
```

**Ejemplo Response (evento sin reseñas):**
```json
{
  "id_evento": "evt-102",
  "promedio": null,
  "total_resenas": 0,
  "resenas": []
}
```

> **Nota de diseño:** No se comparten datos personales del usuario (correo o teléfono) para resguardar la privacidad, entregando solo la información necesaria para renderizar la opinión.

#### 2.6 Códigos de error
| Código | Tratamiento / Significado |
| :--- | :--- |
| `400` | `id_evento` ausente o con formato inválido. |
| `404` | El evento solicitado no existe. |
| `500` | Error interno del servicio de Reseñas. |

#### 2.7 SLA
* **Tiempo de respuesta esperado:** `< 500 ms`

---

## 3. Reglas de uso y Responsabilidades

### 3.1 Reglas del lado consumidor (Catálogo de Eventos)
1. Al cargar el Home o aplicar filtros de búsqueda, Catálogo solicita las calificaciones en bloque mediante `POST /api/v1/resenas/calificaciones-basicas`.
2. Al ingresar a la pantalla de detalle de un evento, Catálogo consulta las opiniones individuales mediante `GET /api/v1/resenas/evento/{id_evento}`.
3. Si la respuesta del microservicio de Reseñas falla o da timeout, Catálogo muestra *"Sin calificaciones aún"* o deshabilita la sección de opiniones sin interrumpir el flujo de reserva ni la compra (patrón *Graceful Degradation*).

### 3.2 Tabla de Responsabilidades
| Responsabilidad | Servicio |
| :--- | :--- |
| Almacenar calificaciones y comentarios de usuarios | Reseñas |
| Cálculo de promedios ponderados y totales | Reseñas |
| Despliegue visual de estrellas y comentarios | Catálogo de Eventos |
| Resiliencia ante caída del servicio de opiniones | Catálogo de Eventos |

---

## 4. Versionado y cambios

* Cualquier cambio en la forma del request/response de esta operación debe ser versionado (ej. `v1`, `v2`) y comunicado con anticipación al equipo consumidor.
* Cambios que rompan compatibilidad (*breaking changes*) requieren un período de transición acordado entre ambos equipos.

---

## 5. Dueños del contrato

| Rol | Equipo | Contacto |
| :--- | :--- | :--- |
| **Dueño del contrato** | Reseñas | Integrador Equipo 6 |
| **Consumidor principal** | Catálogo de Eventos | Integrador Equipo 7 |

---

## 6. Acuerdos y Decisiones Tomadas

* [x] Protocolo de comunicación acordado en HTTP REST síncrono.
* [x] Tiempo de respuesta máximo estipulado en `< 500 ms`.
