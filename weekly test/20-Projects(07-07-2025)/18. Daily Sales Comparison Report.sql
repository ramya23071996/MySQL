-- 1️⃣ Drop and Create Tables
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    SaleAmount DECIMAL(10, 2),
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 2️⃣ Insert Sample Data
INSERT INTO Products VALUES
(1, 'Laptop'),
(2, 'Smartphone'),
(3, 'Headphones'),
(4, 'Tablet');

-- Simulate sales for today (2025-07-07) and yesterday (2025-07-06)
INSERT INTO Sales VALUES
(101, 1, 50000, '2025-07-06'),
(102, 2, 30000, '2025-07-06'),
(103, 3, 10000, '2025-07-06'),
(104, 1, 60000, '2025-07-07'),
(105, 2, 25000, '2025-07-07'),
(106, 4, 15000, '2025-07-07');

-- 3️⃣ Daily Sales Comparison Report
SELECT 
    p.ProductID,
    p.ProductName,
    
    -- Yesterday's total sales
    COALESCE((
        SELECT SUM(SaleAmount)
        FROM Sales s1
        WHERE s1.ProductID = p.ProductID AND s1.SaleDate = DATE '2025-07-06'
    ), 0) AS YesterdaySales,

    -- Today's total sales
    COALESCE((
        SELECT SUM(SaleAmount)
        FROM Sales s2
        WHERE s2.ProductID = p.ProductID AND s2.SaleDate = DATE '2025-07-07'
    ), 0) AS TodaySales,

    -- Sales delta
    COALESCE((
        SELECT SUM(SaleAmount)
        FROM Sales s2
        WHERE s2.ProductID = p.ProductID AND s2.SaleDate = DATE '2025-07-07'
    ), 0) -
    COALESCE((
        SELECT SUM(SaleAmount)
        FROM Sales s1
        WHERE s1.ProductID = p.ProductID AND s1.SaleDate = DATE '2025-07-06'
    ), 0) AS SalesDelta,

    -- Trend indicator
    CASE
        WHEN (
            SELECT SUM(SaleAmount)
            FROM Sales s2
            WHERE s2.ProductID = p.ProductID AND s2.SaleDate = DATE '2025-07-07'
        ) >
        (
            SELECT SUM(SaleAmount)
            FROM Sales s1
            WHERE s1.ProductID = p.ProductID AND s1.SaleDate = DATE '2025-07-06'
        ) THEN '📈 Increase'

        WHEN (
            SELECT SUM(SaleAmount)
            FROM Sales s2
            WHERE s2.ProductID = p.ProductID AND s2.SaleDate = DATE '2025-07-07'
        ) <
        (
            SELECT SUM(SaleAmount)
            FROM Sales s1
            WHERE s1.ProductID = p.ProductID AND s1.SaleDate = DATE '2025-07-06'
        ) THEN '📉 Decrease'

        ELSE '⏸️ No Change'
    END AS Trend

FROM Products p
ORDER BY SalesDelta DESC;