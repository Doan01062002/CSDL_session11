-- 1,
USE session11;

-- 2,
CREATE VIEW EmployeeBranch AS
SELECT e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS FullName, e.Position, e.Salary, b.BranchName, b.Location
FROM Employees e
JOIN Branches b ON e.BranchID = b.BranchID;

-- 3,
CREATE VIEW HighSalaryEmployees AS
SELECT EmployeeID, CONCAT(FirstName, ' ', LastName) AS FullName, Position, Salary
FROM Employees
WHERE Salary >= 15000000
WITH CHECK OPTION;

-- 4,
SELECT * FROM EmployeeBranch;
SELECT * FROM HighSalaryEmployees;

-- 5,
CREATE OR REPLACE VIEW EmployeeBranch AS
SELECT e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS FullName, e.Position, e.Salary,e.PhoneNumber, b.BranchName, b.Location
FROM Employees e
JOIN Branches b ON e.BranchID = b.BranchID;

-- 6,
DELETE FROM Employees 
WHERE BranchID IN (SELECT BranchID FROM Branches WHERE BranchName = 'Chi nhánh Hà Nội');

SELECT * FROM Employees;

