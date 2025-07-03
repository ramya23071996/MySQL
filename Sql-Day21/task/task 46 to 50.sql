-- 46. For each department, show the department name and the highest salary of its employees
SELECT d.department_name, MAX(e.salary) AS highest_salary
FROM employees e
JOIN departments d ON e.department_i

-- 47. List employees whose salary is higher than the average salary of their department
SELECT e.employee_id, e.first_name, e.last_name, e.salary, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

-- 48. List all departments with the total salary paid to employees who joined before 2020
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.hire_date < '2020-01-01'
GROUP BY d.department_name;

-- 49. Show departments where all employees have a salary above 50,000
SELECT d.department_name
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING MIN(e.salary) > 50000;

-- 50. Find the manager who manages the most employees
SELECT m.employee_id, m.first_name, m.last_name, COUNT(e.employee_id) AS report_count
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
GROUP BY m.employee_id, m.first_name, m.last_name
ORDER BY report_count DESC
LIMIT 1;




