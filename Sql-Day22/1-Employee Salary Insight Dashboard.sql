-- 1. Create the database
CREATE DATABASE IF NOT EXISTS hr_dashboard;
USE hr_dashboard;

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
    hire_date DATE,
    birth_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 4. Insert sample departments
INSERT INTO departments (department_id, department_name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Engineering');

-- 5. Insert sample employees
INSERT INTO employees (employee_id, name, salary, department_id, hire_date, birth_date) VALUES
(101, 'Alice', 60000, 1, '2021-03-15', '1990-07-10'),
(102, 'Bob', 45000, 1, '2020-06-10', '1988-12-05'),
(103, 'Charlie', 75000, 2, '2019-01-20', '1992-07-25'),
(104, 'David', 50000, 2, '2022-09-01', '1991-03-18'),
(105, 'Eva', 90000, 3, '2018-11-11', '1985-07-30'),
(106, 'Frank', 30000, 3, '2023-02-01', '1995-07-02');

-- 6. Unified Dashboard Query
SELECT 
    e.employee_id,
    e.name,
    e.salary,
    d.department_name,

    -- Company-wide salary benchmarks
    (SELECT MAX(salary) FROM employees) AS max_company_salary,
    (SELECT AVG(salary) FROM employees) AS avg_company_salary,
    (SELECT MIN(salary) FROM employees) AS min_company_salary,

    -- Salary classification
    CASE 
        WHEN e.salary >= (SELECT MAX(salary) FROM employees) * 0.9 THEN 'High'
        WHEN e.salary >= (SELECT AVG(salary) FROM employees) THEN 'Medium'
        ELSE 'Low'
    END AS salary_category,

    -- Department-level comparison
    CASE 
        WHEN e.salary > (
            SELECT AVG(e2.salary)
            FROM employees e2
            WHERE e2.department_id = e.department_id
        ) THEN 'Above Dept Avg'
        ELSE 'Below/Equal Dept Avg'
    END AS dept_salary_comparison

FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- 7. Department-wise salary summary
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