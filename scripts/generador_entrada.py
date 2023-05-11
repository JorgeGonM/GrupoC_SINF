import sys
import random
import string

def generar_entrada():
    # Generamos un ID de cliente aleatorio
    
    
    id_evento = ''.join(random.choices(string.digits, k=8))
    id_localidad = ''.join(random.choices(string.digits, k=8))
    id_cliente = ''.join(random.choices(string.digits, k=8))
    metodoDePago = random.choice(['Visa', 'Efectivo', 'Transferencia Bancaria', 'MasterCard' ,'Bizum'])
    numCuenta = ''.join(random.choices(string.digits, k=30))
    tipoUser = random.choice(['Bebe', 'Infantil', 'Adulto', 'Parado', 'Jubilado'])
    
    # Creamos la línea de INSERT con los datos generados
    linea_insert = "call compraDeEntradas('" + id_evento + "','" + id_localidad + "','" + id_cliente + "','" + metodoDePago + "','" + numCuenta + "','" + tipoUser + "');"
    
    return linea_insert


                      

# Obtenemos el número de líneas de INSERT a generar a partir del argumento de línea de comandos
if len(sys.argv) > 1:
    num_entradas = int(sys.argv[1])
else:
    print("Error, se tie")

# Abrimos el archivo en modo de escritura

with open('../datos/insetarCompraEntrada.sql', 'w') as archivo:
    archivo.write("-- id_evento id_localidad id_cliente metodoDePago numCuenta tipoUser\n")
    # Generamos 10 líneas de INSERT con datos aleatorios y las escribimos en el archivo
    for i in range(num_entradas):
        linea_insert = generar_entrada()
        archivo.write(linea_insert + '\n')