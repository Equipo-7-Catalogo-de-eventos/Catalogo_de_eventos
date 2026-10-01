## 3. Diccionario de Datos: Tabla `eventos`


* **Descripción:** Almacena la consolidación de la información de los eventos para maximizar la velocidad de lectura del catálogo. No genera datos propios, recibe información del Panel Organizador, Entradas y Reseñas.

| Nombre del Campo | Tipo de Dato (PostgreSQL) | Nulo / Obligatorio | Llave | Valor por Defecto | Descripción y Reglas de Negocio |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `id_evento` | `VARCHAR` | **NOT NULL** | PK | *Ninguno* | El código único del evento (como si fuera su RUT). Provisto por el Panel Organizador. Regla: **UNICO**. |
| `nombre_evento` | `VARCHAR` | **NOT NULL** | - | *Ninguno* | El nombre del evento que verán los usuarios en la página. |
| `descripcion_evento` | `TEXT` | **NOT NULL** | - | *Ninguno* | El texto largo que explica el evento. De aquí busca las palabras clave la barra de búsqueda. |
| `lugar_evento` | `VARCHAR` | **NOT NULL** | - | *Ninguno* | Dónde se hace (la dirección física o el link si es online). |
| `fecha_evento` | `TIMESTAMPTZ` | **NOT NULL** | - | *Ninguno* | El día exacto en que se realiza el evento. |
| `hora_evento` | `VARCHAR` | **NOT NULL** | - | *Ninguno* | A qué hora empieza. |
| `imagen_evento` | `VARCHAR` | **NOT NULL** | - | *Ninguno* | El link de la foto o afiche promocional. |
| `precio_final_evento` | `NUMERIC` | **NOT NULL** | - | *Ninguno* | Cuánto cuesta la entrada. Si dice 0, significa que es gratis. |
| `tipo_evento` | `VARCHAR` | **NOT NULL** | - | *Ninguno* | Define estrictamente la modalidad. Valores permitidos mediante `CHECK`: `gratuito`, `pagado`. |
| `categoria_evento` | `VARCHAR` | **NULLABLE** | - | `NULL` | La etiqueta para que funcionen los filtros (ejemplo: 'fiesta', 'deporte', 'taller'). |
| `estado_evento` | `VARCHAR` | **NOT NULL** | - | *Ninguno* | Avisa en qué estado está el evento para cambiar color o bloquear compra. Valores permitidos mediante `CHECK`: `disponible`, `agotado`, `pasado`, `cancelado`. |
| `stock_actual` | `INTEGER` | **NOT NULL** | - | *Ninguno* | Cuántas entradas quedan disponibles (dato de Entradas). Regla: `CHECK (>= 0)`. |
| `promedio_calificacion` | `NUMERIC` | **NOT NULL** | - | `0` | La nota promedio en estrellas (dato de Reseñas). |
| `total_resenas` | `INTEGER` | **NOT NULL** | - | `0` | Cuánta gente ha dejado su opinión (dato de Reseñas). |
| `fecha_creacion` | `TIMESTAMPTZ` | **NOT NULL** | - | `now()` | La fecha y hora automática de cuándo creamos este evento en el sistema. Actualizado vía `timezone('utc', now())`. |

> **Nota de Integración:** Nuestro microservicio no crea ni genera ningún dato, sino que consolida la información que nos envían otros tres equipos en un solo lugar. Panel Organizador envía detalles estructurales, Entradas actualiza el stock, y Reseñas inyecta el promedio de calificaciones.
