-- 1. Count the total number of employees
SELECT COUNT(*) AS total_employees
FROM employees;

-- 2. Count how many employees are in the "IT" department
SELECT COUNT(*) AS it_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'IT';

-- 3. Find the sum of all employees’ salaries
SELECT SUM(salary) AS total_salary
FROM employees;

-- 4. Find the sum of salaries for employees in the "HR" department
SELECT SUM(e.salary) AS hr_total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'HR';

-- 5. Calculate the average salary of all employees
SELECT AVG(salary) AS average_salary
FROM employees;

--  6. Find the average salary of employees in the "Marketing" department
SELECT AVG(e.salary) AS marketing_avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Marketing';

-- 7. Find the minimum salary in the employees table
SELECT MIN(salary) AS minimum_salary
FROM employees;

-- 8. Find the maximum salary in the employees table
SELECT MAX(salary) AS maximum_salary
FROM employees;

--  9. Find the minimum hire date in the employees table
SELECT MIN(hire_date) AS earliest_hire_date
FROM employees;

-- 10. Find the maximum hire date in the employees table
SELECT MAX(hire_date) AS latest_hire_date
FROM employees;













