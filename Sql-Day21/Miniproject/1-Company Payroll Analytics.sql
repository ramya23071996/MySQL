-- Drop tables if they already exist
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- 1. Create Tables
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE salaries (
    emp_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- 2. Insert Sample Data

-- Departments
INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'Engineering'),
(2, 'Marketing'),
(3, 'HR');

-- Employees
INSERT INTO employees (emp_id, emp_name, dept_id) VALUES
(101, 'Alice', 1),
(102, 'Bob', 1),
(103, 'Charlie', 2),
(104, 'Diana', 2),
(105, 'Eve', 3);

-- Salaries
INSERT INTO salaries (emp_id, salary) VALUES
(101, 75000.00),
(102, 68000.00),
(103, 52000.00),
(104, 48000.00),
(105, 45000.00);

-- 3. Salary Aggregates by Department
SELECT 
    d.dept_name,
    SUM(s.salary) AS total_salary,
    AVG(s.salary) AS avg_salary,
    MIN(s.salary) AS min_salary,
    MAX(s.salary) AS max_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN salaries s ON e.emp_id = s.emp_id
GROUP BY d.dept_name;

-- 4. Departments with Total Salary Above a Threshold
SELECT 
    d.dept_name,
    SUM(s.salary) AS total_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN salaries s ON e.emp_id = s.emp_id
GROUP BY d.dept_name
HAVING total_salary > 100000;

-- 5. Top 3 Highest Paid Employees
SELECT 
    e.emp_name,
    s.salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
ORDER BY s.salary DESC
LIMIT 3;