-- Step 1: Create the Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount INT
);

-- Step 2: Insert sample data
INSERT INTO Orders VALUES
(1, 101, '2025-05-01', 5000),
(2, 101, '2025-06-05', 3000),
(3, 101, '2025-07-10', 4500),
(4, 102, '2025-05-15', 7000),
(5, 102, '2025-08-01', 6500),
(6, 103, '2025-07-01', 4000),
(7, 103, '2025-07-25', 3800),
(8, 104, '2025-06-10', 9000),
(9, 104, '2025-07-20', 8500),
(10, 105, '2025-04-30', 2000),
(11, 105, '2025-07-10', 2200);

-- Step 3: Build the report using window functions
WITH OrderGaps AS (
    SELECT 
        customer_id,
        order_id,
        order_date,
        amount,

        -- Previous and next order dates
        LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev_order_date,
        LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS next_order_date,

        -- Gap calculations
        DATEDIFF(DAY, LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date), order_date) AS gap_from_prev,
        DATEDIFF(DAY, order_date, LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)) AS gap_to_next
    FROM Orders
)

-- Step 4: Filter customers with gaps > 30 days
SELECT * FROM OrderGaps
WHERE gap_from_prev > 30 OR gap_to_next > 30
ORDER BY customer_id, order_date;