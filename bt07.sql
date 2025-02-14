-- 1,
USE sakila;

-- 2,
CREATE VIEW View_Track_Details AS
SELECT t.TrackId, t.Name AS Track_Name, a.Title AS Album_Title, ar.Name AS Artist_Name, t.UnitPrice
FROM Track t
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN Artist ar ON a.ArtistId = ar.ArtistId
WHERE t.UnitPrice > 0.99;

SELECT * FROM View_Track_Details;

-- 3,
CREATE VIEW View_Customer_Invoice AS
SELECT c.CustomerId, CONCAT(c.LastName, ' ', c.FirstName) AS FullName, c.Email, SUM(i.Total) AS Total_Spending, e.FirstName AS Support_Rep
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY c.CustomerId
HAVING SUM(i.Total) > 50;

SELECT * FROM View_Customer_Invoice;

-- 4,
CREATE VIEW View_Top_Selling_Tracks AS
SELECT t.TrackId, t.Name AS Track_Name, g.Name AS Genre_Name, SUM(il.Quantity) AS Total_Sales
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY t.TrackId
HAVING SUM(il.Quantity) > 10;

SELECT * FROM View_Top_Selling_Tracks;

-- 5,
CREATE INDEX idx_Track_Name ON Track (Name);

SELECT * 
FROM Track 
WHERE Name LIKE '%Love%';

EXPLAIN SELECT * 
FROM Track 
WHERE Name LIKE '%Love%';

-- 6,
CREATE INDEX idx_Invoice_Total ON Invoice (Total);

SELECT * 
FROM Invoice 
WHERE Total BETWEEN 20 AND 100;

EXPLAIN SELECT * 
FROM Invoice 
WHERE Total BETWEEN 20 AND 100;

-- 7,
DELIMITER //
CREATE PROCEDURE GetCustomerSpending(IN p_CustomerId INT, OUT p_TotalSpending DECIMAL(10, 2))
BEGIN
    SELECT IFNULL(Total_Spending, 0) INTO p_TotalSpending
    FROM View_Customer_Invoice
    WHERE CustomerId = p_CustomerId;
END //
DELIMITER ;

CALL GetCustomerSpending(1, @TotalSpending);
SELECT @TotalSpending;

-- 8,
DELIMITER //
CREATE PROCEDURE SearchTrackByKeyword(IN p_Keyword VARCHAR(255))
BEGIN
    SELECT *
    FROM Track
    WHERE Name LIKE CONCAT('%', p_Keyword, '%');
END //
DELIMITER ;

CALL SearchTrackByKeyword('lo');

-- 9,
DELIMITER //
CREATE PROCEDURE GetTopSellingTracks(IN p_MinSales INT, IN p_MaxSales INT)
BEGIN
    SELECT *
    FROM View_Top_Selling_Tracks
    WHERE Total_Sales BETWEEN p_MinSales AND p_MaxSales;
END //
DELIMITER ;

CALL GetTopSellingTracks(15, 20);

-- 10,
-- Xóa VIEW
DROP VIEW IF EXISTS View_Track_Details;
DROP VIEW IF EXISTS View_Customer_Invoice;
DROP VIEW IF EXISTS View_Top_Selling_Tracks;

-- Xóa INDEX
DROP INDEX  idx_Track_Name ON Track;
DROP INDEX  idx_Invoice_Total ON Invoice;

-- Xóa PROCEDURE
DROP PROCEDURE IF EXISTS GetCustomerSpending;
DROP PROCEDURE IF EXISTS SearchTrackByKeyword;
DROP PROCEDURE IF EXISTS GetTopSellingTracks;