import sys
import random
import string

def generar_clientes():
    # Generamos un ID de cliente aleatorio
    id_cliente = ''.join(random.choices(string.digits, k=5))
    
    # Generamos un correo electrónico aleatorio
    email = ''.join(random.choices(string.ascii_lowercase, k=random.randint(4,12))) + "@" + ''.join(random.choices(string.ascii_lowercase, k=random.randint(4,10))) + "." + ''.join(random.choices(string.ascii_lowercase, k=random.randint(3,4)))
    
    # Creamos la línea de INSERT con los datos generados
    linea_insert = "INSERT INTO Cliente (IDCliente, Email) VALUES('" + id_cliente + "' , '" + email + "');"
    
    return linea_insert



# Obtenemos el número de líneas de INSERT a generar a partir del argumento de línea de comandos
if len(sys.argv) > 1:
    num_inserts = int(sys.argv[1])
else:
    print("Error, se tie")

# Abrimos el archivo en modo de escritura
with open('../Datos/clientes.sql', 'w') as archivo:
    # Generamos 10 líneas de INSERT con datos aleatorios y las escribimos en el archivo
    for i in range(num_inserts):
        linea_insert = generar_clientes()
        archivo.write(linea_insert + '\n')
