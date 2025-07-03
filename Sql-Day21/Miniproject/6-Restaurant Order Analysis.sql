-- Drop tables if they already exist
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS customers;

-- 1. Create Tables

CREATE TABLE menu_items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
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

CREATE TABLE order_details (
    order_id INT,
    item_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

-- 2. Insert Sample Data

-- Menu Items
INSERT INTO menu_items (item_id, item_name, price) VALUES
(1, 'Margherita Pizza', 300.00),
(2, 'Pasta Alfredo', 250.00),
(3, 'Caesar Salad', 180.00),
(4, 'Lemonade', 90.00),
(5, 'Chocolate Cake', 150.00);

-- Customers
INSERT INTO customers (customer_id, customer_name) VALUES
(101, 'Riya'),
(102, 'Karan'),
(103, 'Meera');

-- Orders
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1001, 101, '2025-07-01'),
(1002, 102, '2025-07-02'),
(1003, 101, '2025-07-03');

-- Order Details
INSERT INTO order_details (order_id, item_id, quantity) VALUES
(1001, 1, 2),
(1001, 4, 2),
(1002, 2, 1),
(1002, 3, 1),
(1003, 1, 1),
(1003, 5, 2);

-- 3. Total Revenue per Menu Item
SELECT 
    m.item_name,
    SUM(od.quantity * m.price) AS total_revenue
FROM order_details od
JOIN menu_items m ON od.item_id = m.item_id
GROUP BY m.item_name;

-- 4. Customers with the Highest Order Totals
SELECT 
    c.customer_name,
    SUM(od.quantity * m.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_items m ON od.item_id = m.item_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 5. Menu Items Never Ordered
SELECT 
    m.item_name
FROM menu_items m
LEFT JOIN order_details od ON m.item_id = od.item_id
WHERE od.item_id IS NULL;