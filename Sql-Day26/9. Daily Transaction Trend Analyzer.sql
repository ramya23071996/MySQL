-- Step 1: Create Transactions Table
CREATE TABLE Transactions (
    txn_id INT PRIMARY KEY,
    txn_date DATE,
    amount INT
);

-- Step 2: Insert Sample Data (last 40 days for context)
INSERT INTO Transactions VALUES
(1, '2025-06-10', 500),
(2, '2025-06-11', 650),
(3, '2025-06-12', 400),
(4, '2025-06-13', 800),
(5, '2025-06-14', 750),
(6, '2025-06-15', 900),
(7, '2025-06-16', 880),
(8, '2025-06-17', 300),
(9, '2025-06-18', 450),
(10, '2025-06-19', 520),
-- Add more transactions up to '2025-07-20'

-- Step 3: CTE to filter recent 30 days
WITH RecentTransactions AS (
    SELECT * FROM Transactions
    WHERE txn_date >= DATEADD(DAY, -30, '2025-07-20')  -- assumes today = July 20, 2025
),

-- Step 4: Add rolling 7-day average using window function
TrendAnalyzer AS (
    SELECT 
        txn_date,
        amount,
        AVG(amount) OVER(
            ORDER BY txn_date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg
    FROM RecentTransactions
)

-- Step 5: Final Report - Flag high-spend days
SELECT 
    txn_date,
    amount,
    ROUND(rolling_avg, 2) AS rolling_7_day_avg,
    CASE 
        WHEN amount > rolling_avg THEN '🔺 Above Avg'
        WHEN amount < rolling_avg THEN '🔻 Below Avg'
        ELSE '➡️ On Avg'
    END AS trend_flag
FROM TrendAnalyzer
ORDER BY txn_date;