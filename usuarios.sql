DROP USER IF EXISTS 'administracion'@'localhost';
CREATE USER 'administracion'@'localhost' IDENTIFIED BY 'Administracion_1.';

GRANT SELECT ON VistaDeRecintos TO 'administracion'@'localhost';





DROP USER IF EXISTS 'cliente'@'localhost';
CREATE USER 'cliente'@'localhost' IDENTIFIED by 'Cliente_1';

GRANT SELECT ON VistaDeEntradas TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE reservaDeEntradas TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE compraDeEntradas TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE anulacionDeEntradas TO 'cliente'@'localhost';






DROP USER IF EXISTS 'mantenimiento'@'localhost';
CREATE USER 'mantenimiento'@'localhost' IDENTIFIED BY 'Mantenimiento_1.';

GRANT ALL PRIVILEGES ON *.* TO 'mantenimiento'@'localhost';

FLUSH PRIVILEGES;
