CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2),
    department_id INT,
    team_id INT,
    hire_date DATE,
    birth_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    quantity INT
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE online_orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE store_orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE full_time_employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE contract_employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE electronics (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE furniture (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE current_employees (
    employee_id INT PRIMARY KEY
);

CREATE TABLE resigned_employees (
    employee_id INT PRIMARY KEY
);

CREATE TABLE wholesale (
    product_id INT PRIMARY KEY
);

CREATE TABLE retail (
    product_id INT PRIMARY KEY
);

CREATE TABLE website_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- 1
SELECT name, salary, 
       (SELECT MAX(salary) FROM employees) AS highest_salary
FROM employees;

-- 2
SELECT name, salary, 
       (SELECT COUNT(*) FROM employees) AS total_employees
FROM employees;

-- 3
SELECT name, salary, department_id,
       (SELECT MIN(salary) FROM employees e2 WHERE e2.department_id = e1.department_id) AS min_dept_salary
FROM employees e1;

-- 4
SELECT product_name, price,
       (SELECT MAX(price) FROM products) AS highest_price
FROM products;

-- 5
SELECT name, salary,
       (SELECT MAX(salary) * 0.10 FROM employees) AS bonus
FROM employees;

-- 6
SELECT dept_id, avg_salary
FROM (
    SELECT department_id AS dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg
WHERE avg_salary > 10000;

-- 7
SELECT dept_id, avg_salary
FROM (
    SELECT department_id AS dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg
WHERE avg_salary > (SELECT AVG(salary) FROM employees);

-- 8
SELECT name, department_id
FROM (
    SELECT * FROM employees ORDER BY salary DESC LIMIT 3
) AS top_earners;

-- 9
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;

-- 10
SELECT * FROM (
    SELECT department_id, MIN(salary) AS min_salary, MAX(salary) AS max_salary, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS salary_ranges;

-- 11
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 12
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- 13
SELECT * FROM employees e1
WHERE (SELECT COUNT(*) FROM employees e2 WHERE e2.department_id = e1.department_id) > 3;

-- 14
SELECT * FROM customers
WHERE (SELECT COUNT(*) FROM orders WHERE orders.customer_id = customers.customer_id) >
      (SELECT AVG(order_count) FROM (
          SELECT customer_id, COUNT(*) AS order_count FROM orders GROUP BY customer_id
      ) AS avg_orders);

-- 15
SELECT * FROM products
WHERE quantity < (SELECT MIN(quantity) FROM products);

-- 16
SELECT * FROM employees e1
WHERE salary > (
    SELECT AVG(salary) FROM employees e2 WHERE e2.department_id = e1.department_id
);

-- 17
SELECT * FROM employees e1
WHERE salary = (
    SELECT MAX(salary) FROM employees e2 WHERE e2.department_id = e1.department_id
);

-- 18
SELECT DISTINCT department_id FROM employees
WHERE salary > 50000;

-- 19
SELECT * FROM employees e1
WHERE salary > ALL (
    SELECT salary FROM employees e2 WHERE e2.team_id = e1.team_id AND e2.employee_id != e1.employee_id
);

-- 20
SELECT * FROM employees
WHERE salary < ANY (
    SELECT MAX(salary) FROM employees GROUP BY department_id
);

-- 21
SELECT customer_name FROM online_orders
UNION
SELECT customer_name FROM store_orders;

-- 22
SELECT customer_name FROM online_orders
UNION ALL
SELECT customer_name FROM store_orders;

-- 23
SELECT name FROM full_time_employees
UNION
SELECT name FROM contract_employees;

-- 24
SELECT product_name FROM electronics
UNION
SELECT product_name FROM furniture;

-- 25
-- With duplicates
SELECT city FROM customers
UNION ALL
SELECT city FROM suppliers;

-- Without duplicates
SELECT city FROM customers
UNION
SELECT city FROM suppliers;

-- 26 (INTERSECT simulated using INNER JOIN)
SELECT name FROM employees WHERE department_id = 101
AND name IN (SELECT name FROM employees WHERE department_id = 102);

-- 27
SELECT name FROM employees WHERE department_id = 101
AND name NOT IN (SELECT name FROM employees WHERE department_id = 103); -- HR

-- 28
SELECT product_id FROM wholesale
INTERSECT
SELECT product_id FROM retail;

-- 29
SELECT customer_id FROM website_orders
EXCEPT
SELECT customer_id FROM store_orders;

-- 30
SELECT employee_id FROM current_employees
EXCEPT
SELECT employee_id FROM resigned_employees;

-- 31
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 32
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;

-- 33
SELECT d.department_name, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 34
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
HAVING total_salary > 100000;

-- 35
SELECT YEAR(hire_date) AS year, COUNT(*) AS hires
FROM employees
GROUP BY YEAR(hire_date);

-- 36
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);

-- 37
SELECT d.department_name, e.name, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE (e.salary, e.department_id) IN (
    SELECT MAX(salary), department_id FROM employees GROUP BY department_id
);

-- 38
SELECT department_id
FROM employees
GROUP BY department_id
HAVING COUNT(*) < (
    SELECT AVG(dept_size) FROM (
        SELECT department_id, COUNT(*) AS dept_size FROM employees GROUP BY department_id
    ) AS dept_sizes
);

-- 39
SELECT department_id, COUNT(*) AS high_earners
FROM employees
WHERE salary > 50000
GROUP BY department_id;

-- 40
SELECT * FROM employees e1
WHERE salary > (
    SELECT AVG(salary) FROM employees e2 WHERE e2.department_id = e1.department_id
);

-- 41
SELECT name, salary,
       CASE 
           WHEN salary >= 50000 THEN 'High'
           WHEN salary >= 30000 THEN 'Medium'
           ELSE 'Low'
       END AS salary_category
FROM employees;

-- 42
SELECT product_name, quantity,
       CASE 
           WHEN quantity < 50 THEN 'Low'
           WHEN quantity BETWEEN 50 AND 200 THEN 'Moderate'
           ELSE 'High'
       END AS stock_status
FROM products;

-- 43
SELECT department_id,
       SUM(CASE WHEN salary >= 50000 THEN 1 ELSE 0 END) AS high,
       SUM(CASE WHEN salary BETWEEN 30000 AND 49999 THEN 1 ELSE 0 END) AS medium,
       SUM(CASE WHEN salary < 30000 THEN 1 ELSE 0 END) AS low
FROM employees
GROUP BY department_id;

-- 44
SELECT name, hire_date,
       CASE 
           WHEN YEAR(hire_date) = YEAR(CURDATE()) THEN 'New Joiner'
           WHEN YEAR(hire_date) >= YEAR(CURDATE()) - 3 THEN 'Mid-Level'
           ELSE 'Senior'
       END AS remarks
FROM employees;

-- 45
SELECT name, salary,
       CASE 
           WHEN salary >= 60000 THEN 'A'
           WHEN salary >= 40000 THEN 'B'
           ELSE 'C'
       END AS grade
FROM employees;

-- 46
SELECT * FROM employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 47
SELECT * FROM employees
WHERE TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) > 2;

-- 48
SELECT name, TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) AS months_since_joining
FROM employees;

-- 49
SELECT YEAR(hire_date) AS year, COUNT(*) AS hires


-- 50
SELECT employee_id, name, birth_date
FROM employees
WHERE MONTH(birth_date) = MONTH(CURDATE());