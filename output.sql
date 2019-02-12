SELECT * FROM sakila.actor;
#--1a, 1b
select first_name, last_name from actor;
SELECT CONCAT(first_name, ' ' ,last_name) AS Actor_Name from actor;

#--2a
SELECT * FROM sakila.actor;
select actor_id
		, first_name
        , last_name 
from actor
where first_name="Joe";

#--2b
select actor_id
		, first_name
        , last_name 
from actor 
where last_name like "%GEN%";

#--2c
#--alter table actor modify column first_name VARCHAR(50) after last_name;
select actor_id
		, last_name
        , first_name
from actor
where last_name like "%LI%";

#--2d
SELECT * FROM sakila.country;
select country_id
		, country 
from country 
where country in ("Afghanistan", "Bangladesh","China");

#--3a-3b
#--alter table actor modify column last_name VARCHAR(1000) after first_name;
SELECT * FROM sakila.actor;
alter table actor add description BLOB;
alter table actor drop column description;

#4a-4b
SELECT * FROM sakila.actor;
select last_name, count(last_name) from actor
group by last_name;
select last_name, count(last_name) from actor
group by last_name having count(last_name)>1;

#4c-4d
SELECT * FROM sakila.actor;
update actor set first_name="HARPO" where first_name="GROUCHO" and last_name="WILLIAMS";
SELECT * FROM sakila.actor where first_name="HARPO" and last_name="WILLIAMS";
update actor set first_name="GROUCHO" where first_name="HARPO" and last_name="WILLIAMS";

#5a
SELECT * FROM sakila.address;
SHOW CREATE TABLE address;

#6a
SELECT * FROM sakila.address;
SELECT * FROM staff;
select staff.first_name
		, staff.last_name
        , address.address
from address 
join staff on staff.address_id=address.address_id;

#6b
SELECT * FROM payment;
SELECT * FROM staff;
select s.first_name
		, s.last_name
        , sum(p.amount) as total_payment
from staff s
join payment p on s.staff_id=p.staff_id
where payment_date like "%2005-08%"
group by s.first_name, s.last_name;


#6c
SELECT * FROM film;
SELECT * FROM film_actor;
select film.title
, film_actor.film_id
, count(*) as no_of_actors
from film_actor 
join film on film.film_id=film_actor.film_id
group by film_id;

#6d
SELECT * FROM inventory;
select film.title
, inventory.film_id
, count(*) as no_of_copies
from inventory 
join film on film.film_id=inventory.film_id
where title="Hunchback Impossible"
group by film_id;

#6e
SELECT * FROM payment;
SELECT * FROM customer;
select customer.first_name
		, customer.last_name
        , sum(payment.amount) as "Total Amount Paid"
from customer
join payment on customer.customer_id=payment.customer_id
group by customer.first_name, customer.last_name
ORDER BY customer.last_name ASC;

#7a
select * from film;
select * from language;
select title from film 
where language_id in
(select language_id 
from language
where name="English") and  (title between "K" and "L") or (title between "Q" and "R");

#7b
select * from actor;
select * from film_actor;
select first_name, last_name from actor
where actor_id in 
(select actor_id 
from film_actor
where film_id in
	(select film_id from film where title="Alone Trip"));
    
#7c
#customer-address-city-country
select * from customer;
select * from address;
select * from city;
select * from country;
select first_name, last_name, email from customer
where address_id in 
(select address_id 
from address
where city_id in
	(select city_id from city where country_id in
		(select country_id from country where country="Canada")))

#7d
select * from film;
select * from film_category;
select * from category;
select title from film
where film_id in 
(select film_id 
from film_category
where category_id in
	(select category_id from category where name="family"));

#7e
select * from rental;
select * from film;
select * from inventory;
select film.title
        , count(inventory.film_id) as "total_rent"
from film
join inventory on film.film_id=inventory.film_id
group by film.title
ORDER BY total_rent desc;

#7f
select * from store;
select * from payment;
select * from staff;
select store.store_id, sum(amount) as "total_business"
from store
join staff on store.store_id=staff.store_id
join payment on staff.staff_id=payment.staff_id
group by store.store_id;

#7g
select * from city;
select * from address;
select * from store;
select * from country;
select store.store_id, city.city, country.country
from store 
join address on store.address_id=address.address_id
join city on city.city_id=address.city_id
join country on country.country_id=city.country_id;

#7h 
# category, film_category, inventory, payment, rental
#rental-inventory-
select * from category;
select * from payment;
select * from rental;
select * from inventory;
select * from film_category;
select category.name, sum(payment.amount) as "gross_sum"
from category 
join film_category on category.category_id=film_category.category_id
join inventory on inventory.film_id=film_category.film_id
join rental on inventory.inventory_id=rental.inventory_id
join payment on payment.rental_id=rental.rental_id
group by category.name
order by gross_sum desc limit 5;

#8a
create view top_five_genres as
select category.name, sum(payment.amount) as "gross_sum"
from category 
join film_category on category.category_id=film_category.category_id
join inventory on inventory.film_id=film_category.film_id
join rental on inventory.inventory_id=rental.inventory_id
join payment on payment.rental_id=rental.rental_id
group by category.name
order by gross_sum desc limit 5;

#8b
select * from sakila.top_five_genres;

#8c
DROP VIEW if exists sakila.top_five_genres;
