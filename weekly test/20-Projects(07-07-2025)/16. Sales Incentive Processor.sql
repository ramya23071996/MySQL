-- 1️⃣ Drop existing tables if needed (for reruns)
DROP TABLE IF EXISTS Bonuses;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Salespeople;

-- 2️⃣ Create Tables
CREATE TABLE Salespeople (
    SalespersonID INT PRIMARY KEY,
    Name VARCHAR(100),
    Region VARCHAR(50)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    SalespersonID INT,
    SaleAmount DECIMAL(10, 2),
    SaleDate DATE,
    FOREIGN KEY (SalespersonID) REFERENCES Salespeople(SalespersonID)
);

CREATE TABLE Bonuses (
    BonusID INT PRIMARY KEY,
    SalespersonID INT,
    BonusAmount DECIMAL(10, 2),
    BonusTier VARCHAR(20),
    FOREIGN KEY (SalespersonID) REFERENCES Salespeople(SalespersonID)
);

-- 3️⃣ Insert Sample Data
INSERT INTO Salespeople VALUES
(1, 'Ramya', 'South'),
(2, 'Arjun', 'North'),
(3, 'Priya', 'East'),
(4, 'Karan', 'West');

INSERT INTO Sales VALUES
(101, 1, 25000, '2025-07-01'),
(102, 1, 30000, '2025-07-02'),
(103, 2, 15000, '2025-07-01'),
(104, 2, 10000, '2025-07-03'),
(105, 3, 60000, '2025-07-01'),
(106, 4, 120000, '2025-07-02');

-- 4️⃣ Transaction Block to Calculate and Update Bonuses
BEGIN TRANSACTION;

BEGIN TRY
    -- Check for incomplete sales data
    IF EXISTS (
        SELECT 1 FROM Sales WHERE SalespersonID IS NULL OR SaleAmount IS NULL
    )
    BEGIN
        THROW 50000, 'Incomplete sales data found. Rolling back.', 1;
    END

    -- Clear previous bonuses
    DELETE FROM Bonuses;

    -- Insert new bonuses based on total sales
    WITH SalesSummary AS (
        SELECT 
            SalespersonID,
            SUM(SaleAmount) AS TotalSales
        FROM Sales
        GROUP BY SalespersonID
    )
    INSERT INTO Bonuses (BonusID, SalespersonID, BonusAmount, BonusTier)
    SELECT 
        ROW_NUMBER() OVER (ORDER BY SalespersonID) AS BonusID,
        SalespersonID,
        CASE 
            WHEN TotalSales >= 100000 THEN 10000
            WHEN TotalSales >= 50000 THEN 5000
            WHEN TotalSales >= 20000 THEN 2000
            ELSE 500
        END AS BonusAmount,
        CASE 
            WHEN TotalSales >= 100000 THEN 'Platinum'
            WHEN TotalSales >= 50000 THEN 'Gold'
            WHEN TotalSales >= 20000 THEN 'Silver'
            ELSE 'Bronze'
        END AS BonusTier
    FROM SalesSummary;

    COMMIT;
    PRINT '✅ Bonuses updated successfully.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT '❌ Error: ' + ERROR_MESSAGE();
END CATCH;

-- 5️⃣ Bonus Summary Report
SELECT 
    BonusTier,
    COUNT(*) AS NumSalespeople,
    SUM(BonusAmount) AS TotalBonuses,
    AVG(BonusAmount) AS AvgBonus
FROM Bonuses
GROUP BY BonusTier
ORDER BY TotalBonuses DESC;