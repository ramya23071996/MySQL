-- 1. Create the database
CREATE DATABASE IF NOT EXISTS warehouse_inventory;
USE warehouse_inventory;

-- 2. Create category tables
CREATE TABLE electronics (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    stock INT
);

CREATE TABLE furniture (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    stock INT
);

CREATE TABLE clothing (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    stock INT
);

-- 3. Create warehouse tables
CREATE TABLE warehouse_a (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100)
);

CREATE TABLE warehouse_b (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100)
);

-- 4. Insert sample data into categories
INSERT INTO electronics VALUES
(1, 'Laptop', 50),
(2, 'Smartphone', 120),
(3, 'Tablet', 30);

INSERT INTO furniture VALUES
(4, 'Chair', 200),
(5, 'Table', 80),
(6, 'Sofa', 15);

INSERT INTO clothing VALUES
(7, 'T-Shirt', 300),
(8, 'Jeans', 150),
(9, 'Jacket', 60);

-- 5. Insert sample data into warehouses
INSERT INTO warehouse_a VALUES
(1, 'Laptop'),
(2, 'Smartphone'),
(4, 'Chair'),
(7, 'T-Shirt');

INSERT INTO warehouse_b VALUES
(2, 'Smartphone'),
(3, 'Tablet'),
(5, 'Table'),
(8, 'Jeans');

-- 6. A. Merge items from all categories using UNION
SELECT item_name, stock FROM electronics
UNION
SELECT item_name, stock FROM furniture
UNION
SELECT item_name, stock FROM clothing;

-- 7. B. Find average stock using subquery
SELECT 
    (SELECT AVG(stock) FROM (
        SELECT stock FROM electronics
        UNION ALL
        SELECT stock FROM furniture
        UNION ALL
        SELECT stock FROM clothing
    ) AS all_stock) AS average_stock;

-- 8. C. Tag stock levels using CASE WHEN
SELECT 
    item_name,
    stock,
    CASE 
        WHEN stock >= 150 THEN 'High'
        WHEN stock >= 50 THEN 'Moderate'
        ELSE 'Low'
    END AS stock_status
FROM (
    SELECT item_name, stock FROM electronics
    UNION ALL
    SELECT item_name, stock FROM furniture
    UNION ALL
    SELECT item_name, stock FROM clothing
) AS merged_items;

-- 9. D. Items in Warehouse A but not in Warehouse B (EXCEPT simulation)
SELECT item_name
FROM warehouse_a
WHERE item_name NOT IN (
    SELECT item_name FROM warehouse_b
);