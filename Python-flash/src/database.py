import mysql.connector

database = mysql.connector.connect(
    host="localhost",
    user="root",
    password="123456789",
    database="mi_libreria"

);

# Verifica si la conexión fue exitosa
if database.is_connected():
    print("Conexión exitosa a la base de datos")