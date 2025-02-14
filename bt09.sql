-- 1,
USE sakila;

-- 2,
CREATE VIEW View_High_Value_Customers AS
SELECT c.CustomerId, CONCAT(c.FirstName, ' ', c.LastName) AS FullName, c.Email, SUM(i.Total) AS Total_Spending
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= '2010-01-01'
GROUP BY c.CustomerId, FullName, c.Email
HAVING SUM(i.Total) > 200 AND c.Country != 'Brazil';      
  
-- 3,
CREATE VIEW View_Popular_Tracks AS
SELECT t.TrackId, t.Name AS Track_Name, SUM(il.Quantity) AS Total_Sales
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
WHERE il.UnitPrice > 1.00 
GROUP BY t.TrackId, Track_Name
HAVING SUM(il.Quantity) > 15;

-- 4,
ALTER TABLE Customer ADD INDEX idx_Customer_Country ((Country));


SELECT * FROM Customer WHERE Country = 'Canada';
EXPLAIN SELECT * FROM Customer WHERE Country = 'Canada';

-- 5,
ALTER TABLE Track ADD FULLTEXT INDEX idx_Track_Name_FT (Name);

SELECT * FROM Track WHERE MATCH (Name) AGAINST ('Love');
EXPLAIN SELECT * FROM Track WHERE MATCH (Name) AGAINST ('Love');

-- 6,
SELECT v.CustomerId, v.FullName, v.Email, v.Total_Spending, c.Country
FROM View_High_Value_Customers v
JOIN Customer c ON v.CustomerId = c.CustomerId
WHERE c.Country = 'Canada';
EXPLAIN SELECT v.CustomerId, v.FullName, v.Email, v.Total_Spending, c.Country
FROM View_High_Value_Customers v
JOIN Customer c ON v.CustomerId = c.CustomerId
WHERE c.Country = 'Canada';

-- 7,
SELECT v.TrackId, v.Track_Name, v.Total_Sales, t.UnitPrice
FROM View_Popular_Tracks v
JOIN Track t ON v.TrackId = t.TrackId
WHERE MATCH (t.Name) AGAINST ('Love');

EXPLAIN SELECT v.TrackId, v.Track_Name, v.Total_Sales, t.UnitPrice
FROM View_Popular_Tracks v
JOIN Track t ON v.TrackId = t.TrackId
WHERE MATCH (t.Name) AGAINST ('Love');

-- 8,
DELIMITER //
CREATE PROCEDURE GetHighValueCustomersByCountry (IN p_Country VARCHAR(255))
BEGIN
    SELECT v.CustomerId, v.FullName, v.Email, v.Total_Spending, c.Country
    FROM View_High_Value_Customers v
    JOIN Customer c ON v.CustomerId = c.CustomerId
    WHERE c.Country = p_Country; 
END //
DELIMITER ;

-- 9,
DELIMITER //
CREATE PROCEDURE UpdateCustomerSpending (IN p_CustomerId INT, IN p_Amount DECIMAL(10,2))
BEGIN
    UPDATE Invoice
    SET Total = Total + p_Amount
    WHERE CustomerId = p_CustomerId
    ORDER BY InvoiceDate DESC;
END //
DELIMITER ;

CALL UpdateCustomerSpending(5, 50.00);

SELECT * FROM View_High_Value_Customers WHERE CustomerId = 5;

-- 10,
DROP VIEW IF EXISTS View_High_Value_Customers;
DROP VIEW IF EXISTS View_Popular_Tracks;

ALTER TABLE Customer DROP INDEX idx_Customer_Country;

ALTER TABLE Track DROP INDEX idx_Track_Name_FT;

DROP PROCEDURE IF EXISTS GetHighValueCustomersByCountry;
DROP PROCEDURE IF EXISTS UpdateCustomerSpending;