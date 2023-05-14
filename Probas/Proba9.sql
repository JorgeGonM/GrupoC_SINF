-- Nesta proba comprobamos que cada cada usuario só pode aceder ao que ten permiso. Definido no fichero 'usuario.sql'
SYSTEM clear;

USE Proxecto;

call EntradasDisponibles(1);

call crearRecinto('Vigo','Balaídos', 'Avenida de Balaídos', 15, NULL, 10000);


/*DELETE FROM Recinto WHERE Nombre = 'Balaídos';*/
