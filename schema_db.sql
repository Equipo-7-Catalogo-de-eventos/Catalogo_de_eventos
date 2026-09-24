CREATE TABLE eventos (
    evento_id VARCHAR PRIMARY KEY,
    evento_titulo VARCHAR NOT NULL,
    evento_descripcion TEXT NOT NULL,
    evento_lugar VARCHAR NOT NULL,
    evento_fecha TIMESTAMP WITH TIME ZONE NOT NULL,
    evento_hora VARCHAR NOT NULL,
    evento_imagen VARCHAR NOT NULL,
    evento_precio_final NUMERIC NOT NULL,
    evento_tipo VARCHAR CHECK (evento_tipo IN ('gratuito', 'pagado')) NOT NULL,
    evento_categoria VARCHAR,
    evento_estado VARCHAR CHECK (evento_estado IN ('disponible', 'agotado', 'pasado')) NOT NULL,
    
    -- Variables que provienen de otros equipos
    inventario_stock INTEGER NOT NULL CHECK (inventario_stock >= 0),
    resena_calificacion_promedio NUMERIC DEFAULT 0,
    resena_total INTEGER DEFAULT 0,
    
    -- Variables internas
    metrica_clics INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 2. aqui voy a isnertar los datos d prueba
INSERT INTO eventos (
    evento_id, evento_titulo, evento_descripcion, evento_lugar, evento_fecha, 
    evento_hora, evento_imagen, evento_precio_final, evento_tipo, evento_categoria, 
    evento_estado, inventario_stock, resena_calificacion_promedio, resena_total
)
VALUES
('evt-101', 'Feria de Innovación TITEC', 'Muestra anual de proyectos de ingeniería y tecnología.', 'Auditorio Principal UV', '2026-10-15 10:00:00+00', '10:00', 'https://ticketu.cl/img/feria-titec.jpg', 0, 'gratuito', 'academico', 'disponible', 150, 4.8, 12),
('evt-102', 'Fiesta de Generación Informática', 'Fiesta de fin de semestre para estudiantes y egresados.', 'Centro de Eventos El Huevo', '2026-11-05 22:00:00+00', '22:00', 'https://ticketu.cl/img/fiesta-info.jpg', 5000, 'pagado', 'fiesta', 'disponible', 300, 4.2, 5),
('evt-103', 'Torneo Interescuelas Valorant', 'Campeonato oficial universitario de deportes electrónicos.', 'Laboratorios de Computación UV', '2026-10-20 15:00:00+00', '15:00', 'https://ticketu.cl/img/valorant-uv.jpg', 2000, 'pagado', 'deporte', 'agotado', 0, 5.0, 45);
-- Índice para acelerar los filtros por categoría y estado (evita escaneos completos)
CREATE INDEX idx_eventos_estado_categoria ON eventos(evento_estado, evento_categoria);

-- Índice para acelerar la carga del catálogo y ordenarlo cronológicamente al instante
CREATE INDEX idx_eventos_fecha ON eventos(evento_fecha);

-- Índice de texto avanzado (GIN) para que la barra de búsqueda encuentre palabras clave en milisegundos
CREATE INDEX idx_eventos_busqueda ON eventos USING GIN (to_tsvector('spanish', evento_titulo || ' ' || evento_descripcion));