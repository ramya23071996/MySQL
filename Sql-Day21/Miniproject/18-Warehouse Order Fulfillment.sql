-- Drop tables if they already exist
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;

-- 1. Create Tables

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    stock_quantity INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    employee_id INT,
    order_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    fulfilled BOOLEAN,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 2. Insert Sample Data

-- Employees
INSERT INTO employees (employee_id, employee_name) VALUES
(1, 'Aarav'),
(2, 'Bhavya'),
(3, 'Chirag');

-- Products
INSERT INTO products (product_id, product_name, stock_quantity) VALUES
(101, 'Laptop', 5),
(102, 'Mouse', 0),
(103, 'Keyboard', 10),
(104, 'Monitor', 0);

-- Orders
INSERT INTO orders (order_id, employee_id, order_date) VALUES
(1001, 1, '2025-07-01'),
(1002, 2, '2025-07-02'),
(1003, 1, '2025-07-03'),
(1004, 3, '2025-07-04');

-- Order Items
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, fulfilled) VALUES
(1, 1001, 101, 1, TRUE),
(2, 1001, 102, 2, FALSE),
(3, 1002, 103, 1, TRUE),
(4, 1003, 104, 1, FALSE),
(5, 1004, 101, 1, TRUE),
(6, 1004, 103, 1, TRUE);

-- 3. Count Orders Handled per Employee
SELECT 
    e.employee_name,
    COUNT(DISTINCT o.order_id) AS orders_handled
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.employee_name;

-- 4. Identify Products Frequently Out of Stock (stock_quantity = 0)
SELECT 
    product_name,
    stock_quantity
FROM products
WHERE stock_quantity = 0;

-- 5. Employees with Top Fulfillment Rates
SELECT 
    e.employee_name,
    COUNT(CASE WHEN oi.fulfilled THEN 1 END) AS fulfilled_items,
    COUNT(oi.order_item_id) AS total_items,
    ROUND(COUNT(CASE WHEN oi.fulfilled THEN 1 END) / COUNT(oi.order_item_id) * 100, 2) AS fulfillment_rate_percent
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY e.employee_id, e.employee_name
ORDER BY fulfillment_rate_percent DESC;