-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS HRSystem;
USE HRSystem;

-- Step 2: Create Departments table
CREATE TABLE IF NOT EXISTS Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL
);

-- Step 3: Create Employees table
CREATE TABLE IF NOT EXISTS Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100) NOT NULL,
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- Insert Values
-- Sample insertions for 50 employees
INSERT INTO Employees (emp_name, dept_id, salary, hire_date) VALUES
('Aarav', 1, 52000, '2023-07-01'),
('Diya', 2, 65000, '2024-01-15'),
('Rohan', 3, 48000, '2023-11-20'),
('Meera', 1, 55000, '2023-06-10'),
('Karan', 2, 70000, '2024-02-05'),
('Sneha', 3, 46000, '2023-10-12'),
('Vikram', 1, 53000, '2023-08-25'),
('Anjali', 2, 62000, '2024-03-01'),
('Rahul', 3, 47000, '2023-09-18'),
('Priya', 1, 51000, '2023-07-30'),
('Neha', 2, 68000, '2024-01-10'),
('Arjun', 3, 49000, '2023-12-05'),
('Ishita', 1, 54000, '2023-06-20'),
('Manav', 2, 66000, '2024-02-15'),
('Tanya', 3, 45000, '2023-11-01'),
('Yash', 1, 56000, '2023-08-10'),
('Pooja', 2, 69000, '2024-03-12'),
('Nikhil', 3, 47000, '2023-10-25'),
('Ritika', 1, 50000, '2023-07-05'),
('Sahil', 2, 71000, '2024-01-20'),
('Divya', 3, 46000, '2023-09-30'),
('Amit', 1, 53000, '2023-06-15'),
('Kavya', 2, 64000, '2024-02-25'),
('Harsh', 3, 48000, '2023-12-10'),
('Simran', 1, 55000, '2023-08-01'),
('Ravi', 2, 67000, '2024-03-20'),
('Bhavna', 3, 49000, '2023-11-15'),
('Deepak', 1, 52000, '2023-07-18'),
('Ayesha', 2, 70000, '2024-01-05'),
('Gaurav', 3, 46000, '2023-10-05'),
('Naina', 1, 51000, '2023-06-28'),
('Suresh', 2, 68000, '2024-02-10'),
('Lavanya', 3, 47000, '2023-09-12'),
('Tarun', 1, 54000, '2023-08-18'),
('Ira', 2, 66000, '2024-03-05'),
('Mohit', 3, 45000, '2023-11-25'),
('Rekha', 1, 56000, '2023-07-12'),
('Ajay', 2, 69000, '2024-01-30'),
('Pallavi', 3, 48000, '2023-10-20'),
('Kriti', 1, 50000, '2023-06-05'),
('Dev', 2, 71000, '2024-02-20'),
('Shreya', 3, 46000, '2023-12-15'),
('Ramesh', 1, 53000, '2023-08-05'),
('Anita', 2, 64000, '2024-03-25'),
('Vikas', 3, 49000, '2023-09-25'),
('Maya', 1, 55000, '2023-07-22'),
('Nitin', 2, 67000, '2024-01-12'),
('Preeti', 3, 47000, '2023-11-08'),
('Raj', 1, 52000, '2023-06-18'),
('Swati', 2, 70000, '2024-02-02');

-- Step 4: Create EmployeeAudit table
CREATE TABLE IF NOT EXISTS EmployeeAudit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    action VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 5: Create or Replace View to hide salary
CREATE OR REPLACE VIEW PublicEmployeeView AS
SELECT 
    e.emp_id, 
    e.emp_name, 
    d.dept_name AS department
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- Step 6: Stored Procedure to get employees by department
DELIMITER //
CREATE PROCEDURE GetEmployeesByDepartment(IN dept_name VARCHAR(100))
BEGIN
    SELECT e.emp_id, e.emp_name, d.dept_name
    FROM Employees e
    JOIN Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
END;
//
DELIMITER ;

-- Step 7: Trigger to log new employee insertions
DELIMITER //
CREATE TRIGGER LogNewEmployee
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO EmployeeAudit(emp_id, action)
    VALUES (NEW.emp_id, 'INSERT');
END;
//
DELIMITER ;

-- Step 8: Function to count employees in a department
DELIMITER //
CREATE FUNCTION CountEmployeesInDept(dept_name VARCHAR(100)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE emp_count INT;
    SELECT COUNT(*) INTO emp_count
    FROM Employees e
    JOIN Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
    RETURN emp_count;
END;
//
DELIMITER ;