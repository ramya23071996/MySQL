-- 1. Create Database
CREATE DATABASE wishlist_system;
USE wishlist_system;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Products Table
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL
);

-- 4. Wishlist Table (Many-to-Many Link)
CREATE TABLE wishlist (
    user_id INT,
    product_id INT,
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 5. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Sample Products
INSERT INTO products (name) VALUES
('iPhone 14'), ('NoiseFit Smartwatch'), ('MacBook Air'), 
('Nike Air Max'), ('LED TV'), ('Instant Pot'),
('AirPods Pro'), ('Kindle Paperwhite'), ('Philips Blender'), 
('Gaming Mouse');

-- 7. Sample Wishlist Data
INSERT INTO wishlist (user_id, product_id) VALUES
(1, 1), (1, 3), (1, 7),
(2, 2), (2, 4), (2, 8),
(3, 3), (3, 6), (3, 9),
(4, 1), (4, 5), (4, 10),
(5, 2), (5, 7), (5, 8);

-- 8. Query: User Wishlist Items
SELECT 
    u.name AS user,
    p.name AS product
FROM wishlist w
JOIN users u ON w.user_id = u.id
JOIN products p ON w.product_id = p.id
ORDER BY u.name;

-- 9. Query: Popular Wishlist Products (Most Wishlisted)
SELECT 
    p.name AS product,
    COUNT(w.user_id) AS wishlist_count
FROM wishlist w
JOIN products p ON w.product_id = p.id
GROUP BY p.name
ORDER BY wishlist_count DESC;

-- 10. Query: Products in Ramya's Wishlist
SELECT p.name AS product
FROM wishlist w
JOIN products p ON w.product_id = p.id
JOIN users u ON w.user_id = u.id
WHERE u.name = 'Ramya';