CREATE DATABASE retail_dw;
USE retail_dw;

-- task 1
 -- Data Warehouse Definition
-- A centralized repository for storing integrated historical data, optimized for analytics and reporting.

-- Key Components:
-- - Source Systems
-- - ETL Processes
-- - Staging Area
-- - Data Marts
-- - OLAP Engine
-- - Metadata
-- - Reporting Tools

-- task 2
-- OLTP vs OLAP (Examples)
-- | Feature |             OLTP |                      OLAP | 
-- | Example | POS system placing order   | BI dashboard showing monthly revenue | 
-- | Query   | INSERT INTO orders ...     | SELECT SUM(amount) GROUP BY category | 
-- | Purpose | Real-time transactions     | Historical analysis and forecasting  | 


-- 3–5. OLTP Simulation
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  order_date DATE,
  quantity INT,
  total_amount DECIMAL(10,2)
);

-- OLAP Table
CREATE TABLE monthly_sales_summary (
  month INT,
  year INT,
  product_category VARCHAR(50),
  total_sales DECIMAL(12,2),
  total_orders INT
);

-- OLTP Insert
INSERT INTO orders VALUES (1, 101, 201, '2025-07-12', 2, 750.00);

-- STAR SCHEMA DESIGN
CREATE TABLE dim_product (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50)
);

CREATE TABLE dim_customer (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE dim_time (
  time_id INT PRIMARY KEY,
  date DATE,
  month INT,
  year INT
);

CREATE TABLE dim_location (
  location_id INT PRIMARY KEY,
  region VARCHAR(50),
  city VARCHAR(50)
);

CREATE TABLE fact_sales (
  sale_id INT PRIMARY KEY,
  product_id INT,
  customer_id INT,
  time_id INT,
  location_id INT,
  quantity INT,
  total_amount DECIMAL(10,2)
);

-- Task 8
SELECT category, SUM(total_amount)
FROM fact_sales fs JOIN dim_product dp ON fs.product_id = dp.product_id
GROUP BY category;

-- Task 9
SELECT region, SUM(total_amount)
FROM fact_sales fs JOIN dim_location dl ON fs.location_id = dl.location_id
GROUP BY region;

-- Task 10
SELECT *
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_customer c ON f.customer_id = c.customer_id
JOIN dim_time t ON f.time_id = t.time_id
JOIN dim_location l ON f.location_id = l.location_id;

-- SNOWFLAKE SCHEMA DESIGN
CREATE TABLE category_details (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(50)
);

ALTER TABLE dim_product ADD category_id INT;

INSERT INTO category_details VALUES
(1, 'Personal Care'), (2, 'Stationery'), (3, 'Food');

UPDATE dim_product
SET category_id = CASE
  WHEN category = 'Personal Care' THEN 1
  WHEN category = 'Stationery' THEN 2
  WHEN category = 'Food' THEN 3
END;

-- Task 13
SELECT cd.category_name, SUM(fs.total_amount)
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
JOIN category_details cd ON dp.category_id = cd.category_id
GROUP BY cd.category_name;

-- Task 14 (Performance Comparison)
EXPLAIN SELECT ... -- (Compare star vs snowflake queries)

-- Task 15
SELECT city, COUNT(*) AS sales_count
FROM fact_sales fs JOIN dim_location dl ON fs.location_id = dl.location_id
GROUP BY city;

-- SECTION 2: AGGREGATION & REPORTING
-- Task 16 & 17
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(total_amount) AS sales
FROM orders
GROUP BY year, month
HAVING SUM(total_amount) > 10000;

-- Task 18
SELECT product_id, COUNT(*) AS order_count FROM orders GROUP BY product_id;

-- Task 19
SELECT customer_id, AVG(total_amount) AS avg_spend FROM orders GROUP BY customer_id;

-- Task 20
SELECT category, MAX(total_amount), MIN(total_amount), AVG(total_amount)
FROM orders o JOIN dim_product dp ON o.product_id = dp.product_id
GROUP BY category;

-- SECTION 3: ETL (Extract, Transform, Load)
-- Extract Phase (Tasks 26–29)
SELECT * FROM customers WHERE status = 'Active';
SELECT * FROM orders WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
SELECT customer_id, SUM(total_amount) FROM orders GROUP BY customer_id HAVING SUM(total_amount) > 20000;

-- Transform Phase (Tasks 30–34)
UPDATE customers SET customer_name = UPPER(customer_name);
UPDATE customers SET email = 'default@email.com' WHERE email IS NULL;
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM customers;
UPDATE dim_product SET category = LOWER(category);
SELECT order_id, total_amount * 0.18 AS tax FROM orders;

-- Load Phase (Tasks 35–39)
CREATE TABLE dw_sales_summary (customer_id INT, total_purchases DECIMAL(12,2));
INSERT INTO dw_sales_summary SELECT customer_id, SUM(total_amount) FROM orders GROUP BY customer_id;

CREATE TABLE dw_monthly_product_sales (
  product_id INT, month INT, year INT, total_sales DECIMAL(12,2)
);

INSERT INTO dw_monthly_product_sales
SELECT product_id, MONTH(order_date), YEAR(order_date), SUM(total_amount)
FROM orders
GROUP BY product_id, MONTH(order_date), YEAR(order_date);

CREATE TABLE etl_logs (
  step_name VARCHAR(50), status VARCHAR(20), timestamp DATETIME
);

INSERT INTO etl_logs VALUES ('Transform', 'Success', NOW());

-- SECTION 4: OLAP QUERY PRACTICE
-- Task 40
SELECT EXTRACT(MONTH FROM order_date), COUNT(*) FROM orders GROUP BY EXTRACT(MONTH FROM order_date);

-- Task 41
SELECT CEIL(MONTH(order_date)/3) AS quarter, YEAR(order_date), SUM(total_amount)
FROM orders GROUP BY YEAR(order_date), quarter;

-- Task 42
SELECT product_id, AVG(quantity) FROM orders GROUP BY product_id;

-- Task 43
SELECT EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date), SUM(total_amount)
FROM orders GROUP BY 1, 2;

-- Task 44
SELECT month, revenue,
       revenue - LAG(revenue) OVER (ORDER BY year, month) AS change
FROM monthly_sales_summary;

-- SECTION 5: ADVANCED BI USE CASES
-- Task 45
CREATE VIEW dashboard_view AS
SELECT MONTH(order_date) AS month,
       SUM(total_amount) AS monthly_sales,
       (SELECT product_id FROM orders GROUP BY product_id ORDER BY SUM(total_amount) DESC LIMIT 3) AS top_products,
       (SELECT region FROM dim_location JOIN fact_sales ON dim_location.location_id = fact_sales.location_id GROUP BY region ORDER BY SUM(total_amount) DESC LIMIT 1) AS top_region
FROM orders GROUP BY MONTH(order_date);

-- Task 46
-- If materialized views supported:
-- CREATE MATERIALIZED VIEW high_value_summary AS ...

-- Task 47
SELECT month, AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM monthly_sales_summary;

-- Task 48
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING MAX(order_date) < DATE_SUB(CURDATE(), INTERVAL 90 DAY);

-- Task 49
SELECT category, COUNT(*) AS appearances
FROM monthly_sales_summary
GROUP BY category
ORDER BY appearances DESC
LIMIT 5;

-- Task 50
EXPLAIN SELECT category, SUM(total_amount)
FROM orders JOIN dim_product USING(product_id)
GROUP BY category;

