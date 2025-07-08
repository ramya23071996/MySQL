-- 🏭 Create Database and Tables
CREATE DATABASE IF NOT EXISTS WarehouseDB;
USE WarehouseDB;

-- Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL
);

-- Inward table (stock received)
CREATE TABLE Inward (
    inward_id INT PRIMARY KEY,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    inward_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Outward table (stock issued)
CREATE TABLE Outward (
    outward_id INT PRIMARY KEY,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    outward_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- StockLevels table (current stock)
CREATE TABLE StockLevels (
    product_id INT PRIMARY KEY,
    current_stock INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 📦 Insert Sample Products
INSERT INTO Products VALUES 
(1, 'Laptop'), 
(2, 'Mouse'), 
(3, 'Keyboard');

-- 📥 Insert Inward Movements
INSERT INTO Inward VALUES 
(101, 1, 50, '2025-07-01'),
(102, 2, 100, '2025-07-02'),
(103, 3, 75, '2025-07-03'),
(104, 1, 20, '2025-07-05');

-- 📤 Insert Outward Movements
INSERT INTO Outward VALUES 
(201, 1, 30, '2025-07-06'),
(202, 2, 120, '2025-07-07'),  -- Intentional over-issue for testing
(203, 3, 40, '2025-07-08');

-- 📊 Calculate Net Stock Using GROUP BY and SUM()
SELECT 
    p.product_id,
    p.product_name,
    IFNULL(SUM(i.quantity), 0) AS total_inward,
    IFNULL(SUM(o.quantity), 0) AS total_outward,
    IFNULL(SUM(i.quantity), 0) - IFNULL(SUM(o.quantity), 0) AS net_stock
FROM Products p
LEFT JOIN Inward i ON p.product_id = i.product_id
LEFT JOIN Outward o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;

-- 🔍 JOIN: Product Stock with Movement History
SELECT 
    p.product_name,
    i.inward_date AS movement_date,
    i.quantity AS inward_qty,
    NULL AS outward_qty
FROM Products p
JOIN Inward i ON p.product_id = i.product_id
UNION
SELECT 
    p.product_name,
    o.outward_date AS movement_date,
    NULL AS inward_qty,
    o.quantity AS outward_qty
FROM Products p
JOIN Outward o ON p.product_id = o.product_id
ORDER BY product_name, movement_date;

-- ⚠️ Find Items with Negative Stock (Potential Errors)
SELECT 
    p.product_id,
    p.product_name,
    IFNULL(SUM(i.quantity), 0) - IFNULL(SUM(o.quantity), 0) AS net_stock
FROM Products p
LEFT JOIN Inward i ON p.product_id = i.product_id
LEFT JOIN Outward o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
HAVING net_stock < 0;

-- 🔁 Update StockLevels with Transaction and Rollback on Inconsistency
START TRANSACTION;

-- Step 1: Recalculate stock for each product
DELETE FROM StockLevels;

INSERT INTO StockLevels (product_id, current_stock)
SELECT 
    p.product_id,
    IFNULL(SUM(i.quantity), 0) - IFNULL(SUM(o.quantity), 0) AS net_stock
FROM Products p
LEFT JOIN Inward i ON p.product_id = i.product_id
LEFT JOIN Outward o ON p.product_id = o.product_id
GROUP BY p.product_id;

-- Step 2: Check for inconsistencies (negative stock)
-- Simulate error if any stock is negative
SELECT * FROM StockLevels WHERE current_stock < 0;

-- If no negative stock, commit
COMMIT;

-- If inconsistency found, rollback
-- ROLLBACK;