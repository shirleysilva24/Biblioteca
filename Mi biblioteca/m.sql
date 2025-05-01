-- Insertar datos de libros en general
INSERT INTO book(name_author_id,page,editorial_id,publication,book.name_book) values
(10,321,8,"1976","Tus Zonas Erroneas"),
(6,576,5,"2006","PERDIDA (GONE GIRL)"),
(7,311,null,"2005","El Verdadero Pablo, Sangre, traición y muerte"),
(8,240,null,"2018","Si lo crees, lo creas"),
(9,432,null,"2020","Asesinato para principiantes");-- 


Insert into book_gender(book_gender.book_id,book_gender.gender_id)
values
(3,3),
(3,8),
(4,3),
(4,11),
(4,7),
(5,3),
(5,1),
(6,6),
(6,12),
(6,8),
(2,6),
(2,1); -- TERMINADO 

-- Insertar interest_book 
Insert into  interest_book(interest_book.id_book,interest_book.remark)
values("");

-- Insertar datos de autor
INSERT INTO author (author, birth, nationality, mother_tongue)
VALUES
("Gillian Flynn", "1971-02-24", "EE. UU.", "Inglés"),
("Astrid María Legarda Martínez", NULL, "Colombia", "Español"),
("Brian Tracy ", "1944-01-05", "Canadá", "Inglés"),
("Holly Jackson", "1992-01-26", "Reino Unido", NULL);

SELECT * FROM editorial where lower(editorial)  like "%ediciones%";

ALTER TABLE book
MODIFY COLUMN editorial_id int NULL;

Insert into interest_book( interest_book.id_book, interest_book.remark)
values
(13,"Este libro me intereso porque nos da la perspectiva de las personas que son responsables y debo pensar si confio o no"),
(14,"Quiero saber mas de Pablo Escobar lo cual es fue una de las personas mas influyente asi que deseo conocer un poco mas de el y unas de las epocas e Colombia mas dura e interesantes"),
(15,"Un libro de superacion personal despues de mis zonas erroneas"),
(16,"Me llamo la atencion el titulo se nota que sera alo pero le dare una oportunidad")
;

insert into pending_book(pending_book.id_book,pending_book.purchase_date)
values
(12,"2023-09-25");

 
INSERT INTO read_book (id_book, start_read, finish_read, id_ranking, opinion)
VALUES 
    (2, NULL, '2023-11-25', 4, 'Estaba mejor la serie, el libro es para una historia de desamor'),
    (3, NULL, NULL, 5, 'Fue mi primer libro que leí seriamente'),
    (4, NULL, NULL, 4, 'Me lo recomendó Katerin y me encantó, su inicio es un poco lento pero desde la mitad es increíble.'),
    (5, NULL, '2022-11-01', 5, 'Qué libro tan largo, pero me encantó gracias a esto quiero saber un poquito latín'),
    (6, '2023-06-11', '2023-09-24', 4, 'Desde que salió mi personaje fav, ese libro mejoró 100%, lo recomiendo si les gusta la fantasía');

insert into ranking(ranking.ranking)
values
(1),
(2),
(3),
(4),
(5);
 
 alter table book 
 add column status enum ("Pendiente","Leido", "Interesado"),
 add  column sipnosis varchar(500),
 add column image varchar(255);

 
