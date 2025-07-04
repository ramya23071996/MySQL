-- 1. Create the database
CREATE DATABASE IF NOT EXISTS hr_analytics;
USE hr_analytics;

-- 2. Create employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    hire_date DATE
);

-- 3. Insert sample data
INSERT INTO employees (employee_id, name, hire_date) VALUES
(101, 'Alice', '2024-12-15'),
(102, 'Bob', '2024-11-01'),
(103, 'Charlie', '2024-07-10'),
(104, 'David', '2023-12-20'),
(105, 'Eva', '2023-06-05'),
(106, 'Frank', '2022-09-18'),
(107, 'Grace', '2021-03-30'),
(108, 'Hank', '2020-08-25'),
(109, 'Ivy', '2023-01-10'),
(110, 'Jack', '2024-06-01');

-- 4. A. Employees who joined in the last 6 months
SELECT employee_id, name, hire_date
FROM employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 5. B. Employees who joined before and after the average join date
-- Average join date
SELECT 
    employee_id,
    name,
    hire_date,
    CASE 
        WHEN hire_date < (SELECT AVG(hire_date) FROM employees) THEN 'Before Avg Join Date'
        ELSE 'After Avg Join Date'
    END AS join_timing
FROM employees;

-- 6. C. Aggregate joiners per month
SELECT 
    DATE_FORMAT(hire_date, '%Y-%m') AS join_month,
    COUNT(*) AS total_joiners
FROM employees
GROUP BY DATE_FORMAT(hire_date, '%Y-%m')
ORDER BY join_month;

-- 7. D. Year-wise hiring classification using CASE
SELECT 
    employee_id,
    name,
    hire_date,
    CASE 
        WHEN YEAR(hire_date) = YEAR(CURDATE()) THEN 'Current Year Joiner'
        WHEN YEAR(hire_date) = YEAR(CURDATE()) - 1 THEN 'Last Year Joiner'
        WHEN YEAR(hire_date) < YEAR(CURDATE()) - 1 THEN 'Veteran'
        ELSE 'Future Joiner'
    END AS hiring_classification
FROM employees;