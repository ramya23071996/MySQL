-- 1. Create the database
CREATE DATABASE IF NOT EXISTS retail_dashboard;
USE retail_dashboard;

-- 2. Create tables for online and offline orders
CREATE TABLE online_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    order_amount DECIMAL(10,2)
);

CREATE TABLE store_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    order_amount DECIMAL(10,2)
);

-- 3. Insert sample data
INSERT INTO online_orders VALUES
(1, 101, 'Alice', 1200),
(2, 102, 'Bob', 800),
(3, 103, 'Charlie', 1500),
(4, 104, 'David', 600),
(5, 105, 'Eva', 2000);

INSERT INTO store_orders VALUES
(6, 101, 'Alice', 1000),
(7, 106, 'Frank', 700),
(8, 103, 'Charlie', 1300),
(9, 107, 'Grace', 900),
(10, 105, 'Eva', 1800);

-- 4. A. Merge customer names using UNION (unique customers)
SELECT customer_name FROM online_orders
UNION
SELECT customer_name FROM store_orders;

-- 5. B. Merge customer names using UNION ALL (with duplicates)
SELECT customer_name FROM online_orders
UNION ALL
SELECT customer_name FROM store_orders;

-- 6. C. Customers active on both platforms (INTERSECT simulation)
SELECT customer_name
FROM online_orders
WHERE customer_name IN (
    SELECT customer_name FROM store_orders
);

-- 7. D. Customers who spent more than the average (across both platforms)
SELECT customer_name, total_spent
FROM (
    SELECT customer_name, SUM(order_amount) AS total_spent
    FROM (
        SELECT customer_name, order_amount FROM online_orders
        UNION ALL
        SELECT customer_name, order_amount FROM store_orders
    ) AS all_orders
    GROUP BY customer_name
) AS customer_totals
WHERE total_spent > (
    SELECT AVG(order_total) FROM (
        SELECT customer_name, SUM(order_amount) AS order_total
        FROM (
            SELECT customer_name, order_amount FROM online_orders
            UNION ALL
            SELECT customer_name, order_amount FROM store_orders
        ) AS combined_orders
        GROUP BY customer_name
    ) AS avg_orders
);