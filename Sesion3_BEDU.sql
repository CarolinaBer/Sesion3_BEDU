-- Sesión 3 Joins y vistas 
-- Iniciaremos con subconsultas. Estas son útiles ya que las BD son dinámicas
USE tienda;
SELECT * FROM puesto;
# En la sesión pasada teníamos que
SELECT max(id_puesto) - 5 
FROM puesto;

SELECT sum(salario)
FROM puesto
WHERE id_puesto > 995;
# Si ahora las anidamos para que esten en una única consulta utilizando subconsultas

SELECT sum(salario)
FROM puesto 
WHERE id_puesto > (SELECT max(id_puesto) - 5 
FROM puesto);
# Primero se realiza la primera subconsulta dentro de los paréntesis y se utiliza para la consulta 

# WHERE IN 
#Junior Executive
SELECT id_puesto 
FROM puesto
WHERE nombre = 'Junior Executive';
# cada consulta nos regresa una tabla o relación.

SELECT *
FROM empleado
WHERE id_puesto IN (SELECT id_puesto 
FROM puesto
WHERE nombre = 'Junior Executive');

#FROM 
# Ahora queremos saber cuál es la menor y mayor cantidad de ventas de un artículo.
SELECT *
FROM venta;
 # hay que contar cuantas veces aparece cada artículo en cada una de las ventas
SELECT clave,id_articulo,count(*) AS cantidad
FROM venta
GROUP BY clave,id_articulo ORDER BY cantidad DESC;
 
 SELECT id_articulo, min(cantidad) AS cantidad_min, max(cantidad) AS cantidad_max
 FROM (SELECT clave,id_articulo,count(*) AS cantidad
FROM venta
GROUP BY clave,id_articulo ORDER BY cantidad DESC)  AS subconsulta
 GROUP BY id_articulo;
 # de esto en otras palabras es:
SELECT clave, id_articulo, count(*) AS cantidad
FROM venta
GROUP BY clave, id_articulo
ORDER BY clave;



# RETO 1 Subconsultas
/* Usando la base de datos tienda, escribe consultas que permitan responder las siguientes preguntas.

¿Cuál es el nombre de los empleados cuyo sueldo es menor a $10,000?
¿Cuál es la cantidad mínima y máxima de ventas de cada empleado?
¿Cuáles claves de venta incluyen artículos cuyos precios son mayores a $5,000?*/

USE tienda;
SELECT *
FROM empleado; -- de aquí obtenemos id_puesto que se relaciona con la tabla puesto en donde está salario

SELECT nombre
FROM empleado
WHERE id_puesto IN (SELECT id_puesto FROM puesto WHERE salario < 10000) ;

SELECT id_empleado, max(ventas_total) AS max_venta, min(ventas_total) AS min_venta
FROM (SELECT id_empleado,clave,count(*) AS ventas_total FROM venta
GROUP BY clave,id_empleado) AS ventas
GROUP BY id_empleado;
-- en venta tenemos id_empleado

SELECT clave, id_articulo FROM venta
 WHERE id_articulo IN (
 SELECT id_articulo FROM
 articulo WHERE precio > 5000);

 
-- Joins y vistas 
#Clasificación de Joins 
/*Para relacionar tablas se utilizan los joins que son operadores entre tablas, las cuales permiten asociar dos o más tablas mediane sus campos. 
En general, esta asociacion se realiza 
usando las llaves primarias y foráneas de cada tabla. En MySQL son:
1. INNER JOIN (o simplemente JOIN)
2. LEFT OUTER JOIN
3. RIGHT OUTER JOIN*/
-- Podemos observar nuestras relaciones entre las tablas mediante el diagrama entidad-relación 
#JOIN Un join, relaciona dos tablas, trayendo todos los campos de éstas siempre y cuando se cumpla la condición de relación.

SHOW KEYS FROM venta;
-- Con SHOW KEYS podemos encontrar las llaves primarias y secundaria de la tabla venta 
SELECT *
FROM venta;
SELECT *
FROM empleado; -- id_puesto es primary key en puesto y foránea en empleado
-- Comparten id_puesto
SELECT *
FROM puesto;
SHOW KEYS FROM empleado;
SHOW KEYS FROM puesto; -- id_puesto es llave primaria
#JOIN/ INNER JOIN
-- tenemos que saber qué tablas están relacionadas para realizar un JOIN
SELECT *
FROM empleado AS e
JOIN puesto AS p
ON e.id_puesto = p.id_puesto;
-- de columa de la tabla y busca las coincidencias y junta los registros y lo regresa como uno solo

#LEFT JOIN / LEFT OUTER JOIN
SELECT *
FROM puesto AS p
LEFT JOIN empleado e
ON p.id_puesto = e.id_puesto;
-- A la izquierda está la tabla puesto , entoces tenemos puestos que no cuentan aún con un empleado
-- Toma como prioridad la tabla de la izquierda
#RIGHT JOIN / RIGHT OUTER JOIN
SELECT *
FROM empleado AS e
RIGHT JOIN puesto AS p
ON e.id_puesto = p.id_puesto; -- En la igualdad no importa el orden 
-- Ahora la  tabla que está a la derecha es la tabla puesto. Esta consulta es la misma que la anterior
-- Los JOINS se pueden concatenar 

-- Para nombrar la tabla es posible omitir AS

# Reto 2: Joins
/* De tienda:
¿Cuál es el nombre de los empleados que realizaron cada venta?
¿Cuál es el nombre de los artículos que se han vendido?
¿Cuál es el total de cada venta?*/
-- cada venta puede tener más de un empleado, hay más de un empleado por venta. Entonces la clave es la clave
-- de la venta. Hay más de un empleado por venta. 
-- Nombre de empleados que realizaron cada venta 
SELECT clave, nombre, apellido_paterno, apellido_paterno
FROM venta AS v
JOIN empleado AS e
ON v.id_empleado = e.id_empleado
ORDER BY clave; -- clave es solo para agrupar pero no es de identificación 

SELECT clave, nombre
FROM venta AS v
JOIN articulo AS a
  ON v.id_articulo = a.id_articulo
ORDER BY clave; -- como clave se repite sirve para agrupar 

SELECT clave, round(sum(precio),2) AS total
FROM venta AS v
JOIN articulo AS a
  ON v.id_articulo = a.id_articulo
GROUP BY clave
ORDER BY clave;

-- ¿qué es clave?
SHOW KEYS FROM venta; 

-- Ejemplo 2. Definición de vistas
#VISTAS 
/* SELECT 
FROM venta AS v 
JOIN empleado AS e
ON v.id_venta = e.id_empleado
JOIN 
*/
CREATE VIEW tickets158 AS
(SELECT v.clave,v.fecha, a.nombre AS producto, a.precio, CONCAT(e.nombre,' ', e.apellido_paterno) AS empleado
FROM venta AS v JOIN empleado AS e ON v.id_empleado = e.id_empleado JOIN articulo AS a 
ON v.id_articulo = a.id_articulo); 

CREATE VIEW tickets158 AS
(SELECT v.clave, v.fecha, a.nombre producto, a.precio, concat(e.nombre, ' ', e.apellido_paterno) empleado 
FROM venta v
JOIN empleado e
  ON v.id_empleado = e.id_empleado
JOIN articulo a
  ON v.id_articulo = a.id_articulo);
  
  SELECT *
FROM tickets158;

SELECT clave, round(sum(precio),2) total
FROM tickets158
GROUP BY clave;

#Reto 3
/* Obtener el puesto de un empleado.
Saber qué artículos ha vendido cada empleado.
Saber qué puesto ha tenido más ventas.*/
CREATE VIEW puestos158 AS
SELECT concat(e.nombre, ' ', e.apellido_paterno) AS nombre, p.nombre
FROM empleado e
JOIN puesto p
ON e.id_puesto = p.id_puesto;

SELECT *
FROM puestos158;


# Ejercicios Sesión 3
-- Para estas consultas usa RIGHT JOIN
#1.Obten el código de producto, nombre de producto y descripción de todos los productos.
USE classicmodels;
SELECT * FROM products; -- productCode,productName,productVendor, productDescription
SELECT p.productCode,p.productName,p.productDescription
FROM products p;
#2. Obten el número de orden, estado y costo total de cada orden.
SELECT *  FROM orders; -- orderNumber,status, orderDate
SELECT * FROM orderdetails; -- orderNumber,productCode, quantityOrdered, priceEach,orderLineNumber

SELECT orderNumber, o.status, SUM(od.priceEach*od.quantityOrdered) AS total_order
FROM orderdetails AS od
RIGHT JOIN orders AS o 
USING(orderNumber)
GROUP BY orderNumber;



#3. Obten el número de orden, fecha de orden, línea de orden, nombre del producto, cantidad ordenada y precio de cada pieza 
-- que muestre los detalles de cada orden.
SELECT * FROM orders; -- customerNumber, orderNumber -- 326
SELECT * FROM orderdetails; -- productCode,orderNumber -- 1000 -- en orderdetails hay varios orderNumber, productCode es PK
DESCRIBE orderdetails; -- orderNumber es PK de orders pero foranea para orderdetails
SELECT * FROM products; -- productCode es PK, productName 
-- tengo que hacer el RIGHT JOIN de tal forma que los nombres de productos sean de aquellos que se a+han vendido, por tanto orderdetails va a la derecha

SELECT orderNumber, o.orderDate, od.orderLineNumber,p.productName, od.quantityOrdered, od.priceEach,p.productDescription
FROM products AS p
RIGHT JOIN orderdetails AS od
USING(productCode)
RIGHT JOIN orders AS o 
USING(orderNumber);



#4. Obtén el número de orden, nombre del producto, el precio sugerido de fábrica (msrp) y precio de cada pieza.
SELECT od.orderNumber, p.productName,p.MSRP,od.priceEach
FROM products AS p
RIGHT JOIN orderdetails AS od
USING(productCode);

-- Para estas consultas usa LEFT JOIN.
#5. Obtén el número de cliente, nombre de cliente, número de orden y estado de cada cliente.
SELECT * FROM customers;-- customerNumber, customerName
-- De la tabla orders: orderNumber, status, customerNumber
SELECT customerNumber, c.customerName,  o.orderNumber, o.status
FROM orders AS o 
LEFT JOIN customers AS c
USING(customerNumber);
-- las ordenes son la parte importante en esta consulta ya que buscamos las ordenes que corresponden a los clientes
-- de caso contrario en la consulta tendríamos clientes que NO tienen una orden asociada
#6. Obtén los clientes que no tienen una orden asociada.
SELECT * FROM orders;
SELECT * FROM customers;
SELECT customerName 
FROM customers
WHERE customerNumber NOT IN (SELECT customerNumber FROM orders);

SELECT customerName,orderNumber
FROM customers c 
LEFT JOIN orders o
USING(customerNumber)
WHERE orderNumber IS NULL;

#7. Obtén el apellido de empleado, nombre de empleado, nombre de cliente, número de cheque y total, 
-- es decir, los clientes asociados a cada empleado.
SELECT * FROM employees; -- employeeNumber,lastName,firstName
SELECT * FROM customers; -- customerNumber,customerName,payments, salesRepEmployeeNumber
SELECT * FROM payments; -- customerNumber, checkNumber, amount
SELECT * FROM orders; -- orderNumber,customerNumber


SELECT concat(e.firstName,' ', e.lastName) AS "employee_Name",c.customerName
FROM employees AS e
JOIN customers AS c
ON e.employeeNumber=c.salesRepEmployeeNumber;
-- Esto por que buscamos los clientes que estan relacionados a un empleado 
#7.1 consulta usando RIGHT JOIN
SELECT concat(e.firstName,' ', e.lastName) AS "employee_Name",c.customerName,p.checkNumber,p.amount
FROM employees AS e
JOIN customers AS c -- right también por que no hay cliente sin empleado
ON e.employeeNumber=c.salesRepEmployeeNumber
RIGHT JOIN payments AS p -- join también funciona , left da dos clientes que no tienen pago registrado
USING(customerNumber); -- 273 rows

SELECT concat(e.firstName,' ', e.lastName) AS "employee_Name",c.customerName,p.checkNumber,p.amount
FROM payments AS p
LEFT JOIN customers AS c -- left y right dan los mismos resultados
USING(customerNumber)
JOIN employees AS e -- se puede usar left o join pero no right por que hay empleados sin cliente
ON e.employeeNumber=c.salesRepEmployeeNumber; -- 273 rows
-- funciona en la segunda left o join por que no hay clientes sin empleado
-- si utilizamos right en la primera unión hay dos clientes que no cuentan con informacio de checkNumber y amount

-- Para estas consultas usa RIGHT JOIN.
USE classicmodels;
#8. Repite los ejercicios 5 a 7 usando RIGHT JOIN.
#5.1. Obtén el número de cliente, nombre de cliente, número de orden y estado de cada cliente.
SELECT customerNumber, c.customerName,  o.orderNumber, o.status
FROM customers AS c 
RIGHT JOIN orders AS o
USING(customerNumber);
-- ya que hay clientes que no han ordenado
#6.1 Obtén los clientes que no tienen una orden asociada.
SELECT customerName,orderNumber
FROM customers c 
LEFT JOIN orders o
USING(customerNumber)
WHERE o.customerNumber IS NULL; -- Esta es otra forma de realizar la consulta deseada anterior

SELECT customerName, orderNumber 
FROM orders o
RIGHT JOIN customers c
USING(customerNumber)
WHERE o.customerNumber IS NULL;



#9. Escoge 3 consultas de los ejercicios anteriores, crea una vista y escribe una consulta para cada una.

USE classicmodels;
# Vista para el ejercicio 7 
CREATE VIEW employee_customer_158 AS
SELECT concat(e.firstName,' ', e.lastName) AS "employee_Name",c.customerName,p.checkNumber,p.amount
FROM employees AS e
JOIN customers AS c -- right también por que no hay cliente sin empleado
ON e.employeeNumber=c.salesRepEmployeeNumber
RIGHT JOIN payments AS p -- join también funciona , left da dos clientes que no tienen pago registrado
USING(customerNumber); -- 273 rows
-- Utilizando esta vista(nueva tabla virtual) es posible encontrar el top 5 de ventas empleado-cliente .
SELECT * 
FROM employee_customer_158
ORDER BY amount DESC LIMIT 5;

-- Esto es :
SELECT concat(e.firstName,' ', e.lastName) AS "employee_Name",c.customerName,p.checkNumber,p.amount
FROM employees AS e
JOIN customers AS c -- right también por que no hay cliente sin empleado
ON e.employeeNumber=c.salesRepEmployeeNumber
RIGHT JOIN payments AS p -- join también funciona , left da dos clientes que no tienen pago registrado
USING(customerNumber) ORDER BY amount DESC LIMIT 5; 

###
# creando la vista del ejercicio 2
CREATE VIEW orders_details_158 AS
SELECT orderNumber, o.status, SUM(od.priceEach*od.quantityOrdered) AS total_order
FROM orderdetails AS od
RIGHT JOIN orders AS o 
USING(orderNumber)
GROUP BY orderNumber;

SELECT o.status,count(o.status)
FROM orders_details_158
GROUP BY o.status;
-- Corroborando la consulta:
USE classicmodels;
SELECT status, count(status)  FROM orders GROUP BY status;

## creando la vista del ejercicio  4 
CREATE VIEW product_order_158 AS
SELECT od.orderNumber, p.productName,p.MSRP,od.priceEach
FROM products AS p
RIGHT JOIN orderdetails AS od
USING(productCode);

-- La consulta es saber para cuales productos coinciden los precios
SELECT p.productName,p.MSRP,od.priceEach
FROM product_order_158
WHERE od.priceEach = p.MSRP ;

-- corroborando
SELECT od.orderNumber, p.productName,p.MSRP,od.priceEach
FROM products AS p
RIGHT JOIN orderdetails AS od
USING(productCode)
WHERE od.priceEach = p.MSRP ;
