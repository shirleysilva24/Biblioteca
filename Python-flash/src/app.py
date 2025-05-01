from flask import Flask, render_template, request, redirect, url_for,jsonify
import os
from database import database as db

template_dir = os.path.dirname(os.path.abspath(os.path.dirname(__file__)))
template_dir = os.path.join(template_dir, "src", "templates")

app = Flask(__name__, template_folder=template_dir) 

@app.route("/")
@app.route("/generos/<int:id>")
def home(id=None):
    id = request.args.get('genero', type=int)

    cursor=db.cursor()
    #Consulta del inicio
    consulta= (
        "SELECT b.id AS book_id, b.name_book AS book, "
        "a.author AS author, "
        "GROUP_CONCAT(g.gender SEPARATOR ', ') AS gender, "
        "b.status as status "
        "FROM book AS b "
        "INNER JOIN author AS a ON b.name_author_id = a.id "
        "INNER JOIN book_gender AS bg ON b.id = bg.book_id "
        "INNER JOIN gender AS g ON bg.gender_id = g.id "
         

         )

    

    #Consulta para generos si hay un filtro de generos 
    if id:
        consulta+="where g.id=%s "

    #aqui no entiendo por que no va junto?
    consulta+="""GROUP BY b.id, a.author, b.name_book, b.status 
         ORDER BY b.id DESC """
    
    #Aqui se ejecuta 
    if id:
        cursor.execute(consulta,(id,))
    else:
        cursor.execute(consulta)


    libros=cursor.fetchall() # Aqui se supone que debe obtener todos los libros
    total=cursor.rowcount#total de mis libros
    cursor.close()
    cursor = db.cursor()

    #verlos
    cursor=db.cursor()
    cursor.execute("SELECT id, gender FROM gender")
    generos = cursor.fetchall()
    print(f"{generos}\n")
    cursor.close()

    return render_template("index.html", datos_libros= libros, total_libros=total,generos=generos,genero_selecionado=id)


@app.route("/agregar", methods=["GET"])
def agregar():
    try:
        cursor = db.cursor()
        consulta = "SELECT g.gender FROM gender g ORDER BY g.gender ASC"
        cursor.execute(consulta)
        generos = cursor.fetchall()
        cursor.close()


        return render_template("agregar.html", generos=generos)
    
    except Exception as e:
        print("Error al recuperar los géneros:", str(e))
        return f"Error al recuperar los géneros: {str(e)}"

@app.route("/procesar_datos", methods=["POST"])
def procesar_datos():
    if request.method == "POST":
        libro = request.form["libro"].strip().lower()
        nombre_autor = request.form["autor"]
        pagina = request.form["pagina"]
        publicacion = request.form["publicacion"]
        editorial = request.form["editorial"]
        image = request.form["imagen"]
        sipnosis = request.form["sipnosis"]
        status = request.form["status"]
        generos = request.form.getlist("generos")

        try:
            # Conexión a la base de datos 
            cursor = db.cursor()

            consulta="SELECT id FROM book WHERE name_book=%s"
            cursor.execute(consulta,(libro,))
            existing_book=cursor.fetchone()

            if existing_book:
                book_id=existing_book[0]
                return redirect(url_for("edite_book",book_id=book_id))

            # Buscar o crear autor
            cursor.execute("SELECT id FROM author WHERE author=%s", (nombre_autor,))
            autor = cursor.fetchone()

            # Si no existe, se crea
            if not autor:
                cursor.execute("INSERT INTO author (author) VALUES (%s)", (nombre_autor,))
                cursor.execute("SELECT LAST_INSERT_ID()")
                autor_id = cursor.fetchone()[0]
                print(f"Autor guardado con el id: {autor_id}")
            else:
                autor_id = autor[0]
                print(f"Autor encontrado con el id: {autor_id}")

            # Buscar o crear editorial
            cursor.execute("SELECT id FROM editorial WHERE editorial=%s", (editorial,))
            editorial_row = cursor.fetchone()

            if not editorial_row:
                cursor.execute("INSERT INTO editorial (editorial) VALUES (%s)", (editorial,))
                cursor.execute("SELECT LAST_INSERT_ID()")
                editorial_id = cursor.fetchone()[0]
                print(f"Editorial guardada con el id: {editorial_id}")
            else:
                editorial_id = editorial_row[0]
                print(f"Editorial encontrada con el id: {editorial_id}")

            #Corregir si la pagina esta vacia
            page=request.form.get("pagina")
            if not page:
                page=None

            # Insertar el  hppppp libro
            cursor.execute(
                "INSERT INTO book (name_author_id, page, editorial_id, publication, name_book, status, sipnosis, image) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
                (autor_id, page, editorial_id, publicacion, libro, status, sipnosis, image)
            )

            cursor.execute("SELECT LAST_INSERT_ID()")
            book_id = cursor.fetchone()[0]
            print(f"Libro guardado con el id: {book_id}")

            for genero in generos:
                cursor.execute("SELECT id FROM gender WHERE gender=%s", (genero,))
                genero_id = cursor.fetchone()[0]
                cursor.execute(
                    "INSERT INTO book_gender (book_id, gender_id) VALUES (%s, %s)", (book_id, genero_id)
                )
                print(f"Insertando género {genero} con ID {genero_id} para el libro {book_id}")

            # Colocar el estado del libro
            if status == "Pendiente":
                cursor.execute("INSERT INTO pending_book (id_book) VALUES (%s)", (book_id,))
            elif status == "Leido":
                cursor.execute("INSERT INTO read_book (id_book) VALUES (%s)", (book_id,))
            elif status == "Interesado":
                cursor.execute("INSERT INTO interest_book (id_book) VALUES (%s)", (book_id,))

            db.commit()

            return redirect(url_for("success",success="true"))

        except Exception as e:
            db.rollback()
            print("Error al procesar datos:", str(e))
            return f"Error al procesar datos: {str(e)}"
        finally:
            cursor.close()

#Eliminar un libro
@app.route("/delete/<string:book_id>" ,methods=["POST"])
def delete_book(book_id):
    try:
        cursor = db.cursor()
        #Eliminar la conexion de la tabla libro y genero
        consulta = "DELETE FROM book_gender WHERE book_id=%s"
        cursor.execute(consulta, (book_id,))

        #Eliminar de libros qune me interesan 
        consulta="DELETE FROM interest_book WHERE id_book=%s"
        cursor.execute(consulta, (book_id,))

        #Eliminar de libros que lei
        consulta="DELETE FROM read_book WHERE id_book=%s"
        cursor.execute(consulta, (book_id,))

        #Eliminar de libros que lei
        consulta="DELETE FROM pending_book WHERE id_book=%s"
        cursor.execute(consulta, (book_id,))

        #Eliminar el libro como tal
        consulta="DELETE FROM book WHERE id=%s"
        cursor.execute(consulta, (book_id,))

        db.commit()
        cursor.close()

    except Exception as e:
        db.rollback()
        return f"Error al eliminar datos: {str(e)}"
    finally:
        cursor.close()

    return redirect(url_for("home"))

@app.route("/editar/<string:book_id>" ,methods=["GET","POST"])
def edite_book(book_id):
    if request.method == "POST":
        libro = request.form["libro"]
        nombre_autor = request.form["autor"]
        pagina = request.form["pagina"]
        publicacion = request.form["publicacion"]
        editorial = request.form["editorial"]
        image = request.form["imagen"]
        sipnosis = request.form["sipnosis"]
        status = request.form["status"]
        generos = request.form.getlist("generos")

        try:
            # Conexión a la base de datos 
            cursor = db.cursor()

            # Buscar o crear autor
            cursor.execute("SELECT id FROM author WHERE author=%s", (nombre_autor,))
            autor = cursor.fetchone()

            # Si no existe, se crea
            if not autor:
                cursor.execute("INSERT INTO author (author) VALUES (%s)", (nombre_autor,))
                cursor.execute("SELECT LAST_INSERT_ID()")
                autor_id = cursor.fetchone()[0]
                print(f"Autor guardado con el id: {autor_id}")
            else:
                autor_id = autor[0]
                print(f"Autor encontrado con el id: {autor_id}")

            # Buscar o crear editorial
            cursor.execute("SELECT id FROM editorial WHERE editorial=%s", (editorial,))
            editorial_row = cursor.fetchone()

            if not editorial_row:
                cursor.execute("INSERT INTO editorial (editorial) VALUES (%s)", (editorial,))
                cursor.execute("SELECT LAST_INSERT_ID()")
                editorial_id = cursor.fetchone()[0]
                print(f"Editorial guardada con el id: {editorial_id}")
            else:
                editorial_id = editorial_row[0]
                print(f"Editorial encontrada con el id: {editorial_id}")

            #Corregir si la pagina esta vacia
            pagina=request.form.get("pagina")
            if not pagina:
                pagina=None

            else:
                try:
                    pagina = int(pagina)  # Asegúrate de convertir a entero si no es None
                except ValueError:
                    pagina = None

            # Insertar el  hppppp libro
            cursor.execute(
                "UPDATE book SET name_author_id=%s, page=%s, editorial_id=%s, publication=%s, name_book=%s, status=%s, sipnosis=%s, image=%s WHERE id=%s",
                (autor_id, pagina, editorial_id, publicacion, libro, status, sipnosis, image,book_id)
            )


            #Eliminar el genero de libro-genero
            cursor.execute("DELETE FROM book_gender WHERE book_id=%s",(book_id,))
            #Añadir nuevo genero en libro-genero
            for genero in generos:
                cursor.execute("INSERT INTO book_gender (book_id,gender_id) VALUES (%s,%s)",(book_id,genero))

            # Eliminar estado previo del libro en las tablas específicas
            cursor.execute("DELETE FROM pending_book WHERE id_book=%s", (book_id,))
            cursor.execute("DELETE FROM read_book WHERE id_book=%s", (book_id,))
            cursor.execute("DELETE FROM interest_book WHERE id_book=%s", (book_id,))

            # Colocar el nuevo estado del libro
            if status == "Pendiente":
                cursor.execute("INSERT INTO pending_book (id_book) VALUES (%s)", (book_id,))
            elif status == "Leido":
                cursor.execute("INSERT INTO read_book (id_book) VALUES (%s)", (book_id,))
            elif status == "Interesado":
                cursor.execute("INSERT INTO interest_book (id_book) VALUES (%s)", (book_id,))

            db.commit()

            return (redirect(url_for("success_actualizar")))

        except Exception as e:
            db.rollback()
            print("Error al procesar datos:", str(e))
            return f"Error al procesar datos: {str(e)}"
        finally:
            cursor.close()

    else:
        try:
            cursor=db.cursor()
            cursor.execute("""
                           SELECT book.*, author.author,editorial.editorial
                            FROM book 
                           LEFT JOIN author ON book.name_author_id = author.id 
                           LEFT JOIN editorial ON book.editorial_id=editorial.id
                           WHERE book.id=%s"""
                           ,(book_id,))
            book_data=cursor.fetchone()
            cursor.execute("SELECT id, gender FROM gender") #Esto no lo entiendo
            generos=cursor.fetchall()

            #obetener los generis actuales 
            cursor.execute("SELECT gender_id FROM book_gender WHERE book_id=%s",(book_id,))
            book_gender=[row[0] for row in cursor.fetchall()]

            
            return render_template("editar.html",book=book_data,generos=generos,book_gender=book_gender,book_id=book_id)
         


        except Exception as e:
            db.rollback()
            print("Error al editar los datos:", str(e))
            return f"Error al editar los datos: {str(e)}"
        finally:
            cursor.close()

@app.route("/success")
def success():
    return render_template("success.html")

@app.route("/success_actualizar")
def success_actualizar():
    return render_template("success_actualizar.html")


@app.route("/sugerencias_autores", methods=["GET"])
def sugerencias_autores():
    query = request.args.get('query', '')
    try:
        cursor = db.cursor()
        consulta_autores = "SELECT DISTINCT author FROM author WHERE author LIKE %s ORDER BY author ASC"
        cursor.execute(consulta_autores, ('%' + query + '%',))
        autores = cursor.fetchall()
        cursor.close()
        return jsonify(autores)
    except Exception as e:
        print("Error al recuperar sugerencias:", str(e))
        return jsonify([]), 500
    
@app.route("/sugerencias_editoriales", methods=["GET"])
def sugerencias_editoriales():
    query = request.args.get('query', '')# Obtiene el parámetro 'query' de la cadena de consulta de la URL. Si no está presente, usa una cadena vacía por defecto.

    try:
        cursor = db.cursor()
        consulta_autores = "SELECT DISTINCT editorial FROM editorial WHERE editorial LIKE %s ORDER BY editorial ASC"
        cursor.execute(consulta_autores, ('%' + query + '%',)) # Ejecuta la consulta SQL con el parámetro 'query' incluido en el patrón de búsqueda.
        autores = cursor.fetchall()
        cursor.close()
        return jsonify(autores)
    except Exception as e:
        print("Error al recuperar sugerencias por bobos:", str(e))
        return jsonify([]), 500


@app.route("/ranking", methods=["GET"])
def ranking():              
    try:
        cursor=db.cursor()
        consulta="""
                select author.author,author.nationality, book.name_book,ranking.ranking,book.id
        from author
    inner join book on author.id=book.name_author_id
    inner join read_book on book.id=read_book.id_book
    left join ranking on read_book.id_ranking=ranking.id;
    """
        
        cursor.execute(consulta)
        datos_ranking=cursor.fetchall()
        total=cursor.rowcount
        cursor.close()

        return render_template("ranking.html",ranking=datos_ranking,total=total)
    except Exception as e:
        return f"Error al mostrar los ranking: {str(e)}"


@app.route("/rankear/<string:libro>" ,methods=["GET","POST"])
def rankear(libro): 
    autor=None


    #Obtener informacion del libro 

    try:
        cursor=db.cursor()
        consulta="SELECT book.id,author.author,book.name_book FROM book inner join author on book.name_author_id=author.id WHERE book.id=%s"
        cursor.execute(consulta,(libro,))
        resultado=cursor.fetchone()

        #Ver el estado actual del libro leido
        consulta = """SELECT start_read, finish_read, id_ranking, opinion FROM read_book WHERE id_book = %s"""
        cursor.execute(consulta, (libro,))
        estado_actual = cursor.fetchone()

        if resultado:
            libro_id = resultado[0]  # ID del libro
            autor = resultado[1] 
            nombre_libro=resultado[2]

        else:
            return "No se encontro al autor putos",400

        if request.method=="POST":
            #autor = request.form['autor'] 
            fecha_inicio=request.form['fecha_inicio'] or None
            fecha_final=request.form['fecha_final'] or None
            ranking = request.form['ranking'] 
            opinion = request.form['opinion'] 
        
            #Existe la entrada?
            consulta="SELECT id FROM read_book WHERE id_book=%s;"
            cursor.execute(consulta,(libro_id,)) 
            entrada=cursor.fetchone() 

            if not  entrada: 
                return "Error: No se encontro",400 
        
 

            # Insertar 
            consulta = """ UPDATE read_book SET id_ranking = %s, opinion = %s, start_read = %s, finish_read = %s WHERE id_book = %s """ 
            cursor.execute(consulta,(ranking,opinion,fecha_inicio,fecha_final,libro_id)) 

            



            db.commit() 
            cursor.close()
            return redirect(url_for("ranking")) 
    
    except Exception as e:
        db.rollback()
        print("Error al editar los datos:", str(e))
        return f"Error al editar los datos: {str(e)}" 
    finally: 
        cursor.close()

    print(f"Valor recibido en la ruta: {libro} y del autor: {autor}")
    print(f"Valor recibido en la ruta: {estado_actual} ")
    return render_template('rankear.html', libro=libro, autor=autor,nombre_libro=nombre_libro, estado_actual=estado_actual)



if __name__ == "__main__":
    app.run(debug=True, port=3000)
