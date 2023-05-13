import sys
import random
import string

def generar_recintos():
    # Generamos un Nombre del recinto aleatorio
    nombre = ''.join(random.choices(string.ascii_lowercase, k=random.randint(4,10))) + " " + ''.join(random.choices(string.ascii_lowercase, k=random.randint(4,10)))
    
    # Generamos una ciudad aleatoria
    ciudad = ''.join(random.choices(string.ascii_lowercase, k=random.randint(4,10)))
    
    # Generamos una calle aleatoria
    calle = ''.join(random.choices(string.ascii_lowercase, k=random.randint(4,10)))
    
    # Generamos un numero aleatorio
    numero = ''.join(random.choices(string.digits, k=random.randint(1,4)))
    
    # Generamos una sala aleatoria
    if random.random() < 0.3:
    	sala = 'null'
    else:
    	sala = ''.join(random.choices(string.digits, k=random.randint(1,4)))
        
    # Generamos un numero aleatorio
    aforo = ''.join(random.choices(string.digits, k=random.randint(4,6)))
        
    # Creamos la línea de INSERT con los datos generados
    linea_insert = "INSERT INTO Recinto (Nombre, Calle, Numero, Ciudad, Sala, Aforo) VALUES('" + nombre + "' , '" + calle + "' , " + numero + " , '" + ciudad + "' , " + sala + " , " + aforo + ");"

    return linea_insert



# Obtenemos el número de líneas de INSERT a generar a partir del argumento de línea de comandos
if len(sys.argv) > 1:
    num_inserts = int(sys.argv[1])
else:
    print("Error, se tie")

# Abrimos el archivo en modo de escritura
with open('../Datos/recintos.sql', 'w') as archivo:
    # Generamos X líneas de INSERT con datos aleatorios y las escribimos en el archivo
    for i in range(num_inserts):
        linea_insert = generar_recintos()
        archivo.write(linea_insert + '\n')
