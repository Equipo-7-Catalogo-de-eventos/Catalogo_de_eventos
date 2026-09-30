
DROP TABLE IF EXISTS eventos;

-- 1. CREACIÓN DE LA TABLA 
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
    evento_estado VARCHAR CHECK (evento_estado IN ('disponible', 'agotado', 'pasado', 'cancelado')) NOT NULL,
    
    -- Variables que provienen de otros equipos
    inventario_stock INTEGER NOT NULL CHECK (inventario_stock >= 0),
    resena_calificacion_promedio NUMERIC DEFAULT 0,
    resena_total INTEGER DEFAULT 0,
    
    -- Variables internas
    metrica_clics INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 2. POBLADO DE DATOS: 15 EVENTOS
INSERT INTO eventos (
    evento_id, evento_titulo, evento_descripcion, evento_lugar, evento_fecha, 
    evento_hora, evento_imagen, evento_precio_final, evento_tipo, evento_categoria, 
    evento_estado, inventario_stock, resena_calificacion_promedio, resena_total
)
VALUES
('evt-101', 'Feria de Innovación TITEC', 'Muestra anual de proyectos de ingeniería y tecnología.', 'Auditorio Principal UV', '2026-10-15 10:00:00+00', '10:00', 'https://loremflickr.com/800/400/technology,engineering', 0, 'gratuito', 'academico', 'disponible', 150, 4.8, 12),
('evt-102', 'Fiesta de Generación Informática', 'Fiesta de fin de semestre para estudiantes y egresados.', 'Centro de Eventos El Huevo', '2026-11-05 22:00:00+00', '22:00', 'https://loremflickr.com/800/400/party,students', 5000, 'pagado', 'fiesta', 'disponible', 300, 4.2, 5),
('evt-103', 'Torneo Interescuelas Valorant', 'Campeonato oficial universitario de deportes electrónicos.', 'Laboratorios de Computación UV', '2026-10-20 15:00:00+00', '15:00', 'https://loremflickr.com/800/400/valorant,esports', 2000, 'pagado', 'deporte', 'agotado', 0, 5.0, 45),
('evt-104', 'Charla: Inteligencia Artificial y Ética', 'Conversatorio con académicos invitados sobre el uso responsable de la inteligencia artificial. (SUSPENDIDO)', 'Sala 204, Edificio de Ingeniería', '2026-10-30 17:30:00+00', '17:30', 'https://loremflickr.com/800/400/artificialintelligence,robotics', 0, 'gratuito', 'charla', 'cancelado', 0, 0, 0),
('evt-105', 'Congreso de Ciencias Sociales 2026', 'Ponencias y mesas de trabajo sobre investigación social en la región de Valparaíso.', 'Aula Magna UV', '2026-09-10 09:00:00+00', '09:00', 'https://loremflickr.com/800/400/conference,social', 3000, 'pagado', 'academico', 'pasado', 40, 3.9, 18),
('evt-106', 'Taller de Fotografía Nocturna', 'Taller práctico de fotografía urbana nocturna. Se recomienda traer cámara o celular.', 'Plaza Sotomayor', '2026-11-14 20:00:00+00', '20:00', 'https://loremflickr.com/800/400/photography,night', 1500, 'pagado', 'taller', 'disponible', 20, 0, 0),
('evt-107', 'Corrida Solidaria UV 5K', 'Corrida recreativa abierta a la comunidad universitaria a beneficio de la Teletón.', 'Avenida Borgoño, Viña del Mar', '2026-08-30 08:30:00+00', '08:30', 'https://loremflickr.com/800/400/running,marathon', 0, 'gratuito', 'deporte', 'pasado', 120, 4.6, 31),
('evt-108', 'Festival de Bandas Universitarias', 'Bandas de estudiantes de distintas facultades compiten en una noche de música en vivo.', 'Centro de Eventos El Huevo', '2026-12-04 19:00:00+00', '19:00', 'https://loremflickr.com/800/400/concert,band', 3500, 'pagado', 'fiesta', 'disponible', 250, 0, 0),
('evt-109', 'Feria de Empleabilidad e Inserción Laboral TI', 'Stands de empresas de tecnología, recepción de currículums y entrevistas para prácticas profesionales.', 'Patio Central, Facultad de Ingeniería UV', '2026-11-10 10:00:00+00', '10:00', 'https://loremflickr.com/800/400/jobfair,technology', 0, 'gratuito', 'academico', 'disponible', 180, 0, 0),
('evt-110', 'Torneo Interfacultades de Futsal', 'Fase eliminatoria del campeonato interescuelas de fútbol sala masculino y femenino.', 'Gimnasio Polideportivo UV', '2026-10-24 16:00:00+00', '16:00', 'https://loremflickr.com/800/400/futsal,soccer', 1000, 'pagado', 'deporte', 'disponible', 75, 4.3, 8),
('evt-111', 'Gala Universitaria Fin de Año', 'Cena formal y fiesta bailable de despedida de semestre con música en directo.', 'Hotel O''Higgins, Viña del Mar', '2026-12-18 21:00:00+00', '21:00', 'https://loremflickr.com/800/400/gala,dinner', 8000, 'pagado', 'fiesta', 'agotado', 0, 4.9, 52),
('evt-112', 'Ciclo de Cine Universitario al Aire Libre', 'Proyección de películas independientes latinoamericanas en pantalla gigante. Entrada liberada.', 'Parque Cultural de Valparaíso (Ex Cárcel)', '2026-09-18 19:00:00+00', '19:00', 'https://loremflickr.com/800/400/cinema,outdoor', 0, 'gratuito', 'cultural', 'pasado', 0, 4.7, 27),
('evt-113', 'Workshop: Ciberseguridad Defensiva y CTF', 'Taller práctico de detección de vulnerabilidades web y desafíos Capture The Flag.', 'Laboratorio de Redes y Seguridad UV', '2026-11-28 14:00:00+00', '14:00', 'https://loremflickr.com/800/400/cybersecurity,hacker', 0, 'gratuito', 'academico', 'disponible', 30, 0, 0),
('evt-114', 'Campeonato Relámpago de Smash Bros Ultimate', 'Torneo universitario presencial con brackets de doble eliminación y premios para el podio.', 'Casino de Estudiantes, Sede Brasil', '2026-10-16 16:30:00+00', '16:30', 'https://loremflickr.com/800/400/nintendo,esports', 1500, 'pagado', 'deporte', 'disponible', 40, 4.8, 14),
('evt-115', 'Taller de Salud Integral y Primeros Auxilios', 'Capacitación teórico-práctica en reanimación cardiopulmonar básica y manejo de urgencias.', 'Auditorio Facultad de Medicina UV', '2026-11-06 11:00:00+00', '11:00', 'https://loremflickr.com/800/400/firstaid,cpr', 0, 'gratuito', 'taller', 'disponible', 50, 0, 0)

-- Cláusula de seguridad: actualiza los datos si el evento_id ya existe
ON CONFLICT (evento_id) DO UPDATE SET
    evento_titulo                = EXCLUDED.evento_titulo,
    evento_descripcion           = EXCLUDED.evento_descripcion,
    evento_lugar                 = EXCLUDED.evento_lugar,
    evento_fecha                 = EXCLUDED.evento_fecha,
    evento_hora                  = EXCLUDED.evento_hora,
    evento_imagen                = EXCLUDED.evento_imagen,
    evento_precio_final          = EXCLUDED.evento_precio_final,
    evento_tipo                  = EXCLUDED.evento_tipo,
    evento_categoria             = EXCLUDED.evento_categoria,
    evento_estado                = EXCLUDED.evento_estado,
    inventario_stock             = EXCLUDED.inventario_stock,
    resena_calificacion_promedio = EXCLUDED.resena_calificacion_promedio,
    resena_total                 = EXCLUDED.resena_total;

-- 3. ÍNDICES DE RENDIMIENTO
-- Índice para acelerar los filtros por categoría y estado
CREATE INDEX idx_eventos_estado_categoria ON eventos(evento_estado, evento_categoria);

-- Índice para acelerar la carga del catálogo y ordenarlo cronológicamente al instante
CREATE INDEX idx_eventos_fecha ON eventos(evento_fecha);

-- Índice de texto avanzado (GIN) para que la barra de búsqueda encuentre palabras clave en milisegundos
CREATE INDEX idx_eventos_busqueda ON eventos USING GIN (to_tsvector('spanish', evento_titulo || ' ' || evento_descripcion));
