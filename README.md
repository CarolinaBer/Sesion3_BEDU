# Sesión3 BEDU: Subconsultas, Joins y Vistas.
Para esta sesión se vuelve importante conocer las **llaves primarias(PK)** y las **llaves foráneas** de una tabla para poder utilizar los JOIN.

Una **llave primaria** permite identificar de manera *única* los registros de una tabla, por lo cual se debe de utilizar para algún campo que no se repita. 
Mediante la DESCRIBE tabla; podemos identificar las llaves que tiene la tabla.

Por otro lado, una **llave foránea** representa una relación entre dos tablas. Con ello se *evitan duplicados*. Se puede tener **uno a muchos**,**muchos a muchos** lo cual nos permitiría unir dos tablas sin relación directa mediante la creación de una llave intermedia y **uno a uno** que es la menos utilizada y es creada con fines específicos. 
### Uno a muchos.
![imagen](imagenes/unoamuchos.png)
### Muchos a muchos.
![imagen](imagenes/muchosAmuchos.png)
### Uno a uno.
![imagen](imagenes/unoAuno.png)


Imágenes consultadas en: Sarmiento M.(2017). Cómo crear relaciones entre tablas en MySQL con Workbench.[Blog].Retrieved from http://www.marcossarmiento.com/2017/05/05/como-crear-relaciones-entre-tablas-en-mysql-con-workbench/

Las soluciones a los retos de esta sesión son las siguientes:
## :pushpin: Reto 1: Subconsultas.
![imagen](imagenes/Reto1.png)
![imagen](imagenes/Reto1s.png)
![imagen](imagenes/Reto1.1.png)
![imagen](imagenes/Reto1.2.png)

#### Un poco acerca de JOIN:
![imagen](imagenes/JOINs.png)

Imagen tomada de: Prieto Fernandéz, R.(2020). ¿Cómo funcionan los principales SQL JOINS?[Blog] Retrived from https://www.raulprietofernandez.net/blog/bases-de-datos/como-funcionan-los-principales-sql-joins
## :pushpin: Reto 2: Joins.
![imagen](imagenes/Reto2.png)
![imagen](imagenes/Reto2.1.png)
![imagen](imagenes/Reto2.2.png)
## :pushpin: Reto 3: Definición de vistas.
![imagen](imagenes/Reto3.png)
![imagen](imagenes/Reto3.1.png)
![imagen](imagenes/Reto3.2.png)
![imagen](imagenes/Reto3.3.png)
![imagen](imagenes/Reto3.4.png)
