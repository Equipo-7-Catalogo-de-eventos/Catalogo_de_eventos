
# Contrato de interfaz: Reseñas ↔ Catálogo de Eventos

**Versión:** 1.0  
**Estado:** Propuesto  
**Proveedor:** Catálogo de Eventos  
**Consumidor:** Reseñas (Equipo 6)  
**Basado en:** HU-01 (Reseñar evento asistido) y HU-02 (Adjuntar imagen a la reseña).

---

## 1. Propósito

El módulo de Reseñas requiere información básica de los eventos para mostrarla junto a las reseñas publicadas y validar la existencia del evento antes de habilitar el flujo de reseña.

Catálogo de Eventos proporciona los datos necesarios sin compartir información interna de gestión, salvo acuerdo explícito entre ambos equipos.

---

## 2. Operación: Obtener datos del evento

### 2.1 Descripción

Dado un identificador de evento, retorna los datos mínimos necesarios para mostrarlos en el contexto de una reseña.

### 2.2 Roles

- **Expone:** Catálogo de Eventos.
- **Consume:** Reseñas, al habilitar el formulario de reseña y mostrar una reseña publicada.

### 2.3 Endpoint propuesto

`GET /eventos/{eventoId}`

Se propone utilizar HTTP REST síncrono. El protocolo y la ruta definitiva deben acordarse entre ambos equipos.

### 2.4 Request (Path Parameter)

| Campo | Tipo | Obligatorio | Descripción |
| --- | --- | --- | --- |
| `eventoId` | string | Sí | Identificador único del evento. |

**Ejemplo Request:**

```http
GET /eventos/e-98765
```

### 2.5 Response

| Campo | Tipo | Obligatorio | Descripción |
| --- | --- | --- | --- |
| `eventoId` | string | Sí | Identificador único del evento. |
| `nombre` | string | Sí | Nombre del evento. |
| `fecha` | string (ISO 8601) | Sí | Fecha de realización del evento. |
| `tipo` | string | Sí | Tipo o categoría del evento (gratuito, pagado). |
| `existe` | boolean | Sí | Indica si el evento existe en Catálogo. |

**Ejemplo Response (evento existente):**

```json
{
  "eventoId": "e-98765",
  "nombre": "Feria de Innovación TITEC",
  "fecha": "2026-09-21",
  "tipo": "gratuito",
  "existe": true
}
```

**Ejemplo Response (evento inexistente):**

```json
{
  "eventoId": "e-98765",
  "existe": false
}
```

> **Nota de diseño:** Catálogo de Eventos proporciona únicamente los datos necesarios para contextualizar la reseña. No se comparte información interna de gestión sin un acuerdo explícito entre ambos equipos.

### 2.6 Códigos de error

| Código | Significado |
| --- | --- |
| `400` | Identificador del evento ausente o inválido. |
| `404` | Evento inexistente en Catálogo. |
| `500` | Error interno del servicio de Catálogo de Eventos. |

### 2.7 SLA

- **Tiempo de respuesta propuesto:** Inferior a 300 ms.
- **Estado:** Pendiente de acuerdo entre ambos equipos.

---

## 3. Reglas de uso y responsabilidades

### 3.1 Reglas del lado consumidor (Reseñas)

1. Antes de habilitar o mostrar una reseña, Reseñas puede consultar el identificador del evento para validar su existencia y obtener su nombre, fecha y tipo.
2. Si el campo `existe` es `false`, Reseñas no debe permitir crear ni mostrar una reseña asociada al evento.
3. El campo `tipo` se utiliza únicamente como contexto visual. Las reglas de reseña son independientes de si el evento es gratuito o pagado.

### 3.2 Tabla de responsabilidades

| Responsabilidad | Módulo |
| --- | --- |
| Proporcionar información básica del evento | Catálogo de Eventos |
| Validar la existencia del evento mediante el servicio | Reseñas |
| Mostrar la información asociada a la reseña | Reseñas |
| Gestionar la creación y visualización de reseñas | Reseñas |

---

## 4. Versionado y cambios

- Los cambios en la estructura de las solicitudes o respuestas deben versionarse y comunicarse previamente al módulo consumidor.
- Los cambios que rompan la compatibilidad requieren un período de transición acordado entre ambos equipos.

---

## 5. Dueños del contrato

| Rol | Equipo | Contacto |
| --- | --- | --- |
| Dueño del contrato | Catálogo de Eventos | Integrador Equipo 7 |
| Consumidor principal | Reseñas | constanzadiaz03 y equipo |

---

## 6. Acuerdos pendientes

- [ ] Confirmar el protocolo de comunicación.
- [ ] Confirmar la ruta definitiva del endpoint.
- [ ] Confirmar el mecanismo de autenticación.
- [ ] Confirmar los campos adicionales requeridos.
- [ ] Confirmar el SLA de respuesta.
- [ ] Confirmar el manejo de reintentos ante indisponibilidad de Catálogo de Eventos.
