-- Step 1: Create UserFunnelActivity Table
CREATE TABLE UserFunnelActivity (
    activity_id INT PRIMARY KEY,
    user_id INT,
    user_name VARCHAR(50),
    activity_stage VARCHAR(20),  -- stages: view, cart, checkout, payment
    activity_time DATETIME
);

-- Step 2: Insert Sample Funnel Data
INSERT INTO UserFunnelActivity VALUES
(1, 101, 'Ananya', 'view', '2025-07-10 10:15'),
(2, 101, 'Ananya', 'cart', '2025-07-10 10:20'),
(3, 101, 'Ananya', 'checkout', '2025-07-10 10:25'),
(4, 101, 'Ananya', 'payment', '2025-07-10 10:30'),
(5, 102, 'Bharath', 'view', '2025-07-10 11:00'),
(6, 102, 'Bharath', 'cart', '2025-07-10 11:05'),
(7, 103, 'Charu', 'view', '2025-07-10 11:30'),
(8, 103, 'Charu', 'cart', '2025-07-10 11:35'),
(9, 103, 'Charu', 'checkout', '2025-07-10 11:40'),
(10, 104, 'Dev', 'view', '2025-07-10 11:50'),
(11, 104, 'Dev', 'cart', '2025-07-10 11:55'),
(12, 104, 'Dev', 'checkout', '2025-07-10 12:00'),
(13, 104, 'Dev', 'payment', '2025-07-10 12:05');

-- Step 3: Create Funnel Order Reference Table (optional, to manage stage sequence)
-- This part can help if you're using JOIN logic based on order

-- Step 4: Window Function to Analyze User Funnel
WITH FunnelAnalysis AS (
    SELECT 
        user_id,
        user_name,
        activity_stage,
        activity_time,

        -- Identify next stage (where they are headed)
        LEAD(activity_stage) OVER(PARTITION BY user_id ORDER BY activity_time) AS next_stage,

        -- Rank how deep the user reached in the funnel
        RANK() OVER(PARTITION BY user_id ORDER BY activity_stage DESC) AS stage_rank
    FROM UserFunnelActivity
),

-- Step 5: CTE to Determine Funnel Depth
UserFunnelDepth AS (
    SELECT 
        user_id,
        user_name,
        COUNT(DISTINCT activity_stage) AS funnel_depth
    FROM UserFunnelActivity
    GROUP BY user_id, user_name
)

-- Step 6: Final Funnel Drop-Off Report
SELECT 
    fa.user_id,
    fa.user_name,
    fa.activity_stage,
    fa.activity_time,
    fa.next_stage,
    ufd.funnel_depth,
    
    -- Conversion Status
    CASE 
        WHEN fa.activity_stage = 'payment' THEN '✔ Completed Purchase'
        WHEN fa.next_stage IS NULL THEN '❌ Dropped Here'
        ELSE '⏩ In Progress'
    END AS funnel_status
FROM FunnelAnalysis fa
JOIN UserFunnelDepth ufd ON fa.user_id = ufd.user_id
ORDER BY fa.user_id, fa.activity_time;

-- Step 7: Create View for Dashboard Integration
CREATE VIEW FunnelProgressView AS
SELECT 
    fa.user_id,
    fa.user_name,
    fa.activity_stage,
    fa.activity_time,
    fa.next_stage,
    ufd.funnel_depth,
    CASE 
        WHEN fa.activity_stage = 'payment' THEN '✔ Completed Purchase'
        WHEN fa.next_stage IS NULL THEN '❌ Dropped Here'
        ELSE '⏩ In Progress'
    END AS funnel_status
FROM FunnelAnalysis fa
JOIN UserFunnelDepth ufd ON fa.user_id = ufd.user_id;