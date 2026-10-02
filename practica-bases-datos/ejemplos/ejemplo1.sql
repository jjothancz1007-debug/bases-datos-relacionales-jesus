CREATE DATABASE escuela;
USE escuela;

CREATE TABLE alumnos (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    edad INT,
    semestre INT
);

INSERT INTO alumnos (id, nombre, apellido, edad, semestre)
VALUES
(1, 'Ana', 'López', 18, 2),
(2, 'Carlos', 'Pérez', 19, 4),
(3, 'María', 'García', 18, 2);

SELECT * FROM alumnos;