
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
    SELECT SuplementoPrecio INTO SuplementoPrecioGrada FROM Grada WHERE IDGrada = IDGradaIN;
    SELECT DescuentoPrecio INTO DescuentoPrecioUsuario FROM TipoUsuario WHERE Tipo = TipoUsuarioIN;

    SET PrecioTotal = PrecioBaseEvento * SuplementoPrecioGrada * DescuentoPrecioUsuario;

END //



-- Procedimietos del cliente:

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

    IF((SELECT EXISTS(SELECT * FROM Evento WHERE IDEvento = IDEventoIN)) = '') THEN
        SELECT 'Non existe o evento a reservar.';
    END IF;

    IF((SELECT EXISTS(SELECT * FROM Evento JOIN Localidad ON Evento.IDRecinto = Localidad.IDRecinto WHERE Localidad.IDLocalidad = IDLocalidadIN AND Evento.IDEvento = IDEventoIN)) = '') THEN
        SELECT 'Non existe a localidade a reservar.';
    END IF;

    IF((SELECT EXISTS(SELECT * FROM Cliente WHERE IDCliente = IDClienteIN)) = '') THEN
        SELECT 'Non existe o cliente que quere reservar.';
    END IF;

    IF((SELECT FechaReserva FROM Evento WHERE IDEvento = IDEventoIN) < NOW()) THEN
        SELECT 'Non podes reservar porque o periodo de reserva está cerrado.';
    END IF;


    IF((SELECT Estado FROM Entrada WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN) = "Disponible") THEN
        
        SELECT IDEspectaculo INTO IDEspectaculoIN FROM Evento WHERE IDEvento = IDEventoIN;
        SELECT IDGrada INTO IDGradaIN FROM Localidad WHERE IDLocalidad = IDLocalidadIN;
        CALL calcularPrecioTotal(TipoUsuarioIN, IDEspectaculoIN, IDGradaIN, Precio); 
        
        UPDATE Entrada SET PrecioTotal = Precio WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;
        UPDATE Entrada SET Estado = "Reservada" WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;
        UPDATE Entrada SET IDCliente = IDClienteIN WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;

    ELSE

        SELECT 'Entrada non dispoñible para reservar.';

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

    SET IDEspectaculoIN = 0;
    SET IDGradaIN = 0;
    SET Precio = 0;

    IF((SELECT EXISTS(SELECT * FROM Evento WHERE IDEvento = IDEventoIN)) = '') THEN
        SELECT 'Non existe o evento a comprar.';
    END IF;

    IF((SELECT EXISTS(SELECT * FROM Evento JOIN Localidad ON Evento.IDRecinto = Localidad.IDRecinto WHERE Localidad.IDLocalidad = IDLocalidadIN AND Evento.IDEvento = IDEventoIN)) = '') THEN
        SELECT 'Non existe a localidade a comprar.';
    END IF;

    IF((SELECT EXISTS(SELECT * FROM Cliente WHERE IDCliente = IDClienteIN)) = '') THEN
        SELECT 'Non existe o cliente que quere comprar.';
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
            CALL calcularPrecio (TipoUsuarioIN, IDEspectaculoIN, IDGradaIN, Precio);
        
            UPDATE Entrada SET PrecioTotal = Precio WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;
            UPDATE Entrada SET Estado = "Comprada" WHERE IDEvento = IDEventoIN AND IDLocalidad = IDLocalidadIN;
            UPDATE Cliente SET MetodoDePago = MetodoDePagoIN WHERE IDCliente = IDClienteIN;
            UPDATE Cliente SET NumeroDeCuenta = NumeroDeCuentaIN WHERE IDCliente = IDClienteIN;
    
        ELSE
            SELECT 'Entrada non dispoñible para a compra.';

        END IF;
    END IF;
END //



DROP PROCEDURE IF EXISTS anulacionDeEntradas //

CREATE PROCEDURE anulacionDeEntradas(

    IN IDEntradaIN INT,
    IN IDClienteIN VARCHAR(9)
    
)

BEGIN 

    IF((SELECT EXISTS(SELECT * FROM Entrada WHERE IDEntrada = IDEntradaIN)) = '') THEN
        SELECT 'Non existe a entrada a anular.';
    END IF;

    IF((SELECT EXISTS(SELECT * FROM Cliente WHERE IDCliente = IDClienteIN)) = '') THEN
        SELECT 'Non existe o cliente que quere anular.';
    END IF;

    IF((SELECT FechaAnulacion FROM Evento WHERE IDEvento = (SELECT IDEvento FROM Entrada WHERE IDEntrada = IDEntradaIN)) < NOW()) THEN
        SELECT 'Non é posible anular porque o periodo de anulacion está cerrado.';
    END IF;


    IF((SELECT Estado FROM Entrada WHERE IDEntrada = IDEntradaIN) = "Reservada" AND 
        (SELECT IDCliente FROM Entrada WHERE IDEntrada = IDEntradaIN) = IDClienteIN) THEN

        INSERT INTO EntradaAnulada (IDEvento, IDCliente, PrecioTotal) SELECT IDEvento, IDCliente, PrecioTotal FROM Entrada WHERE IDEntrada = IDEntradaIN;

        UPDATE Entrada SET PrecioTotal = NULL WHERE IDEntrada = IDEntradaIN;
        UPDATE Entrada SET Estado = "Disponible" WHERE IDEntrada = IDEntradaIN;
        UPDATE Entrada SET IDCliente = NULL WHERE IDEntrada = IDEntradaIN;

    ELSE
        SELECT 'Non podes anular a entrada porque non a ten reservada.';
    END IF;

END //

DELIMITER ;















-- Vistas

DROP VIEW IF EXISTS VistaDeEntradas;

CREATE VIEW VistaDeEntradas AS SELECT Espectaculo.Nombre AS Espectaculo, Recinto.Nombre AS Recinto, Grada.Nombre AS Grada, COUNT(Entrada.IDEntrada) AS Disponibles, Evento.FechaInicio FROM Evento 
    JOIN Recinto ON Evento.IDRecinto = Recinto.IDRecinto
    JOIN Espectaculo ON Evento.IDEspectaculo = Espectaculo.IDEspectaculo
    JOIN Grada ON Recinto.IDRecinto = Grada.IDRecinto
    JOIN Entrada ON Evento.IDEvento = Entrada.IDEvento
    WHERE Entrada.Estado = "Disponible"
    GROUP BY Evento.IDEvento, Grada.IDGrada;


DROP VIEW IF EXISTS VistaDeRecintos;

CREATE VIEW VistaDeRecintos AS SELECT Recinto.Nombre AS Recinto, Evento.IDEvento, Espectaculo.Nombre AS Espectaculo, Evento.FechaInicio, Evento.FechaFin, Evento.Estado, COUNT(IF(Entrada.Estado = "Comprada", Entrada.Estado, NULL)) AS Compradas FROM Evento 
    JOIN Recinto ON Evento.IDRecinto = Recinto.IDRecinto
    JOIN Espectaculo ON Evento.IDEspectaculo = Espectaculo.IDEspectaculo
    JOIN Entrada ON Evento.IDEvento = Entrada.IDEvento
    GROUP BY Evento.IDEvento
    ORDER BY Evento.FechaInicio, Recinto.Nombre;



