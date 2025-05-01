import mysql.connector
from openpyxl import Workbook

# Conecta a la base de datos
ddatabase = mysql.connector.connect(
    host="localhost",
    user="root",
    password="123456789",
    database="mi_libreria"

);

# Ejecuta la consulta SQL
consulta = """
    SELECT 
        b.id AS id_libro,
        b.name_book AS nombre_libro,
        a.author AS autor,
        b.page AS paginas,
        e.editorial AS editorial,
        b.publication AS publicacion,
        b.status AS status
    FROM 
        book b
    JOIN 
        author a ON b.name_author_id = a.id
    JOIN 
        editorial e ON b.editorial_id = e.id
"""
cursor = db.cursor()
cursor.execute(consulta)

# Obtiene los resultados de la consulta
resultados = cursor.fetchall()

# Crear un libro de trabajo de Excel
workbook = Workbook()
sheet = workbook.active

# Añadir encabezados de columna
sheet.append(['ID', 'Libro', 'Autor', 'Páginas', 'Editorial', 'Publicación', 'Estado'])

# Agregar datos a la hoja
for resultado in resultados:
    sheet.append(resultado)

# Guardar el libro de trabajo
workbook.save("datos_libros.xlsx")

# Cierra la conexión a la base de datos
cursor.close()
db.close()
