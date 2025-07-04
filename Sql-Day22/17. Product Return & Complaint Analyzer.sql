-- 1. Create the database
CREATE DATABASE IF NOT EXISTS customer_support_dashboard;
USE customer_support_dashboard;

-- 2. Create tables
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_id INT,
    return_date DATE,
    return_reason_code CHAR(1),  -- 'D' = Damaged, 'L' = Late, 'N' = Not as Described
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 3. Insert sample products
INSERT INTO products VALUES
(1, 'Smartphone'),
(2, 'Laptop'),
(3, 'Headphones'),
(4, 'Tablet'),
(5, 'Smartwatch');

-- 4. Insert sample orders
INSERT INTO orders VALUES
(101, 1, 1001, '2024-11-01'),
(102, 2, 1002, '2024-11-02'),
(103, 3, 1003, '2024-11-03'),
(104, 4, 1004, '2024-11-04'),
(105, 5, 1005, '2024-11-05'),
(106, 1, 1006, '2024-11-06'),
(107, 3, 1007, '2024-11-07'),
(108, 2, 1008, '2024-11-08'),
(109, 1, 1009, '2024-11-09'),
(110, 4, 1010, '2024-11-10');

-- 5. Insert sample returns
INSERT INTO returns VALUES
(201, 101, '2024-11-11', 'D'),
(202, 103, '2024-11-12', 'L'),
(203, 106, '2024-11-13', 'N'),
(204, 107, '2024-11-14', 'D'),
(205, 109, '2024-11-15', 'D');

-- 6. A. Most returned products (subquery)
SELECT 
    p.product_name,
    COUNT(r.return_id) AS return_count
FROM returns r
JOIN orders o ON r.order_id = o.order_id
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
HAVING return_count = (
    SELECT MAX(product_returns) FROM (
        SELECT COUNT(r2.return_id) AS product_returns
        FROM returns r2
        JOIN orders o2 ON r2.order_id = o2.order_id
        GROUP BY o2.product_id
    ) AS return_stats
);

-- 7. B. Classify return reasons using CASE
SELECT 
    r.return_id,
    p.product_name,
    r.return_reason_code,
    CASE 
        WHEN r.return_reason_code = 'D' THEN 'Damaged'
        WHEN r.return_reason_code = 'L' THEN 'Late'
        WHEN r.return_reason_code = 'N' THEN 'Not as Described'
        ELSE 'Other'
    END AS reason_description
FROM returns r
JOIN orders o ON r.order_id = o.order_id
JOIN products p ON o.product_id = p.product_id;

-- 8. C. Join orders and returns to show return behavior
SELECT 
    o.order_id,
    p.product_name,
    o.customer_id,
    r.return_date,
    CASE 
        WHEN r.return_reason_code = 'D' THEN 'Damaged'
        WHEN r.return_reason_code = 'L' THEN 'Late'
        WHEN r.return_reason_code = 'N' THEN 'Not as Described'
        ELSE 'Other'
    END AS return_reason
FROM orders o
JOIN products p ON o.product_id = p.product_id
LEFT JOIN returns r ON o.order_id = r.order_id;

-- 9. D. Filter products with return rate above average
SELECT 
    p.product_name,
    COUNT(r.return_id) / COUNT(o.order_id) AS return_rate
FROM products p
JOIN orders o ON p.product_id = o.product_id
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY p.product_name
HAVING return_rate > (
    SELECT AVG(product_return_rate) FROM (
        SELECT 
            COUNT(r2.return_id) / COUNT(o2.order_id) AS product_return_rate
        FROM products p2
        JOIN orders o2 ON p2.product_id = o2.product_id
        LEFT JOIN returns r2 ON o2.order_id = r2.order_id
        GROUP BY p2.product_id
    ) AS avg_rates
);