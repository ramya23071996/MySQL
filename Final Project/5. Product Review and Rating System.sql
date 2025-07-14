-- 1. Create Review Database
CREATE DATABASE product_reviews;
USE product_reviews;

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

-- 4. Reviews Table
CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    UNIQUE (user_id, product_id) -- Prevent duplicate reviews
);

-- 5. Insert Sample Users
INSERT INTO users (name) VALUES
('Ramya'),
('Arjun'),
('Sneha');

-- 6. Insert Sample Products
INSERT INTO products (name) VALUES
('Laptop'),
('Sneakers'),
('Smartphone'),
('Headphones'),
('Desk Lamp');

-- 7. Insert Sample Reviews
INSERT INTO reviews (user_id, product_id, rating, review) VALUES
(1, 1, 5, 'Excellent performance and build quality'),
(1, 2, 4, 'Stylish and comfortable'),
(2, 1, 4, 'Solid choice for work'),
(2, 3, 5, 'Outstanding features'),
(3, 4, 3, 'Sound is decent, battery could be better'),
(3, 5, 4, 'Bright and compact design'),
(1, 3, 5, 'Amazing camera and speed'),
(2, 2, 3, 'Good, but could be cheaper'),
(3, 1, 5, 'Fast and lightweight'),
(1, 5, 4, 'Adds a nice glow to the workspace');

-- 8. Query: Average Ratings for Each Product
SELECT 
    p.name AS product,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.id) AS total_reviews
FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name;

-- 9. Query: Top-Rated Products (Above 4.5)
SELECT 
    p.name AS product,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM products p
JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name
HAVING AVG(r.rating) > 4.5;

-- 10. Query: Reviews for Product 'Laptop'
SELECT 
    u.name AS user,
    r.rating,
    r.review,
    r.created_at
FROM reviews r
JOIN users u ON r.user_id = u.id
JOIN products p ON r.product_id = p.id
WHERE p.name = 'Laptop'
ORDER BY r.created_at DESC;