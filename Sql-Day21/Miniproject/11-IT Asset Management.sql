-- Drop tables if they already exist
DROP TABLE IF EXISTS assets;
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

CREATE TABLE assets (
    asset_id INT PRIMARY KEY,
    asset_name VARCHAR(100),
    emp_id INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- 2. Insert Sample Data

-- Departments
INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing');

-- Employees
INSERT INTO employees (emp_id, emp_name, dept_id) VALUES
(101, 'Amit', 1),
(102, 'Bhavna', 1),
(103, 'Chirag', 2),
(104, 'Divya', 3);

-- Assets
INSERT INTO assets (asset_id, asset_name, emp_id) VALUES
(1001, 'Laptop', 101),
(1002, 'Monitor', 101),
(1003, 'Keyboard', 101),
(1004, 'Mouse', 102),
(1005, 'Printer', 103);

-- 3. Count Assets Assigned per Department
SELECT 
    d.dept_name,
    COUNT(a.asset_id) AS total_assets
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
JOIN assets a ON e.emp_id = a.emp_id
GROUP BY d.dept_name;

-- 4. Employees with More Than 2 Assets
SELECT 
    e.emp_name,
    COUNT(a.asset_id) AS asset_count
FROM employees e
JOIN assets a ON e.emp_id = a.emp_id
GROUP BY e.emp_name
HAVING asset_count > 2;

-- 5. Departments with No Assigned Assets
SELECT 
    d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN assets a ON e.emp_id = a.emp_id
WHERE a.asset_id IS NULL;