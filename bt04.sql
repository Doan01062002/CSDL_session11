-- 1,
use session11;

-- 2,
DELIMITER //

CREATE PROCEDURE UpdateSalaryByID(
    IN pro_EmployeeID INT,
    OUT newsalary DECIMAL(10,2)
)
BEGIN
    SELECT salary INTO newsalary FROM employees WHERE EmployeeID = pro_EmployeeID;
    
    IF newsalary < 20000000 THEN 
        SET newsalary = newsalary * 1.1;
    ELSE 
        SET newsalary = newsalary * 1.05;
    END IF;
    
    UPDATE employees SET salary = newsalary WHERE EmployeeID = pro_EmployeeID;    
END //

DELIMITER ;


call UpdateSalaryByID(1,@newsalary);
select @newsalary;

-- 3,
DELIMITER //
create procedure GetLoanAmountByCustomerID(in pro_CustomerID int, out pro_total DECIMAL(15,2))
begin
select sum(l.LoanAmount) from Loans l where pro_CustomerID = CustomerID group by l.CustomerID;
end//
DELIMITER //

call GetLoanAmountByCustomerID(1,@pro_total);

-- 4,
DELIMITER //
CREATE PROCEDURE DeleteAccountIfLowBalance(IN accID INT)
BEGIN
    DECLARE accBalance DECIMAL(15,2);
    SELECT Balance INTO accBalance FROM Accounts WHERE AccountID = accID;
    IF accBalance < 1000000 THEN
        DELETE FROM Accounts WHERE AccountID = accID;
        SELECT 'Tài khoản đã được xóa thành công!' AS Message;
    ELSE
        SELECT 'Không thể xóa tài khoản, số dư lớn hơn 1 triệu!' AS Message;
    END IF;
END //
DELIMITER ;

-- 5,
DELIMITER //
CREATE PROCEDURE TransferMoney(IN senderID INT, IN receiverID INT, INOUT transferAmount DECIMAL(15,2))
BEGIN
    DECLARE senderBalance DECIMAL(15,2);
    SELECT Balance INTO senderBalance FROM Accounts WHERE AccountID = senderID;

    IF senderBalance >= transferAmount THEN
        UPDATE Accounts SET Balance = Balance - transferAmount WHERE AccountID = senderID;
        UPDATE Accounts SET Balance = Balance + transferAmount WHERE AccountID = receiverID;
        
        SELECT CONCAT('Đã chuyển thành công ', transferAmount, ' VND!') AS Message;
    ELSE
        SET transferAmount = 0;
        SELECT 'Số dư không đủ, giao dịch thất bại!' AS Message;
    END IF;
END //
DELIMITER ;

-- 6,
CALL UpdateSalaryByID(4, 20000000);

CALL GetLoanAmountByCustomerID(1);

CALL DeleteAccountIfLowBalance(8);

SET @amount = 2000000;
CALL TransferMoney(1, 3, @amount);
SELECT @amount AS 'Số tiền cuối cùng đã chuyển';

-- 7,
DROP PROCEDURE IF EXISTS DeleteAccountIfLowBalance;
DROP PROCEDURE IF EXISTS TransferMoney;
DROP PROCEDURE IF EXISTS UpdateSalaryByID;
DROP PROCEDURE IF EXISTS GetLoanAmountByCustomerID;
