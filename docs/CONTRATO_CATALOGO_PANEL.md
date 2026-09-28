# Contrato de interfaz: Catálogo de Eventos ↔ Panel Organizador

**Versión:** 1.0  
**Proveedor:** Panel Organizador  
**Consumidor:** Catálogo de Eventos  
**Basado en:** Diagrama de secuencia de Catálogo de Eventos  

---

## 1. Propósito

El **Catálogo de Eventos** necesita solicitar el listado de eventos próximos, realizar búsquedas o filtrados y consultar el detalle completo de un evento para desplegarlos en la aplicación web/móvil.

Por su parte, el **Panel Organizador** gestiona la creación y administración de los eventos y los expone para el consumo del Catálogo.

---

## 2. Acuerdos confirmados y Operaciones de la interfaz

### Operación 1: Solicitar eventos próximos (Carga inicial)

#### 2.1 Descripción
Obtiene el listado de los eventos próximos a realizarse para desplegar en la pantalla principal del catálogo (Home).

#### 2.2 Roles
* **Expone:** Panel Organizador
* **Consume:** Catálogo de Eventos (al cargar la pantalla principal)

#### 2.3 Endpoint
```http
GET /api/v1/organizador/eventos/proximos
```

#### 2.4 Request (Parámetros de consulta)
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `limite` | `integer` | No | Cantidad máxima de eventos a retornar (ej. 6). |

**Ejemplo Request:**
```http
GET /api/v1/organizador/eventos/proximos?limite=6
```

#### 2.5 Response
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `eventos` | `array [object]` | Sí | Lista de eventos próximos a realizarse. |

Cada elemento dentro de `eventos` contiene:

| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `id_evento` | `string` | Sí | Identificador único del evento. |
| `titulo` | `string` | Sí | Nombre del evento. |
| `lugar` | `string` | Sí | Ubicación o recinto del evento. |
| `fecha` | `string (ISO 8601)` | Sí | Fecha de realización del evento. |
| `imagen` | `string (URL)` | Sí | URL de la imagen del banner promocional. |
| `stock` | `integer` | Sí | Disponibilidad total de entradas. |
| `precio_final` | `number` | Sí | Precio final por entrada (0.0 para eventos gratuitos). |

**Ejemplo Response:**
```json
{
  "eventos": [
    {
      "id_evento": "evt-101",
      "titulo": "Feria de Innovación TITEC",
      "lugar": "Auditorio Principal",
      "fecha": "2026-09-25T10:00:00Z",
      "imagen": "https://ticketu.cl/img/evt-101.jpg",
      "stock": 150,
      "precio_final": 0.0
    }
  ]
}
```

> **Nota de diseño:** Mantiene la respuesta ligera enviando solo los datos necesarios para renderizar las tarjetas del catálogo.

#### 2.6 Códigos de error
| Código | Tratamiento / Significado |
| :--- | :--- |
| `400` | Parámetro límite inválido. |
| `500` | Error interno del Panel Organizador. |

#### 2.7 SLA
* **Tiempo de respuesta esperado:** `< 500 ms`

---

### Operación 2: Buscar eventos por filtro

#### 2.1 Descripción
Permite buscar y filtrar la lista de eventos por palabra clave, categoría, rango de fechas o estado.

#### 2.2 Roles
* **Expone:** Panel Organizador
* **Consume:** Catálogo de Eventos (cuando el usuario aplica filtros en la aplicación)

#### 2.3 Endpoint
```http
POST /api/v1/organizador/eventos/buscar
```

#### 2.4 Request (Body JSON)
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `criterio` | `string` | No | Texto de búsqueda por título o descripción. |
| `categoria` | `string` | No | Categoría del evento (ej. academico, charla, fiesta, deporte). |
| `fecha_inicio` | `string (ISO 8601)` | No | Fecha inicial para el rango de búsqueda. |
| `fecha_fin` | `string (ISO 8601)` | No | Fecha final para el rango de búsqueda. |
| `estado` | `string` | No | Filtro por estado (`'proximos'` \| `'pasados'`). |

**Ejemplo Request:**
```json
{
  "criterio": "Feria",
  "categoria": "academico",
  "estado": "proximos"
}
```

#### 2.5 Response
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `eventos` | `array [object]` | Sí | Lista de eventos que coinciden con los criterios solicitados (`[]` si no hay coincidencias). Mismo esquema de objeto que Operación 1. |

**Ejemplo Response:**
```json
{
  "eventos": [
    {
      "id_evento": "evt-101",
      "titulo": "Feria de Innovación TITEC",
      "lugar": "Auditorio Principal",
      "fecha": "2026-09-25T10:00:00Z",
      "imagen": "https://ticketu.cl/img/evt-101.jpg",
      "stock": 150,
      "precio_final": 0.0
    }
  ]
}
```

> **Nota de diseño:** Permite filtrar eventos en el backend sin sobrecargar la memoria del cliente.

#### 2.6 Códigos de error
| Código | Tratamiento / Significado |
| :--- | :--- |
| `400` | Parámetro de búsqueda inválido. |
| `500` | Error interno del Panel Organizador. |

#### 2.7 SLA
* **Tiempo de respuesta esperado:** `< 500 ms`

---

### Operación 3: Solicitar detalle de evento

#### 2.1 Descripción
Entrega la información completa y desglosada de un evento específico para su vista de detalle.

#### 2.2 Roles
* **Expone:** Panel Organizador
* **Consume:** Catálogo de Eventos (cuando el usuario selecciona un evento)

#### 2.3 Endpoint
```http
GET /api/v1/organizador/eventos/{id_evento}
```

#### 2.4 Request (Path Parameter)
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `id_evento` | `string (path)` | Sí | Identificador único del evento. |

**Ejemplo Request:**
```http
GET /api/v1/organizador/eventos/evt-101
```

#### 2.5 Response
| Campo | Tipo | Obligatorio | Descripción |
| :--- | :--- | :--- | :--- |
| `id_evento` | `string` | Sí | Identificador único del evento. |
| `titulo` | `string` | Sí | Nombre del evento. |
| `descripcion` | `string` | Sí | Descripción extendida del evento. |
| `lugar` | `string` | Sí | Recinto del evento. |
| `fecha` | `string (ISO 8601)` | Sí | Fecha de realización del evento. |
| `hora` | `string` | Sí | Hora de inicio del evento (ej. `'10:00'`). |
| `imagen` | `string (URL)` | Sí | URL del banner promocional. |
| `stock` | `integer` | Sí | Stock restante de entradas. |
| `precio_final` | `number` | Sí | Precio final por entrada. |
| `tipo_evento` | `string` | Sí | Tipo de evento (`'gratuito'` \| `'pagado'`). |
| `estado` | `string` | Sí | Estado del evento (`'disponible'`, `'agotado'`, `'pasado'`). |

**Ejemplo Response:**
```json
{
  "id_evento": "evt-101",
  "titulo": "Feria de Innovación TITEC",
  "descripcion": "Muestra anual de proyectos de ingeniería y tecnología.",
  "lugar": "Auditorio Principal",
  "fecha": "2026-09-25T10:00:00Z",
  "hora": "10:00",
  "imagen": "https://ticketu.cl/img/evt-101.jpg",
  "stock": 150,
  "precio_final": 0.0,
  "tipo_evento": "gratuito",
  "estado": "disponible"
}
```

> **Nota de diseño:** Retorna el detalle del evento permitiendo verificar si está disponible o agotado antes de iniciar la compra.

#### 2.6 Códigos de error
| Código | Tratamiento / Significado |
| :--- | :--- |
| `400` | `id_evento` ausente o inválido. |
| `404` | El evento solicitado no existe. |
| `500` | Error interno del Panel Organizador. |

#### 2.7 SLA
* **Tiempo de respuesta esperado:** `< 500 ms`

---

## 3. Reglas de uso y Responsabilidades

### 3.1 Reglas del lado consumidor (Catálogo de Eventos)
1. Al realizar la carga inicial de la Home, Catálogo solicita los eventos próximos llamando a `GET /api/v1/organizador/eventos/proximos`.
2. Cuando el usuario utiliza el buscador o selecciona filtros por categoría/fecha, Catálogo invoca `POST /api/v1/organizador/eventos/buscar`.
3. Al ingresar a la vista de detalle de un evento, Catálogo consulta `GET /api/v1/organizador/eventos/{id_evento}`.
4. Si el atributo `estado` es `'pasado'` o `'agotado'`, Catálogo deshabilita el botón de compra en la interfaz.

### 3.2 Tabla de Responsabilidades
| Responsabilidad | Servicio |
| :--- | :--- |
| Creación, edición y administración de eventos | Panel Organizador |
| Publicación y estado de vigencia del evento | Panel Organizador |
| Despliegue de tarjetas y catálogo visual | Catálogo de Eventos |
| Filtrado y renderizado del catálogo para clientes | Catálogo de Eventos |

---

## 4. Versionado y cambios

* Cualquier cambio en la forma del request/response de esta operación debe ser versionado (ej. `v1`, `v2`) y comunicado con anticipación al equipo consumidor.
* Cambios que rompan compatibilidad (*breaking changes*) requieren un período de transición acordado entre ambos equipos.

---

## 5. Dueños del contrato

| Rol | Equipo | Contacto |
| :--- | :--- | :--- |
| **Dueño del contrato** | Panel Organizador | Integrador Equipo 1 |
| **Consumidor principal** | Catálogo de Eventos | Integrador Equipo 7 |

---

## 6. Acuerdos y Decisiones Tomadas

* [x] Protocolo de comunicación acordado en HTTP REST síncrono.
* [x] Tiempo de respuesta máximo estipulado en `< 500 ms`.
