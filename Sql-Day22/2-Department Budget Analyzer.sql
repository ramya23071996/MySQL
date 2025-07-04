-- 1. Create the database
CREATE DATABASE IF NOT EXISTS finance_dashboard;
USE finance_dashboard;

-- 2. Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- 3. Create employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 4. Insert sample departments
INSERT INTO departments (department_id, department_name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Engineering'),
(4, 'Marketing');

-- 5. Insert sample employees
INSERT INTO employees (employee_id, name, salary, department_id) VALUES
(101, 'Alice', 60000, 1),
(102, 'Bob', 45000, 1),
(103, 'Charlie', 75000, 2),
(104, 'David', 50000, 2),
(105, 'Eva', 90000, 3),
(106, 'Frank', 30000, 3),
(107, 'Grace', 55000, 4),
(108, 'Hank', 52000, 4);

-- 6. A. Departments with Average Salary > ₹50,000 (Subquery in FROM clause)
SELECT dept_id, avg_salary
FROM (
    SELECT department_id AS dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg
WHERE avg_salary > 50000;

-- 7. B. Total Salary Paid by Each Department
SELECT 
    d.department_name,
    SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 8. C. Department with the Highest Total Salary
SELECT 
    d.department_name,
    SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING total_salary = (
    SELECT MAX(dept_total)
    FROM (
        SELECT department_id, SUM(salary) AS dept_total
        FROM employees
        GROUP BY department_id
    ) AS totals
);