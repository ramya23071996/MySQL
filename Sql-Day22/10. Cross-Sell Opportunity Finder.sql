-- 1. Create the database
CREATE DATABASE IF NOT EXISTS sales_analytics;
USE sales_analytics;

-- 2. Create category-specific purchase tables
CREATE TABLE electronics_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2)
);

CREATE TABLE clothing_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2)
);

CREATE TABLE furniture_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2)
);

-- 3. Insert sample data
INSERT INTO electronics_orders VALUES
(1, 101, 'Alice', 25000),
(2, 102, 'Bob', 18000),
(3, 103, 'Charlie', 30000),
(4, 104, 'David', 15000);

INSERT INTO clothing_orders VALUES
(5, 101, 'Alice', 5000),
(6, 105, 'Eva', 3000),
(7, 103, 'Charlie', 7000),
(8, 106, 'Frank', 4000);

INSERT INTO furniture_orders VALUES
(9, 101, 'Alice', 20000),
(10, 107, 'Grace', 10000),
(11, 103, 'Charlie', 15000),
(12, 108, 'Hank', 8000);

-- 4. A. Customers who purchased from all three categories (INTERSECT simulation)
SELECT customer_name
FROM electronics_orders
WHERE customer_name IN (
    SELECT customer_name FROM clothing_orders
)
AND customer_name IN (
    SELECT customer_name FROM furniture_orders
);

-- 5. B. Customers who purchased from electronics but not clothing (EXCEPT simulation)
SELECT customer_name
FROM electronics_orders
WHERE customer_name NOT IN (
    SELECT customer_name FROM clothing_orders
);

-- 6. C. Customers who spent above average (across all categories)
SELECT customer_name, total_spent
FROM (
    SELECT customer_name, SUM(amount) AS total_spent
    FROM (
        SELECT customer_name, amount FROM electronics_orders
        UNION ALL
        SELECT customer_name, amount FROM clothing_orders
        UNION ALL
        SELECT customer_name, amount FROM furniture_orders
    ) AS all_orders
    GROUP BY customer_name
) AS customer_totals
WHERE total_spent > (
    SELECT AVG(total_amount) FROM (
        SELECT customer_name, SUM(amount) AS total_amount
        FROM (
            SELECT customer_name, amount FROM electronics_orders
            UNION ALL
            SELECT customer_name, amount FROM clothing_orders
            UNION ALL
            SELECT customer_name, amount FROM furniture_orders
        ) AS combined
        GROUP BY customer_name
    ) AS avg_calc
);

-- 7. D. Merge all customer names using UNION (unique list)
SELECT customer_name FROM electronics_orders
UNION
SELECT customer_name FROM clothing_orders
UNION
SELECT customer_name FROM furniture_orders;