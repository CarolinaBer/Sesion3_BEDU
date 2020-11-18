# SESIÓN 3:  Subconsultas, Joins y Vistas.

# RETO 1 :Subconsultas.
USE tienda;
SELECT *
FROM empleado; -- de aquí obtenemos id_puesto que se relaciona con la tabla puesto en donde está salario
-- --- --- 
SELECT *
FROM puesto; -- En la tabla puesto obtenemos el id_puesto y salario 

#¿Cuál es el nombre de los empleados cuyo sueldo es menor a $10,000?
SELECT nombre AS Nombre, concat(apellido_paterno,' ', apellido_materno) AS Apellidos
FROM empleado
WHERE id_puesto IN (SELECT id_puesto FROM puesto WHERE salario < 10000) ;
-- No arroja ningún registro pues no existe ningún salario menor a $10,000 en los registros

#¿Cuál es el nombre de los empleados cuyo sueldo es mayor a $10,000?
SELECT nombre AS Nombre, concat(apellido_paterno,' ', apellido_materno) AS Apellidos
FROM empleado
WHERE id_puesto IN (SELECT id_puesto FROM puesto WHERE salario > 10000) ;
-- Arroja todos los regristros pues todos los salarios son mayores a $10,000 


#¿Cuál es la cantidad mínima y máxima de ventas de cada empleado?

-- La primera consulta que tenemos que hacer es:
SELECT id_empleado,clave,count(*) AS ventas_total 
FROM venta
GROUP BY clave,id_empleado;
-- En donde contamos el número de ventas realizadas por cada empleado y las agrupamos por 'clave'
-- que es un campo que nos permite agrupar los registros
SELECT id_empleado, max(ventas_total) AS max_venta, min(ventas_total) AS min_venta
FROM (SELECT id_empleado,clave,count(*) AS ventas_total FROM venta
GROUP BY clave,id_empleado) AS ventas
GROUP BY id_empleado;

# ¿Cuáles claves de venta incluyen artículos cuyos precios son mayores a $5,000?
SELECT clave, id_articulo FROM venta
 WHERE id_articulo IN ( SELECT id_articulo FROM
 articulo WHERE precio > 5000);


SELECT *
FROM venta; -- id_venta, id_articulo, id_empleado,clave y fecha
SELECT *
FROM empleado; -- id_empleado,id_puesto,nombre,apellido_paterno,apellido_materno, rfc

# Reto 2: Joins

# ¿Cuál es el nombre de los empleados que realizaron cada venta?
SELECT v.clave,v.id_articulo,  concat(e.nombre, ' ', e.apellido_paterno, ' ', e.apellido_materno) AS Nombre 
FROM venta AS v
JOIN empleado AS e
ON v.id_empleado = e.id_empleado
ORDER BY clave; -- para saber a que venta corresponde utilizamos la clave y para agrupar 
-- id_artículo es llave foránea para la tabla venta y primaria para la tabla artículo

# ¿Cuál es el nombre de los artículos que se han vendido?
SELECT v.clave, a.nombre 
FROM venta AS v 
JOIN articulo AS a
ON v.id_articulo = a.id_articulo
ORDER BY clave;
-- Cuando colocamos v.clave se hace referencia explícita de que tabla estamos tomando el campo solicitado

# ¿Cuál es el total de cada venta?
SELECT clave, sum(precio) AS total_venta
FROM venta AS v
JOIN articulo AS a ON v.id_articulo = a.id_articulo
GROUP BY clave ORDER BY clave; 

#Reto 3: Creación de vistas
USE tienda;
SELECT * FROM empleado; -- id_empleado, id_puesto,nombre, apellido_paterno, apellido_materno, rfc
SELECT * FROM puesto; -- id_puesto,nombre, salario
SELECT * FROM articulo; -- id_articulo, nombre, precio, iva, cantidad
SELECT * FROM venta; -- id_venta, id_articulo, id_empleado, clave, fecha
# Obtener el puesto de un empleado.
CREATE VIEW puestos_0158 AS
SELECT concat(e.nombre, ' ', e.apellido_paterno, ' ', e.apellido_materno) AS "Nombre Completo", p.nombre AS "Puesto"
FROM empleado e
JOIN puesto p
ON e.id_puesto = p.id_puesto;

CREATE VIEW puestos_C158 AS
SELECT concat(e.nombre, ' ', e.apellido_paterno, ' ', e.apellido_materno) AS "Nombre Completo", p.nombre AS "Puesto"
FROM empleado e LEFT JOIN puesto p
ON e.id_puesto = p.id_puesto;


SELECT *
FROM puestos_0158;-- 1000 rows

SELECT Puesto,count(Puesto)
FROM  puestos_0158
WHERE Puesto LIKE '%Engineer%'
GROUP BY Puesto; -- Consulta para practicar 

SELECT *
FROM puestos_C158;-- 1000 rows 
-- En este caso la consulta arroja los mismos resultados ya que todos los empleados tienen un puesto asignado
-- Así que es posible utilizar tanto Join como LEFT JOIN, esto es indistinto  


# Saber qué artículos ha vendido cada empleado.

CREATE VIEW empleado_articulo__158 AS
SELECT v.clave, concat(e.nombre, ' ', e.apellido_paterno, ' ',e.apellido_materno) AS "Nombre de empleado", a.nombre AS  "Artículo"
FROM venta v
JOIN empleado e
ON v.id_empleado = e.id_empleado -- como en campo tiene el mismo nombre es posible USING(id_empleado)
JOIN articulo a
ON v.id_articulo = a.id_articulo -- como el campo tiene el mismo nombre es posible USING(id_articulo)
ORDER BY v.clave;

SELECT *
FROM  empleado_articulo__158;

CREATE VIEW empleado_articulo_C158 AS
SELECT v.clave, concat(e.nombre, ' ', e.apellido_paterno, ' ',e.apellido_materno) AS "Nombre_empleado", a.nombre AS  "Artículo"
FROM venta v
JOIN empleado e
ON v.id_empleado = e.id_empleado
JOIN articulo a
ON v.id_articulo = a.id_articulo
ORDER BY v.clave;



#Saber qué puesto ha obtenido más ventas.
USE tienda;
SELECT * FROM puesto; -- id_puesto, nombre, salario
SELECT * FROM empleado; -- id_empleado, id_puesto
SELECT * FROM venta; -- id_venta,id_empleado, clave
-- Hay que recordar que la clave en la tabla venta nos perminre agrupar y contar los registros en 
-- las ventas realizadas.
SELECT p.nombre, count(v.clave) AS total_ventas
FROM empleado AS e 
JOIN venta AS v 
USING(id_empleado)
JOIN puesto AS p
USING(id_puesto)
GROUP BY p.nombre
ORDER BY total_ventas DESC LIMIT 1;

-- Con lo anterior, creando la vista de la tabla
CREATE VIEW puesto_ventas_158 AS
SELECT p.nombre, count(v.clave) total_ventas
FROM venta v
JOIN empleado e ON v.id_empleado = e.id_empleado
JOIN puesto p   ON e.id_puesto = p.id_puesto
GROUP BY p.nombre;

SELECT *
FROM puesto_ventas_158
ORDER BY total_ventas DESC LIMIT 1;


