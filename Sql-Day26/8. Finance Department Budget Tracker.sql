-- Step 1: Create DepartmentBudgets Table
CREATE TABLE DepartmentBudgets (
    dept_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    fiscal_year INT,
    total_budget INT
);

-- Step 2: Insert Sample Budget Data
INSERT INTO DepartmentBudgets VALUES
(1, 'Research & Development', 2025, 250000),
(2, 'Sales & Marketing', 2025, 180000),
(3, 'Human Resources', 2025, 95000),
(4, 'Finance', 2025, 120000),
(5, 'Operations', 2025, 220000),
(6, 'IT Services', 2025, 175000),
(7, 'Legal', 2025, 85000),
(8, 'Procurement', 2025, 98000);

-- Step 3: CTE to Filter High-Budget Departments
WITH HighBudget AS (
    SELECT 
        dept_id,
        department_name,
        fiscal_year,
        total_budget
    FROM DepartmentBudgets
    WHERE total_budget > 100000
),

-- Step 4: Apply Ranking and Calculate Spend Delta
RankedBudgets AS (
    SELECT 
        dept_id,
        department_name,
        total_budget,
        RANK() OVER(ORDER BY total_budget DESC) AS spend_rank,
        MAX(total_budget) OVER() - total_budget AS spend_delta
    FROM HighBudget
)

-- Step 5: Final Report
SELECT 
    department_name,
    total_budget,
    spend_rank,
    spend_delta
FROM RankedBudgets
ORDER BY spend_rank;