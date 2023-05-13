SYSTEM clear;

DROP TABLE IF EXISTS EntradaAnulada;
DROP TABLE IF EXISTS EntradaLocalidad;
DROP TABLE IF EXISTS Entrada;
DROP TABLE IF EXISTS Evento;
DROP TABLE IF EXISTS Espectaculo;
DROP TABLE IF EXISTS Localidad;
DROP TABLE IF EXISTS Grada;
DROP TABLE IF EXISTS Recinto;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Fecha;
DROP TABLE IF EXISTS TipoUsuario;


CREATE TABLE Cliente(

    IDCliente VARCHAR(15) PRIMARY KEY,
    MetodoDePago VARCHAR(100) DEFAULT NULL,
    NumeroDeCuenta VARCHAR(50) DEFAULT NULL,
    Email VARCHAR(100) UNIQUE
);


CREATE TABLE TipoUsuario(

    Tipo VARCHAR(30) CHECK (Tipo = "Bebe" OR Tipo = "Infantil" OR Tipo = "Adulto" OR Tipo = "Parado" OR Tipo = "Jubilado"),
    DescuentoPrecio FLOAT DEFAULT 1 NOT NULL CHECK (DescuentoPrecio >= 0 AND DescuentoPrecio <= 1),
    PRIMARY KEY (Tipo)
);


CREATE TABLE Fecha(

    IDFecha INT PRIMARY KEY,
    Movimiento VARCHAR(50),
    Fecha DATETIME DEFAULT NOW()
);


CREATE TABLE Recinto(

    IDRecinto INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,    
    Calle VARCHAR(100) NOT NULL,
    Numero INT CHECK (Numero > 0),
    Ciudad VARCHAR(100) NOT NULL,
    Sala INT CHECK (Sala > 0 ),
    Aforo INT NOT NULL CHECK (Aforo > 0),
    CONSTRAINT direccion UNIQUE (Nombre, Calle, Numero, Ciudad, Sala)
);


CREATE TABLE Espectaculo(

    IDEspectaculo INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(200) NOT NULL,
    FechaEspectaculo DATETIME NOT NULL,
    TipoEspectaculo VARCHAR(30) NOT NULL,
    ProductorEspectaculo VARCHAR(100),
    PrecioBase FLOAT NOT NULL CHECK (PrecioBase >= 0),
    CONSTRAINT infoEspectaculo UNIQUE (FechaEspectaculo, TipoEspectaculo, Nombre)
);


CREATE TABLE Evento(

    IDEvento INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    IDEspectaculo INT NOT NULL,
    IDRecinto INT NOT NULL,
    FechaInicio DATETIME NOT NULL,
    FechaFin DATETIME NOT NULL,
    FechaReserva DATETIME,
    FechaAnulacion DATETIME, 
    Estado VARCHAR(100) DEFAULT "Abierto" NOT NULL CHECK (Estado = "Abierto" OR Estado = "No Disponible" OR Estado = "Finalizado"),
    CONSTRAINT infoEvento UNIQUE (IDEspectaculo, IDRecinto, FechaInicio),  
    FOREIGN KEY (IDEspectaculo) REFERENCES Espectaculo (IDEspectaculo),
    FOREIGN KEY (IDRecinto) REFERENCES Recinto (IDRecinto)
);


CREATE TABLE Grada(

    ID_grada INT AUTO_INCREMENT NOT NULL,
    ID_recinto INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    SuplementoPrecio FLOAT DEFAULT 1.0 NOT NULL CHECK (SuplementoPrecio >= 1),
    Capacidad INT NOT NULL CHECK (Capacidad > 0),
    PRIMARY KEY (ID_grada),
    CONSTRAINT nombre_recinto UNIQUE (ID_recinto, Nombre),
    FOREIGN KEY (ID_recinto) REFERENCES Recinto (IDRecinto)
);

CREATE TABLE Localidad(

    IDRecinto INT NOT NULL,
    IDGrada INT NOT NULL,
    IDLocalidad INT AUTO_INCREMENT NOT NULL,
    Numero INT NOT NULL CHECK (Numero >= 0),
    Estado VARCHAR(50) DEFAULT "Disponible" NOT NULL CHECK (Estado = "Disponible" OR Estado = "No Disponible"),
    PRIMARY KEY (IDLocalidad),
    CONSTRAINT recinto_grada_numeroLocalidad UNIQUE (IDRecinto, IDGrada, Numero),
    FOREIGN KEY (IDRecinto) REFERENCES Recinto (IDRecinto),
    FOREIGN KEY (IDGrada) REFERENCES Grada (ID_grada) 
);




CREATE TABLE Entrada(

    IDEvento INT NOT NULL,
    IDEntrada INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    IDCliente VARCHAR(15) DEFAULT NULL,
    IDLocalidad INT NOT NULL,
    Estado VARCHAR(50) DEFAULT "Disponible" NOT NULL CHECK (Estado = "Disponible" OR Estado = "Comprada" OR Estado = "Reservada" OR Estado = "No Disponible"),
    PrecioTotal FLOAT DEFAULT NULL,
    CONSTRAINT evento_localidad UNIQUE (IDLocalidad, IDEvento),
    FOREIGN KEY (IDEvento) REFERENCES Evento (IDEvento),
    FOREIGN KEY (IDLocalidad) REFERENCES Localidad (IDLocalidad),
    FOREIGN KEY (IDCliente) REFERENCES Cliente (IDCliente)
);

CREATE TABLE EntradaAnulada(

    IDEvento INT NOT NULL,
    IDEntrada INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    IDCliente VARCHAR(15) NOT NULL,
    PrecioTotal FLOAT NOT NULL,
    Vendida BOOLEAN DEFAULT FALSE NOT NULL,
    FOREIGN KEY (IDEvento) REFERENCES Evento (IDEvento),
    FOREIGN KEY (IDCliente) REFERENCES Cliente (IDCliente)
);


CREATE TABLE EntradaLocalidad(

    IDEntrada INT NOT NULL,
    IDLocalidad INT NOT NULL,
    TipoUsuario VARCHAR(50) DEFAULT "Adulto",
    PRIMARY KEY (IDEntrada, IDLocalidad),
    FOREIGN KEY (IDEntrada) REFERENCES Entrada (IDEntrada),
    FOREIGN KEY (IDLocalidad) REFERENCES Localidad (IDLocalidad)

);


SHOW TABLES;



