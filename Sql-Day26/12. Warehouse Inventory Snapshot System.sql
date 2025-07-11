-- Step 1: Create InventoryTransactions Table
CREATE TABLE InventoryTransactions (
    txn_id INT PRIMARY KEY,
    item_id INT,
    item_name VARCHAR(100),
    txn_date DATE,
    stock_level INT
);

-- Step 2: Insert Sample Inventory Data
INSERT INTO InventoryTransactions VALUES
(1, 101, 'Laptop Pro 15"', '2025-07-01', 120),
(2, 101, 'Laptop Pro 15"', '2025-07-02', 115),
(3, 101, 'Laptop Pro 15"', '2025-07-03', 98),
(4, 102, 'Wireless Mouse', '2025-07-01', 220),
(5, 102, 'Wireless Mouse', '2025-07-02', 210),
(6, 102, 'Wireless Mouse', '2025-07-03', 190),
(7, 103, 'USB-C Hub', '2025-07-01', 80),
(8, 103, 'USB-C Hub', '2025-07-02', 78),
(9, 103, 'USB-C Hub', '2025-07-03', 79),
(10, 104, 'Keyboard MK-II', '2025-07-01', 140),
(11, 104, 'Keyboard MK-II', '2025-07-02', 110),
(12, 104, 'Keyboard MK-II', '2025-07-03', 100);

-- Step 3: CTE to Calculate Daily Stock Change and Trend Flags
WITH StockChanges AS (
    SELECT 
        item_id,
        item_name,
        txn_date,
        stock_level,
        LAG(stock_level) OVER(PARTITION BY item_id ORDER BY txn_date) AS previous_stock,
        AVG(stock_level) OVER(PARTITION BY item_id ORDER BY txn_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS avg_7day_stock
    FROM InventoryTransactions
),

-- Step 4: Identify Sharp Drops and High-Movement Items
AnnotatedChanges AS (
    SELECT 
        item_id,
        item_name,
        txn_date,
        stock_level,
        previous_stock,
        avg_7day_stock,
        stock_level - previous_stock AS change,
        CASE 
            WHEN previous_stock IS NOT NULL AND stock_level - previous_stock <= -15 THEN '⚠️ Sharp Drop'
            WHEN stock_level - previous_stock < 0 THEN '📉 Dropping'
            WHEN stock_level - previous_stock > 0 THEN '📈 Replenished'
            ELSE '→ Stable'
        END AS status_flag
    FROM StockChanges
),

-- Step 5: Top 10 High-Movement Items by Absolute Change
TopMovers AS (
    SELECT 
        item_id,
        item_name,
        txn_date,
        stock_level,
        previous_stock,
        change,
        status_flag,
        avg_7day_stock,
        RANK() OVER(PARTITION BY txn_date ORDER BY ABS(change) DESC) AS movement_rank
    FROM AnnotatedChanges
)

-- Step 6: Final Snapshot Report
SELECT 
    item_id,
    item_name,
    txn_date,
    stock_level,
    previous_stock,
    change,
    ROUND(avg_7day_stock, 2) AS avg_7day_stock,
    status_flag
FROM TopMovers
WHERE movement_rank <= 10
ORDER BY txn_date, movement_rank;