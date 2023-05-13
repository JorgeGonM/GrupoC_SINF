SYSTEM clear;

INSERT INTO Espectaculo (Nombre, FechaEspectaculo, TipoEspectaculo, ProductorEspectaculo, PrecioBase) VALUES ('El lago de los cisnes', '1987-01-16 06:02:20', 'Ballet', 'Matthew Bourne', -50);

INSERT INTO Espectaculo (Nombre, FechaEspectaculo, TipoEspectaculo, ProductorEspectaculo, PrecioBase) VALUES ('El lago de los cisnes', '1987-01-16 06:02:20', NULL, 'Matthew Bourne', 15.4);

INSERT INTO Espectaculo (Nombre, FechaEspectaculo, TipoEspectaculo, ProductorEspectaculo, PrecioBase) VALUES ('El lago de los cisnes', '1987-01-16 06:02:20', 'Ballet', 'Matthew Bourne', 15.4);

SELECT * FROM Espectaculo WHERE TipoEspectaculo = 'Ballet';

DELETE FROM Espectaculo WHERE TipoEspectaculo = 'Ballet';

SELECT * FROM Espectaculo WHERE TipoEspectaculo = 'Ballet';
