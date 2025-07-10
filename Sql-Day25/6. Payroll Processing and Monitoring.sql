-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS PayrollDB;
USE PayrollDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100),
    department VARCHAR(100),
    salary DECIMAL(10,2),
    tax_rate DECIMAL(4,2) DEFAULT 0.10
);

CREATE TABLE IF NOT EXISTS PayrollLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create views

-- HR view with salary
CREATE OR REPLACE VIEW HRPayrollView AS
SELECT emp_id, emp_name, department, salary FROM Employees;

-- Employee view without salary
CREATE OR REPLACE VIEW EmployeePayrollView AS
SELECT emp_id, emp_name, department FROM Employees;

-- Step 4: Stored procedure for monthly payroll
DELIMITER //
CREATE PROCEDURE GenerateMonthlyPayroll()
BEGIN
    SELECT 
        emp_id,
        emp_name,
        department,
        salary,
        salary * tax_rate AS tax_deduction,
        salary - (salary * tax_rate) AS net_pay
    FROM Employees;
END;
//
DELIMITER ;

-- Step 5: Function to calculate tax
DELIMITER //
CREATE FUNCTION CalculateTax(emp INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE tax DECIMAL(10,2);
    SELECT salary * tax_rate INTO tax FROM Employees WHERE emp_id = emp;
    RETURN IFNULL(tax, 0);
END;
//
DELIMITER ;

-- Step 6: Trigger to log salary changes
DELIMITER //
CREATE TRIGGER LogSalaryChange
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO PayrollLog(emp_id, old_salary, new_salary)
        VALUES (NEW.emp_id, OLD.salary, NEW.salary);
    END IF;
END;
//
DELIMITER ;

-- Step 7: Insert 50 sample employees
INSERT INTO Employees (emp_name, department, salary, tax_rate) VALUES
('Ramya', 'HR', 60000, 0.10), ('Karthik', 'Finance', 75000, 0.12), ('Diya', 'IT', 85000, 0.15),
('Rohan', 'Marketing', 50000, 0.08), ('Meera', 'Sales', 55000, 0.10), ('Sneha', 'IT', 90000, 0.15),
('Vikram', 'Finance', 72000, 0.12), ('Anjali', 'HR', 58000, 0.10), ('Rahul', 'Sales', 53000, 0.09),
('Priya', 'Marketing', 62000, 0.08), ('Neha', 'IT', 87000, 0.15), ('Manav', 'Finance', 76000, 0.12),
('Tanya', 'HR', 61000, 0.10), ('Pooja', 'Sales', 54000, 0.09), ('Nikhil', 'Marketing', 51000, 0.08),
('Ritika', 'IT', 89000, 0.15), ('Sahil', 'Finance', 74000, 0.12), ('Divya', 'HR', 60000, 0.10),
('Amit', 'Sales', 56000, 0.09), ('Kavya', 'Marketing', 52000, 0.08), ('Harsh', 'IT', 88000, 0.15),
('Simran', 'Finance', 73000, 0.12), ('Ravi', 'HR', 59000, 0.10), ('Bhavna', 'Sales', 55000, 0.09),
('Deepak', 'Marketing', 50000, 0.08), ('Ayesha', 'IT', 91000, 0.15), ('Gaurav', 'Finance', 77000, 0.12),
('Naina', 'HR', 62000, 0.10), ('Suresh', 'Sales', 57000, 0.09), ('Lavanya', 'Marketing', 53000, 0.08),
('Tarun', 'IT', 86000, 0.15), ('Ira', 'Finance', 75000, 0.12), ('Mohit', 'HR', 60000, 0.10),
('Rekha', 'Sales', 56000, 0.09), ('Ajay', 'Marketing', 52000, 0.08), ('Pallavi', 'IT', 92000, 0.15),
('Dev', 'Finance', 78000, 0.12), ('Shreya', 'HR', 63000, 0.10), ('Ramesh', 'Sales', 58000, 0.09),
('Anita', 'Marketing', 54000, 0.08), ('Vikas', 'IT', 93000, 0.15), ('Maya', 'Finance', 79000, 0.12),
('Nitin', 'HR', 64000, 0.10), ('Preeti', 'Sales', 59000, 0.09), ('Raj', 'Marketing', 55000, 0.08),
('Swati', 'IT', 94000, 0.15), ('Kiran', 'Finance', 80000, 0.12), ('Tejas', 'HR', 65000, 0.10),
('Anu', 'Sales', 60000, 0.09), ('Zara', 'Marketing', 56000, 0.08), ('Om', 'IT', 95000, 0.15);