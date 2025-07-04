-- 1. Create the database
CREATE DATABASE IF NOT EXISTS management_dashboard;
USE management_dashboard;

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
(107, 'Grace', 85000, 3),
(108, 'Hank', 40000, 4),
(109, 'Ivy', 42000, 4);

-- 6. Department Performance Ranking with All Requirements
SELECT 
    d.department_name,
    dept_stats.total_salary,
    dept_stats.avg_salary,
    
    -- Performance tag based on average salary
    CASE 
        WHEN dept_stats.avg_salary >= 70000 THEN 'Outstanding'
        WHEN dept_stats.avg_salary >= 50000 THEN 'Strong'
        ELSE 'Needs Improvement'
    END AS performance_tag

FROM (
    -- Subquery to calculate total and average salary per department
    SELECT 
        department_id,
        SUM(salary) AS total_salary,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_stats

JOIN departments d ON dept_stats.department_id = d.department_id

-- Filter departments with above-average total salary expense
WHERE dept_stats.total_salary > (
    SELECT AVG(total_dept_salary)
    FROM (
        SELECT department_id, SUM(salary) AS total_dept_salary
        FROM employees
        GROUP BY department_id
    ) AS all_dept_totals
)

ORDER BY dept_stats.total_salary DESC;