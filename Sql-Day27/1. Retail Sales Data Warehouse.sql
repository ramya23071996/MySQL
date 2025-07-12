CREATE DATABASE retail_dw;
USE retail_dw;

-- Category Table (optional for snowflake extension)
CREATE TABLE category_details (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(50)
);

-- Product Dimension
CREATE TABLE dim_product (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES category_details(category_id)
);

-- Customer Dimension
CREATE TABLE dim_customer (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  email VARCHAR(100)
);

-- Time Dimension
CREATE TABLE dim_time (
  time_id INT PRIMARY KEY,
  date DATE,
  month INT,
  year INT
);

-- Location Dimension
CREATE TABLE dim_location (
  location_id INT PRIMARY KEY,
  region VARCHAR(50),
  city VARCHAR(50)
);

-- Fact Table
CREATE TABLE fact_sales (
  sale_id INT PRIMARY KEY,
  product_id INT,
  customer_id INT,
  time_id INT,
  location_id INT,
  quantity INT,
  total_amount DECIMAL(10,2),
  FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
  FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
  FOREIGN KEY (time_id) REFERENCES dim_time(time_id),
  FOREIGN KEY (location_id) REFERENCES dim_location(location_id)
);

-- Category Data
INSERT INTO category_details VALUES
(1, 'Personal Care'), (2, 'Stationery'), (3, 'Food');

-- Products
INSERT INTO dim_product VALUES
(101, 'Shampoo', 1),
(102, 'Notebook', 2),
(103, 'Biscuits', 3),
(104, 'Toothpaste', 1),
(105, 'Pen', 2),
(106, 'Cookies', 3),
(107, 'Facewash', 1),
(108, 'Pencil', 2),
(109, 'Soda', 3),
(110, 'Lotion', 1);

-- Customers
INSERT INTO dim_customer VALUES
(1, 'Rajesh', 'raj@example.com'),
(2, 'Anika', 'anika@example.com'),
(3, 'Sneha', 'sneha@example.com'),
(4, 'Praveen', 'praveen@example.com'),
(5, 'Meena', 'meena@example.com'),
(6, 'Latha', 'latha@example.com'),
(7, 'John', 'john@example.com'),
(8, 'Kavya', 'kavya@example.com'),
(9, 'Ravi', 'ravi@example.com'),
(10, 'Amit', 'amit@example.com');

-- Time
INSERT INTO dim_time VALUES
(1, '2025-07-01', 7, 2025),
(2, '2025-07-10', 7, 2025),
(3, '2025-08-05', 8, 2025),
(4, '2025-08-20', 8, 2025),
(5, '2025-09-15', 9, 2025),
(6, '2025-09-30', 9, 2025),
(7, '2025-10-05', 10, 2025),
(8, '2025-10-20', 10, 2025),
(9, '2025-11-01', 11, 2025),
(10, '2025-11-15', 11, 2025);

-- Locations
INSERT INTO dim_location VALUES
(1, 'South', 'Coimbatore'),
(2, 'North', 'Delhi'),
(3, 'West', 'Mumbai'),
(4, 'East', 'Kolkata'),
(5, 'Central', 'Bhopal'),
(6, 'South', 'Chennai'),
(7, 'East', 'Vizag'),
(8, 'North', 'Lucknow'),
(9, 'West', 'Ahmedabad'),
(10, 'Central', 'Nagpur');

-- Fact Sales
INSERT INTO fact_sales VALUES
(1001, 101, 1, 1, 1, 2, 400.00),
(1002, 102, 2, 2, 2, 1, 80.00),
(1003, 103, 3, 3, 3, 5, 300.00),
(1004, 104, 4, 4, 4, 1, 180.00),
(1005, 105, 5, 5, 5, 4, 160.00),
(1006, 106, 6, 6, 6, 2, 150.00),
(1007, 107, 7, 7, 7, 1, 180.00),
(1008, 108, 8, 8, 8, 3, 75.00),
(1009, 109, 9, 9, 9, 2, 60.00),
(1010, 110, 10, 10, 10, 1, 250.00);

-- Standardize product and customer names
UPDATE dim_product SET product_name = UPPER(product_name);
UPDATE dim_customer SET customer_name = UPPER(customer_name);

SELECT p.product_name, SUM(f.total_amount) AS total_sales
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 5;

SELECT t.year, t.month, SUM(f.total_amount) AS monthly_revenue
FROM fact_sales f
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY t.year, t.month
ORDER BY t.year, t.month;

SELECT c.customer_name,
       SUM(f.total_amount) AS total_spend,
       CASE
         WHEN SUM(f.total_amount) > 30000 THEN 'Gold'
         WHEN SUM(f.total_amount) BETWEEN 15000 AND 30000 THEN 'Silver'
         ELSE 'Bronze'
       END AS segment
FROM fact_sales f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_name;

