USE sastreria_3;
-- tablas 
Select * from cliente;
Select * from factura;
Select * from sastrero;
-- Ingresar informacion
Insert into cliente (nombre,apellido,direccion,telefono,correo)
values("Pepita","JAJAJAAJ","Madrid",233322,"Pepita@gmail.com");
-- eliminar
Delete from cliente where id_cliente between  19 and 29;
-- Count
select count(fk_tipo_trabajo) as tipo_trabajo from factura where fk_tipo_trabajo = 1;
select count(fk_tipo_trabajo) as tipo_trabajo from factura where fk_tipo_trabajo = 2;
-- Group by
select fk_sastrero from factura group by fk_sastrero;
-- between
select * from factura where precio not between 200 and 600;
-- inner join
select fk_sastrero as id, nombre_sastrero as sastrero, fk_tipo_trabajo as id_tipo_trabajo , nombre as cliente, precio
from cliente
inner join factura on cliente.id_cliente = factura.fk_cliente
inner join sastrero on factura.fk_sastrero = sastrero.id_satrero
order by (precio) ASC ;
