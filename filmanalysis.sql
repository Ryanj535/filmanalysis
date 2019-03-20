Use sakila;
-- 1a
SELECT first_name, last_name
FROM actor;

-- 1b
SELECT Concat(first_name," ", last_name) as "Actor Name"
FROM actor;

-- 2a
SELECT  actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

-- 2b
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%GEN%";

-- 2c
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE "%LI%";

-- 2d
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a
ALTER TABLE actor
ADD COLUMN (description blob);

-- 3b
ALTER TABLE actor
DROP COLUMN description;

-- 4a
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name HAVING count(last_name) > 1;

-- 4c
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

-- 4d
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

-- 5a
SHOW CREATE TABLE address;
CREATE TABLE address (address_id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
	address varchar(50) NOT NULL,
    address2 varchar(50) DEFAULT NULL,
    district varchar(20) NOT NULL,
    city_id smallint(5) unsigned NOT NULL,
    postal_code varchar(10) DEFAULT NULL,
    phone varchar(20) NOT NULL,
    location geometry NOT NULL,
    last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (address_id),
    KEY idx_fk_city_id (city_id),
    SPATIAL KEY idx_location (location),
    CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
    );

-- 6a
SELECT first_name, last_name, address
FROM staff
JOIN address
USING (address_id);

-- 6b
SELECT first_name, last_name, sum(amount) as "Total Charged"
FROM staff
INNER JOIN payment
USING (staff_id)
WHERE payment_date LIKE "2005-08%"
GROUP BY staff_id;

-- 6c
SELECT title, count(actor_id)
FROM film_actor
INNER JOIN film
USING (film_id)
GROUP BY title;

-- 6d
SELECT count(inventory_id)
FROM inventory
WHERE film_id IN (
	SELECT film_id
    FROM film
    WHERE title = "Hunchback Impossible");

-- 6e
SELECT first_name, last_name, sum(amount)
FROM customer
INNER JOIN payment
USING (customer_id)
GROUP BY customer_id
ORDER BY last_name ASC;

-- 7a
SELECT title
FROM film
WHERE title LIKE "k%" 
OR title LIKE "q%"
AND language_id IN (
	SELECT language_id
    FROM language
    WHERE name = "english");

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id 
    FROM film_actor
    WHERE film_id IN (
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip")
        );

-- 7c
SELECT first_name, last_name, email
FROM customer
	INNER JOIN address
	USING (address_id)
	INNER JOIN city
	USING (city_id)
	INNER JOIN country
	USING (country_id)
WHERE country = "canada";

-- 7d
SELECT title 
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM film_category
    WHERE category_id IN (
		SELECT category_id
        FROM category
        WHERE name = "family")
        );

-- 7e
SELECT title, count(inventory_id) as "Total Rentals"
FROM film
	INNER JOIN inventory
	USING (film_id)
    INNER JOIN rental
    USING (inventory_id)
GROUP BY title
ORDER BY count(inventory_id) DESC;

-- 7f	
SELECT store_id, sum(amount) as "Total Store Sales"
FROM payment
	INNER JOIN staff
    USING (staff_id)
    INNER JOIN store
    USING(store_id)
GROUP BY store_id;

-- 7g
SELECT store_id, city, country
FROM store
	INNER JOIN address
    USING (address_id)
    INNER JOIN city
    USING (city_id)
    INNER JOIN country
    USING (country_id);

-- 7h
SELECT name, sum(amount) as "Total Revenue"
FROM category
	INNER JOIN film_category
    USING (category_id)
    INNER JOIN inventory
    USING (film_id)
    INNER JOIN rental
    USING (inventory_id)
    INNER JOIN payment
    USING(rental_id)
GROUP BY name
ORDER BY sum(amount) DESC;

-- 8a
SELECT name, sum(amount) as "Total Revenue"
FROM category
	INNER JOIN film_category
    USING (category_id)
    INNER JOIN inventory
    USING (film_id)
    INNER JOIN rental
    USING (inventory_id)
    INNER JOIN payment
    USING(rental_id)
GROUP BY name
ORDER BY sum(amount) DESC
LIMIT 5;

-- 8b
CREATE VIEW top_five_genres AS (
SELECT name, sum(amount) as "Total Revenue"
FROM category
	INNER JOIN film_category
    USING (category_id)
    INNER JOIN inventory
    USING (film_id)
    INNER JOIN rental
    USING (inventory_id)
    INNER JOIN payment
    USING(rental_id)
GROUP BY name
ORDER BY sum(amount) DESC
LIMIT 5); 

DROP VIEW top_five_genres;