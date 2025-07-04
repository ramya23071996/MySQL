-- 1. Create the database
CREATE DATABASE IF NOT EXISTS ecommerce_dashboard;
USE ecommerce_dashboard;

-- 2. Create category tables
CREATE TABLE electronics (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE clothing (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE furniture (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- 3. Insert sample data
INSERT INTO electronics VALUES
(1, 'Smartphone', 25000),
(2, 'Laptop', 55000),
(3, 'Headphones', 3000);

INSERT INTO clothing VALUES
(4, 'T-Shirt', 800),
(5, 'Jeans', 2000),
(6, 'Jacket', 3500);

INSERT INTO furniture VALUES
(7, 'Sofa', 30000),
(8, 'Dining Table', 18000),
(9, 'Chair', 2500);

-- 4. A. Combine products using UNION (unique products)
SELECT product_name, price FROM electronics
UNION
SELECT product_name, price FROM clothing
UNION
SELECT product_name, price FROM furniture;

-- 5. B. Combine products using UNION ALL (with duplicates)
SELECT product_name, price FROM electronics
UNION ALL
SELECT product_name, price FROM clothing
UNION ALL
SELECT product_name, price FROM furniture;

-- 6. C. Show max and min price using subqueries
SELECT 
    (SELECT MAX(price) FROM (
        SELECT price FROM electronics
        UNION ALL
        SELECT price FROM clothing
        UNION ALL
        SELECT price FROM furniture
    ) AS all_prices) AS max_price,

    (SELECT MIN(price) FROM (
        SELECT price FROM electronics
        UNION ALL
        SELECT price FROM clothing
        UNION ALL
        SELECT price FROM furniture
    ) AS all_prices) AS min_price;

-- 7. D. Classify products by price using CASE
SELECT 
    product_name,
    price,
    CASE 
        WHEN price >= 30000 THEN 'Premium'
        WHEN price >= 10000 THEN 'Mid-Range'
        ELSE 'Budget'
    END AS price_category
FROM (
    SELECT product_name, price FROM electronics
    UNION ALL
    SELECT product_name, price FROM clothing
    UNION ALL
    SELECT product_name, price FROM furniture
) AS merged_products;