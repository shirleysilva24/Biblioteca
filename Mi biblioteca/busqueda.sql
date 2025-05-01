show columns from author;
show columns from book;

select * from gender order by gender asc ;
select * from gender ;

select * from ranking;
select format(1,3);

 select * from book;
select * from author;
select * from interest_book;
select * from read_book;
select * from mi_libreria.book_gender;

-- queria ver los generos de mis libros 

SELECT   b.id AS id_libro,  b.name_book AS nombre_libro, GROUP_CONCAT(g.gender) AS genero_libro
FROM book AS b
INNER JOIN mi_libreria.book_gender AS bg ON b.id = bg.book_id
INNER JOIN mi_libreria.gender AS g ON bg.gender_id = g.id
GROUP BY b.id, b.name_book;

  
  
SELECT * FROM book_gender;
 
show columns from book;
show columns from gender;
show columns from read_book;
show columns from pending_book;
show tables;

SELECT COUNT(gender) FROM gender;
