-- 1. Create the database
CREATE DATABASE IF NOT EXISTS hr_salary_bands;
USE hr_salary_bands;

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
(101, 'Alice', 90000, 1),
(102, 'Bob', 85000, 1),
(103, 'Charlie', 87000, 1),
(104, 'David', 88000, 1),
(105, 'Eva', 60000, 2),
(106, 'Frank', 55000, 2),
(107, 'Grace', 50000, 2),
(108, 'Hank', 95000, 3),
(109, 'Ivy', 30000, 3),
(110, 'Jack', 40000, 3),
(111, 'Liam', 70000, 4),
(112, 'Mia', 72000, 4),
(113, 'Noah', 68000, 4);

-- 6. A. Add salary band classification using CASE
-- Band A: salary >= company avg
-- Band B: salary >= dept avg but < company avg
-- Band C: salary < dept avg

SELECT 
    e.employee_id,
    e.name,
    e.salary,
    d.department_name,
    CASE 
        WHEN e.salary >= (SELECT AVG(salary) FROM employees) THEN 'Band A'
        WHEN e.salary >= (
            SELECT AVG(e2.salary)
            FROM employees e2
            WHERE e2.department_id = e.department_id
        ) THEN 'Band B'
        ELSE 'Band C'
    END AS salary_band
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- 7. B. Count employees per band per department
-- CTE to assign bands
WITH banded_employees AS (
    SELECT 
        e.employee_id,
        e.department_id,
        CASE 
            WHEN e.salary >= (SELECT AVG(salary) FROM employees) THEN 'Band A'
            WHEN e.salary >= (
                SELECT AVG(e2.salary)
                FROM employees e2
                WHERE e2.department_id = e.department_id
            ) THEN 'Band B'
            ELSE 'Band C'
        END AS salary_band
    FROM employees e
)

-- Count per band per department
SELECT 
    d.department_name,
    b.salary_band,
    COUNT(*) AS employee_count
FROM banded_employees b
JOIN departments d ON b.department_id = d.department_id
GROUP BY d.department_name, b.salary_band;

-- 8. C. Filter departments where Band A employees > 3
WITH banded_employees AS (
    SELECT 
        e.employee_id,
        e.department_id,
        CASE 
            WHEN e.salary >= (SELECT AVG(salary) FROM employees) THEN 'Band A'
            WHEN e.salary >= (
                SELECT AVG(e2.salary)
                FROM employees e2
                WHERE e2.department_id = e.department_id
            ) THEN 'Band B'
            ELSE 'Band C'
        END AS salary_band
    FROM employees e
)

SELECT 
    d.department_name,
    COUNT(*) AS band_a_count
FROM banded_employees b
JOIN departments d ON b.department_id = d.department_id
WHERE b.salary_band = 'Band A'
GROUP BY d.department_name
HAVING COUNT(*) > 3;