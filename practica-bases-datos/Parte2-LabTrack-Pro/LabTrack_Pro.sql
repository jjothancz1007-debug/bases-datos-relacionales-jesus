-- LabTrack Pro | Práctica de Bases de Datos Relacionales
-- MySQL 8.0+ | UPEM | Alumno: Jesús Jothan Cuellar

CREATE DATABASE IF NOT EXISTS LabTrackDB
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE LabTrackDB;

-- Alumnos que pueden solicitar equipos en préstamo.
CREATE TABLE alumno (
  id_alumno INT AUTO_INCREMENT PRIMARY KEY,
  matricula VARCHAR(20) NOT NULL UNIQUE,
  nombre VARCHAR(100) NOT NULL,
  carrera VARCHAR(80) NOT NULL,
  correo VARCHAR(120) NOT NULL UNIQUE,
  fecha_registro DATE NOT NULL DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Inventario físico de equipos del laboratorio.
CREATE TABLE equipo_lab (
  id_equipo INT AUTO_INCREMENT PRIMARY KEY,
  num_inventario VARCHAR(30) NOT NULL UNIQUE,
  tipo ENUM('PC','Monitor','Proyector','Switch','Laptop') NOT NULL,
  marca VARCHAR(60) NOT NULL,
  modelo VARCHAR(80) NOT NULL,
  estado ENUM('Disponible','Prestado','En mantenimiento','Baja')
    NOT NULL DEFAULT 'Disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Historial de préstamos. fecha_devolucion NULL significa que sigue activo.
CREATE TABLE prestamo (
  id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
  fecha_prestamo DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_devolucion DATETIME NULL,
  id_equipo INT NOT NULL,
  id_alumno INT NOT NULL,
  CONSTRAINT fk_prestamo_equipo FOREIGN KEY (id_equipo)
    REFERENCES equipo_lab(id_equipo)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_prestamo_alumno FOREIGN KEY (id_alumno)
    REFERENCES alumno(id_alumno)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Historial de mantenimientos realizados a los equipos.
CREATE TABLE mantenimiento (
  id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL,
  descripcion VARCHAR(250) NOT NULL,
  costo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  tipo_mant ENUM('Preventivo','Correctivo') NOT NULL DEFAULT 'Preventivo',
  id_equipo INT NOT NULL,
  CONSTRAINT chk_mantenimiento_costo CHECK (costo >= 0),
  CONSTRAINT fk_mantenimiento_equipo FOREIGN KEY (id_equipo)
    REFERENCES equipo_lab(id_equipo)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Cuatro alumnos de prueba; el cuarto no tiene movimientos y se usará para DELETE seguro.
INSERT INTO alumno (matricula,nombre,carrera,correo) VALUES
('20241001','Ana López García','Ingeniería en Sistemas','ana.lopez@upem.edu.mx'),
('20241002','Carlos Ruiz Pérez','Ingeniería en Sistemas','carlos.ruiz@upem.edu.mx'),
('20241003','María Torres Díaz','Ingeniería Industrial','maria.torres@upem.edu.mx'),
('20241004','Luis Hernández Soto','Ingeniería en Sistemas','luis.hernandez@upem.edu.mx');

-- Seis equipos; el inventario LAB-005 nunca se presta en los datos de prueba.
INSERT INTO equipo_lab (num_inventario,tipo,marca,modelo,estado) VALUES
('LAB-001','PC','Dell','OptiPlex 7010','Prestado'),
('LAB-002','Monitor','HP','P24 G5','Prestado'),
('LAB-003','Proyector','Epson','PowerLite E20','Prestado'),
('LAB-004','Switch','Cisco','Catalyst 2960','Disponible'),
('LAB-005','Laptop','Lenovo','ThinkPad E14','Disponible'),
('LAB-006','PC','HP','ProDesk 400 G9','Disponible');

-- Ocho préstamos de prueba: los tres con devolución NULL están activos.
INSERT INTO prestamo (fecha_prestamo,fecha_devolucion,id_equipo,id_alumno) VALUES
('2026-10-01 09:00:00','2026-10-02 12:00:00',1,1),
('2026-10-03 10:00:00','2026-10-03 14:00:00',2,1),
('2026-10-10 08:00:00',NULL,1,1),
('2026-10-04 11:00:00','2026-10-04 15:00:00',3,2),
('2026-10-05 09:30:00','2026-10-05 12:00:00',4,1),
('2026-10-12 10:00:00',NULL,2,2),
('2026-10-13 08:30:00',NULL,3,3),
('2026-10-06 13:00:00','2026-10-06 16:00:00',4,3);

-- Cinco mantenimientos realistas asociados con equipos existentes.
INSERT INTO mantenimiento (fecha,descripcion,costo,tipo_mant,id_equipo) VALUES
('2026-09-15','Limpieza interna y revisión de ventiladores',150.00,'Preventivo',1),
('2026-09-20','Cambio de cable de alimentación',45.00,'Correctivo',2),
('2026-10-02','Cambio de lámpara del proyector',320.00,'Correctivo',3),
('2026-10-05','Limpieza de puertos y actualización',0.00,'Preventivo',4),
('2026-10-07','Reemplazo de ventilador',80.00,'Correctivo',6);

-- UPDATE de un solo registro: cambiar la carrera de un alumno específico.
UPDATE alumno
SET carrera = 'Ingeniería en Sistemas Computacionales'
WHERE id_alumno = 1;

-- UPDATE de varios registros: enviar equipos disponibles de esos tipos a revisión.
UPDATE equipo_lab
SET estado = 'En mantenimiento'
WHERE estado = 'Disponible' AND tipo IN ('Switch','Laptop');

-- DELETE seguro: el alumno 4 no tiene préstamos; las FK también bloquean borrar
-- alumnos que sí tienen historial.
DELETE FROM alumno
WHERE id_alumno = 4
  AND NOT EXISTS (SELECT 1 FROM prestamo WHERE prestamo.id_alumno = alumno.id_alumno);

-- SELECT simple con WHERE.
SELECT num_inventario,tipo,marca,modelo,estado
FROM equipo_lab
WHERE estado = 'Prestado';

-- SELECT simple con ORDER BY.
SELECT matricula,nombre,carrera
FROM alumno
ORDER BY nombre ASC;

-- RETO 1: equipos prestados actualmente y datos del alumno.
SELECT e.num_inventario,e.tipo,e.marca,e.modelo,a.nombre,a.matricula,p.fecha_prestamo
FROM prestamo p
INNER JOIN equipo_lab e ON e.id_equipo = p.id_equipo
INNER JOIN alumno a ON a.id_alumno = p.id_alumno
WHERE p.fecha_devolucion IS NULL;

-- RETO 2: equipos que nunca han sido prestados.
SELECT e.id_equipo,e.num_inventario,e.tipo,e.marca,e.modelo
FROM equipo_lab e
LEFT JOIN prestamo p ON p.id_equipo = e.id_equipo
WHERE p.id_prestamo IS NULL;

-- RETO 3: número de préstamos por alumno, incluidos los alumnos con cero.
SELECT a.matricula,a.nombre,COUNT(p.id_prestamo) AS total_prestamos
FROM alumno a
LEFT JOIN prestamo p ON p.id_alumno = a.id_alumno
GROUP BY a.id_alumno,a.matricula,a.nombre
ORDER BY total_prestamos DESC;

-- RETO 4: costo total de mantenimiento por tipo de equipo.
SELECT e.tipo,SUM(m.costo) AS costo_total
FROM equipo_lab e
INNER JOIN mantenimiento m ON m.id_equipo = e.id_equipo
GROUP BY e.tipo
ORDER BY costo_total DESC;

-- RETO 5: alumnos con más de dos préstamos.
SELECT a.matricula,a.nombre,COUNT(p.id_prestamo) AS total_prestamos
FROM alumno a
INNER JOIN prestamo p ON p.id_alumno = a.id_alumno
GROUP BY a.id_alumno,a.matricula,a.nombre
HAVING COUNT(p.id_prestamo) > 2;

-- RETO 6: equipo con el mantenimiento más costoso.
SELECT e.num_inventario,e.tipo,e.marca,e.modelo,m.descripcion,m.costo,m.fecha
FROM mantenimiento m
INNER JOIN equipo_lab e ON e.id_equipo = m.id_equipo
ORDER BY m.costo DESC
LIMIT 1;
