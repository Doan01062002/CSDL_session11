-- 1,
USE session11;

-- 2,
CREATE INDEX idx_phone_number ON Customers(PhoneNumber);

EXPLAIN SELECT * FROM Customers WHERE PhoneNumber = '0901234567';

-- 3,
CREATE INDEX idx_branch_salary ON Employees(BranchID, Salary);

EXPLAIN SELECT * FROM Employees WHERE BranchID = 1 AND Salary > 20000000;

-- 4,
CREATE UNIQUE INDEX idx_account_customer ON Accounts(AccountID, CustomerID);


-- 5,
SHOW INDEX FROM Customers;
SHOW INDEX FROM Employees;
SHOW INDEX FROM Accounts;

-- 6,
DROP INDEX idx_phone_number ON Customers;
DROP INDEX idx_branch_salary ON Employees;
DROP INDEX idx_account_customer ON Accounts;
