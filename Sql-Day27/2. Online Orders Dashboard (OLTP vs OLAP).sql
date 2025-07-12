-- Customers
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  email VARCHAR(100)
);

-- Products
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50),
  price DECIMAL(10,2)
);

-- Orders
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  order_date DATE,
  quantity INT,
  total_amount DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Customers
INSERT INTO customers VALUES
(1, 'Rajesh', 'raj@example.com'),
(2, 'Anika', 'anika@example.com'),
(3, 'Sneha', 'sneha@example.com');

-- Products
INSERT INTO products VALUES
(101, 'Shampoo', 'Personal Care', 200.00),
(102, 'Notebook', 'Stationery', 80.00),
(103, 'Biscuits', 'Food', 60.00);

-- Orders
INSERT INTO orders VALUES
(1001, 1, 101, '2025-07-01', 2, 400.00),
(1002, 2, 102, '2025-07-02', 1, 80.00),
(1003, 3, 103, '2025-07-05', 3, 180.00);

-- Place a new order
INSERT INTO orders VALUES (1004, 1, 103, '2025-07-06', 2, 120.00);

-- Check customer order history
SELECT * FROM orders WHERE customer_id = 1 ORDER BY order_date DESC;

-- Update quantity in an order
UPDATE orders SET quantity = 4, total_amount = 240.00 WHERE order_id = 1003;

-- Delete an erroneous order
DELETE FROM orders WHERE order_id = 1002;

CREATE TABLE monthly_order_summary (
  month INT,
  year INT,
  product_id INT,
  total_orders INT,
  total_quantity INT,
  total_revenue DECIMAL(12,2)
);

INSERT INTO monthly_order_summary
SELECT
  MONTH(order_date) AS month,
  YEAR(order_date) AS year,
  product_id,
  COUNT(order_id) AS total_orders,
  SUM(quantity) AS total_quantity,
  SUM(total_amount) AS total_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date), product_id;

-- Monthly product performance
SELECT month, year, product_id, total_orders, total_revenue
FROM monthly_order_summary
ORDER BY year, month;

-- Top 3 best-selling products by revenue
SELECT product_id, SUM(total_revenue) AS total_sales
FROM monthly_order_summary
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 3;

