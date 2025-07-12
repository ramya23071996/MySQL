CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  order_date DATE,
  quantity INT,
  total_amount DECIMAL(12,2)
);

INSERT INTO orders VALUES
(1001, 1, 101, '2025-04-01', 2, 400.00),
(1002, 2, 102, '2025-04-07', 1, 80.00),
(1003, 3, 103, '2025-04-15', 5, 300.00),
(1004, 4, 104, '2025-05-02', 1, 180.00),
(1005, 5, 105, '2025-05-10', 4, 300.00),
(1006, 6, 106, '2025-06-12', 2, 150.00),
(1007, 7, 107, '2025-07-05', 1, 180.00),
(1008, 8, 108, '2025-07-20', 3, 75.00),
(1009, 9, 109, '2025-08-01', 2, 60.00),
(1010, 10, 110, '2025-08-15', 1, 250.00);

SELECT order_date, SUM(total_amount) AS daily_revenue
FROM orders
GROUP BY order_date
ORDER BY order_date;

SELECT
  YEAR(order_date) AS year,
  WEEK(order_date) AS week,
  SUM(total_amount) AS weekly_revenue
FROM orders
GROUP BY year, week
ORDER BY year, week;

SELECT
  EXTRACT(YEAR FROM order_date) AS year,
  EXTRACT(MONTH FROM order_date) AS month,
  SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY year, month
ORDER BY year, month;

SELECT
  EXTRACT(YEAR FROM order_date) AS year,
  CEIL(EXTRACT(MONTH FROM order_date)/3) AS quarter,
  SUM(total_amount) AS quarterly_revenue
FROM orders
GROUP BY year, quarter
ORDER BY year, quarter;

SELECT
  EXTRACT(YEAR FROM order_date) AS year,
  SUM(total_amount) AS annual_revenue
FROM orders
GROUP BY year
ORDER BY year;

-- Best month
SELECT
  EXTRACT(MONTH FROM order_date) AS month,
  SUM(total_amount) AS revenue
FROM orders
GROUP BY month
ORDER BY revenue DESC
LIMIT 1;

-- Worst quarter
SELECT
  CEIL(EXTRACT(MONTH FROM order_date)/3) AS quarter,
  SUM(total_amount) AS revenue
FROM orders
GROUP BY quarter
ORDER BY revenue ASC
LIMIT 1;

