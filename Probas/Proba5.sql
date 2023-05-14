-- Nesta proba comprobamos a creacion e eliminación de gradas e eventos empregando os procedementos almacenados.
SYSTEM clear;

call crearRecinto('Vigo','Balaídos', 'Avenida de Balaídos', 15, NULL, 10000);

call crearEspectaculo('El lago de los cisnes', '1987-01-16 06:02:20', 'Ballet', 'Matthew Bourne', 15.4);


-- Error en la fecha
call crearEvento ((SELECT max(IDEspectaculo) FROM Espectaculo) , (SELECT max(IDRecinto) FROM Recinto) , '2026-2-19 9:00:00' , '2024-2-19 11:00:00' , '2026-2-14 11:00:00' , '2026-2-16 11:00:00' , 'Abierto');

-- Error porque el id del espectaculo no existe no existe
call crearEvento (526985265 , (SELECT max(IDRecinto) FROM Recinto) , '2026-2-19 9:00:00' , '2026-2-19 11:00:00' , '2026-2-14 11:00:00' , '2026-2-16 11:00:00' , 'Abierto');


-- Este si que se crea
call crearEvento ((SELECT max(IDEspectaculo) FROM Espectaculo) , (SELECT max(IDRecinto) FROM Recinto) , '2026-2-19 9:00:00' , '2026-2-19 11:00:00' , '2026-2-14 11:00:00' , '2026-2-16 11:00:00' , 'Abierto');


-- Mostramos el recinto de Balaídos
SELECT * FROM Recinto WHERE Nombre = 'Balaídos';

-- Este non funciona porque o id que lle pasamos non existe
CALL crearGrada(5145875, 'Grada Abel Caballero', 30, 1);

-- Esta si que funciona. Capacidad = 30, suplemento = 2.5
CALL crearGrada((SELECT max(IDRecinto) FROM Recinto), 'Grada Abel Caballero', 30, 2.5);


SELECT * FROM Grada WHERE ID_grada = (SELECT max(ID_grada) FROM Grada);

SELECT * FROM Localidad WHERE IDGrada = (SELECT max(ID_grada) FROM Grada);

SELECT * FROM Evento WHERE IDRecinto = (SELECT max(IDRecinto) FROM Recinto) AND IDEspectaculo = (SELECT max(IDEspectaculo) FROM Espectaculo);


-- Non existe esta grada. Da error
call eliminarGrada(5145875);

-- Este si que funciona
call eliminarGrada((SELECT max(ID_grada) FROM Grada));

SELECT * FROM Grada WHERE ID_grada = (SELECT max(ID_grada) FROM Grada);


-- Primeiro eliminamos cancelar evento, despois eliminamos e evento, depois o espectáculo e por último o recinto. Ten que ser neste orden
call cancelarEvento((SELECT max(IDEvento) FROM Evento));
DELETE FROM Evento WHERE IDRecinto =  (SELECT max(IDRecinto) FROM Recinto);
DELETE FROM Espectaculo WHERE TipoEspectaculo = 'Ballet';
DELETE FROM Recinto WHERE Nombre = 'Balaídos';



