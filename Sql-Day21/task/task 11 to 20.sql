-- 11. Show the total salary paid for each department
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e

-- 12. Show the average salary for each department
SELECT d.department_name, AVG(e.salary) AS average_salary
FROM employees e
JOIN departments d ON e.de


-- 13. List the number of employees in each department
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;



-- 14. List departments with more than 2 employees (use HAVING)
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 2;



-- 15. Show the minimum salary for each department
SELECT d.department_name, MIN(e.salary) AS min_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;



-- 16. Show the maximum salary for each department
SELECT d.department_name, MAX(e.salary) AS max_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;



-- 17. List the number of employees hired each year
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS employee_count
FROM employees
GROUP BY YEAR(hire_date);



-- 18. Show the total salary for departments where the total salary exceeds 100,000
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) > 100000;



-- 19. List departments where the average salary is above 60,000
SELECT d.department_name, AVG(e.salary) AS average_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > 60000;



-- 20. List years and the number of employees hired in each year
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS employee_count
FROM employees
GROUP BY YEAR(hire_date);



