-- 1. Create Database and Use It
CREATE DATABASE order_management;
USE order_management;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 3. Products Table
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0
);

-- 4. Orders Table with ENUM Status
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. Order Items Table
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 6. Insert Users
INSERT INTO users (name, email) VALUES
('Ramya', 'ramya@example.com'),
('Arjun', 'arjun@example.com'),
('Sneha', 'sneha@example.com');

-- 7. Insert Products
INSERT INTO products (name, price, stock) VALUES
('Laptop', 54999.00, 10),
('Sneakers', 2999.00, 40),
('Blender', 1999.00, 25),
('Smartphone', 38999.00, 20),
('Watch', 4999.00, 15),
('Earphones', 999.00, 60),
('Book', 499.00, 100),
('Gaming Mouse', 1499.00, 35),
('Desk Lamp', 899.00, 50),
('Tablet', 19999.00, 12);

-- 8. Insert Orders
INSERT INTO orders (user_id, status) VALUES
(1, 'Pending'),
(2, 'Shipped'),
(3, 'Delivered'),
(1, 'Cancelled');

-- 9. Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 54999.00),
(1, 6, 2, 999.00),
(2, 2, 1, 2999.00),
(2, 4, 1, 38999.00),
(3, 5, 2, 4999.00),
(3, 7, 3, 499.00),
(3, 9, 1, 899.00),
(4, 3, 1, 1999.00),
(4, 10, 1, 19999.00),
(4, 8, 2, 1499.00);

-- 10. Get Order History for User 'Ramya'
SELECT o.id AS order_id, o.status, o.created_at,
       p.name AS product, oi.quantity, oi.price,
       (oi.quantity * oi.price) AS total
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
JOIN users u ON o.user_id = u.id
WHERE u.name = 'Ramya';

-- 11. Total Spent by Each User
SELECT u.name AS user, SUM(oi.quantity * oi.price) AS total_spent
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY u.name;