-- 1️⃣ Drop and Create Tables
DROP TABLE IF EXISTS StoreA_Inventory;
DROP TABLE IF EXISTS StoreB_Inventory;
DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

CREATE TABLE StoreA_Inventory (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

CREATE TABLE StoreB_Inventory (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

-- 2️⃣ Insert Sample Data
INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Smartphone', 'Electronics'),
(3, 'Desk Chair', 'Furniture');

-- Store A has correct and one inconsistent entry
INSERT INTO StoreA_Inventory VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Smartphone', 'Electronics'),
(3, 'Desk Chair', 'Furniture');

-- Store B has a mismatch and a missing product
INSERT INTO StoreB_Inventory VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Smartphone', 'Gadgets'), -- ❌ Wrong category
(4, 'Desk Chair', 'Furniture'); -- ❌ Wrong ProductID

-- 3️⃣ Compare Inventories Using UNION, INTERSECT, EXCEPT

-- Products common to both stores
SELECT * FROM StoreA_Inventory
INTERSECT
SELECT * FROM StoreB_Inventory;

-- Products in Store A but not in Store B
SELECT * FROM StoreA_Inventory
EXCEPT
SELECT * FROM StoreB_Inventory;

-- Products in Store B but not in Store A
SELECT * FROM StoreB_Inventory
EXCEPT
SELECT * FROM StoreA_Inventory;

-- 4️⃣ Detect Duplicates Using GROUP BY and DISTINCT
SELECT 
    ProductID, ProductName, Category, COUNT(*) AS Occurrences
FROM (
    SELECT * FROM StoreA_Inventory
    UNION ALL
    SELECT * FROM StoreB_Inventory
) AS CombinedInventory
GROUP BY ProductID, ProductName, Category
HAVING COUNT(*) > 1;

-- 5️⃣ Merge Store Data for Review
SELECT 
    a.ProductID AS A_ID,
    a.ProductName AS A_Name,
    a.Category AS A_Category,
    b.ProductID AS B_ID,
    b.ProductName AS B_Name,
    b.Category AS B_Category
FROM StoreA_Inventory a
FULL OUTER JOIN StoreB_Inventory b ON a.ProductID = b.ProductID;

-- 6️⃣ Transaction Block to Fix Inconsistencies in StoreB
BEGIN TRANSACTION;

BEGIN TRY
    -- Fix incorrect category for Smartphone in StoreB
    UPDATE StoreB_Inventory
    SET Category = 'Electronics'
    WHERE ProductID = 2 AND Category = 'Gadgets';

    -- Remove incorrect Desk Chair entry (wrong ProductID)
    DELETE FROM StoreB_Inventory
    WHERE ProductID = 4;

    -- Insert correct Desk Chair record
    INSERT INTO StoreB_Inventory (ProductID, ProductName, Category)
    SELECT ProductID, ProductName, Category
    FROM Products
    WHERE ProductID = 3;

    COMMIT;
    PRINT '✅ StoreB inventory corrected successfully.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT '❌ Error: ' + ERROR_MESSAGE();
END CATCH;