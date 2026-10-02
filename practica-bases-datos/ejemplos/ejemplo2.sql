USE escuela;

SELECT nombre, apellido
FROM alumnos;

SELECT *
FROM alumnos
WHERE semestre = 2;

UPDATE alumnos
SET edad = 19
WHERE id = 1;

SELECT *
FROM alumnos
WHERE id = 1;

UPDATE alumnos
SET edad = 20,
    semestre = 3
WHERE id = 1;

SELECT *
FROM alumnos
WHERE id = 1;