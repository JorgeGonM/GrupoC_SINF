import sys
import random
import subprocess
import string


def generar_eventos():
    # Generamos un idEspectaculo aleatorio
    idEspectaculo = random.randint(1,15000)
    
    # Generamos un idRecinto aleatorio
    idRecinto = random.randint(1,30)
    
    # Generamos fechas aleatoria
    
    año = random.randint(0,5) + 2022
    mes = random.randint(0,11) + 1
    dia = random.randint(0,15) + 10
    hora = random.randint(0,18) 
    
    
    fechaInicio = str(año) + "-" + str(mes) + "-" + str(dia) + " " + str(hora) + ":00:00"
    
    hora = hora + 2
    
    fechaFin = str(año) + "-" + str(mes) + "-" + str(dia) + " " + str(hora) + ":00:00"
    
    dia = dia - 5
    
    fechaReserva = str(año) + "-" + str(mes) + "-" + str(dia) + " " + str(hora) + ":00:00"
    
    dia = dia + 2
    
    fechaAnulacion = str(año) + "-" + str(mes) + "-" + str(dia) + " " + str(hora) + ":00:00"
    
    
    # Generamos un tipo aleatoria
    estado = random.choice(['Abierto', 'No Disponible'])
        
    # Creamos la línea de INSERT con los datos generados
    linea_insert = "call crearEvento (" + str(idEspectaculo) + " , " + str(idRecinto) + " , '" + fechaInicio + "' , '" + fechaFin + "' , '" + fechaReserva + "' , '" + fechaAnulacion + "' , '" + estado + "');"

    return linea_insert



# Obtenemos el número de líneas de INSERT a generar a partir del argumento de línea de comandos
if len(sys.argv) > 1:
    num_inserts = int(sys.argv[1])
else:
    print("Error, se tie")

# Abrimos el archivo en modo de escritura
with open('../Datos/eventos.sql', 'w') as archivo:
    # Generamos X líneas de INSERT con datos aleatorios y las escribimos en el archivo
    for i in range(num_inserts):
        linea_insert = generar_eventos()
        archivo.write(linea_insert + '\n')
