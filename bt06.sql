-- 1,
USE sakila;

-- 2,
-- Quan sát ERD

-- 3,
CREATE VIEW view_film_category AS
SELECT f.film_id, f.title, c.name AS category_name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;

-- 4,
CREATE VIEW view_high_value_customers AS
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING SUM(p.amount) > 100;

-- 5,
CREATE INDEX idx_rental_rental_date ON rental (rental_date);

SELECT * 
FROM rental 
WHERE rental_date = '2005-06-14';

EXPLAIN SELECT * 
FROM rental 
WHERE rental_date = '2005-06-14';

-- 6,
DELIMITER //
CREATE PROCEDURE CountCustomerRentals(IN customer_id INT, OUT rental_count INT)
BEGIN
    SELECT COUNT(*) INTO rental_count
    FROM rental
    WHERE rental.customer_id = customer_id;
END //
DELIMITER //

-- 7,
DELIMITER //
CREATE PROCEDURE GetCustomerEmail( IN customer_id INT, OUT customer_email VARCHAR(50))
BEGIN
    SELECT email INTO customer_email
    FROM customer
    WHERE customer.customer_id = customer_id;
END //
DELIMITER //

-- 8,
-- Xóa INDEX
DROP INDEX idx_rental_rental_date ON rental;

-- Xóa VIEW
DROP VIEW IF EXISTS view_film_category;
DROP VIEW IF EXISTS view_high_value_customers;

-- Xóa Stored Procedure
DROP PROCEDURE IF EXISTS CountCustomerRentals;
DROP PROCEDURE IF EXISTS GetCustomerEmail;
