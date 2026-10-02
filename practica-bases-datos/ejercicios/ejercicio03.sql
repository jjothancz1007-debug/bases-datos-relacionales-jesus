-- EJERCICIO 3: VIDEOJUEGOS

-- 1. Crear la base de datos
CREATE DATABASE videojuegos;

-- 2. Seleccionar la base de datos
USE videojuegos;

-- 3. Crear la tabla juegos
CREATE TABLE juegos (
    id INT PRIMARY KEY,
    titulo VARCHAR(100),
    genero VARCHAR(50),
    plataforma VARCHAR(50),
    anio INT
);

-- 4. Insertar ocho videojuegos
-- El año del registro 7 se corregirá después.
INSERT INTO juegos
(id, titulo, genero, plataforma, anio)
VALUES
(1, 'Minecraft', 'Sandbox', 'PC', 2011),
(2, 'Grand Theft Auto V', 'Acción', 'PlayStation 3', 2013),
(3, 'Forza Horizon 5', 'Carreras', 'Xbox Series X/S', 2021),
(4, 'Super Mario Odyssey', 'Plataformas', 'Nintendo Switch', 2017),
(5, 'Halo Infinite', 'Disparos', 'Xbox Series X/S', 2021),
(6, 'The Legend of Zelda: Breath of the Wild',
 'Aventura', 'Nintendo Switch', 2017),
(7, 'EA Sports FC 24', 'Deportes', 'PlayStation 5', 2022),
(8, 'God of War', 'Acción y aventura', 'PlayStation 4', 2018);

-- 5. Consultar todos los videojuegos
SELECT * FROM juegos;

-- 6. Consultar únicamente título y plataforma
SELECT titulo, plataforma
FROM juegos;

-- 7. Consultar videojuegos de Nintendo Switch
SELECT *
FROM juegos
WHERE plataforma = 'Nintendo Switch';

-- 8. Consultar videojuegos posteriores a 2018
SELECT *
FROM juegos
WHERE anio > 2018;

-- 9. Modificar la plataforma de un registro
UPDATE juegos
SET plataforma = 'PC'
WHERE id = 2;

-- 10. Comprobar la plataforma modificada
SELECT *
FROM juegos
WHERE id = 2;

-- 11. Modificar el año de otro registro
UPDATE juegos
SET anio = 2023
WHERE id = 7;

-- 12. Comprobar el año modificado
SELECT *
FROM juegos
WHERE id = 7;

-- 13. Eliminar un videojuego
DELETE FROM juegos
WHERE id = 8;

-- 14. Consultar el resultado final
SELECT * FROM juegos;