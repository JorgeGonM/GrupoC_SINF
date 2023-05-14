# GrupoC_SINF
Proxecto Taquilla Virtual

## Procedimientos
Los procedimientos que hemos creado son los siguientes:

### calcularPrecioTotal
Recive: 
- IN TipoUsuarioIN VARCHAR(20),
- IN IDEspectaculoIN INT,
- IN IDGradaIN INT,
- OUT PrecioTotal FLOAT

ejm:
```sql
CALL calcularPrecioTotal(TipoUsuarioIN, IDEspectaculoIN, IDGradaIN, Precio); 
```


### reservaDeEntradas
Para realizar la reserva de una entrada.
Recive:
- IN IDEventoIN INT,
- IN IDLocalidadIN INT,
- IN IDClienteIN VARCHAR(9),
- IN TipoUsuarioIN VARCHAR(20)
  
ejm:
```sql
CALL reservaDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad), '44583632B', 'Adulto');
```


### compraDeEntradas
Para guardar la compra de una entrada.
- IN IDEventoIN INT,
- IN IDLocalidadIN INT,
- IN IDClienteIN VARCHAR(9),
- IN MetodoDePagoIN VARCHAR(50),
- IN NumeroDeCuentaIN VARCHAR(30),
- IN TipoUsuarioIN VARCHAR(20)

ejm:
```sql
CALL compraDeEntradas((SELECT max(IDEvento) FROM Evento), (SELECT max(IDLocalidad) FROM Localidad), '55565656' , 'Efectivo', NULL, 'Adulto');
```

### anulacionDeEntradas
Recive:
- IN IDEntradaIN INT
- IN IDClienteIN VARCHAR(9)

ejm:
```sql
CALL anulacionDeEntradas((SELECT max(IDEntrada) FROM Entrada), '35257898E');
```


## Probas
Na carpeta [probas](./Probas/) están postas 9 probas distintas escritas en 9 ficheros sql

### Proba 1
Nesta proba mostramos por pantalla o número de tuplas que ten cada tabla no noso sistema.

```sql
SELECT count(*) AS 'Numero de Clientes' FROM Cliente;
```
Esto mostranos o numero de filas totales que ten a tabla Cliente e renombrao como "Numero de Clientes".

### Proba 2
Nesta proba comprobamos a funcionalidade das restricións CHECK das gradas e mostramos mensaxes de erro.