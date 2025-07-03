-- 26. Find the highest salary among employees who joined after 2020-01-01
SELECT MAX(salary) AS highest_salary
FROM employees
WHERE hire_date > '2020-01-01'

-- 27. Count how many employees have a salary below the overall average
SELECT COUNT(*) AS below_avg_salary_count
FROM employees
WHERE salary < (
    SELECT AVG(salary)
    FROM employees
);

-- 27. Count how many employees have a salary below the overall average
SELECT COUNT(*) AS below_avg_salary_count
FROM employees
WHERE salary < (
    SELECT AVG(salary)
    FROM employees
);

-- 28. List all departments and their total salary, including those with NULL department names
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 29. Find the department with the most employees
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY employee_count DESC
LIMIT 1;



-- 30. Find the department with the lowest total salary
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_salary ASC
LIMIT 1;







