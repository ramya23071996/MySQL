-- dim_product with embedded category (denormalized)
CREATE TABLE dim_product_star (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50)
);

-- fact_sales
CREATE TABLE fact_sales_star (
  sale_id INT PRIMARY KEY,
  product_id INT,
  quantity INT,
  total_amount DECIMAL(10,2),
  FOREIGN KEY (product_id) REFERENCES dim_product_star(product_id)
);

-- category_details table (normalized)
CREATE TABLE category_details (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(50)
);

-- dim_product with category_id FK
CREATE TABLE dim_product_snowflake (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES category_details(category_id)
);

-- fact_sales
CREATE TABLE fact_sales_snowflake (
  sale_id INT PRIMARY KEY,
  product_id INT,
  quantity INT,
  total_amount DECIMAL(10,2),
  FOREIGN KEY (product_id) REFERENCES dim_product_snowflake(product_id)
);

-- Category Details
INSERT INTO category_details VALUES
(1, 'Personal Care'), (2, 'Stationery'), (3, 'Food');

-- Star Products
INSERT INTO dim_product_star VALUES
(101, 'Shampoo', 'Personal Care'),
(102, 'Notebook', 'Stationery'),
(103, 'Biscuits', 'Food'),
(104, 'Toothpaste', 'Personal Care'),
(105, 'Pen', 'Stationery'),
(106, 'Cookies', 'Food'),
(107, 'Facewash', 'Personal Care'),
(108, 'Pencil', 'Stationery'),
(109, 'Soda', 'Food'),
(110, 'Lotion', 'Personal Care');

-- Snowflake Products
INSERT INTO dim_product_snowflake VALUES
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

-- Sales Data
INSERT INTO fact_sales_star VALUES
(201, 101, 2, 400.00), (202, 102, 1, 80.00), (203, 103, 5, 300.00),
(204, 104, 1, 180.00), (205, 105, 4, 160.00), (206, 106, 2, 150.00),
(207, 107, 1, 180.00), (208, 108, 3, 75.00), (209, 109, 2, 60.00), (210, 110, 1, 250.00);

INSERT INTO fact_sales_snowflake SELECT * FROM fact_sales_star;

SELECT dp.category, SUM(fs.total_amount) AS revenue
FROM fact_sales_star fs
JOIN dim_product_star dp ON fs.product_id = dp.product_id
GROUP BY dp.category;

SELECT cd.category_name, SUM(fs.total_amount) AS revenue
FROM fact_sales_snowflake fs
JOIN dim_product_snowflake dp ON fs.product_id = dp.product_id
JOIN category_details cd ON dp.category_id = cd.category_id
GROUP BY cd.category_name;

-- Star Schema
EXPLAIN SELECT dp.category, SUM(fs.total_amount)
FROM fact_sales_star fs
JOIN dim_product_star dp ON fs.product_id = dp.product_id
GROUP BY dp.category;

-- Snowflake Schema
EXPLAIN SELECT cd.category_name, SUM(fs.total_amount)
FROM fact_sales_snowflake fs
JOIN dim_product_snowflake dp ON fs.product_id = dp.product_id
JOIN category_details cd ON dp.category_id = cd.category_id
GROUP BY cd.category_name;

