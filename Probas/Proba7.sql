-- Nesta proba comprobamos que se pode reservar entradas, comprar entradas, anular entradas e volver comprar estas entradas.
SYSTEM clear;

call engadirCliente('35257898E','mariana1652000@gmail.com');
call engadirCliente('44583632B','jorgegon1420@gmail.com');

call crearRecinto('Vigo','Balaídos', 'Avenida de Balaídos', 15, NULL, 10000);

call crearEspectaculo('El lago de los cisnes', '1987-01-16 06:02:20', 'Ballet', 'Matthew Bourne', 15.4);

call crearEvento ((SELECT max(IDEspectaculo) FROM Espectaculo) , (SELECT max(IDRecinto) FROM Recinto) , '2026-2-19 9:00:00' , '2026-2-19 11:00:00' , '2026-2-14 11:00:00' , '2026-2-16 11:00:00' , 'Abierto');

CALL crearGrada((SELECT max(IDRecinto) FROM Recinto), 'Grada Abel Caballero', 10, 2.5);


SELECT * FROM Entrada WHERE IDEvento = (SELECT IDEvento FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto) AND IDEspectaculo =  (SELECT max(IDEspectaculo) FROM Espectaculo));



CALL reservaDeEntradas(12585425, (SELECT max(IDLocalidad) FROM Localidad), '35257898E', 'Adulto');
CALL reservaDeEntradas((SELECT max(IDEvento) FROM Evento), 51252541, '35257898E', 'Adulto');
CALL reservaDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad), '5556565', 'Adulto');


CALL reservaDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad)-2 FROM Localidad), '35257898E', 'Adulto');
CALL reservaDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad)-1 FROM Localidad), '35257898E', 'Bebe');
CALL reservaDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad), '35257898E', 'Jubilado');


SELECT * FROM Entrada WHERE IDEvento = (SELECT IDEvento FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto) AND IDEspectaculo =  (SELECT max(IDEspectaculo) FROM Espectaculo));

CALL reservaDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad), '44583632B', 'Adulto');



CALL compraDeEntradas(54252355, (SELECT max(IDLocalidad) FROM Localidad), '35257898E' , 'Efectivo', NULL, 'Adulto');
CALL compraDeEntradas((SELECT max(IDEvento) FROM Evento), 5426523652, '35257898E' , 'Efectivo', NULL, 'Adulto');
CALL compraDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad), '55565656' , 'Efectivo', NULL, 'Adulto');


CALL compraDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad), '35257898E' , 'Efectivo', NULL, 'Adulto');


SELECT * FROM Entrada WHERE IDEvento = (SELECT IDEvento FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto) AND IDEspectaculo =  (SELECT max(IDEspectaculo) FROM Espectaculo));

CALL compraDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad), '44583632B' , 'Efectivo', NULL, 'Adulto');


CALL anulacionDeEntradas(545456555, '35257898E');
CALL anulacionDeEntradas((SELECT max(IDEntrada) FROM Entrada), '37898E55');


CALL anulacionDeEntradas((SELECT max(IDEntrada)-1 FROM Entrada), '35257898E');
CALL anulacionDeEntradas((SELECT max(IDEntrada) FROM Entrada), '35257898E');


SELECT * FROM Entrada WHERE IDEvento = (SELECT IDEvento FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto) AND IDEspectaculo =  (SELECT max(IDEspectaculo) FROM Espectaculo));

SELECT * FROM EntradaAnulada WHERE IDEvento = (SELECT IDEvento FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto) AND IDEspectaculo =  (SELECT max(IDEspectaculo) FROM Espectaculo));



CALL reservaDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad), '44583632B', 'Adulto');

CALL compraDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad)-1, '44583632B' , 'Efectivo', NULL, 'Parado');


SELECT * FROM Entrada WHERE IDEvento = (SELECT IDEvento FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto) AND IDEspectaculo =  (SELECT max(IDEspectaculo) FROM Espectaculo));

SELECT * FROM EntradaAnulada WHERE IDEvento = (SELECT IDEvento FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto) AND IDEspectaculo =  (SELECT max(IDEspectaculo) FROM Espectaculo));




call eliminarGrada((SELECT max(ID_grada) FROM Grada));
call cancelarEvento((SELECT max(IDEvento) FROM Evento));


SELECT * FROM EntradaAnulada WHERE IDEvento = (SELECT IDEvento FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto) AND IDEspectaculo =  (SELECT max(IDEspectaculo) FROM Espectaculo));

 
DELETE FROM EntradaAnulada WHERE IDCliente = '35257898E';
DELETE FROM EntradaAnulada WHERE IDCliente = '44583632B';
DELETE FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto);
DELETE FROM Espectaculo WHERE TipoEspectaculo = 'Ballet';
DELETE FROM Recinto WHERE Nombre = 'Balaídos';

DELETE FROM Cliente WHERE IDCliente = '35257898E';
DELETE FROM Cliente WHERE IDCliente = '44583632B';

