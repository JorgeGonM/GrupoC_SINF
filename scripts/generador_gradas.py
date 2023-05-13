import sys
import random
import string

def generar_gradas():
   
    # Generamos un idRecinto aleatorio
    idRecinto = random.randint(1,30)
    
    # Generamos un Nombre de la grada aleatorio
    nombre = ''.join(random.choices(string.ascii_lowercase, k=random.randint(6,12)))
    
    # Generamos una capacidad aleatorio
    capacidad = ''.join(random.choices(string.digits, k=random.randint(1,2)))
    
    # Generamos un suplemento aleatorio
    numero_entero = ''.join(random.choices(string.digits, k=1))
    numero_decimal = ''.join(random.choices(string.digits, k=1))
    
    num = float(numero_entero + '.' + numero_decimal)
    suplemento = str(num)   
     
    # Creamos la línea de INSERT con los datos generados
    linea_insert = "call crearGrada (" + str(idRecinto) + " , '" + nombre + "' , " + capacidad + " , " + suplemento + ");"

    return linea_insert



# Obtenemos el número de líneas de INSERT a generar a partir del argumento de línea de comandos
if len(sys.argv) > 1:
    num_inserts = int(sys.argv[1])
else:
    print("Error, se tie")

# Abrimos el archivo en modo de escritura
with open('../Datos/gradas.sql', 'w') as archivo:
    # Generamos X líneas de INSERT con datos aleatorios y las escribimos en el archivo
    for i in range(num_inserts):
        linea_insert = generar_gradas()
        archivo.write(linea_insert + '\n')
