-- EJERCICIO 2: TIENDA
-- Precios de ejemplo en pesos mexicanos.

-- 1. Crear la base de datos
CREATE DATABASE tienda;

-- 2. Seleccionar la base de datos
USE tienda;

-- 3. Crear la tabla productos
CREATE TABLE productos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    categoria VARCHAR(50),
    precio DECIMAL(10,2),
    existencia INT
);

-- 4. Insertar seis productos
INSERT INTO productos
(id, nombre, categoria, precio, existencia)
VALUES
(1, 'Cuaderno', 'Papelería', 45.00, 30),
(2, 'Lápiz', 'Papelería', 8.50, 100),
(3, 'Mochila', 'Accesorios', 450.00, 15),
(4, 'Memoria USB 32 GB', 'Tecnología', 120.00, 20),
(5, 'Mouse', 'Tecnología', 180.00, 12),
(6, 'Botella de agua', 'Bebidas', 15.00, 40);

-- 5. Consultar todos los productos
SELECT * FROM productos;

-- 6. Consultar únicamente nombre y precio
SELECT nombre, precio
FROM productos;

-- 7. Consultar productos con precio mayor a 100
SELECT *
FROM productos
WHERE precio > 100.00;

-- 8. Modificar el precio de un producto
UPDATE productos
SET precio = 420.00
WHERE id = 3;

-- 9. Comprobar el precio modificado
SELECT *
FROM productos
WHERE id = 3;

-- 10. Modificar la existencia de otro producto
UPDATE productos
SET existencia = 25
WHERE id = 4;

-- 11. Comprobar la existencia modificada
SELECT *
FROM productos
WHERE id = 4;

-- 12. Eliminar un producto
DELETE FROM productos
WHERE id = 6;

-- 13. Consultar el resultado final
SELECT * FROM productos;