-- ============================================
--  CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS ECommerceSearch;
USE ECommerceSearch;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Categories table (1NF & 2NF)
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

-- Products table (3NF)
CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Inventory table (separate stock info)
CREATE TABLE IF NOT EXISTS Inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    last_updated DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Categories
INSERT INTO Categories VALUES
(1, 'Electronics'), (2, 'Books'), (3, 'Clothing'), (4, 'Home & Kitchen');

-- Products
INSERT INTO Products VALUES
(101, 'Smartphone', 1, 25000),
(102, 'Laptop', 1, 55000),
(103, 'Fiction Novel', 2, 499),
(104, 'T-Shirt', 3, 799),
(105, 'Blender', 4, 2999),
(106, 'Headphones', 1, 1999),
(107, 'Cookbook', 2, 899),
(108, 'Jeans', 3, 1499),
(109, 'Microwave', 4, 7499),
(110, 'Tablet', 1, 18000);

-- Inventory
INSERT INTO Inventory VALUES
(1, 101, 50, '2024-07-01'),
(2, 102, 30, '2024-07-02'),
(3, 103, 100, '2024-07-03'),
(4, 104, 75, '2024-07-04'),
(5, 105, 40, '2024-07-05'),
(6, 106, 60, '2024-07-06'),
(7, 107, 90, '2024-07-07'),
(8, 108, 55, '2024-07-08'),
(9, 109, 20, '2024-07-09'),
(10, 110, 35, '2024-07-10');

-- ============================================
-- 3. CREATE INDEXES FOR OPTIMIZATION
-- ============================================

CREATE INDEX idx_product_name ON Products(product_name);
CREATE INDEX idx_category_id ON Products(category_id);
CREATE INDEX idx_price ON Products(price);

-- ============================================
-- 4. ANALYZE FILTERED QUERIES WITH EXPLAIN
-- ============================================

-- Filter by price range
EXPLAIN SELECT * FROM Products WHERE price BETWEEN 1000 AND 20000;

-- Filter by category
EXPLAIN SELECT * FROM Products WHERE category_id = 1;

-- ============================================
-- 5. DENORMALIZED TABLE FOR REPORTING
-- ============================================

CREATE TABLE IF NOT EXISTS Products_Denormalized (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    category_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- Insert denormalized data
INSERT INTO Products_Denormalized
SELECT p.product_id, p.product_name, p.category_id, c.category_name, p.price
FROM Products p
JOIN Categories c ON p.category_id = c.category_id;

-- Query denormalized table
EXPLAIN SELECT * FROM Products_Denormalized WHERE category_name = 'Electronics';

-- ============================================
-- 6. PAGINATION USING LIMIT AND OFFSET
-- ============================================

-- First 5 products sorted by price
SELECT product_id, product_name, price
FROM Products
ORDER BY price ASC
LIMIT 5;

-- Next 5 products (pagination)
SELECT product_id, product_name, price
FROM Products
ORDER BY price ASC
LIMIT 5 OFFSET 5;