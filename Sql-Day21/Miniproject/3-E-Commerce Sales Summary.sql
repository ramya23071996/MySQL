-- Drop tables if they already exist
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- 1. Create Tables
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 2. Insert Sample Data

-- Products
INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Laptop', 75000.00),
(2, 'Smartphone', 30000.00),
(3, 'Headphones', 2500.00),
(4, 'Keyboard', 1500.00);

-- Customers
INSERT INTO customers (customer_id, customer_name) VALUES
(101, 'Anita'),
(102, 'Bharath'),
(103, 'Chetan'),
(104, 'Divya');

-- Orders
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1001, 101, '2025-07-01'),
(1002, 102, '2025-07-02'),
(1003, 101, '2025-07-03');

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1001, 1, 1),
(1001, 3, 2),
(1002, 2, 1),
(1003, 4, 3);

-- 3. Total Sales per Product
SELECT 
    p.product_name,
    SUM(oi.quantity * p.price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- 4. Total Sales per Customer
SELECT 
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_name;

-- 5. Products with Sales Above a Threshold
SELECT 
    p.product_name,
    SUM(oi.quantity * p.price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
HAVING total_sales > 5000;

-- 6. Customers with No Orders
SELECT 
    c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;