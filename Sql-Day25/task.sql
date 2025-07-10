-- Create the database
CREATE DATABASE CompanyDB;
USE CompanyDB;

-- Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10,2),
    status VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE,
    dob DATE
);

-- Departments table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100)
);

-- Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    join_date DATE
);

-- Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    order_date DATE
);

-- Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- UserRoles table
CREATE TABLE UserRoles (
    user_id INT,
    role_name VARCHAR(50)
);

-- Employee_Audit table
CREATE TABLE Employee_Audit (
    emp_id INT,
    action VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Backup table for deleted employees
CREATE TABLE DeletedEmployees (
    emp_id INT,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1
CREATE VIEW ActiveEmployees AS
SELECT * FROM Employees WHERE status = 'Active';

-- 2
CREATE VIEW HighSalaryEmployees AS
SELECT * FROM Employees WHERE salary > 50000;

-- 3
CREATE VIEW EmpDeptView AS
SELECT e.emp_name, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- 4
CREATE OR REPLACE VIEW HighSalaryEmployees AS
SELECT e.*, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE e.salary > 50000;

-- 5
CREATE VIEW EmployeePublicView AS
SELECT emp_id, emp_name FROM Employees;

-- 6
CREATE VIEW ITEmployees AS
SELECT * FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'IT';

-- 7
DROP VIEW IF EXISTS ITEmployees;

-- 8
CREATE VIEW RecentCustomers AS
SELECT * FROM Customers
WHERE join_date >= CURDATE() - INTERVAL 6 MONTH;

-- 9
CREATE VIEW EmpAliasView AS
SELECT emp_name AS EmployeeName, d.dept_name AS Dept
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- 10
CREATE VIEW ValidEmailEmployees AS
SELECT * FROM Employees WHERE email IS NOT NULL;

-- 11
CREATE VIEW RecentHires AS
SELECT * FROM Employees
WHERE hire_date >= CURDATE() - INTERVAL 1 YEAR;

-- 12
CREATE VIEW EmployeeBonus AS
SELECT *, salary * 0.10 AS bonus FROM Employees;

-- 13
CREATE VIEW OrderDetails AS
SELECT o.order_id, c.customer_name, p.product_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id;

-- 14
CREATE VIEW SalaryByDept AS
SELECT d.dept_name, SUM(e.salary) AS total_salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

-- 15
CREATE VIEW JuniorStaffView AS
SELECT emp_id, emp_name, dept_id FROM Employees;

-- 16
DELIMITER //
CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT * FROM Employees;
END;
//
DELIMITER ;

-- 17
CALL GetAllEmployees();

-- 18
DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN dept_name VARCHAR(50))
BEGIN
    SELECT e.* FROM Employees e
    JOIN Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
END;
//
DELIMITER ;

-- 19
CALL GetEmployeesByDept('HR');

-- 20
DELIMITER //
CREATE PROCEDURE AddEmployee(
    IN name VARCHAR(100), IN dept INT, IN sal DECIMAL(10,2),
    IN stat VARCHAR(20), IN mail VARCHAR(100), IN hdate DATE, IN birth DATE
)
BEGIN
    INSERT INTO Employees(emp_name, dept_id, salary, status, email, hire_date, dob)
    VALUES (name, dept, sal, stat, mail, hdate, birth);
END;
//
DELIMITER ;

-- 21
DELIMITER //
CREATE PROCEDURE DeleteEmployee(IN id INT)
BEGIN
    DELETE FROM Employees WHERE emp_id = id;
END;
//
DELIMITER ;

-- 22
DELIMITER //
CREATE PROCEDURE UpdateSalary(IN id INT, IN new_salary DECIMAL(10,2))
BEGIN
    UPDATE Employees SET salary = new_salary WHERE emp_id = id;
END;
//
DELIMITER ;

-- 23
DELIMITER //
CREATE PROCEDURE TotalEmployees(OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total FROM Employees;
END;
//
DELIMITER ;

-- 24
DROP PROCEDURE IF EXISTS GetAllEmployees;
-- Recreate with new logic
DELIMITER //
CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT emp_id, emp_name FROM Employees;
END;
//
DELIMITER ;

-- 25
DELIMITER //
CREATE PROCEDURE GetEmployeesByInitial(IN letter CHAR(1))
BEGIN
    SELECT * FROM Employees WHERE emp_name LIKE CONCAT(letter, '%');
END;
//
DELIMITER ;

-- 26
DELIMITER //
CREATE PROCEDURE AvgSalaryByDept()
BEGIN
    SELECT d.dept_name, AVG(e.salary) AS avg_salary
    FROM Employees e
    JOIN Departments d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name;
END;
//
DELIMITER ;

-- 27
DELIMITER //
CREATE PROCEDURE CountByDept()
BEGIN
    SELECT d.dept_name, COUNT(e.emp_id) AS emp_count
    FROM Employees e
    JOIN Departments d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name;
END;
//
DELIMITER ;

-- 28
DELIMITER //
CREATE PROCEDURE JoinedThisMonth()
BEGIN
    SELECT * FROM Employees
    WHERE MONTH(hire_date) = MONTH(CURDATE())
    AND YEAR(hire_date) = YEAR(CURDATE());
END;
//
DELIMITER ;

-- 29
DELIMITER //
CREATE PROCEDURE LogAndSelect()
BEGIN
    INSERT INTO Employee_Audit(emp_id, action) VALUES (0, 'Procedure Called');
    SELECT * FROM Employees;
END;
//
DELIMITER ;

-- 30
START TRANSACTION;
CALL UpdateSalary(1, 70000);
-- Simulate error
ROLLBACK;

-- 31
DELIMITER //
CREATE FUNCTION EmployeeCount(dept_name VARCHAR(50)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Employees e
    JOIN Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
    RETURN total;
END;
//
DELIMITER ;

-- 32
SELECT EmployeeCount('Finance');

-- 33
DELIMITER //
CREATE FUNCTION AvgDeptSalary(dept_name VARCHAR(50)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_sal DECIMAL(10,2);
    SELECT AVG(salary) INTO avg_sal
    FROM Employees e
    JOIN Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
    RETURN avg_sal;
END;
//
DELIMITER ;

-- 34
DELIMITER //
CREATE FUNCTION CalculateAge(dob DATE) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END;
//
DELIMITER ;

-- 35
DELIMITER //
CREATE FUNCTION MaxSalary() RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE max_sal DECIMAL(10,2);
    SELECT MAX(salary) INTO max_sal FROM Employees;
    RETURN max_sal;
END;
//
DELIMITER ;

-- 36
DELIMITER //
CREATE FUNCTION FullName(first_name VARCHAR(50), last_name VARCHAR(50)) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(first_name, ' ', last_name);
END;
//
DELIMITER ;

-- 37
DELIMITER //
CREATE FUNCTION DeptExists(dept_name VARCHAR(50)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN EXISTS(SELECT 1 FROM Departments WHERE dept_name = dept_name);
END;
//
DELIMITER ;

-- 38
DELIMITER //
CREATE FUNCTION WorkingDays(join_date DATE) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), join_date);
END;
//
DELIMITER ;

-- 39
DELIMITER //
CREATE FUNCTION TotalOrders(customer_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Orders WHERE customer_id = customer_id;
    RETURN total;
END;
//
DELIMITER ;

-- 40
DELIMITER

CREATE TABLE Employee_Audit (
    emp_id INT,
    action VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 41
CREATE TABLE Employee_Audit (
    emp_id INT,
    action VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 42
DELIMITER //
CREATE TRIGGER after_employee_insert
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Audit(emp_id, action)
    VALUES (NEW.emp_id, 'INSERT');
END;
//
DELIMITER ;

-- 43
-- Insert a new employee
INSERT INTO Employees (emp_name, dept_id, salary, status, email, hire_date, dob)
VALUES ('Karthik', 1, 60000, 'Active', 'karthik@example.com', CURDATE(), '1995-06-15');

-- Check audit log
SELECT * FROM Employee_Audit;

-- 44
DELIMITER //
CREATE TRIGGER prevent_salary_decrease
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary decrease is not allowed';
    END IF;
END;
//
DELIMITER ;

-- 45
-- This will succeed
UPDATE Employees SET salary = 65000 WHERE emp_id = 1;

-- This will fail
UPDATE Employees SET salary = 50000 WHERE emp_id = 1;

-- 46
CREATE TABLE DeletedEmployees (
    emp_id INT,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_employee_delete
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO DeletedEmployees(emp_id)
    VALUES (OLD.emp_id);
END;
//
DELIMITER ;

-- 47
-- First, add the column
ALTER TABLE Employees ADD COLUMN LastModified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- No trigger needed if using ON UPDATE, but here's a manual version:
DELIMITER //
CREATE TRIGGER update_last_modified
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    SET NEW.LastModified = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

-- 48
DELIMITER //
CREATE TRIGGER assign_default_role
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO UserRoles(user_id, role_name)
    VALUES (NEW.emp_id, 'Employee');
END;
//
DELIMITER ;

-- 49
DROP TRIGGER IF EXISTS logNewEmployee;

-- 50
CREATE TABLE Projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    status VARCHAR(20)
);

-- Trigger to prevent deletion
DELIMITER //
CREATE TRIGGER prevent_delete_if_active_project
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Projects
        WHERE emp_id = OLD.emp_id AND status = 'Active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete employee assigned to active projects';
    END IF;
END;
//
DELIMITER ;