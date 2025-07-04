-- 1. Create the database
CREATE DATABASE IF NOT EXISTS hr_performance;
USE hr_performance;

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
(3, 'Engineering');

-- 5. Insert sample employees
INSERT INTO employees (employee_id, name, salary, department_id) VALUES
(101, 'Alice', 60000, 1),
(102, 'Bob', 45000, 1),
(103, 'Charlie', 75000, 2),
(104, 'David', 50000, 2),
(105, 'Eva', 90000, 3),
(106, 'Frank', 30000, 3),
(107, 'Grace', 85000, 3),
(108, 'Hank', 40000, 1),
(109, 'Ivy', 70000, 2),
(110, 'Jack', 95000, 3);

-- 6. A. Employees with salary > department average (correlated subquery)
SELECT 
    employee_id,
    name,
    salary,
    department_id
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

-- 7. B. Top 5 earners in the company
SELECT employee_id, name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- 8. C. Department-level performance summary (JOIN + GROUP BY)
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    AVG(e.salary) AS avg_salary,
    SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 9. D. Classify employee performance level using CASE WHEN
SELECT 
    employee_id,
    name,
    salary,
    department_id,
    CASE 
        WHEN salary >= 90000 THEN 'Outstanding'
        WHEN salary >= 70000 THEN 'Excellent'
        WHEN salary >= 50000 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance_level
FROM employees;