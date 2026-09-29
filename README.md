# Sistema de Catálogo y Gestión de Eventos

Repositorio de **Arquitectura, Contratos de Interfaz, Hitos y Modelo de Datos** del microservicio de Catálogo de Eventos (TicketU).

> **Código fuente del Microservicio:** El código fuente ejecutable del backend (Node.js/Express) se encuentra en su propio repositorio dedicado:  
> **[ms-catalogo-eventos](https://github.com/Equipo-7-Catalogo-de-eventos/ms-catalogo-eventos)**

---

## Información del Equipo

* **Grupo 7:** Catálogo de Eventos
* **Integrantes:**
  * **Nombre:** Amalia Toledo — **Correo:** `amalia.toledo@estudiantes.uv.cl`
  * **Nombre:** Maximiliano Rozas — **Correo:** `maximiliano.rozas@estudiantes.uv.cl`
  * **Nombre:** Anaís Muñoz — **Correo:** `anais.munozm@estudiantes.uv.cl`
  * **Nombre:** Diego Valenzuela — **Correo:** `diego.valenzuelap@estudiantes.uv.cl`
  * **Nombre:** Gladys Carvacho — **Correo:** `gladys.carvacho@estudiantes.uv.cl`

---


## Diagrama de Secuencia

```mermaid
sequenceDiagram
    actor Usuario as Cliente
    participant Sistema as Sistema (Catálogo)
    participant ModOrganizador as Módulo Panel Organizador
    participant ModResenas as Módulo Reseñas
    participant ModInventario as Módulo Entradas / Inventario
    autonumber

    %% Flujo 1: Carga Inicial de Catálogo con los 6 eventos más próximos (HU1)
    Note over Usuario,ModOrganizador: 1. Carga Inicial: 6 Eventos Próximos (HU1)
    Usuario->>Sistema: ver_catalogo()
    Sistema->>ModOrganizador: solicitar_eventos_proximos()
    Note over ModOrganizador: Incluye título, lugar, fecha, imagen, stock y precio final
    ModOrganizador-->>Sistema: retornar_eventos_proximos(lista_eventos)
    Sistema->>ModResenas: solicitar_calificaciones_basicas(lista_id_eventos)
    Note over ModResenas,Sistema: Puede retornar las calificaciones o vacío (si no hay reseñas)
    ModResenas-->>Sistema: retornar_calificaciones_basicas(calificaciones_o_vacio)
    Sistema-->>Usuario: mostrar_catalogo_proximos_eventos()

    %% Flujo 2: Búsqueda, Filtros y Eventos Pasados (HU1, HU2, HU3)
    Note over Usuario,ModOrganizador: 2. Exploración y Filtros (HU1, HU2, HU3)
    opt Filtrar por Calificación, Eventos pasados o búsqueda
        Usuario->>Sistema: aplicar_filtro(criterio)
        Sistema->>ModOrganizador: buscar_eventos_por_filtro(criterio)
        ModOrganizador-->>Sistema: retornar_eventos_filtrados(lista_eventos)
        
        Sistema->>ModResenas: solicitar_calificaciones_basicas(lista_id_eventos)
        ModResenas-->>Sistema: retornar_calificaciones_basicas(calificaciones_o_vacio)
        
        Sistema-->>Usuario: mostrar_resultados_filtrados()
    end

    %% Flujo 3: Detalle del Evento (HU4)
    Note over Usuario,ModResenas: 3. Detalle de Evento (HU4)
    Usuario->>Sistema: seleccionar_evento(id_evento)
    par Consulta de datos completos y reseñas
        Sistema->>ModOrganizador: solicitar_detalle_evento(id_evento)
        ModOrganizador-->>Sistema: retornar_detalle_evento()
    and
        Sistema->>ModResenas: consultar_resenas_completas(id_evento)
        Note over ModResenas,Sistema: Pide opiniones y notas. Puede retornar vacío si el evento no tiene reseñas.
        ModResenas-->>Sistema: retornar_resenas_completas(datos_o_vacio)
    end

    alt Evento Pasado
        Sistema-->>Usuario: mostrar_detalle_pasado_boton_deshabilitado()
    else Evento Futuro / Vigente (Agotado)
        Sistema-->>Usuario: mostrar_detalle_agotado_compra_deshabilitada()
    else Evento Futuro / Vigente (Disponible)
        Sistema-->>Usuario: mostrar_detalle_disponible_con_opcion_compra()
    end

    %% Flujo 4: Secuencia de Compra
    Note over Usuario,ModInventario: 4. Proceso de Compra y Actualización de Stock
    Usuario->>Sistema: solicitar_compra_entrada(id_evento, tipo_entrada, cantidad)
    Sistema->>ModInventario: procesar_compra(id_evento, tipo_entrada, cantidad)
    ModInventario-->>Sistema: confirmar_compra_exitosa(nuevo_stock)
    Sistema->>Sistema: actualizar_disponibilidad(id_evento, nuevo_stock)
    Sistema-->>Usuario: mostrar_confirmacion_compra()
```

---

## Contratos de Interfaz

Los acuerdos de integración y especificaciones de endpoints pactados con los otros microservicios del ecosistema TicketU se encuentran documentados en la carpeta [`docs/`](docs/):

| Contrato | Consumidor | Proveedor | Descripción |
| :--- | :--- | :--- | :--- |
| [**CONTRATO_CATALOGO_PANEL.md**](docs/CONTRATO_CATALOGO_PANEL.md) | Catálogo de Eventos | Panel Organizador | Consulta de eventos próximos, filtros y ficha de detalle. |
| [**CONTRATO_CATALOGO_RESENAS.md**](docs/CONTRATO_CATALOGO_RESENAS.md) | Catálogo de Eventos | Reseñas | Calificaciones básicas (estrellas) y comentarios completos. |
| [**CONTRATO_CATALOGO_ENTRADAS.md**](docs/CONTRATO_CATALOGO_ENTRADAS.md) | Catálogo de Eventos | Entradas / Inventario | Solicitud de procesamiento de compra de entradas. |
| [**CONTRATO_ENTRADAS_CATALOGO.md**](docs/CONTRATO_ENTRADAS_CATALOGO.md) | Entradas / Inventario | Catálogo de Eventos | Actualización de stock en el catálogo tras compra exitosa. |

---

## Hitos y Planificación

El seguimiento de los sprints, entregables y estado de cada etapa se encuentra detallado en:
* [**docs/milestones.md**](docs/milestones.md)

---

## Estructura del Repositorio

```text
Catalogo_de_eventos/
├── docs/
│   ├── diagrams/
│   │   └── README.md                       # Explicación de flujos y arquitectura
│   ├── CONTRATO_CATALOGO_PANEL.md          # Contrato con Panel Organizador
│   ├── CONTRATO_CATALOGO_RESENAS.md        # Contrato con Módulo Reseñas
│   ├── CONTRATO_CATALOGO_ENTRADAS.md       # Contrato de solicitud de compra con Entradas
│   ├── CONTRATO_ENTRADAS_CATALOGO.md       # Contrato de actualización de stock desde Entradas
│   └── milestones.md                       # Planificación y estado de hitos
├── schema_db.sql                           # Esquema DDL e inserción de datos de prueba en PostgreSQL/Supabase
└── README.md                               # Documento principal del repositorio
```

---

## Base de Datos

El diseño del modelo relacional se encuentra en [`schema_db.sql`](schema_db.sql). Utiliza PostgreSQL alojado en Supabase, incluyendo índices optimizados para:
* Búsqueda por texto rápido (`GIN` con `to_tsvector` en español).
* Filtrado acelerado por estado y categoría (`idx_eventos_estado_categoria`).
* Ordenamiento cronológico de eventos (`idx_eventos_fecha`).

---

## Repositorio del Backend

Para clonar y ejecutar el código del microservicio, visita el repositorio:  
🔗 **[Equipo-7-Catalogo-de-eventos / ms-catalogo-eventos](https://github.com/Equipo-7-Catalogo-de-eventos/ms-catalogo-eventos)**
