SYSTEM clear;



INSERT INTO Recinto (Nombre, Calle, Numero, Ciudad, Sala, Aforo) VALUES ('Balaídos','Avenida de Balaídos', 0, 'Vigo', NULL, 10000);


INSERT INTO Recinto (Nombre, Calle, Numero, Ciudad, Sala, Aforo) VALUES ('Balaídos','Avenida de Balaídos', 15, 'Vigo', 0, 10000);


INSERT INTO Recinto (Nombre, Calle, Numero, Ciudad, Sala, Aforo) VALUES ('Balaídos','Avenida de Balaídos', 15, 'Vigo', NULL, 0);


INSERT INTO Recinto (Nombre, Calle, Numero, Ciudad, Sala, Aforo) VALUES (NULL,'Avenida de Balaídos', 15, 'Vigo', NULL, 10000);

INSERT INTO Recinto (Nombre, Calle, Numero, Ciudad, Sala, Aforo) VALUES ('Balaídos','Avenida de Balaídos', 15, 'Vigo', NULL, 10000);

SELECT * FROM Recinto WHERE Nombre = 'Balaídos';

DELETE FROM Recinto WHERE Nombre = 'Balaídos';

SELECT * FROM Recinto WHERE Nombre = 'Balaídos';
