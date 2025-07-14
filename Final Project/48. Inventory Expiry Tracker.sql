-- 1. Create Inventory Database
CREATE DATABASE inventory_expiry;
USE inventory_expiry;

-- 2. Products Table
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Batches Table
CREATE TABLE batches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT,
    expiry_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 4. Sample Products
INSERT INTO products (name) VALUES
('Pain Relief Tablets'),
('Vitamin C Capsules'),
('Herbal Shampoo'),
('Organic Face Cream'),
('Antiseptic Liquid');

-- 5. Sample Batches
INSERT INTO batches (product_id, quantity, expiry_date) VALUES
(1, 100, '2025-07-25'),
(2, 200, '2025-08-10'),
(3, 150, '2024-12-31'),
(4, 80, '2025-06-30'),
(5, 50, '2023-12-15'),
(2, 120, '2025-06-01'),
(1, 60,  '2024-11-15');

-- Expired Stock (As of today)
SELECT 
    p.name AS product,
    b.quantity,
    b.expiry_date
FROM batches b
JOIN products p ON b.product_id = p.id
WHERE b.expiry_date < CURDATE()
ORDER BY b.expiry_date;

-- Remaining Stock by Product
SELECT 
    p.name AS product,
    SUM(b.quantity) AS total_quantity
FROM batches b
JOIN products p ON b.product_id = p.id
WHERE b.expiry_date >= CURDATE()
GROUP BY p.name
ORDER BY total_quantity DESC;

-- Total Stock Including Expired
SELECT 
    p.name AS product,
    SUM(b.quantity) AS overall_quantity
FROM batches b
JOIN products p ON b.product_id = p.id
GROUP BY p.name;

--  Expiry Distribution per Product
SELECT 
    p.name AS product,
    b.expiry_date,
    b.quantity
FROM batches b
JOIN products p ON b.product_id = p.id
ORDER BY p.name, b.expiry_date;