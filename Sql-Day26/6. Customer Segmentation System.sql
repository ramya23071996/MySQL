-- Step 1: Create Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount INT
);

-- Step 2: Insert Sample Data
INSERT INTO Orders VALUES
(1, 101, '2025-05-01', 12000),
(2, 101, '2025-06-10', 8000),
(3, 102, '2025-05-03', 7000),
(4, 102, '2025-07-15', 3000),
(5, 103, '2025-05-12', 9000),
(6, 104, '2025-06-01', 4000),
(7, 105, '2025-06-15', 10000),
(8, 105, '2025-07-01', 5000),
(9, 106, '2025-07-03', 2000),
(10, 107, '2025-07-10', 6000),
(11, 108, '2025-07-12', 8500),
(12, 109, '2025-07-18', 3000),
(13, 110, '2025-07-20', 9500);

-- Step 3: CTE to Aggregate Total Spend per Customer
WITH CustomerSpend AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_spend
    FROM Orders
    GROUP BY customer_id
),

-- Step 4: Assign Quartiles and Segments with NTILE
SegmentedCustomers AS (
    SELECT 
        customer_id,
        total_spend,
        NTILE(4) OVER(ORDER BY total_spend DESC) AS quartile
    FROM CustomerSpend
)

-- Step 5: Final Report with Segment Labels
SELECT 
    customer_id,
    total_spend,
    quartile,
    CASE quartile
        WHEN 1 THEN 'Platinum'
        WHEN 2 THEN 'Gold'
        WHEN 3 THEN 'Silver'
        ELSE 'Bronze'
    END AS segment
FROM SegmentedCustomers
ORDER BY total_spend DESC;