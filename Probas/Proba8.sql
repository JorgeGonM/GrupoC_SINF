SYSTEM clear;

call engadirCliente('35257898E','mariana1652000@gmail.com');
call engadirCliente('44583632B','jorgegon1420@gmail.com');

call crearRecinto('Vigo','Balaídos', 'Avenida de Balaídos', 15, NULL, 10000);

call crearEspectaculo('El lago de los cisnes', '1987-01-16 06:02:20', 'Ballet', 'Matthew Bourne', 15.4);


call crearEspectaculo('AHHHHHHH', '1987-01-16 06:02:20', 'Grital', 'Matthew Bourne', 15.4);

call crearEvento ((SELECT max(IDEspectaculo) FROM Espectaculo)-1 , (SELECT max(IDRecinto) FROM Recinto) , '2026-2-19 9:00:00' , '2026-2-19 11:00:00' , '2026-2-14 11:00:00' , '2026-2-16 11:00:00' , 'Abierto');



call crearEvento ((SELECT max(IDEspectaculo) FROM Espectaculo) , (SELECT max(IDRecinto) FROM Recinto) , '2027-2-19 9:00:00' , '2027-2-19 11:00:00' , '2027-2-14 11:00:00' , '2027-2-16 11:00:00' , 'Abierto');





CALL crearGrada((SELECT max(IDRecinto) FROM Recinto), 'Grada Abel Caballero', 10, 2.5);


SELECT * FROM Entrada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento);
SELECT * FROM Entrada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento)-1;


CALL reservaDeEntradas((SELECT max(IDEvento) FROM Evento)-1, (SELECT max(IDLocalidad) FROM Localidad), '35257898E', 'Jubilado');

CALL compraDeEntradas((SELECT max(IDEvento) FROM Evento)-1, (SELECT max(IDLocalidad) FROM Localidad)-1, '44583632B' , 'Efectivo', NULL, 'Adulto');



CALL reservaDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad), '35257898E', 'Jubilado');

CALL compraDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad)-1, '44583632B' , 'Efectivo', NULL, 'Adulto');





SELECT * FROM Entrada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento);
SELECT * FROM Entrada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento)-1;


CALL estadoLocalidad((SELECT max(IDLocalidad) FROM Localidad));

SELECT * FROM Entrada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento);
SELECT * FROM Entrada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento)-1;


SELECT * FROM Localidad WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto);


SELECT * FROM EntradaAnulada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento);
SELECT * FROM EntradaAnulada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento)-1;



CALL estadoLocalidad((SELECT max(IDLocalidad) FROM Localidad));


SELECT * FROM Entrada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento);
SELECT * FROM Entrada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento)-1;


SELECT * FROM Localidad WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto);






call eliminarGrada((SELECT max(ID_grada) FROM Grada));
call cancelarEvento((SELECT max(IDEvento) FROM Evento));
call cancelarEvento((SELECT max(IDEvento) FROM Evento)-1);



SELECT * FROM EntradaAnulada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento);
SELECT * FROM EntradaAnulada WHERE IDEvento = (SELECT max(IDEvento) FROM Evento)-1;



 
DELETE FROM EntradaAnulada WHERE IDCliente = '35257898E';
DELETE FROM EntradaAnulada WHERE IDCliente = '44583632B';
DELETE FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto);
DELETE FROM Espectaculo WHERE TipoEspectaculo = 'Ballet';
DELETE FROM Espectaculo WHERE TipoEspectaculo = 'Grital';
DELETE FROM Recinto WHERE Nombre = 'Balaídos';

DELETE FROM Cliente WHERE IDCliente = '35257898E';
DELETE FROM Cliente WHERE IDCliente = '44583632B';

