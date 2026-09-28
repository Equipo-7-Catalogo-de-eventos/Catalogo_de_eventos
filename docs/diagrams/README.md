# Diagramas del Microservicio de Catálogo de Eventos

Esta carpeta contiene los diagramas arquitectónicos y de secuencia del microservicio **Catálogo de Eventos** (Equipo 7).

## Diagrama de Secuencia General

El diagrama de secuencia describe los 4 flujos principales de integración con los otros equipos del sistema TicketU:
1. **Carga Inicial de Catálogo:** Consulta de eventos próximos a Panel Organizador y notas básicas a Reseñas.
2. **Exploración y Filtros:** Búsqueda avanzada y filtros de eventos combinados con calificaciones.
3. **Detalle del Evento:** Consulta concurrente de ficha técnica a Panel Organizador y opiniones completas a Reseñas.
4. **Proceso de Compra y Actualización de Stock:** Orquestación con Entradas / Inventario y sincronización eventual de stock.

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
