USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(film_id)
FROM inventory
WHERE film_id = (SELECT film_id FROM film
                 WHERE title = "Hunchback Impossible"); 

-- 2.List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title,
length
FROM film 
WHERE length > (SELECT AVG(length) FROM film); 

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT a.actor_id, a.first_name, a.last_name
FROM actor as a
LEFT JOIN film_actor as fa
ON a.actor_id = fa.actor_id
WHERE fa.film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip');

-- Bonus
-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title,
fc.category_id
FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
WHERE category_id = (SELECT category_id  FROM category WHERE name = 'family');

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT cus.first_name,
cus.email
FROM customer cus
LEFT JOIN address a 
ON cus.address_id = a.address_id
LEFT JOIN city cty
ON a.city_id = cty.city_id
LEFT JOIN country cou
ON cty.country_id = cou.country_id
WHERE country = (SELECT country FROM country 
				 WHERE country = 'Canada');
                 
-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT f.title
FROM film f
JOIN film_actor fa 
ON f.film_id = fa.film_id
WHERE fa.actor_id = (SELECT actor_id
                     FROM film_actor
                     GROUP BY actor_id
                     ORDER BY COUNT(film_id) DESC
                     LIMIT 1);
                     
-- 7. Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, 
-- i.e., the customer who has made the largest sum of payments.
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.customer_id = p.customer_id
WHERE p.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);