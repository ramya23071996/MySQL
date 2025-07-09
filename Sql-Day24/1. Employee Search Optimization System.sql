--  CREATE DATABASE
CREATE DATABASE IF NOT EXISTS HRMS_EmployeeSearch;
USE HRMS_EmployeeSearch;

-- 1. CREATE NORMALIZED TABLES

-- Departments table
CREATE TABLE IF NOT EXISTS Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

-- Employees table
CREATE TABLE IF NOT EXISTS Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10,2),
    joining_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- 2. INSERT SAMPLE DATA

-- Insert into Departments
INSERT INTO Departments (dept_id, dept_name) VALUES
(101, 'HR'), (102, 'Finance'), (103, 'Engineering'), (104, 'Marketing');

-- Insert into Employees
INSERT INTO Employees (emp_id, emp_name, dept_id, salary, joining_date) VALUES
(1, 'John', 101, 50000, '2020-01-15'),
(2, 'Alice', 102, 60000, '2019-03-10'),
(3, 'Bob', 103, 55000, '2021-06-20'),
(4, 'David', 104, 70000, '2018-11-05'),
(5, 'Eva', 102, 62000, '2022-02-01'),
(6, 'Frank', 103, 48000, '2020-08-12'),
(7, 'Grace', 101, 75000, '2017-09-30'),
(8, 'Helen', 104, 53000, '2021-12-25'),
(9, 'Ian', 103, 51000, '2023-01-10'),
(10, 'Jane', 101, 68000, '2019-07-18');

-- 3. CREATE INDEXES FOR OPTIMIZATION

CREATE INDEX idx_emp_name ON Employees(emp_name);
CREATE INDEX idx_dept_id ON Employees(dept_id);

-- 4. ANALYZE SEARCH QUERY PERFORMANCE

-- Search by employee name
EXPLAIN SELECT * FROM Employees WHERE emp_name = 'John';

-- Search by department
EXPLAIN SELECT * FROM Employees WHERE dept_id = 103;

-- 5. CREATE DENORMALIZED TABLE

CREATE TABLE IF NOT EXISTS Employees_Denormalized (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    dept_name VARCHAR(100),
    salary DECIMAL(10,2),
    joining_date DATE
);

-- Insert data into denormalized table
INSERT INTO Employees_Denormalized
SELECT e.emp_id, e.emp_name, e.dept_id, d.dept_name, e.salary, e.joining_date
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- Analyze search in denormalized table
EXPLAIN SELECT * FROM Employees_Denormalized WHERE dept_name = 'Engineering';

-- 6. PERFORMANCE COMPARISON WITH AND WITHOUT LIMIT

-- Without LIMIT
EXPLAIN SELECT emp_id, emp_name, salary FROM Employees ORDER BY salary DESC;

-- With LIMIT
EXPLAIN SELECT emp_id, emp_name, salary FROM Employees ORDER BY salary DESC LIMIT 5;

-- 7. BONUS: PAGINATION EXAMPLE

-- Retrieve records 6–10 (pagination)
SELECT emp_id, emp_name, salary
FROM Employees
ORDER BY salary DESC
LIMIT 5 OFFSET 5;