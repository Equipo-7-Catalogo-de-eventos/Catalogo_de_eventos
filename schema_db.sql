DROP TABLE IF EXISTS eventos;

-- 1. Crear la tabla (Vista Materializada de solo lectura para el catálogo)
CREATE TABLE eventos (
    -- Datos recibidos desde el MS Panel Organizador
    id_evento VARCHAR PRIMARY KEY,
    nombre_evento VARCHAR NOT NULL,
    descripcion_evento TEXT NOT NULL,
    lugar_evento VARCHAR NOT NULL,
    fecha_evento TIMESTAMP WITH TIME ZONE NOT NULL,
    hora_evento VARCHAR NOT NULL,
    imagen_evento VARCHAR NOT NULL,
    precio_final_evento NUMERIC NOT NULL,
    tipo_evento VARCHAR CHECK (tipo_evento IN ('gratuito', 'pagado')) NOT NULL,
    categoria_evento VARCHAR,
    estado_evento VARCHAR CHECK (estado_evento IN ('disponible', 'agotado', 'pasado', 'cancelado')) NOT NULL,
    
    -- Datos recibidos desde el MS Entradas e Inventario
    stock_actual INTEGER NOT NULL CHECK (stock_actual >= 0),
    
    -- Datos recibidos desde el MS Reseñas
    promedio_calificacion NUMERIC NOT NULL DEFAULT 0,
    total_resenas INTEGER NOT NULL DEFAULT 0,
    
    -- Metadato técnico automático de la base de datos
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 2. Poblado de datos
INSERT INTO eventos (
    id_evento, nombre_evento, descripcion_evento, lugar_evento, fecha_evento, 
    hora_evento, imagen_evento, precio_final_evento, tipo_evento, categoria_evento, 
    estado_evento, stock_actual, promedio_calificacion, total_resenas
)
VALUES
('evt-101', 'Feria de Innovación TITEC', 'Muestra anual de proyectos de ingeniería y tecnología.', 'Auditorio Principal UV', '2026-10-15 10:00:00+00', '10:00', 'https://loremflickr.com/800/400/technology', 0, 'gratuito', 'academico', 'disponible', 150, 4.8, 12),
('evt-102', 'Fiesta de Generación Informática', 'Fiesta de fin de semestre para estudiantes y egresados.', 'Centro de Eventos El Huevo', '2026-11-05 22:00:00+00', '22:00', 'https://loremflickr.com/800/400/party', 5000, 'pagado', 'fiesta', 'disponible', 300, 4.2, 5),
('evt-103', 'Torneo Interescuelas Valorant', 'Campeonato oficial universitario de deportes electrónicos.', 'Laboratorios de Computación UV', '2026-10-20 15:00:00+00', '15:00', 'https://loremflickr.com/800/400/esports', 2000, 'pagado', 'deporte', 'agotado', 0, 5.0, 45),
('evt-104', 'Charla: Inteligencia Artificial y Ética', 'Conversatorio con académicos invitados sobre el uso responsable de la inteligencia artificial.', 'Sala 204, Edificio de Ingeniería', '2026-10-30 17:30:00+00', '17:30', 'https://loremflickr.com/800/400/robotics', 0, 'gratuito', 'charla', 'disponible', 8, 0, 0),
('evt-105', 'Congreso de Ciencias Sociales 2026', 'Ponencias y mesas de trabajo sobre investigación social en la región de Valparaíso.', 'Aula Magna UV', '2026-09-10 09:00:00+00', '09:00', 'https://loremflickr.com/800/400/conference', 3000, 'pagado', 'academico', 'pasado', 40, 3.9, 18),
('evt-106', 'Taller de Fotografía Nocturna', 'Taller práctico de fotografía urbana nocturna. Se recomienda traer cámara o celular.', 'Plaza Sotomayor', '2026-11-14 20:00:00+00', '20:00', 'https://loremflickr.com/800/400/photography', 1500, 'pagado', 'taller', 'disponible', 20, 0, 0),
('evt-107', 'Corrida Solidaria UV 5K', 'Corrida recreativa abierta a la comunidad universitaria a beneficio de la Teletón.', 'Avenida Borgoño, Viña del Mar', '2026-08-30 08:30:00+00', '08:30', 'https://loremflickr.com/800/400/marathon', 0, 'gratuito', 'deporte', 'pasado', 120, 4.6, 31),
('evt-108', 'Festival de Bandas Universitarias', 'Bandas de estudiantes de distintas facultades compiten en una noche de música en vivo.', 'Centro de Eventos El Huevo', '2026-12-04 19:00:00+00', '19:00', 'https://loremflickr.com/800/400/concert', 3500, 'pagado', 'fiesta', 'disponible', 250, 0, 0),
('evt-109', 'Feria de Empleabilidad e Inserción Laboral TI', 'Stands de empresas de tecnología, recepción de currículums y entrevistas para prácticas profesionales.', 'Patio Central, Facultad de Ingeniería UV', '2026-11-10 10:00:00+00', '10:00', 'https://loremflickr.com/800/400/interview', 0, 'gratuito', 'academico', 'disponible', 180, 0, 0),
('evt-110', 'Torneo Interfacultades de Futsal', 'Fase eliminatoria del campeonato interescuelas de fútbol sala masculino y femenino.', 'Gimnasio Polideportivo UV', '2026-10-24 16:00:00+00', '16:00', 'https://loremflickr.com/800/400/soccer', 1000, 'pagado', 'deporte', 'disponible', 75, 4.3, 8),
('evt-111', 'Gala Universitaria Fin de Año', 'Cena formal y fiesta bailable de despedida de semestre con música en directo.', 'Hotel O''Higgins, Viña del Mar', '2026-12-18 21:00:00+00', '21:00', 'https://loremflickr.com/800/400/gala', 8000, 'pagado', 'fiesta', 'agotado', 0, 4.9, 52),
('evt-112', 'Ciclo de Cine Universitario al Aire Libre', 'Proyección de películas independientes latinoamericanas en pantalla gigante. Entrada liberada.', 'Parque Cultural de Valparaíso (Ex Cárcel)', '2026-09-18 19:00:00+00', '19:00', 'https://loremflickr.com/800/400/cinema', 0, 'gratuito', 'cultural', 'pasado', 0, 4.7, 27),
('evt-113', 'Workshop: Ciberseguridad Defensiva y CTF', 'Taller práctico de detección de vulnerabilidades web y desafíos Capture The Flag.', 'Laboratorio de Redes y Seguridad UV', '2026-11-28 14:00:00+00', '14:00', 'https://loremflickr.com/800/400/cybersecurity', 0, 'gratuito', 'academico', 'disponible', 30, 0, 0),
('evt-114', 'Campeonato Relámpago de Smash Bros Ultimate', 'Torneo universitario presencial con brackets de doble eliminación y premios para el podio.', 'Casino de Estudiantes, Sede Brasil', '2026-10-16 16:30:00+00', '16:30', 'https://loremflickr.com/800/400/videogames', 1500, 'pagado', 'deporte', 'disponible', 40, 4.8, 14),
('evt-115', 'Taller de Salud Integral y Primeros Auxilios', 'Capacitación teórico-práctica en reanimación cardiopulmonar básica y manejo de urgencias.', 'Auditorio Facultad de Medicina UV', '2026-11-06 11:00:00+00', '11:00', 'https://loremflickr.com/800/400/medical', 0, 'gratuito', 'taller', 'disponible', 50, 0, 0),
('evt-116', 'Seminario: Tendencias en Computación Cuántica', '(CANCELADO) El evento ha sido suspendido por problemas logísticos.', 'Sala de Conferencias UV', '2026-11-25 09:00:00+00', '09:00', 'https://loremflickr.com/800/400/physics', 0, 'gratuito', 'academico', 'cancelado', 0, 0, 0)

-- Cláusula de seguridad (UPSERT) para actualizar datos si el microservicio de origen envía un cambio
ON CONFLICT (id_evento) DO UPDATE SET
    nombre_evento                = EXCLUDED.nombre_evento,
    descripcion_evento           = EXCLUDED.descripcion_evento,
    lugar_evento                 = EXCLUDED.lugar_evento,
    fecha_evento                 = EXCLUDED.fecha_evento,
    hora_evento                  = EXCLUDED.hora_evento,
    imagen_evento                = EXCLUDED.imagen_evento,
    precio_final_evento          = EXCLUDED.precio_final_evento,
    tipo_evento                  = EXCLUDED.tipo_evento,
    categoria_evento             = EXCLUDED.categoria_evento,
    estado_evento                = EXCLUDED.estado_evento,
    stock_actual                 = EXCLUDED.stock_actual,
    promedio_calificacion        = EXCLUDED.promedio_calificacion,
    total_resenas                = EXCLUDED.total_resenas;

-- Índice para acelerar los filtros por categoría y estado (evita escaneos completos)
CREATE INDEX IF NOT EXISTS idx_eventos_estado_categoria
ON eventos(estado_evento, categoria_evento);

-- Índice para acelerar la carga del catálogo y ordenarlo cronológicamente al instante
CREATE INDEX IF NOT EXISTS idx_eventos_fecha
ON eventos(fecha_evento);

-- Índice de texto avanzado (GIN) para que la barra de búsqueda encuentre palabras clave en milisegundos
CREATE INDEX IF NOT EXISTS idx_eventos_busqueda
ON eventos USING GIN (to_tsvector('spanish', nombre_evento || ' ' || descripcion_evento));

UPDATE eventos
SET imagen_evento = 'https://picsum.photos/seed/' || id_evento || '/800/400';
