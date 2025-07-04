-- 1. Create the database
CREATE DATABASE IF NOT EXISTS marketing_dashboard;
USE marketing_dashboard;

-- 2. Create products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    launch_date DATE
);

-- 3. Create sales table
CREATE TABLE product_sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_amount DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 4. Insert sample products
INSERT INTO products (product_id, product_name, launch_date) VALUES
(1, 'AlphaPhone', '2024-06-01'),
(2, 'BetaWatch', '2024-05-15'),
(3, 'GammaTablet', '2024-04-10'),
(4, 'DeltaLaptop', '2023-12-01'),
(5, 'OmegaSpeaker', '2023-10-20');

-- 5. Insert sample sales
INSERT INTO product_sales (sale_id, product_id, sale_amount) VALUES
(1, 1, 50000),
(2, 1, 45000),
(3, 2, 30000),
(4, 3, 20000),
(5, 4, 60000),
(6, 4, 55000),
(7, 5, 15000);

-- 6. A. Products launched in the last 3 months
SELECT * 
FROM products
WHERE launch_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

-- 7. B. Compare sales of new vs existing products using UNION
SELECT 
    p.product_name,
    'New' AS product_type,
    SUM(s.sale_amount) AS total_sales
FROM products p
JOIN product_sales s ON p.product_id = s.product_id
WHERE p.launch_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY p.product_name

UNION

SELECT 
    p.product_name,
    'Existing' AS product_type,
    SUM(s.sale_amount) AS total_sales
FROM products p
JOIN product_sales s ON p.product_id = s.product_id
WHERE p.launch_date < DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY p.product_name;

-- 8. C & D. Classify launch success using average sales and CASE
SELECT 
    p.product_name,
    p.launch_date,
    SUM(s.sale_amount) AS total_sales,
    CASE 
        WHEN SUM(s.sale_amount) >= (
            SELECT AVG(total) FROM (
                SELECT product_id, SUM(sale_amount) AS total
                FROM product_sales
                GROUP BY product_id
            ) AS avg_sales
        ) * 1.2 THEN 'Successful'
        WHEN SUM(s.sale_amount) >= (
            SELECT AVG(total) FROM (
                SELECT product_id, SUM(sale_amount) AS total
                FROM product_sales
                GROUP BY product_id
            ) AS avg_sales
        ) * 0.8 THEN 'Neutral'
        ELSE 'Fail'
    END AS launch_outcome
FROM products p
JOIN product_sales s ON p.product_id = s.product_id
WHERE p.launch_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY p.product_name, p.launch_date;