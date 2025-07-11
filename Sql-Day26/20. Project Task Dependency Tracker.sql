-- Step 1: Create Tasks Table
CREATE TABLE ProjectTasks (
    task_id INT PRIMARY KEY,
    task_name VARCHAR(100),
    depends_on_task_id INT,
    estimated_days INT,
    start_date DATE,
    FOREIGN KEY (depends_on_task_id) REFERENCES ProjectTasks(task_id)
);

-- Step 2: Insert Sample Tasks with Dependencies
INSERT INTO ProjectTasks VALUES
(1, 'Project Initiation', NULL, 2, '2025-07-01'),
(2, 'Requirement Gathering', 1, 3, '2025-07-03'),
(3, 'System Design', 2, 4, '2025-07-06'),
(4, 'Development Phase 1', 3, 7, '2025-07-10'),
(5, 'Development Phase 2', 4, 6, '2025-07-17'),
(6, 'Testing & QA', 5, 5, '2025-07-23'),
(7, 'Deployment', 6, 2, '2025-07-28');

-- Step 3: Recursive CTE to Build Task Execution Tree
WITH RECURSIVE TaskHierarchy AS (
    SELECT 
        task_id,
        task_name,
        depends_on_task_id,
        estimated_days,
        start_date,
        1 AS level,
        CAST(task_name AS VARCHAR(1000)) AS task_path,
        start_date AS actual_start,
        DATEADD(DAY, estimated_days, start_date) AS estimated_end
    FROM ProjectTasks
    WHERE depends_on_task_id IS NULL

    UNION ALL

    SELECT 
        pt.task_id,
        pt.task_name,
        pt.depends_on_task_id,
        pt.estimated_days,
        pt.start_date,
        th.level + 1,
        CONCAT(th.task_path, ' → ', pt.task_name),
        DATEADD(DAY, 1, th.estimated_end) AS actual_start,
        DATEADD(DAY, pt.estimated_days, DATEADD(DAY, 1, th.estimated_end)) AS estimated_end
    FROM ProjectTasks pt
    JOIN TaskHierarchy th ON pt.depends_on_task_id = th.task_id
)

-- Step 4: Gantt Chart–Ready Output
SELECT 
    task_id,
    task_name,
    depends_on_task_id,
    level,
    actual_start,
    estimated_end,
    DATEDIFF(DAY, actual_start, estimated_end) AS duration,
    task_path
FROM TaskHierarchy
ORDER BY actual_start;