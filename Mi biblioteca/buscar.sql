select * from author;
select * from gender;
select * from editorial;
select * from book;
select * from ranking;
select * from book_gender;
select * from read_book;
select * from interest_book;
select * from pending_book;

delete from ranking where id between 5 and 10;

show columns from read_book;
show columns from ranking;
show columns from author;
show columns from editorial;


SHOW tables ;
delete from ranking where id=11;
insert into ranking(id,ranking) values (5,"5");


-- Estan vacias las tablas
SELECT COUNT(*) FROM interest_book; -- Libros que me interesan
SELECT COUNT(*) FROM read_book; -- Libros  que he leido 
SELECT COUNT(*) FROM pending_book; -- Libros que estoy leyendo en la actualidad

ALTER TABLE editorial modify column formato varchar(50) DEFAULT "Fisico";


alter table ranking modify column ranking varchar(40) default null;

 


 


select book.name_book as name 
, gender.gender as gender
from book_gender
inner join book on book_gender.book_id= book.id
inner join gender on book_gender.gender_id= gender.id;

UPDATE  book
SET name_book ="El nombre de la rosa"
where id =5;

SELECT 
	author.author as name_author ,
    editorial.editorial as name_editorial,
    book.page,
    book.publication,
    book.name_book
FROM  book
INNER JOIN author On book.name_author_id= author.id
INNER JOIN editorial ON book.editorial_id= editorial.id;

INSERT INTO gender( gender.gender,gender.depcription)
values 
("Fantasía","Para historias con elementos mágicos, mundos imaginarios y criaturas fantásticas.");


INSERT INTO editorial( editorial.editorial,editorial.format)
values ("Ediciones Grijalbo S.A.","Fisico");

INSERT INTO author (author, birth, nationality, mother_tongue) 
values
("Wayne W. Dyer", "1940-05-10", "EE. UU.", "Inglés");


-- Elimine el gender
ALTER TABLE book
DROP FOREIGN KEY fk_book_gender;
Alter table book
drop column gender_id;


ALTER TABLE book 
drop foreign key fk_book_format; -- Eliminar llave foranea

Alter table book
drop column format_id;

DELETE FROM format; -- Elimine la tabla de format 
DROP TABLE format;
DELETE FROM book;



ALTER TABLE book
ADD COLUMN  name_book VARCHAR(100);

-- Me muestra los libros y su genero
 
  
-- Mostrar todos los autores con sus libros
SELECT author.author as author,
		book.name_book as book
	from book 
    inner join author on book.name_author_id = author.id;
    
-- Si fuera por grupo
SELECT author.author as author,
group_concat( book.name_book, "-") as book
from book
inner join author on book.name_author_id = author.id
group by author.id;

-- Mostrar todos los libros de un género específico:
SELECT group_concat( book.name_book, "---" ) as book,
 gender.gender as geres
 from book 
 inner join book_gender on book.id = book_gender.book_id
 inner join  gender on book_gender.gender_id = gender.id
 group by gender.id
;

-- Me muestra la cantidad de libros por genero de forma desc
 SELECT gender.gender as genre,
       COUNT(book.id) as total_books
FROM book_gender
INNER JOIN book ON book_gender.book_id = book.id
INNER JOIN gender ON book_gender.gender_id = gender.id
GROUP BY gender.id
ORDER BY total_books desc;

select count(*) from mi_libreria.book;

SELECT COUNT(table_name)
FROM information_schema.tables
WHERE table_schema = 'mi_libreria' AND table_rows  <> 0;

-- necesito los autores,
select book.name_book as libro, author.author as autor ,read_book.start_read as inicio ,read_book.finish_read as final,ranking.id as puntaje ,read_book.opinion from read_book
inner join book on book.id = read_book.id_book
inner join author on author.id = book.name_author_id
left join ranking on read_book.id_ranking= ranking.id;



 
