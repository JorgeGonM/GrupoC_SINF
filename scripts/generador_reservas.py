import sys
import random
import string

def generar_reservas():
    # Generamos un ID de cliente aleatorio
    
    
    id_evento = random.randint(1,40)
    id_localidad = ''.join(random.choices(string.digits, k=random.randint(2,4)))
    id_cliente = ''.join(random.choices(string.digits, k=5))
    tipoUser = random.choice(['Bebe', 'Infantil', 'Adulto', 'Parado', 'Jubilado'])
    
    # Creamos la línea de INSERT con los datos generados
    linea_insert = "call reservaDeEntradas (" + str(id_evento) + "," + id_localidad + ",'" + id_cliente + "','" + tipoUser + "');"
    
    return linea_insert


                      

# Obtenemos el número de líneas de INSERT a generar a partir del argumento de línea de comandos
if len(sys.argv) > 1:
    num_entradas = int(sys.argv[1])
else:
    print("Error, se tie")

# Abrimos el archivo en modo de escritura

with open('../Datos/reservas.sql', 'w') as archivo:
    # Generamos 10 líneas de INSERT con datos aleatorios y las escribimos en el archivo
    for i in range(num_entradas):
        linea_insert = generar_reservas()
        archivo.write(linea_insert + '\n')
