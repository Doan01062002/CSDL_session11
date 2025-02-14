-- 1,
USE sakila;

-- 2,
ALTER TABLE customer ADD UNIQUE INDEX idx_unique_email (email);

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
VALUES (1, 'Jane', 'Doe', 'johndoe@example.com', 6, 1, NOW());

-- 3,
DELIMITER //
CREATE PROCEDURE CheckCustomerEmail (IN email_input VARCHAR(255), OUT exists_flag INT)
BEGIN
    SELECT COUNT(*) INTO exists_flag
    FROM customer
    WHERE email = email_input;
END //
DELIMITER ;

CALL CheckCustomerEmail('johndoe@example.com', @exists);
SELECT @exists;

-- 4,
ALTER TABLE rental ADD INDEX idx_rental_customer_id (customer_id);

-- 5,
CREATE VIEW view_active_customer_rentals AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, r.rental_date,
       CASE WHEN r.return_date IS NOT NULL THEN 'Returned' ELSE 'Not Returned' END AS status
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE c.active = 1 AND r.rental_date >= '2023-01-01' AND (r.return_date IS NULL OR r.return_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY));
  
-- 6,
ALTER TABLE payment ADD INDEX idx_payment_customer_id (customer_id);

-- 7,
CREATE VIEW view_customer_payments AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_date >= '2023-01-01'
GROUP BY c.customer_id, full_name
HAVING SUM(p.amount) > 100;

-- 8,
DELIMITER //
CREATE PROCEDURE GetCustomerPaymentsByAmount (IN min_amount DECIMAL(10,2), IN date_from DATE)
BEGIN
    SELECT *
    FROM view_customer_payments
    WHERE total_payment >= min_amount AND payment_date >= date_from;
END //
DELIMITER ;

-- 9,
DROP VIEW IF EXISTS view_active_customer_rentals;
DROP VIEW IF EXISTS view_customer_payments;

DROP PROCEDURE IF EXISTS CheckCustomerEmail;
DROP PROCEDURE IF EXISTS GetCustomerPaymentsByAmount;

ALTER TABLE customer DROP INDEX idx_unique_email;
ALTER TABLE rental DROP INDEX idx_rental_customer_id;
ALTER TABLE payment DROP INDEX idx_payment_customer_id;