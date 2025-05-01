use sakila;

select first_name,last_name 
from actor
where (select category_id from category where category_id=1)  ;



SELECT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN film AS f ON fa.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE c.category_id = 1;


select *  from category;
