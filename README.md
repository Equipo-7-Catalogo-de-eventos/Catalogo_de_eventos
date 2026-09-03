# Sistema de Catálogo y Gestión de Eventos

## Información del Equipo

* **Grupo 7:** [Catalogo de Eventos]
* **Integrantes:**
  * **Nombre:** [Amalia Toledo] — **Correo:** `[amalia.toledo@estudiantes.uv.cl]`
  * **Nombre:** [Maximiliano Rozas] — **Correo:** `[maximiliano.rozas@estudiantes.uv.cl]`
  * **Nombre:** [Anaís Muñoz] — **Correo:** `[anais.munozm@estudiantes.uv.cl]`
  * **Nombre:** [Diego Valenzuela] — **Correo:** `[diego.valenzuelap@estudiantes.uv.cl]`

---

## Diagrama de Secuencia

```mermaid
sequenceDiagram
    actor Usuario
    participant Sistema as Sistema (Catálogo)
    participant ModOrganizador as Módulo Panel Organizador
    participant ModResenas as Módulo Reseñas
    autonumber

    %% Flujo 1: Carga Inicial de Catálogo con los 6 eventos más próximos (HU1)
    Note over Usuario,ModOrganizador: 1. Carga Inicial: 6 Eventos Próximos (HU1)
    Usuario->>Sistema: Ver catálogo
    Sistema->>ModOrganizador: soloicitar_eventos_proximos()
    Note over ModOrganizador: Incluye título, lugar, fecha, imagen, stock y precio final (con promoción aplicada)
    ModOrganizador-->>Sistema: Retorna listado de eventos con todos sus datos
    Sistema-->>Usuario: Despliega catálogo con las tarjetas de los 6 eventos más próximos

    %% Flujo 2: Búsqueda, Filtros y Eventos Pasados (HU1, HU2, HU3)
    Note over Usuario,Sistema: 2. Exploración y Filtros (HU1, HU2, HU3)
    opt Filtrar por pasados, categorías o búsqueda
        Usuario->>Sistema: Aplica filtro (ver pasados, fechas o palabra clave)
        Sistema-->>Usuario: Muestra resultados correspondientes (con etiqueta "Finalizado" si aplica)
    end

    %% Flujo 3: Detalle del Evento (HU4)
    Note over Usuario,ModResenas: 3. Detalle de Evento (HU4)
    Usuario->>Sistema: Selecciona un evento para ver detalle
    par Consulta de datos completos y reseñas
        Sistema->>ModOrganizador: Solicita detalle completo del evento (descripción, precios finales y disponibilidad)
        ModOrganizador-->>Sistema: Retorna información detallada
    and
        Sistema->>ModResenas: Consulta calificaciones y opiniones
        ModResenas-->>Sistema: Retorna puntaje del evento/organizador
    end

    alt Evento Pasado
        Sistema-->>Usuario: Muestra detalle, reseñas y botón inactivo ("Evento finalizado")
    else Evento Futuro / Vigente (Agotado)
        Sistema-->>Usuario: Muestra detalle con etiqueta "Agotado" (compra deshabilitada)
    else Evento Futuro / Vigente (Disponible)
        Sistema-->>Usuario: Muestra detalle, reseñas, precio final y botón de acción ("Reservar" / "Comprar entrada")
    end

    %% Flujo 4: Secuencia de Compra
    Note over Usuario,ModOrganizador: 4. Proceso de Compra y Actualización de Stock
    Usuario->>Sistema: Hace clic en "Comprar entrada" / "Pagar"
    Sistema->>ModOrganizador: Envía solicitud de compra (id_evento, tipo_entrada, cantidad)
    Note over ModOrganizador: Panel de Organización gestiona bloqueo, cobro y descuento de stock con los demás módulos
    ModOrganizador-->>Sistema: Confirma compra exitosa y entrega nuevo stock/disponibilidad
    Sistema-->>Sistema: Actualiza disponibilidad local del evento
    Sistema-->>Usuario: Muestra pantalla de confirmación de compra / comprobante
