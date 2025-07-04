-- 1. Create the database
CREATE DATABASE IF NOT EXISTS hr_audit;
USE hr_audit;

-- 2. Create tables
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE resigned_employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    designation VARCHAR(100),
    department_id INT,
    resignation_date DATE
);

CREATE TABLE hired_employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    designation VARCHAR(100),
    department_id INT,
    hire_date DATE
);

-- 3. Insert sample departments
INSERT INTO departments VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Engineering'),
(4, 'Marketing');

-- 4. Insert sample resigned employees
INSERT INTO resigned_employees VALUES
(101, 'Alice', 'HR Executive', 1, '2024-12-01'),
(102, 'Bob', 'Accountant', 2, '2024-11-15'),
(103, 'Charlie', 'Software Engineer', 3, '2024-10-20'),
(104, 'David', 'Marketing Analyst', 4, '2024-09-10'),
(105, 'Eva', 'Software Engineer', 3, '2024-08-05');

-- 5. Insert sample hired employees
INSERT INTO hired_employees VALUES
(201, 'Frank', 'Accountant', 2, '2024-12-10'),
(202, 'Grace', 'Software Engineer', 3, '2024-12-15'),
(203, 'Hank', 'Marketing Analyst', 4, '2024-12-20');

-- 6. A. Resigned employees not replaced (EXCEPT simulation)
SELECT name, designation
FROM resigned_employees
WHERE designation NOT IN (
    SELECT designation FROM hired_employees
);

-- 7. B. Overlapping designations (INTERSECT simulation)
SELECT DISTINCT designation
FROM resigned_employees
WHERE designation IN (
    SELECT designation FROM hired_employees
);

-- 8. C. Department(s) with highest attrition (subquery)
SELECT department_id, resignation_count
FROM (
    SELECT department_id, COUNT(*) AS resignation_count
    FROM resigned_employees
    GROUP BY department_id
) AS dept_attrition
WHERE resignation_count = (
    SELECT MAX(resignation_count)
    FROM (
        SELECT department_id, COUNT(*) AS resignation_count
        FROM resigned_employees
        GROUP BY department_id
    ) AS all_counts
);

-- 9. D. Department-level resignation count (JOIN + GROUP BY)
SELECT 
    d.department_name,
    COUNT(r.employee_id) AS total_resignations
FROM resigned_employees r
JOIN departments d ON r.department_id = d.department_id
GROUP BY d.department_name;