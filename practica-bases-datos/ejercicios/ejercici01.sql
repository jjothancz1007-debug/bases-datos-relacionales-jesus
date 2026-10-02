-- EJERCICIO 1: BIBLIOTECA

-- 1. Crear la base de datos
CREATE DATABASE biblioteca;

-- 2. Seleccionar la base de datos
USE biblioteca;

-- 3. Crear la tabla libros
CREATE TABLE libros (
    id INT PRIMARY KEY,
    titulo VARCHAR(150),
    autor VARCHAR(100),
    anio INT,
    categoria VARCHAR(50)
);

-- 4. Insertar cinco libros
-- El año del libro 5 se corregirá después.
INSERT INTO libros (id, titulo, autor, anio, categoria)
VALUES
(1, 'El principito', 'Antoine de Saint-Exupéry', 1943, 'Literatura infantil'),
(2, 'Cien años de soledad', 'Gabriel García Márquez', 1967, 'Novela'),
(3, '1984', 'George Orwell', 1949, 'Ciencia ficción'),
(4, 'Los juegos del hambre', 'Suzanne Collins', 2008, 'Novela juvenil'),
(5, 'El código Da Vinci', 'Dan Brown', 2002, 'Misterio');

-- 5. Consultar todos los libros
SELECT * FROM libros;

-- 6. Consultar únicamente título y autor
SELECT titulo, autor
FROM libros;

-- 7. Consultar libros posteriores al año 2000
SELECT *
FROM libros
WHERE anio > 2000;

-- 8. Modificar el año de publicación de un libro
UPDATE libros
SET anio = 2003
WHERE id = 5;

-- 9. Comprobar el registro modificado
SELECT *
FROM libros
WHERE id = 5;

-- 10. Eliminar un libro
DELETE FROM libros
WHERE id = 3;

-- 11. Consultar el resultado final
SELECT * FROM libros;