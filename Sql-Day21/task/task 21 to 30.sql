-- 21. Find departments where the sum of salaries is less than 120,000
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) < 120000;



-- 22. Find departments with an average salary below 55,000
SELECT d.department_name, AVG(e.salary) AS average_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) < 55000;

-- 23. List departments with more than 3 employees and total salary above 150,000
SELECT d.department_name, COUNT(e.employee_id) AS employee_count, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 3 AND SUM(e.salary) > 150000;

-- 24. Show departments where the maximum salary is at least 70,000
SELECT d.department_name, MAX(e.salary) AS max_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING MAX(e.salary) >= 70000;

-- 25. List departments where the minimum salary is above 50,000
SELECT d.department_name, MIN(e.salary) AS min_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING MIN(e.salary) > 50000;


