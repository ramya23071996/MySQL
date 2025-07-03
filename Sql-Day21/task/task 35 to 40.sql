-- 36. Show all employees, their department names, and their latest salary paid
SELECT e.employee_id, e.first_name, e.last_name, d.department_name, s.amount AS latest_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN (
    SELECT employee_id, MAX(date_paid) AS latest_date
    FROM salaries
    GROUP BY employee_id
) latest ON e.employee_id = latest.employee_id
JOIN salaries s ON s.employee_id = latest.employee_id AND s.date_paid = latest.latest_date;

-- 37. List all salaries paid in each department
SELECT d.department_name, s.amount, s.date_paid
FROM salaries s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id;



-- 38. Find employees who have never been paid a salary (LEFT JOIN with salaries)
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
LEFT JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.salary_id IS NULL;



-- 39. List departments and the total paid to their employees (JOIN + GROUP BY)
SELECT d.department_name, SUM(s.amount) AS total_paid
FROM salaries s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;



-- 40. Find the average salary amount paid per department
SELECT d.department_name, AVG(s.amount) AS average_paid
FROM salaries s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;





