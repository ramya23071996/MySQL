-- Step 1: Create CustomerBalances Table
CREATE TABLE CustomerBalances (
    txn_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    txn_date DATE,
    account_balance DECIMAL(12,2)
);

-- Step 2: Insert Sample Data (Simulating Daily Balances)
INSERT INTO CustomerBalances VALUES
(1, 101, 'Ananya', '2025-07-01', 85000.00),
(2, 101, 'Ananya', '2025-07-02', 87000.00),
(3, 101, 'Ananya', '2025-07-03', 82000.00),
(4, 101, 'Ananya', '2025-07-04', 81000.00),
(5, 102, 'Bharath', '2025-07-01', 54000.00),
(6, 102, 'Bharath', '2025-07-02', 52500.00),
(7, 102, 'Bharath', '2025-07-03', 52000.00),
(8, 102, 'Bharath', '2025-07-04', 45000.00),
(9, 103, 'Charu', '2025-07-01', 42000.00),
(10, 103, 'Charu', '2025-07-02', 43000.00),
(11, 103, 'Charu', '2025-07-03', 42800.00),
(12, 103, 'Charu', '2025-07-04', 41000.00);

-- Step 3: CTE to Calculate Previous Day's Balance and Percent Change
WITH BalanceAudit AS (
    SELECT 
        customer_id,
        customer_name,
        txn_date,
        account_balance,
        LAG(account_balance) OVER(PARTITION BY customer_id ORDER BY txn_date) AS prev_balance,
        ROUND(
            (account_balance - LAG(account_balance) OVER(PARTITION BY customer_id ORDER BY txn_date)) 
            / NULLIF(LAG(account_balance) OVER(PARTITION BY customer_id ORDER BY txn_date), 0) * 100, 2
        ) AS pct_change
    FROM CustomerBalances
),

-- Step 4: CTE to Identify Abnormal Dips (e.g., > 10% decrease)
AbnormalDips AS (
    SELECT * FROM BalanceAudit
    WHERE pct_change IS NOT NULL AND pct_change <= -10
)

-- Step 5: Audit Summary for Compliance Team
SELECT 
    customer_id,
    customer_name,
    txn_date,
    account_balance,
    prev_balance,
    pct_change,
    CASE 
        WHEN pct_change <= -25 THEN '🔴 Critical Drop'
        WHEN pct_change <= -10 THEN '🟠 Abnormal Dip'
        ELSE '🟢 Stable'
    END AS risk_flag
FROM AbnormalDips
ORDER BY customer_id, txn_date;