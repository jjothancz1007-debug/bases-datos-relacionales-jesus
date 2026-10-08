-- EJERCICIO 1: DISEÑO DE ESQUEMA

CREATE DATABASE IF NOT EXISTS practica_academica
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE practica_academica;

CREATE TABLE Profesor (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    apellido VARCHAR(60) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    CONSTRAINT chk_profesor_email
        CHECK (email LIKE '%_@_%._%')
) ENGINE = InnoDB;

CREATE TABLE Materia (
    id_materia INT AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(15) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    departamento VARCHAR(80) NOT NULL,
    carga_horaria INT NOT NULL,
    CONSTRAINT chk_carga_horaria
        CHECK (carga_horaria > 0)
) ENGINE = InnoDB;

CREATE TABLE Asignacion (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_profesor INT NOT NULL,
    id_materia INT NOT NULL,
    grupo VARCHAR(15) NOT NULL,

    CONSTRAINT fk_asignacion_profesor
        FOREIGN KEY (id_profesor)
        REFERENCES Profesor(id_profesor),

    CONSTRAINT fk_asignacion_materia
        FOREIGN KEY (id_materia)
        REFERENCES Materia(id_materia),

    CONSTRAINT uq_materia_grupo
        UNIQUE (id_materia, grupo),

    CONSTRAINT chk_grupo
        CHECK (CHAR_LENGTH(TRIM(grupo)) > 0)
) ENGINE = InnoDB;


-- EJERCICIO 2: POBLACIÓN DE DATOS

INSERT INTO Profesor
    (id_profesor, nombre, apellido, email)
VALUES
    (1, 'Ana', 'García', 'ana.garcia@universidad.mx'),
    (2, 'Carlos', 'López', 'carlos.lopez@universidad.mx'),
    (3, 'María', 'Hernández', 'maria.hernandez@universidad.mx'),
    (4, 'José', 'Pérez', 'jose.perez@universidad.mx'),
    (5, 'Laura', 'Ramírez', 'laura.ramirez@universidad.mx');

INSERT INTO Materia
    (id_materia, clave, nombre, departamento, carga_horaria)
VALUES
    (1, 'BD01', 'Bases de Datos', 'Sistemas', 4),
    (2, 'PR01', 'Programación', 'Sistemas', 5),
    (3, 'RD01', 'Redes de Computadoras', 'Sistemas', 4),
    (4, 'MT01', 'Cálculo Diferencial', 'Matemáticas', 5),
    (5, 'MT02', 'Álgebra Lineal', 'Matemáticas', 4),
    (6, 'AD01', 'Administración', 'Administración', 3);

INSERT INTO Asignacion
    (id_profesor, id_materia, grupo)
VALUES
    (1, 1, 'ISC-301'),
    (1, 1, 'ISC-302'),
    (2, 2, 'ISC-301'),
    (2, 2, 'ISC-302'),
    (3, 3, 'ISC-301'),
    (3, 3, 'ISC-302'),
    (4, 4, 'ISC-101'),
    (4, 5, 'ISC-201'),
    (5, 6, 'ISC-301'),
    (5, 6, 'ISC-302');

SELECT
    CONCAT(p.nombre, ' ', p.apellido) AS profesor,
    m.clave AS clave_materia,
    a.grupo
FROM Asignacion AS a
INNER JOIN Profesor AS p
    ON a.id_profesor = p.id_profesor
INNER JOIN Materia AS m
    ON a.id_materia = m.id_materia
ORDER BY p.apellido, p.nombre, m.clave, a.grupo;


-- EJERCICIO 3: MODIFICACIÓN CONTROLADA

CREATE TABLE AuditoriaMateria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_materia INT NOT NULL,
    carga_anterior INT NOT NULL,
    carga_nueva INT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(150) NOT NULL,
    descripcion VARCHAR(200) NOT NULL,

    CONSTRAINT fk_auditoria_materia
        FOREIGN KEY (id_materia)
        REFERENCES Materia(id_materia)
) ENGINE = InnoDB;

START TRANSACTION;

-- Bloquear las materias que se modificarán.
SELECT id_materia, nombre, carga_horaria
FROM Materia
WHERE departamento = 'Sistemas'
FOR UPDATE;

-- Registrar la carga anterior y la nueva.
INSERT INTO AuditoriaMateria (
    id_materia,
    carga_anterior,
    carga_nueva,
    usuario,
    descripcion
)
SELECT
    id_materia,
    carga_horaria,
    carga_horaria + 1,
    CURRENT_USER(),
    'Aumento de una hora en el departamento de Sistemas'
FROM Materia
WHERE departamento = 'Sistemas';

-- Aumentar una hora a las materias de Sistemas.
UPDATE Materia
SET carga_horaria = carga_horaria + 1
WHERE departamento = 'Sistemas';

COMMIT;

-- Comprobar la modificación.
SELECT id_materia, nombre, departamento, carga_horaria
FROM Materia
WHERE departamento = 'Sistemas';

-- Comprobar los registros de auditoría.
SELECT *
FROM AuditoriaMateria
ORDER BY id_auditoria;


-- EJERCICIO 4: CONSULTA COMPLEJA Y ANÁLISIS
-- Esquema propuesto para estudiantes, carreras e inscripciones.

CREATE TABLE Carrera (
    id_carrera INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE Estudiante (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    id_carrera INT NOT NULL,

    CONSTRAINT fk_estudiante_carrera
        FOREIGN KEY (id_carrera)
        REFERENCES Carrera(id_carrera)
) ENGINE = InnoDB;

CREATE TABLE Inscripcion (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_materia INT NOT NULL,
    calificacion DECIMAL(4,2) NOT NULL,

    CONSTRAINT fk_inscripcion_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES Estudiante(id_estudiante),

    CONSTRAINT fk_inscripcion_materia
        FOREIGN KEY (id_materia)
        REFERENCES Materia(id_materia),

    CONSTRAINT uq_estudiante_materia
        UNIQUE (id_estudiante, id_materia),

    CONSTRAINT chk_calificacion
        CHECK (calificacion BETWEEN 0 AND 10)
) ENGINE = InnoDB;

INSERT INTO Carrera (id_carrera, nombre)
VALUES
    (1, 'Ingeniería en Sistemas'),
    (2, 'Administración');

INSERT INTO Estudiante
    (id_estudiante, matricula, nombre, id_carrera)
VALUES
    (1, 'A1001', 'Jesús Cuellar', 1),
    (2, 'A1002', 'Ana Torres', 1),
    (3, 'A1003', 'Carlos Díaz', 1),
    (4, 'A1004', 'María López', 2),
    (5, 'A1005', 'Luis Pérez', 2);

INSERT INTO Inscripcion
    (id_estudiante, id_materia, calificacion)
VALUES
    (1, 1, 9.00),
    (1, 2, 10.00),
    (2, 1, 8.00),
    (2, 2, 9.00),
    (3, 1, 7.00),
    (3, 2, 8.00),
    (4, 5, 9.00),
    (4, 6, 9.00),
    (5, 5, 7.00),
    (5, 6, 8.00);

-- Contar estudiantes inscritos y calcular resultados por carrera.
SELECT
    c.nombre AS carrera,
    COUNT(e.id_estudiante) AS estudiantes_inscritos,

    ROUND(
        SUM(r.suma_calificaciones) /
        SUM(r.numero_calificaciones),
        2
    ) AS promedio_general,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN r.promedio >= 8.5 THEN 1
                ELSE 0
            END
        ) /
        COUNT(e.id_estudiante),
        2
    ) AS porcentaje_promedio_mayor_igual_8_5

FROM Carrera AS c

INNER JOIN Estudiante AS e
    ON c.id_carrera = e.id_carrera

INNER JOIN (
    SELECT
        id_estudiante,
        SUM(calificacion) AS suma_calificaciones,
        COUNT(*) AS numero_calificaciones,
        AVG(calificacion) AS promedio
    FROM Inscripcion
    GROUP BY id_estudiante
) AS r
    ON e.id_estudiante = r.id_estudiante

GROUP BY c.id_carrera, c.nombre
ORDER BY promedio_general DESC;