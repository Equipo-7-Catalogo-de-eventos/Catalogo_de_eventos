```mermaid
erDiagram
    EVENTOS {
        VARCHAR id_evento PK "Identificador único (Panel Organizador)"
        VARCHAR nombre_evento "NOT NULL"
        TEXT descripcion_evento "NOT NULL"
        VARCHAR lugar_evento "NOT NULL"
        TIMESTAMP fecha_evento "NOT NULL"
        VARCHAR hora_evento "NOT NULL"
        VARCHAR imagen_evento "NOT NULL"
        NUMERIC precio_final_evento "NOT NULL"
        VARCHAR tipo_evento "NOT NULL, CHECK (gratuito, pagado)"
        VARCHAR categoria_evento "NULL"
        VARCHAR estado_evento "NOT NULL, CHECK (disponible...)"
        INTEGER stock_actual "NOT NULL, CHECK (>= 0)"
        NUMERIC promedio_calificacion "NOT NULL, DEFAULT 0"
        INTEGER total_resenas "NOT NULL, DEFAULT 0"
        TIMESTAMP fecha_creacion "NOT NULL, DEFAULT now()"
    }
