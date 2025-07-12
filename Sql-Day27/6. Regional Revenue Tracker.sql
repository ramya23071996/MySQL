-- Dim_Location
CREATE TABLE dim_location (
  location_id INT PRIMARY KEY,
  region VARCHAR(50),
  city VARCHAR(50)
);

-- Dim_Customer (linked to location)
CREATE TABLE dim_customer (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  email VARCHAR(100),
  location_id INT,
  FOREIGN KEY (location_id) REFERENCES dim_location(location_id)
);

-- Dim_Product
CREATE TABLE dim_product (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50)
);

-- Fact_Sales
CREATE TABLE fact_sales (
  sale_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  quantity INT,
  total_amount DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
  FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- Locations
INSERT INTO dim_location VALUES
(1, 'South', 'Coimbatore'),
(2, 'North', 'Delhi'),
(3, 'West', 'Mumbai'),
(4, 'East', 'Kolkata'),
(5, 'Central', 'Bhopal');

-- Customers
INSERT INTO dim_customer VALUES
(101, 'Rajesh', 'raj@example.com', 1),
(102, 'Anika', 'anika@example.com', 2),
(103, 'Sneha', 'sneha@example.com', 3),
(104, 'Praveen', 'praveen@example.com', 4),
(105, 'Meena', 'meena@example.com', 5);

-- Products
INSERT INTO dim_product VALUES
(201, 'Shampoo', 'Personal Care'),
(202, 'Notebook', 'Stationery'),
(203, 'Biscuits', 'Food'),
(204, 'Toothpaste', 'Personal Care'),
(205, 'Pen', 'Stationery');

-- Sales
INSERT INTO fact_sales VALUES
(3001, 101, 201, 2, 400.00),
(3002, 102, 202, 1, 80.00),
(3003, 103, 203, 3, 180.00),
(3004, 104, 204, 1, 120.00),
(3005, 105, 205, 4, 160.00);

SELECT 
  l.region,
  p.category,
  SUM(fs.total_amount) AS total_revenue
FROM fact_sales fs
JOIN dim_customer dc ON fs.customer_id = dc.customer_id
JOIN dim_location l ON dc.location_id = l.location_id
JOIN dim_product p ON fs.product_id = p.product_id
GROUP BY l.region, p.category
HAVING SUM(fs.total_amount) > 100;  -- Filter low revenue regions

