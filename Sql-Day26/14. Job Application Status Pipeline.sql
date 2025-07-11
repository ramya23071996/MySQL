-- Step 1: Create Applications Table
CREATE TABLE Applications (
    app_id INT PRIMARY KEY,
    candidate_id INT,
    candidate_name VARCHAR(100),
    stage VARCHAR(20),           -- Stages: Applied, HR, Tech, Offered
    stage_time DATETIME
);

-- Step 2: Insert Sample Data
INSERT INTO Applications VALUES
(1, 201, 'Ananya', 'Applied', '2025-07-01 09:00'),
(2, 201, 'Ananya', 'HR', '2025-07-03 14:00'),
(3, 201, 'Ananya', 'Tech', '2025-07-05 10:30'),
(4, 201, 'Ananya', 'Offered', '2025-07-08 16:00'),
(5, 202, 'Bharath', 'Applied', '2025-07-02 10:00'),
(6, 202, 'Bharath', 'HR', '2025-07-04 11:15'),
(7, 203, 'Charu', 'Applied', '2025-07-03 08:30'),
(8, 203, 'Charu', 'HR', '2025-07-05 12:45'),
(9, 203, 'Charu', 'Tech', '2025-07-07 09:20'),
(10, 204, 'Dev', 'Applied', '2025-07-04 09:15');

-- Step 3: Analyze Stage Transitions
WITH StageTransitions AS (
    SELECT 
        candidate_id,
        candidate_name,
        stage,
        stage_time,
        LAG(stage) OVER(PARTITION BY candidate_id ORDER BY stage_time) AS prev_stage,
        LAG(stage_time) OVER(PARTITION BY candidate_id ORDER BY stage_time) AS prev_stage_time,
        LEAD(stage) OVER(PARTITION BY candidate_id ORDER BY stage_time) AS next_stage,
        LEAD(stage_time) OVER(PARTITION BY candidate_id ORDER BY stage_time) AS next_stage_time
    FROM Applications
)

-- Step 4: Final Pipeline Report
SELECT 
    candidate_id,
    candidate_name,
    stage,
    stage_time,
    prev_stage,
    prev_stage_time,
    next_stage,
    next_stage_time,
    
    -- Time taken from previous stage
    DATEDIFF(MINUTE, prev_stage_time, stage_time) AS mins_since_prev_stage,

    -- Time expected until next stage
    DATEDIFF(MINUTE, stage_time, next_stage_time) AS mins_until_next_stage,

    -- Status flag
    CASE 
        WHEN next_stage IS NULL THEN '✔ Final Stage'
        WHEN prev_stage IS NULL THEN '🟢 New Entry'
        ELSE '🔄 In Progress'
    END AS status_flag
FROM StageTransitions
ORDER BY candidate_id, stage_time;