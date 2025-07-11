-- Step 1: Create CallLogs Table
CREATE TABLE CallLogs (
    call_id INT PRIMARY KEY,
    agent_id INT,
    agent_name VARCHAR(100),
    location VARCHAR(50),
    shift VARCHAR(20),
    call_time DATETIME
);

-- Step 2: Insert Sample Data
INSERT INTO CallLogs VALUES
(1, 201, 'Ananya', 'Mumbai', 'Morning', '2025-07-01 09:00'),
(2, 201, 'Ananya', 'Mumbai', 'Morning', '2025-07-01 09:25'),
(3, 201, 'Ananya', 'Mumbai', 'Morning', '2025-07-01 09:50'),
(4, 202, 'Bharath', 'Mumbai', 'Morning', '2025-07-01 09:05'),
(5, 202, 'Bharath', 'Mumbai', 'Morning', '2025-07-01 10:10'),
(6, 203, 'Charu', 'Delhi', 'Evening', '2025-07-01 17:20'),
(7, 203, 'Charu', 'Delhi', 'Evening', '2025-07-01 17:45'),
(8, 203, 'Charu', 'Delhi', 'Evening', '2025-07-01 18:00'),
(9, 204, 'Dev', 'Delhi', 'Evening', '2025-07-01 17:00'),
(10, 204, 'Dev', 'Delhi', 'Evening', '2025-07-01 18:30'),
(11, 201, 'Ananya', 'Mumbai', 'Morning', '2025-07-01 10:30');

-- Step 3: CTE to Count Calls per Agent
WITH AgentCallStats AS (
    SELECT 
        agent_id,
        agent_name,
        location,
        shift,
        COUNT(*) AS calls_handled
    FROM CallLogs
    GROUP BY agent_id, agent_name, location, shift
),

-- Step 4: Rank Agents by Call Volume within Shift or Location
RankedAgents AS (
    SELECT 
        *,
        RANK() OVER(PARTITION BY shift ORDER BY calls_handled DESC) AS rank_in_shift,
        RANK() OVER(PARTITION BY location ORDER BY calls_handled DESC) AS rank_in_location
    FROM AgentCallStats
),

-- Step 5: CTE to Detect Gaps Between Calls using LAG()
CallGaps AS (
    SELECT 
        agent_id,
        agent_name,
        call_time,
        LAG(call_time) OVER(PARTITION BY agent_id ORDER BY call_time) AS previous_call_time,
        DATEDIFF(MINUTE, LAG(call_time) OVER(PARTITION BY agent_id ORDER BY call_time), call_time) AS gap_minutes
    FROM CallLogs
),

-- Step 6: Identify Agents with Consistently High Volume (e.g., >= 3 calls)
ConsistentPerformers AS (
    SELECT agent_id, agent_name, calls_handled
    FROM AgentCallStats
    WHERE calls_handled >= 3
)

-- Step 7: Final Agent Performance Report
SELECT 
    ra.agent_id,
    ra.agent_name,
    ra.location,
    ra.shift,
    ra.calls_handled,
    ra.rank_in_shift,
    ra.rank_in_location,
    cp.calls_handled AS consistent_calls,
    cg.call_time,
    cg.previous_call_time,
    cg.gap_minutes
FROM RankedAgents ra
LEFT JOIN ConsistentPerformers cp ON ra.agent_id = cp.agent_id
LEFT JOIN CallGaps cg ON ra.agent_id = cg.agent_id
ORDER BY ra.shift, ra.rank_in_shift, cg.call_time;