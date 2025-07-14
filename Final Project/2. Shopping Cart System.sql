-- 1. Create Database and Use It
CREATE DATABASE shopping_cart;
USE shopping_cart;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 3. Carts Table
CREATE TABLE carts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 4. Products Table
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0
);

-- 5. Cart Items Table (Composite PK)
CREATE TABLE cart_items (
    cart_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES carts(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 6. Insert Users
INSERT INTO users (name, email) VALUES
('Ramya', 'ramya@example.com'),
('Arjun', 'arjun@example.com'),
('Sneha', 'sneha@example.com');

-- 7. Insert Carts
INSERT INTO carts (user_id) VALUES 
(1), (2), (3);

-- 8. Insert Products
INSERT INTO products (name, price, stock) VALUES
('Laptop', 54999.00, 12),
('Sneakers', 2999.00, 40),
('Blender', 1999.00, 25),
('Smartphone', 38999.00, 20),
('Hoodie', 1999.00, 50),
('Watch', 4999.00, 15),
('Earphones', 999.00, 100),
('Book', 499.00, 80),
('Gaming Mouse', 1499.00, 35),
('Desk Lamp', 899.00, 60);

-- 9. Insert Cart Items
INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 4, 2),
(1, 10, 1),
(2, 2, 2),
(2, 5, 1),
(2, 7, 3),
(3, 3, 1),
(3, 6, 2),
(3, 9, 1),
(3, 8, 4);

-- 10. View Cart with Product Details (JOIN)
SELECT u.name AS user, p.name AS product, p.price, ci.quantity, (p.price * ci.quantity) AS subtotal
FROM cart_items ci
JOIN carts c ON ci.cart_id = c.id
JOIN users u ON c.user_id = u.id
JOIN products p ON ci.product_id = p.id
WHERE u.name = 'Ramya';

-- 11. Total Cart Value (SUM)
SELECT u.name AS user, SUM(p.price * ci.quantity) AS total_cart_value
FROM cart_items ci
JOIN carts c ON ci.cart_id = c.id
JOIN users u ON c.user_id = u.id
JOIN products p ON ci.product_id = p.id
WHERE u.name = 'Ramya'
GROUP BY u.name;

-- 12. Update Quantity
UPDATE cart_items
SET quantity = 5
WHERE cart_id = 1 AND product_id = 4;

-- 13. Delete Item from Cart
DELETE FROM cart_items
WHERE cart_id = 1 AND product_id = 10;