SYSTEM clear;

call crearRecinto('Vigo','Balaídos', 'Avenida de Balaídos', 15, NULL, 10000);

call crearEspectaculo('El lago de los cisnes', '1987-01-16 06:02:20', 'Ballet', 'Matthew Bourne', 15.4);

call crearEvento ((SELECT max(IDEspectaculo) FROM Espectaculo) , (SELECT max(IDRecinto) FROM Recinto) , '2026-2-19 9:00:00' , '2024-2-19 11:00:00' , '2026-2-14 11:00:00' , '2026-2-16 11:00:00' , 'Abierto');

call crearEvento (526985265 , (SELECT max(IDRecinto) FROM Recinto) , '2026-2-19 9:00:00' , '2026-2-19 11:00:00' , '2026-2-14 11:00:00' , '2026-2-16 11:00:00' , 'Abierto');

call crearEvento ((SELECT max(IDEspectaculo) FROM Espectaculo) , (SELECT max(IDRecinto) FROM Recinto) , '2026-2-19 9:00:00' , '2026-2-19 11:00:00' , '2026-2-14 11:00:00' , '2026-2-16 11:00:00' , 'Abierto');


SELECT * FROM Recinto WHERE Nombre = 'Balaídos';




CALL crearGrada(5145875, 'Grada Abel Caballero', 30, 1);
CALL crearGrada((SELECT max(IDRecinto) FROM Recinto), 'Grada Abel Caballero', 30, 2.5);


SELECT * FROM Grada WHERE ID_grada = (SELECT max(ID_grada) FROM Grada);

SELECT * FROM Localidad WHERE IDGrada = (SELECT max(ID_grada) FROM Grada);

SELECT * FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto) AND IDEspectaculo = (SELECT max(IDEspectaculo) FROM Espectaculo);



call eliminarGrada(5145875);

call eliminarGrada((SELECT max(ID_grada) FROM Grada));

SELECT * FROM Grada WHERE ID_grada = (SELECT max(ID_grada) FROM Grada);


call cancelarEvento((SELECT max(IDEvento) FROM Evento));
DELETE FROM Evento WHERE IDRecinto =  (SELECT max(IDRecinto) FROM Recinto);
DELETE FROM Espectaculo WHERE TipoEspectaculo = 'Ballet';
DELETE FROM Recinto WHERE Nombre = 'Balaídos';



