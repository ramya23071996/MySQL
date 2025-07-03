-- 31. List all employees and their department names (use INNER JOIN)
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

--  32. List all employees and their department names, including those without a department (LEFT JOIN)
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- 33. List all departments and employees, including departments with no employees (RIGHT JOIN)
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- 34. Show all department names, even if there are no employees in them (RIGHT or LEFT JOIN)
SELECT d.department_name
FROM departments d
LEFT JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 35. For each department, list the department name and the number of employees in it (JOIN + GROUP BY)
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_name;





