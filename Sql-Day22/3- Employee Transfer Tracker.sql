-- 1. Create the database
CREATE DATABASE IF NOT EXISTS hr_operations;
USE hr_operations;

-- 2. Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- 3. Create employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- 4. Create employee_department_history table
CREATE TABLE employee_department_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    department_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 5. Insert sample departments
INSERT INTO departments (department_id, department_name) VALUES
(101, 'IT'),
(102, 'Finance'),
(103, 'HR'),
(104, 'Marketing');

-- 6. Insert sample employees
INSERT INTO employees (employee_id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David'),
(5, 'Eva');

-- 7. Insert department history (transfers)
INSERT INTO employee_department_history (employee_id, department_id, start_date, end_date) VALUES
(1, 101, '2022-01-01', '2023-01-01'),
(1, 102, '2023-01-02', NULL),
(2, 101, '2023-06-01', NULL),
(3, 102, '2022-05-01', NULL),
(4, 103, '2023-01-01', NULL),
(5, 101, '2023-02-01', '2023-08-01'),
(5, 102, '2023-08-02', NULL);

-- 8. A. Employees who worked in both IT and Finance
SELECT 'Employees in both IT and Finance' AS insight, name
FROM employees
WHERE employee_id IN (
    SELECT employee_id FROM employee_department_history WHERE department_id = 101
)
AND employee_id IN (
    SELECT employee_id FROM employee_department_history WHERE department_id = 102
);

-- 9. B. Employees in IT but not in HR
SELECT 'Employees in IT but not in HR' AS insight, name
FROM employees
WHERE employee_id IN (
    SELECT employee_id FROM employee_department_history WHERE department_id = 101
)
AND employee_id NOT IN (
    SELECT employee_id FROM employee_department_history WHERE department_id = 103
);

-- 10. C. Employees transferred in the last 6 months
SELECT 'Transferred in last 6 months' AS insight, DISTINCT e.name
FROM employees e
JOIN employee_department_history h ON e.employee_id = h.employee_id
WHERE h.start_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 11. D. Unique department count per employee
SELECT 'Unique departments per employee' AS insight, e.name, COUNT(DISTINCT h.department_id) AS department_count
FROM employees e
JOIN employee_department_history h ON e.employee_id = h.employee_id
GROUP BY e.name;