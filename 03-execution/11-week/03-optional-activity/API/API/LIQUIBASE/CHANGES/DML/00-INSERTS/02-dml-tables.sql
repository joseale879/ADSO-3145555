INSERT INTO usuario VALUES
(gen_random_uuid(), 'Juan Perez', 'juan@email.com', NOW()),
(gen_random_uuid(), 'Maria Lopez', 'maria@email.com', NOW());

INSERT INTO tarea VALUES
(gen_random_uuid(), 'Aprender Docker', 'Estudiar contenedores', 'PENDIENTE', NOW()),
(gen_random_uuid(), 'Crear API', 'Desarrollar backend', 'EN_PROGRESO', NOW());