-- 41. List all employees with their manager’s name
SELECT 
    e.employee_id,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    m.first_name AS manager_first_name,
    m.last_name AS manager_last_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;



-- 42. Find employees who are also managers
SELECT DISTINCT m.employee_id, m.first_name, m.last_name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id;



-- 43. Find employees who have the same manager
SELECT 
    e1.employee_id AS emp1_id, e1.first_name AS emp1_name,
    e2.employee_id AS emp2_id, e2.first_name AS emp2_name,
    e1.manager_id
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.manager_id
WHERE e1.employee_id < e2.employee_id AND e1.manager_id IS NOT NULL;


-- 44. List all managers and the number of employees reporting to them
SELECT 
    m.employee_id AS manager_id,
    m.first_name AS manager_first_name,
    m.last_name AS manager_last_name,
    COUNT(e.employee_id) AS report_count
FROM employees m
JOIN employees e ON m.employee_id = e.manager_id
GROUP BY m.employee_id, m.first_name, m.last_name;



-- 45. Show employees whose manager is in the "IT" department
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    m.first_name AS manager_first_name,
    m.last_name AS manager_last_name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
JOIN departments d ON m.department_id = d.department_id
WHERE d.department_name = 'IT';




