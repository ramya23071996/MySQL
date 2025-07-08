-- 🔧 Create Database and Tables
CREATE DATABASE IF NOT EXISTS EmployeeDB;
USE EmployeeDB;

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    performance_score INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Salaries (
    emp_id INT PRIMARY KEY,
    salary DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

-- 📝 Insert Data
INSERT INTO Departments VALUES 
(1, 'HR'), 
(2, 'IT'), 
(3, 'Finance');

INSERT INTO Employees VALUES 
(101, 'Ramya', 2, 92),
(102, 'Arun', 2, 85),
(103, 'Priya', 1, 78),
(104, 'Kiran', 3, 88),
(105, 'Divya', 1, 95);

INSERT INTO Salaries VALUES 
(101, 75000.00),
(102, 68000.00),
(103, 50000.00),
(104, 72000.00),
(105, 80000.00);

-- 🔍 Retrieve High-Performing Employees
SELECT e.emp_id, e.emp_name, d.dept_name, e.performance_score, s.salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
JOIN Salaries s ON e.emp_id = s.emp_id
WHERE e.performance_score >= 85
ORDER BY e.performance_score DESC;

-- 📊 Department-wise Average Salary
SELECT d.dept_name, AVG(s.salary) AS avg_salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
JOIN Salaries s ON e.emp_id = s.emp_id
GROUP BY d.dept_name;

-- 🧠 Classify Salaries Using CASE
SELECT e.emp_name, s.salary,
  CASE 
    WHEN s.salary >= 75000 THEN 'High'
    WHEN s.salary >= 60000 THEN 'Medium'
    ELSE 'Low'
  END AS salary_level
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 🔁 Update Salaries with Transaction and Rollback Support
START TRANSACTION;

-- Increase salary by 10% for high performers
UPDATE Salaries
SET salary = salary * 1.10
WHERE emp_id IN (
    SELECT emp_id FROM Employees WHERE performance_score >= 90
);

-- Simulate failure (optional test)
-- UPDATE Salaries SET salary = 'invalid' WHERE emp_id = 102;

-- If successful, commit
COMMIT;

-- If error occurs, uncomment to rollback
-- ROLLBACK;