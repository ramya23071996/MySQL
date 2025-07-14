-- 1. Create Database and Use It
CREATE DATABASE ecommerce_catalog;
USE ecommerce_catalog;

-- 2. Create Categories Table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Create Brands Table
CREATE TABLE brands (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Create Products Table with Foreign Keys and Indexing
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    image_url VARCHAR(255),
    category_id INT,
    brand_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (brand_id) REFERENCES brands(id),
    INDEX idx_category (category_id),
    INDEX idx_brand (brand_id),
    INDEX idx_price (price)
);

-- 5. Insert Category Data
INSERT INTO categories (name) VALUES 
('Electronics'), 
('Apparel'), 
('Home');

-- 6. Insert Brand Data
INSERT INTO brands (name) VALUES 
('Apple'), 
('Nike'), 
('Philips');

-- 7. Insert 10 Sample Products
INSERT INTO products (name, description, price, stock, image_url, category_id, brand_id) VALUES
('iPhone 14', 'Smartphone with A15 Bionic chip', 79999.00, 25, 'images/iphone14.jpg', 1, 1),
('Nike Air Max', 'Comfortable running shoes', 5999.00, 50, 'images/airmax.jpg', 2, 2),
('Philips Blender', 'Multi-function kitchen blender', 3499.00, 20, 'images/blender.jpg', 3, 3),
('MacBook Air', 'Lightweight laptop with M2 chip', 114999.00, 15, 'images/macbook.jpg', 1, 1),
('Nike Hoodie', 'Warm cotton hoodie', 2999.00, 40, 'images/hoodie.jpg', 2, 2),
('LED TV 42"', 'Full HD television', 23999.00, 18, 'images/ledtv.jpg', 1, 3),
('Running Tights', 'Stretchable training wear', 1999.00, 60, 'images/tights.jpg', 2, 2),
('AirPods Pro', 'Wireless earbuds with noise cancellation', 24999.00, 30, 'images/airpods.jpg', 1, 1),
('Philips Iron', 'Steam iron for clothes', 1899.00, 35, 'images/iron.jpg', 3, 3),
('Smart Watch', 'Fitness tracker with GPS', 5499.00, 45, 'images/smartwatch.jpg', 1, 2);

-- 8. Queries to Retrieve Data

-- Products by Category
SELECT p.name, p.price, p.stock, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Electronics';

-- Products by Brand
SELECT p.name, p.price, p.stock, b.name AS brand
FROM products p
JOIN brands b ON p.brand_id = b.id
WHERE b.name = 'Nike';

-- Products in Price Range
SELECT name, price, stock
FROM products
WHERE price BETWEEN 1000 AND 5000;

-- Products by Category and Price
SELECT p.name, p.price, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Apparel' AND p.price < 2000;

-- Product Count by Brand
SELECT b.name AS brand, COUNT(p.id) AS product_count
FROM products p
JOIN brands b ON p.brand_id = b.id
GROUP BY b.name;