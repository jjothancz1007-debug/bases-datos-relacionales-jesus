-- TechTrack Pro | Ejemplo resuelto | MySQL 8.0+
CREATE DATABASE IF NOT EXISTS TechTrackDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE TechTrackDB;

-- Empleados y usuarios que pueden tener activos asignados.
CREATE TABLE Usuarios (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  departamento VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  fecha_alta DATE DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Inventario de activos tecnológicos. El usuario puede ser NULL si no está asignado.
CREATE TABLE Equipos (
  id_equipo INT AUTO_INCREMENT PRIMARY KEY,
  num_serie VARCHAR(50) NOT NULL UNIQUE,
  modelo VARCHAR(80) NOT NULL,
  tipo ENUM('Laptop','Desktop','Servidor','Periferico','Otro') NOT NULL DEFAULT 'Laptop',
  estado ENUM('Disponible','Asignado','En Mantenimiento','Baja') DEFAULT 'Disponible',
  id_usuario INT NULL,
  CONSTRAINT fk_usuario_equipo FOREIGN KEY (id_usuario)
    REFERENCES Usuarios(id_usuario) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Historial técnico asociado a cada equipo.
CREATE TABLE Mantenimientos (
  id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL,
  descripcion TEXT,
  costo DECIMAL(10,2) DEFAULT 0.00,
  tipo_mant ENUM('Preventivo','Correctivo') DEFAULT 'Correctivo',
  id_equipo INT NOT NULL,
  CONSTRAINT fk_equipo_manto FOREIGN KEY (id_equipo)
    REFERENCES Equipos(id_equipo) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO Usuarios (nombre,departamento,email) VALUES
('Ana López','Sistemas','ana.lopez@empresa.com'),
('Carlos Ruiz','Contabilidad','carlos.ruiz@empresa.com'),
('María Torres','Recursos Humanos','maria.torres@empresa.com');

INSERT INTO Equipos (num_serie,modelo,tipo,estado,id_usuario) VALUES
('SN-998877','Dell Latitude 5420','Laptop','Asignado',1),
('SN-112233','HP ProDesk 400','Desktop','Asignado',2),
('SN-445566','Dell PowerEdge R740','Servidor','Disponible',NULL),
('SN-778899','Lenovo ThinkPad X1','Laptop','Asignado',1);

INSERT INTO Mantenimientos (fecha,descripcion,costo,tipo_mant,id_equipo) VALUES
('2025-03-15','Cambio de disco SSD',85.00,'Correctivo',1),
('2025-06-01','Limpieza preventiva y actualización BIOS',0.00,'Preventivo',1),
('2025-08-20','Reemplazo de fuente de poder',120.50,'Correctivo',3);

-- Consultas básicas
-- 1. Insertar equipo
INSERT INTO Equipos (num_serie,modelo,tipo,estado,id_usuario)
VALUES ('SN-554433','Apple MacBook Pro 14','Laptop','Asignado',3);

-- 2. Actualizar departamento
UPDATE Usuarios SET departamento='Sistemas' WHERE id_usuario=2;

-- 3. Eliminar un mantenimiento antiguo
DELETE FROM Mantenimientos WHERE id_mantenimiento=1;

-- 4. Listar equipos
SELECT * FROM Equipos;

-- Consultas avanzadas
-- 5. Filtrar laptops
SELECT num_serie,modelo,estado FROM Equipos WHERE tipo='Laptop';

-- 6. Ordenar usuarios por departamento y nombre
SELECT nombre,departamento,email FROM Usuarios ORDER BY departamento ASC,nombre ASC;

-- 7. Equipos con nombre de usuario asignado (INNER JOIN)
SELECT e.num_serie,e.modelo,e.tipo,u.nombre AS asignado_a
FROM Equipos e INNER JOIN Usuarios u ON e.id_usuario=u.id_usuario;

-- 8. Mantenimientos con costo mayor a $100
SELECT m.fecha,e.modelo,m.descripcion,m.costo,m.tipo_mant
FROM Mantenimientos m JOIN Equipos e ON m.id_equipo=e.id_equipo
WHERE m.costo>100;

-- 9. Contar equipos por departamento (incluye usuarios sin equipos)
SELECT u.departamento,COUNT(e.id_equipo) AS total_equipos
FROM Usuarios u LEFT JOIN Equipos e ON u.id_usuario=e.id_usuario
GROUP BY u.departamento;

-- 10. Equipos sin mantenimientos
SELECT e.num_serie,e.modelo,e.tipo
FROM Equipos e LEFT JOIN Mantenimientos m ON e.id_equipo=m.id_equipo
WHERE m.id_mantenimiento IS NULL;

-- Pregunta 11: costo total de mantenimientos por equipo
SELECT e.id_equipo,e.num_serie,e.modelo,COALESCE(SUM(m.costo),0) AS costo_total
FROM Equipos e LEFT JOIN Mantenimientos m ON e.id_equipo=m.id_equipo
GROUP BY e.id_equipo,e.num_serie,e.modelo;

-- Pregunta 12: aplicar HAVING para filtrar los equipos con total mayor a $100
SELECT e.id_equipo,e.num_serie,e.modelo,SUM(m.costo) AS costo_total
FROM Equipos e JOIN Mantenimientos m ON e.id_equipo=m.id_equipo
GROUP BY e.id_equipo,e.num_serie,e.modelo
HAVING SUM(m.costo)>100;
