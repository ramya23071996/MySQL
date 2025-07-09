-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS SalesDashboard;
USE SalesDashboard;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Customers table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50)
);

-- Products table
CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- SalesPersons table
CREATE TABLE IF NOT EXISTS SalesPersons (
    salesperson_id INT PRIMARY KEY,
    salesperson_name VARCHAR(100),
    territory VARCHAR(50)
);

-- Sales table
CREATE TABLE IF NOT EXISTS Sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    product_id INT,
    customer_id INT,
    salesperson_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (salesperson_id) REFERENCES SalesPersons(salesperson_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Customers
INSERT INTO Customers VALUES
(1, 'Alice', 'North'), (2, 'Bob', 'South'), (3, 'Charlie', 'East'), (4, 'Diana', 'West');

-- Products
INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Tablet', 'Electronics', 30000),
(103, 'Chair', 'Furniture', 5000),
(104, 'Desk', 'Furniture', 8000);

-- SalesPersons
INSERT INTO SalesPersons VALUES
(1, 'Raj', 'North'), (2, 'Meena', 'South'), (3, 'Karan', 'East'), (4, 'Anita', 'West');

-- Sales
INSERT INTO Sales VALUES
(1, '2024-06-01', 101, 1, 1, 2),
(2, '2024-06-15', 102, 2, 2, 1),
(3, '2024-07-01', 103, 3, 3, 5),
(4, '2024-07-10', 104, 4, 4, 3),
(5, '2024-07-15', 101, 1, 1, 1),
(6, '2024-07-20', 102, 2, 2, 2),
(7, '2024-07-25', 103, 3, 3, 4),
(8, '2024-07-30', 104, 4, 4, 2);

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_sale_date ON Sales(sale_date);
CREATE INDEX idx_product_id ON Sales(product_id);
CREATE INDEX idx_customer_id ON Sales(customer_id);

-- ============================================
-- 4. MONTHLY SALES REPORT WITH GROUP BY + HAVING
-- ============================================

-- Total quantity sold per month
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    SUM(quantity) AS total_quantity
FROM Sales
GROUP BY sale_month
HAVING total_quantity > 5;

-- ============================================
-- 5. EXPLAIN TO DETECT FULL TABLE SCANS
-- ============================================

EXPLAIN SELECT * FROM Sales WHERE sale_date BETWEEN '2024-07-01' AND '2024-07-31';

-- ============================================
-- 6. DENORMALIZED SUMMARY TABLE FOR REPORTING
-- ============================================

CREATE TABLE IF NOT EXISTS SalesSummary (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    product_name VARCHAR(100),
    customer_name VARCHAR(100),
    salesperson_name VARCHAR(100),
    quantity INT
);

-- Insert denormalized data
INSERT INTO SalesSummary
SELECT 
    s.sale_id, s.sale_date, 
    p.product_name, 
    c.customer_name, 
    sp.salesperson_name,
    s.quantity
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
JOIN Customers c ON s.customer_id = c.customer_id
JOIN SalesPersons sp ON s.salesperson_id = sp.salesperson_id;

-- Fast report query
SELECT * FROM SalesSummary WHERE sale_date >= '2024-07-01';
