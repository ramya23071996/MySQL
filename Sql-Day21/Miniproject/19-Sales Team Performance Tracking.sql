-- Drop tables if they already exist
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS salespeople;
DROP TABLE IF EXISTS regions;

-- 1. Create Tables

CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(100)
);

CREATE TABLE salespeople (
    salesperson_id INT PRIMARY KEY,
    salesperson_name VARCHAR(100),
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    salesperson_id INT,
    sale_amount DECIMAL(10,2),
    sale_date DATE,
    FOREIGN KEY (salesperson_id) REFERENCES salespeople(salesperson_id)
);

-- 2. Insert Sample Data

-- Regions
INSERT INTO regions (region_id, region_name) VALUES
(1, 'North'),
(2, 'South'),
(3, 'East'),
(4, 'West');

-- Salespeople
INSERT INTO salespeople (salesperson_id, salesperson_name, region_id) VALUES
(101, 'Aarav', 1),
(102, 'Bhavya', 2),
(103, 'Chirag', 3),
(104, 'Diya', 4),
(105, 'Esha', 1);

-- Sales
INSERT INTO sales (sale_id, salesperson_id, sale_amount, sale_date) VALUES
(1001, 101, 5000.00, '2025-06-01'),
(1002, 101, 7000.00, '2025-07-01'),
(1003, 102, 3000.00, '2025-07-02'),
(1004, 103, 4000.00, '2025-06-15'),
(1005, 103, 6000.00, '2025-07-10'),
(1006, 105, 8000.00, '2025-07-12');

-- 3. Total Sales per Region
SELECT 
    r.region_name,
    SUM(s.sale_amount) AS total_sales
FROM sales s
JOIN salespeople sp ON s.salesperson_id = sp.salesperson_id
JOIN regions r ON sp.region_id = r.region_id
GROUP BY r.region_id, r.region_name;

-- 4. Total Sales per Salesperson
SELECT 
    sp.salesperson_name,
    SUM(s.sale_amount) AS total_sales
FROM salespeople sp
LEFT JOIN sales s ON sp.salesperson_id = s.salesperson_id
GROUP BY sp.salesperson_id, sp.salesperson_name;

-- 5. Salespeople with No Sales in Their Region
SELECT 
    sp.salesperson_name,
    r.region_name
FROM salespeople sp
JOIN regions r ON sp.region_id = r.region_id
LEFT JOIN sales s ON sp.salesperson_id = s.salesperson_id
WHERE s.sale_id IS NULL;

-- 6. Regions with the Highest Sales Growth (June → July 2025)
SELECT 
    r.region_name,
    SUM(CASE WHEN MONTH(s.sale_date) = 6 THEN s.sale_amount ELSE 0 END) AS june_sales,
    SUM(CASE WHEN MONTH(s.sale_date) = 7 THEN s.sale_amount ELSE 0 END) AS july_sales,
    (SUM(CASE WHEN MONTH(s.sale_date) = 7 THEN s.sale_amount ELSE 0 END) -
     SUM(CASE WHEN MONTH(s.sale_date) = 6 THEN s.sale_amount ELSE 0 END)) AS growth
FROM sales s
JOIN salespeople sp ON s.salesperson_id = sp.salesperson_id
JOIN regions r ON sp.region_id = r.region_id
GROUP BY r.region_id, r.region_name
ORDER BY growth DESC;