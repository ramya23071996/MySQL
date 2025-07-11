-- Step 1: Create the Salespersons Table
CREATE TABLE Salespersons (
    sales_id INT PRIMARY KEY,
    sales_name VARCHAR(50),
    manager_id INT,
    sales_amount INT,
    FOREIGN KEY (manager_id) REFERENCES Salespersons(sales_id)
);

-- Step 2: Insert Sample Data
INSERT INTO Salespersons VALUES
(1, 'Aarav', NULL, 120000),        -- Regional Head
(2, 'Bhavna', 1, 85000),           -- Manager
(3, 'Chetan', 1, 90000),           -- Manager
(4, 'Deepa', 2, 50000),            -- Sales Executive
(5, 'Esha', 2, 55000),
(6, 'Farhan', 3, 62000),
(7, 'Gauri', 3, 58000),
(8, 'Harsh', 2, 47000),
(9, 'Isha', 3, 49000);

-- Step 3: Recursive CTE to Build Team Hierarchy
WITH RECURSIVE SalesHierarchy AS (
    SELECT 
        sales_id,
        sales_name,
        manager_id,
        sales_amount,
        1 AS level,
        CAST(sales_name AS VARCHAR(500)) AS team_path
    FROM Salespersons
    WHERE manager_id IS NULL

    UNION ALL

    SELECT 
        sp.sales_id,
        sp.sales_name,
        sp.manager_id,
        sp.sales_amount,
        sh.level + 1,
        CONCAT(sh.team_path, ' → ', sp.sales_name)
    FROM Salespersons sp
    JOIN SalesHierarchy sh ON sp.manager_id = sh.sales_id
),

-- Step 4: Team Performance Aggregation
TeamPerformance AS (
    SELECT 
        manager_id,
        SUM(sales_amount) OVER(PARTITION BY manager_id) AS team_total_sales
    FROM Salespersons
)

-- Step 5: Final Report with Rankings by Sales within Team
SELECT 
    sh.sales_id,
    sh.sales_name,
    sh.manager_id,
    m.sales_name AS manager_name,
    sh.level AS depth,
    sh.team_path,
    sh.sales_amount,
    
    -- Total team sales grouped by manager
    tp.team_total_sales,

    -- Rank of each salesperson within their manager’s team
    RANK() OVER(PARTITION BY sh.manager_id ORDER BY sh.sales_amount DESC) AS team_rank

FROM SalesHierarchy sh
LEFT JOIN Salespersons m ON sh.manager_id = m.sales_id
LEFT JOIN TeamPerformance tp ON sh.manager_id = tp.manager_id
ORDER BY sh.manager_id, team_rank;