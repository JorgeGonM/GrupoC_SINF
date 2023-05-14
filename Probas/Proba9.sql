SYSTEM clear;

USE Proxecto;

call EntradasDisponibles(1);

call crearRecinto('Vigo','Balaídos', 'Avenida de Balaídos', 15, NULL, 10000);


/*DELETE FROM Recinto WHERE Nombre = 'Balaídos';*/
