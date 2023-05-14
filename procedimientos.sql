
DELIMITER //

DROP PROCEDURE IF EXISTS calcularPrecioTotal //

CREATE PROCEDURE calcularPrecioTotal(

    IN TipoUsuarioIN VARCHAR(20),
    IN IDEspectaculoIN INT,
    IN IDGradaIN INT,
    OUT PrecioTotal FLOAT
)

BEGIN 

    DECLARE SuplementoPrecioGrada FLOAT;
    DECLARE DescuentoPrecioUsuario FLOAT;
    DECLARE PrecioBaseEvento FLOAT;

    SET SuplementoPrecioGrada = 0;
    SET DescuentoPrecioUsuario = 0;
    SET PrecioBaseEvento = 0;

    SELECT PrecioBase INTO PrecioBaseEvento FROM Espectaculo WHERE IDEspectaculo = IDEspectaculoIN;
    SELECT SuplementoPrecio INTO SuplementoPrecioGrada FROM Grada WHERE ID_grada = IDGradaIN;
    SELECT DescuentoPrecio INTO DescuentoPrecioUsuario FROM TipoUsuario WHERE Tipo = TipoUsuarioIN;

    SET PrecioTotal = PrecioBaseEvento * SuplementoPrecioGrada * DescuentoPrecioUsuario;

END //



-- PROCEDIMIENTOS DEL CLIENTE:
DROP PROCEDURE IF EXISTS reservaDeEntradas //


CREATE PROCEDURE reservaDeEntradas(

    IN IDEventoIN INT,
    IN IDLocalidadIN INT,
    IN IDClienteIN VARCHAR(9),
    IN TipoUsuarioIN VARCHAR(20)
)

BEGIN   

    DECLARE IDEspectaculoIN INT;
    DECLARE IDGradaIN INT;
    DECLARE Precio FLOAT;
    DECLARE mensajeError varchar(255);

    IF((SELECT EXISTS(SELECT * FROM Evento WHERE IDEvento = IDEventoIN)) = '') THEN
        SET mensajeError = 'Non existe o evento a reservar.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    

    ELSEIF((SELECT EXISTS(SELECT * FROM Evento JOIN Localidad ON Evento.IDRecinto = Localidad.IDRecinto WHERE Localidad.IDLocalidad = IDLocalidadIN AND Evento.IDEvento = IDEventoIN)) = '') THEN
        SET mensajeError = 'Non existe a localidade a reservar.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    

    ELSEIF((SELECT EXISTS(SELECT * FROM Cliente WHERE IDCliente = IDClienteIN)) = '') THEN
        SET mensajeError = 'Non existe o cliente que quere reservar.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
        

    ELSEIF((SELECT FechaReserva FROM Evento WHERE IDEvento = IDEventoIN) < NOW()) THEN
        SET mensajeError = 'Non podes reservar porque o periodo de reserva está cerrado.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;    


    ELSEIF((SELECT Estado FROM Entrada WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN) = "Disponible") THEN
        
        SELECT IDEspectaculo INTO IDEspectaculoIN FROM Evento WHERE IDEvento = IDEventoIN;
        SELECT IDGrada INTO IDGradaIN FROM Localidad WHERE IDLocalidad = IDLocalidadIN;
        CALL calcularPrecioTotal(TipoUsuarioIN, IDEspectaculoIN, IDGradaIN, Precio); 
        
        UPDATE Entrada SET Estado = "Reservada", PrecioTotal = Precio, IDCliente = IDClienteIN WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;
        



    ELSE

        SET mensajeError = 'Entrada non dispoñible para reservar.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;

    END IF;

END //



DROP PROCEDURE IF EXISTS compraDeEntradas //

CREATE PROCEDURE compraDeEntradas(

    IN IDEventoIN INT,
    IN IDLocalidadIN INT,
    IN IDClienteIN VARCHAR(9),
    IN MetodoDePagoIN VARCHAR(50),
    IN NumeroDeCuentaIN VARCHAR(30),
    IN TipoUsuarioIN VARCHAR(20)
)

BEGIN

    DECLARE IDEspectaculoIN INT;
    DECLARE IDGradaIN INT;
    DECLARE Precio FLOAT;
    DECLARE mensajeError varchar(255);

    SET IDEspectaculoIN = 0;
    SET IDGradaIN = 0;
    SET Precio = 0;

    IF((SELECT EXISTS(SELECT * FROM Evento WHERE IDEvento = IDEventoIN)) = '') THEN
        SET mensajeError = 'Non existe o evento a comprar.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;

    IF((SELECT EXISTS(SELECT * FROM Evento JOIN Localidad ON Evento.IDRecinto = Localidad.IDRecinto WHERE Localidad.IDLocalidad = IDLocalidadIN AND Evento.IDEvento = IDEventoIN)) = '') THEN
        SET mensajeError = 'Non existe a localidade a comprar.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;

    IF((SELECT EXISTS(SELECT * FROM Cliente WHERE IDCliente = IDClienteIN)) = '') THEN
        SET mensajeError = 'Non existe o cliente que quere comprar.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;

    END IF;


    IF((SELECT Estado FROM Entrada WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN) = "Disponible") THEN

        SELECT IDEspectaculo INTO IDEspectaculoIN FROM Evento WHERE IDEvento = IDEventoIN;
        SELECT IDGrada INTO IDGradaIN FROM Localidad WHERE IDLocalidad = IDLocalidadIN;
        CALL calcularPrecioTotal(TipoUsuarioIN, IDEspectaculoIN, IDGradaIN, Precio);
        
        UPDATE Entrada SET PrecioTotal = Precio WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;
        UPDATE Entrada SET Estado = "Comprada" WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;
        UPDATE Entrada SET IDCliente = IDClienteIN WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;
        UPDATE Cliente SET MetodoDePago = MetodoDePagoIN WHERE IDCliente = IDClienteIN;
        UPDATE Cliente SET NumeroDeCuenta = NumeroDeCuentaIN WHERE IDCliente = IDClienteIN;

    ELSE
        IF((SELECT Estado FROM Entrada WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN) = "Reservada" AND 
            (SELECT IDCliente FROM Entrada WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN) = IDClienteIN) THEN
        
            SELECT IDEspectaculo INTO IDEspectaculoIN FROM Evento WHERE IDEvento = IDEventoIN;
            SELECT IDGrada INTO IDGradaIN FROM Localidad WHERE IDLocalidad = IDLocalidadIN;
            CALL calcularPrecioTotal (TipoUsuarioIN, IDEspectaculoIN, IDGradaIN, Precio);
        
            UPDATE Entrada SET PrecioTotal = Precio WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;
            UPDATE Entrada SET Estado = "Comprada" WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;
            UPDATE Cliente SET MetodoDePago = MetodoDePagoIN WHERE IDCliente = IDClienteIN;
            UPDATE Cliente SET NumeroDeCuenta = NumeroDeCuentaIN WHERE IDCliente = IDClienteIN;
    
        ELSE
            SET mensajeError = 'Entrada non dispoñible para a compra.';
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;

        END IF;
    END IF;
END //



DROP PROCEDURE IF EXISTS anulacionDeEntradas //

CREATE PROCEDURE anulacionDeEntradas(

    IN IDEntradaIN INT,
    IN IDClienteIN VARCHAR(9)
    
)

BEGIN 

    DECLARE mensajeError varchar(255);

    IF((SELECT EXISTS(SELECT * FROM Entrada WHERE IDEntrada = IDEntradaIN)) = '') THEN
        SET mensajeError = 'Non existe a entrada a anular.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;

    IF((SELECT EXISTS(SELECT * FROM Cliente WHERE IDCliente = IDClienteIN)) = '') THEN
        SET mensajeError = 'Non existe o cliente que quere anular.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;

    IF((SELECT FechaAnulacion FROM Evento WHERE IDEvento = (SELECT IDEvento FROM Entrada WHERE IDEntrada = IDEntradaIN)) < NOW()) THEN
        SET mensajeError = 'Non é posible anular porque o periodo de anulación está cerrado.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;


    IF((SELECT Estado FROM Entrada WHERE IDEntrada = IDEntradaIN) = "Reservada" AND 
        (SELECT IDCliente FROM Entrada WHERE IDEntrada = IDEntradaIN) = IDClienteIN) THEN

        INSERT INTO EntradaAnulada (IDEvento, IDCliente, PrecioTotal) SELECT IDEvento, IDCliente, PrecioTotal FROM Entrada WHERE IDEntrada = IDEntradaIN;

        UPDATE Entrada SET PrecioTotal = NULL WHERE IDEntrada = IDEntradaIN;
        UPDATE Entrada SET Estado = "Disponible" WHERE IDEntrada = IDEntradaIN;
        UPDATE Entrada SET IDCliente = NULL WHERE IDEntrada = IDEntradaIN;

    ELSEIF((SELECT Estado FROM Entrada WHERE IDEntrada = IDEntradaIN) = "Comprada" AND 
        (SELECT IDCliente FROM Entrada WHERE IDEntrada = IDEntradaIN) = IDClienteIN) THEN

        INSERT INTO EntradaAnulada (IDEvento, IDCliente, PrecioTotal, Vendida) SELECT IDEvento, IDCliente, PrecioTotal, TRUE FROM Entrada WHERE IDEntrada = IDEntradaIN;

        UPDATE Entrada SET PrecioTotal = NULL WHERE IDEntrada = IDEntradaIN;
        UPDATE Entrada SET Estado = "Disponible" WHERE IDEntrada = IDEntradaIN;
        UPDATE Entrada SET IDCliente = NULL WHERE IDEntrada = IDEntradaIN;

    ELSE
        SET mensajeError = 'Non podes anular a entrada porque non a ten reservada.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError; 
    END IF;

END //


DROP PROCEDURE IF EXISTS engadirCliente //

CREATE PROCEDURE engadirCliente(

    IN IDClienteIN VARCHAR(15),
    IN emailIN VARCHAR(100)

)

BEGIN

INSERT INTO Cliente (IDCliente, Email) VALUES (IDClienteIN, emailIN);

END //



DROP PROCEDURE IF EXISTS EntradasCliente //

CREATE PROCEDURE EntradasCliente(

    IN IDClienteIN VARCHAR(15)

)

BEGIN

    SELECT Espectaculo.Nombre AS Espectaculo, Recinto.Nombre AS Recinto, Grada.Nombre AS Grada, Localidad.Numero AS Sitio, Evento.FechaInicio FROM Entrada
    JOIN Evento ON Entrada.IDEvento = Evento.IDEvento
    JOIN Recinto ON Recinto.IDRecinto = Evento.IDRecinto
    JOIN Espectaculo ON Espectaculo.IDEspectaculo = Evento.IDEspectaculo
    JOIN Localidad ON Localidad.IDLocalidad = Entrada.IDLocalidad
    JOIN Grada ON Grada.ID_grada = Localidad.IDGrada
    WHERE IDCliente = IDClienteIN;
    

END //


DROP PROCEDURE IF EXISTS EntradasDisponibles //

CREATE PROCEDURE EntradasDisponibles(

    IN IDEventoIN INT

)

BEGIN

    SELECT Localidad.IDGrada, Localidad.Numero AS 'Numero Localidad' FROM Entrada
    JOIN Localidad ON Localidad.IDLocalidad = Entrada.IDLocalidad
    WHERE IDEvento = IDEventoIN AND Entrada.Estado = "Disponible";


END //



-- PROCEDIMIENTOS DEL ADMINISTRADOR:

DROP PROCEDURE IF EXISTS crearRecinto //

CREATE PROCEDURE crearRecinto(

    IN CiudadIN VARCHAR(100),
    IN NombreIN VARCHAR(100),
    IN CalleIN VARCHAR(100),
    IN NumeroIN INT,
    IN SalaIN INT,
    IN AforoIN INT
)

BEGIN
    INSERT INTO Recinto (Ciudad, Nombre, Calle, Numero, Sala, Aforo) VALUE (CiudadIN, NombreIN, CalleIN, NumeroIN, SalaIN, AforoIN);
END //



DROP PROCEDURE IF EXISTS crearEspectaculo //

CREATE PROCEDURE crearEspectaculo(

    IN NombreIN VARCHAR(200),
    IN FechaEspectaculoIN DATETIME,
    IN TipoEspectaculoIN VARCHAR(30),
    IN ProductorEspectaculoIN VARCHAR(100),
    IN PrecioBaseIN INT
)

BEGIN
    INSERT INTO Espectaculo (Nombre, FechaEspectaculo, TipoEspectaculo, ProductorEspectaculo, PrecioBase) VALUE (NombreIN, FechaEspectaculoIN, TipoEspectaculoIN, ProductorEspectaculoIN, PrecioBaseIN);
END //


DROP PROCEDURE IF EXISTS crearGrada //

CREATE PROCEDURE crearGrada(

    IN IDRecintoIN INT,
    IN NombreIN VARCHAR(100),
    IN CapacidadIN INT,
    IN SuplementoPrecioIN FLOAT
)

BEGIN

    DECLARE idGrada INT;
    DECLARE capacidadAux INT;
    DECLARE numEvento INT;
    DECLARE IDLocalidadAux INT;
    DECLARE mensajeError varchar(255);

    DECLARE cursorEventos CURSOR FOR SELECT IDEvento FROM Evento WHERE (IDRecinto = IDRecintoIN AND FechaInicio > NOW());
    
   
    SET idGrada = 0;
    SET capacidadAux = 0;
    

    
    IF(SuplementoPrecioIN < 1) THEN
        SET mensajeError = 'Non se creou a grada porque o suplemento do precio é menor a 1.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    
    
    ELSEIF(CapacidadIN = 0) THEN
        SET mensajeError = 'Non se creou a grada porque a capacidade é igual a 0.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    

    ELSEIF((SELECT EXISTS(SELECT * FROM Recinto WHERE IDRecinto = IDRecintoIN)) = '') THEN
        SET mensajeError = 'Non se creou a grada porque non existe o recinto.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    

    ELSEIF(CapacidadIN > (SELECT Aforo FROM Recinto WHERE IDRecinto = IDRecintoIN)) THEN
        SET mensajeError = 'Non se creou a grada porque excedeuse a capacidade do recinto.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
        

    ELSEIF(((SELECT SUM(Capacidad) FROM Grada WHERE ID_recinto = IDRecintoIN) + CapacidadIN) > (SELECT Aforo FROM Recinto WHERE IDRecinto = IDRecintoIN)) THEN
        SET mensajeError = 'Non se creou a grada porque excedeuse a capacidade do recinto.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;

    INSERT INTO Grada(ID_recinto, Nombre, SuplementoPrecio, Capacidad) VALUES
        (IDRecintoIN, NombreIN, SuplementoPrecioIN, CapacidadIN);

    SELECT ID_grada INTO idGrada FROM Grada WHERE ID_grada=(SELECT max(ID_grada) FROM Grada);

    bucleCrearLocalidades : LOOP
        IF capacidadAux = CapacidadIN THEN 
            LEAVE bucleCrearLocalidades;

        ELSE

            INSERT INTO Localidad(IDRecinto, IDGrada, Numero) VALUES (IDRecintoIN, idGrada, capacidadAux);
            SET capacidadAux = capacidadAux + 1;

        END IF;
    END LOOP;
    OPEN cursorEventos;
    BEGIN
        DECLARE finEventos BOOLEAN DEFAULT false;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finEventos = TRUE;
        

        bucleEventos: LOOP

            FETCH cursorEventos INTO numEvento;

            IF finEventos THEN
                LEAVE bucleEventos;
            ELSE
                SET capacidadAux = 0;
                bucleEventos2 : LOOP
                    IF capacidadAux = CapacidadIN THEN
                        LEAVE bucleEventos2;
                    ELSE
                        SELECT IDLocalidad INTO IDLocalidadAux FROM Localidad WHERE IDRecinto = IDRecintoIN AND Numero = capacidadAux AND IDGrada = (SELECT max(ID_grada) FROM Grada);
                        INSERT INTO Entrada (IDEvento, IDLocalidad) VALUES (numEvento, IDLocalidadAux);
                        SET capacidadAux = capacidadAux + 1;

                    END IF;
                END LOOP;
            END IF;
        END LOOP;
    END;
    CLOSE cursorEventos;
END //




DROP PROCEDURE IF EXISTS eliminarGrada //

CREATE PROCEDURE eliminarGrada(

    IN IDGradaIN INT
)

BEGIN

    DECLARE mensajeError varchar(255);

    IF((SELECT EXISTS(SELECT * FROM Grada WHERE ID_grada = IDGradaIN)) = '') THEN
        SET mensajeError = 'Non se pode eliminar a grada porque non existe.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;

    INSERT INTO EntradaAnulada (IDEvento, IDCliente, PrecioTotal) SELECT Entrada.IDEvento, Entrada.IDCliente, Entrada.PrecioTotal FROM Entrada, Localidad WHERE Entrada.IDLocalidad = Localidad.IDLocalidad AND Localidad.IDGrada = IDGradaIN AND Entrada.Estado = "Reservada";
    INSERT INTO EntradaAnulada (IDEvento, IDCliente, PrecioTotal, Vendida) SELECT Entrada.IDEvento, Entrada.IDCliente, Entrada.PrecioTotal, TRUE FROM Entrada, Localidad WHERE Entrada.IDLocalidad = Localidad.IDLocalidad AND Localidad.IDGrada = IDGradaIN AND Entrada.Estado = "Comprada";

    DELETE Entrada FROM Entrada
    INNER JOIN Localidad ON Localidad.IDLocalidad = Entrada.IDLocalidad
    WHERE Localidad.IDGrada = IDGradaIN;

    DELETE FROM Localidad WHERE IDGrada = IDGradaIN;
    DELETE FROM Grada where ID_grada = IDGradaIN;

END //


DROP PROCEDURE IF EXISTS crearEvento //

CREATE PROCEDURE crearEvento(

    IN IDEspectaculoIN INT, 
    IN IDRecintoIN INT,
    IN FechaInicioIN DATETIME,
    IN FechaFinIN DATETIME,
    IN FechaReservaIN DATETIME,
    IN FechaAnulacionIN DATETIME,
    IN EstadoIN VARCHAR(50)

)

BEGIN

    DECLARE mensajeError varchar(255);
    DECLARE numeroDeEventoNuevo INT;
    DECLARE numeroDeLocalidades INT;
    DECLARE LocalidadesCursor CURSOR FOR SELECT Localidad.IDLocalidad FROM Localidad WHERE Localidad.IDRecinto = IDRecintoIN;
    
    SET numeroDeLocalidades = 0;

    IF((SELECT EXISTS(SELECT * FROM Espectaculo WHERE IDEspectaculo = IDEspectaculoIN)) = '') THEN
        SET mensajeError = 'Non se pode crear o evento porque non existe o espectaculo.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    

    ELSEIF((SELECT EXISTS(SELECT * FROM Recinto WHERE IDRecinto = IDRecintoIN)) = '') THEN
        SET mensajeError = 'Non se pode crear o evento porque non existe o recinto.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;



    IF((FechaInicioIN > FechaFinIN) OR (FechaInicioIN = FechaFinIN) OR (FechaInicioIN <= NOW()) OR (FechaAnulacionIN > DATE_SUB(FechaInicioIN,INTERVAL 8 HOUR)) OR (FechaAnulacionIN < FechaReservaIN)) THEN
        SET mensajeError = 'Datas Erróneas';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    

    ELSEIF((EstadoIN = "Finalizado")) THEN
        SET mensajeError = 'O evento está finalizado.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;

    INSERT INTO Evento (IDEspectaculo, IDRecinto, FechaInicio, FechaFin, FechaReserva, FechaAnulacion, Estado) VALUES
        (IDEspectaculoIN, IDRecintoIN, FechaInicioIN, FechaFinIN, FechaReservaIN, FechaAnulacionIN, EstadoIN);

    SELECT IDEvento INTO numeroDeEventoNuevo FROM Evento WHERE IDEspectaculo = IDEspectaculoIN AND IDRecinto = IDRecintoIN AND FechaInicio = FechaInicioIN; 

    OPEN LocalidadesCursor;
    BEGIN

        DECLARE finalDeLocalidades BOOLEAN DEFAULT false;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finalDeLocalidades = TRUE;

        localidades : LOOP

            FETCH LocalidadesCursor INTO numeroDeLocalidades;
            IF finalDeLocalidades THEN 
                LEAVE localidades;
            
            ELSE
                IF((SELECT Estado FROM Localidad WHERE IDLocalidad = numeroDeLocalidades ) = "Disponible") THEN
                    INSERT INTO Entrada(IDEvento, IDLocalidad) VALUES (numeroDeEventoNuevo, numeroDeLocalidades);
                END IF;
            END IF;
        END LOOP;
    END;
    CLOSE LocalidadesCursor;

END // 



DROP PROCEDURE IF EXISTS estadoLocalidad //

CREATE PROCEDURE estadoLocalidad(

    IN IDLocalidadIN INT
)

BEGIN

    DECLARE mensajeError varchar(255);

    IF (SELECT Estado FROM Localidad WHERE IDLocalidad = IDLocalidadIN) = "Disponible" THEN
        UPDATE Localidad SET Estado = "No Disponible" WHERE IDLocalidad = IDLocalidadIN;
    ELSEIF (SELECT Estado FROM Localidad WHERE IDLocalidad = IDLocalidadIN) = "No Disponible" THEN
        UPDATE Localidad SET Estado = "Disponible" WHERE IDLocalidad = IDLocalidadIN;
    ELSE
        SET mensajeError = 'Non se pode cambiar o estado da localidade porque non existe.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;

END //



DROP PROCEDURE IF EXISTS cancelarEvento //

CREATE PROCEDURE cancelarEvento (

    IN IDEventoIN INT
)

BEGIN

    INSERT INTO EntradaAnulada (IDEvento, IDCliente, PrecioTotal) SELECT IDEvento, IDCliente, PrecioTotal FROM Entrada WHERE IDEvento = IDEventoIN AND (Estado = "Reservada");
    INSERT INTO EntradaAnulada (IDEvento, IDCliente, PrecioTotal, Vendida) SELECT IDEvento, IDCliente, PrecioTotal, TRUE FROM Entrada WHERE IDEvento = IDEventoIN AND (Estado = "Comprada");
    DELETE FROM Entrada WHERE IDEvento = IDEventoIN;

END //



-- TRIGERS

DROP TRIGGER IF EXISTS TriggerEntradasLocalidades //

CREATE TRIGGER TriggerEntradasLocalidades AFTER UPDATE ON Localidad for each row
BEGIN

    DECLARE numeroDeEvento INT;
    DECLARE EventosCursor CURSOR FOR SELECT IDEvento FROM Evento WHERE IDRecinto = new.IDRecinto AND FechaInicio > NOW();
    
    SET numeroDeEvento = 0;

    IF (new.Estado = "Disponible") THEN
        
        OPEN EventosCursor;
        BEGIN

            DECLARE finalDeEventos BOOLEAN DEFAULT false;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET finalDeEventos = TRUE;
            eventos: LOOP

                FETCH EventosCursor INTO numeroDeEvento;

                IF finalDeEventos THEN
                    LEAVE eventos;
                ELSE
                    INSERT INTO Entrada (IDEvento, IDLocalidad) VALUES (numeroDeEvento, new.IDLocalidad);
                END IF;
            END LOOP;
        END;
        CLOSE EventosCursor;

    ELSE

        INSERT INTO EntradaAnulada (IDEvento, IDCliente, PrecioTotal) SELECT IDEvento, IDCliente, PrecioTotal FROM Entrada WHERE IDLocalidad = new.IDLocalidad AND (Estado = "Reservada");
        INSERT INTO EntradaAnulada (IDEvento, IDCliente, PrecioTotal, Vendida) SELECT IDEvento, IDCliente, PrecioTotal, TRUE FROM Entrada WHERE IDLocalidad = new.IDLocalidad AND (Estado = "Comprada");
        DELETE FROM Entrada WHERE IDLocalidad = new.IDLocalidad;

    END IF;
END //


DROP TRIGGER IF EXISTS TriggerErrorRecinto //

CREATE TRIGGER TrigerErrorRecinto BEFORE INSERT ON Recinto FOR EACH ROW
BEGIN

  IF NEW.Numero = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El numero del recinto no puede ser 0.';
  END IF;
  
  IF NEW.Sala = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sala del recinto no puede ser 0.';
  END IF;
  
  IF NEW.Aforo = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El aforo del recinto no puede ser 0.';
  END IF;
END //


DROP TRIGGER IF EXISTS TriggerErrorGrada//

CREATE TRIGGER TrigerErrorGrada BEFORE INSERT ON Grada FOR EACH ROW
BEGIN

  IF(NEW.SuplementoPrecio < 1) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Non se creou a grada porque o suplemento do precio é menor a 1.';
    
  ELSEIF(NEW.Capacidad = 0) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Non se creou a grada porque a capacidade é igual a 0.';
    

  ELSEIF((SELECT EXISTS(SELECT * FROM Recinto WHERE IDRecinto = NEW.ID_recinto)) = '') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Non se creou a grada porque non existe o recinto.';
    

  ELSEIF(NEW.Capacidad > (SELECT Aforo FROM Recinto WHERE IDRecinto = NEW.ID_recinto)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Non se creou a grada porque excedeuse a capacidade do recinto.';
  END IF;
  
END //



-- PROCEDIMIENTOS PARA EL EVENTO DE COMPROBACIÓN:


DROP PROCEDURE IF EXISTS comprobarEstadoEntradas //

CREATE PROCEDURE comprobarEstadoEntradas(

)

BEGIN
    DECLARE numeroDeEvento INT;
    DECLARE EventosCursor CURSOR FOR SELECT Evento.IDEvento FROM Evento WHERE FechaAnulacion < NOW();
        
    SET numeroDeEvento = 0;



    OPEN EventosCursor;
        BEGIN
            DECLARE finalDeEventos BOOLEAN DEFAULT false;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET finalDeEventos = TRUE;

            eventos : LOOP
                    FETCH EventosCursor INTO numeroDeEvento;
                    
                    IF finalDeEventos THEN
                        LEAVE eventos;
                    ELSE
                        INSERT INTO EntradaAnulada(IDEvento, IDCliente) SELECT IDEvento, IDCliente FROM Entrada WHERE IDEvento = numeroDeEvento AND Estado = "Reservada";
                        UPDATE Entrada SET Estado = "Disponible", IDCliente = NULL WHERE IDEvento = numeroDeEvento AND Entrada.Estado = "Reservada"; 

                    END IF; 
        
                END LOOP;
            END;
        CLOSE EventosCursor;
END //



DROP PROCEDURE IF EXISTS comprobarEstadoEventos //

CREATE PROCEDURE comprobarEstadoEventos(

)

BEGIN

    DECLARE numeroDeEventos INT;
    DECLARE EventosCursor CURSOR FOR SELECT Evento.IDEvento FROM Evento WHERE FechaFin < NOW();

    set numeroDeEventos = 0;

    OPEN EventosCursor;
        BEGIN
            DECLARE finalDeEventos BOOLEAN DEFAULT false;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET finalDeEventos = TRUE;

            eventos : LOOP
                FETCH EventosCursor INTO numeroDeEventos;

                IF finalDeEventos THEN
                    LEAVE eventos;
                ELSE
                    UPDATE Evento SET Estado = "Finalizado" WHERE IDEvento = numeroDeEventos;
                    DELETE FROM Entrada WHERE IDEvento = numeroDeEventos AND Estado != "Comprada";

                END IF;
            END LOOP;
        END;
    CLOSE EventosCursor;
END //



-- EVENTO COMPROBACION



DROP EVENT IF EXISTS EventoComprobacion //

CREATE EVENT EventoComprobacion 
ON SCHEDULE EVERY 10 MINUTE
DO
BEGIN

    CALL comprobarEstadoEntradas();
    CALL comprobarEstadoEventos();
    
END //





DELIMITER ;

-- VISTAS

DROP VIEW IF EXISTS VistaDeEntradas;

CREATE VIEW VistaDeEntradas AS SELECT Espectaculo.Nombre AS Espectaculo, Recinto.Nombre AS Recinto, Grada.Nombre AS Grada, COUNT(Entrada.IDEntrada) AS Disponibles, Evento.FechaInicio FROM Evento 
    JOIN Recinto ON Evento.IDRecinto = Recinto.IDRecinto
    JOIN Espectaculo ON Evento.IDEspectaculo = Espectaculo.IDEspectaculo
    JOIN Grada ON Recinto.IDRecinto = Grada.ID_recinto
    JOIN Entrada ON Evento.IDEvento = Entrada.IDEvento
    WHERE Entrada.Estado = "Disponible"
    GROUP BY Evento.IDEvento, Grada.ID_grada;


DROP VIEW IF EXISTS VistaDeRecintos;

CREATE VIEW VistaDeRecintos AS SELECT Recinto.Nombre AS Recinto, Evento.IDEvento, Espectaculo.Nombre AS Espectaculo, Evento.FechaInicio, Evento.FechaFin, Evento.Estado, COUNT(IF(Entrada.Estado = "Comprada", Entrada.Estado, NULL)) AS Compradas FROM Evento 
    JOIN Recinto ON Evento.IDRecinto = Recinto.IDRecinto
    JOIN Espectaculo ON Evento.IDEspectaculo = Espectaculo.IDEspectaculo
    JOIN Entrada ON Evento.IDEvento = Entrada.IDEvento
    GROUP BY Evento.IDEvento
    ORDER BY Evento.FechaInicio, Recinto.Nombre;



