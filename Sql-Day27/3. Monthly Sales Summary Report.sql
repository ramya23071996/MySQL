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
(1002, 2, 102, '2025-04-15', 1, 80.00),
(1003, 3, 103, '2025-05-05', 5, 300.00),
(1004, 4, 104, '2025-05-20', 1, 180.00),
(1005, 5, 105, '2025-06-10', 4, 300.00),
(1006, 6, 106, '2025-06-25', 2, 150.00),
(1007, 7, 107, '2025-07-05', 1, 180.00),
(1008, 8, 108, '2025-07-20', 3, 75.00),
(1009, 9, 109, '2025-08-01', 2, 60.00),
(1010, 10, 110, '2025-08-15', 1, 250.00);

SELECT 
  YEAR(order_date) AS sale_year,
  MONTH(order_date) AS sale_month,
  COUNT(*) AS total_orders,
  SUM(total_amount) AS total_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY sale_year, sale_month;

SELECT 
  YEAR(order_date) AS sale_year,
  MONTH(order_date) AS sale_month,
  COUNT(*) AS total_orders,
  SUM(total_amount) AS total_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
HAVING SUM(total_amount) > 50000
ORDER BY sale_year, sale_month;

