-- Step 1: Create Salaries Table
CREATE TABLE Salaries (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

-- Step 2: Insert Sample Data
INSERT INTO Salaries VALUES
(1, 'Aarav', 'Management', 100000),
(2, 'Bhavna', 'Sales', 80000),
(3, 'Chetan', 'Tech', 85000),
(4, 'Deepa', 'Sales', 45000),
(5, 'Esha', 'Sales', 47000),
(6, 'Farhan', 'Tech', 50000),
(7, 'Gauri', 'Tech', 52000),
(8, 'Harsh', 'Sales', 47000),
(9, 'Isha', 'Tech', 68000),
(10, 'Jay', 'Sales', 44000);

-- Step 3: Salary Ranking Dashboard Report
SELECT 
    emp_id,
    emp_name,
    department,
    salary,

    -- Ranking metrics within department
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS row_number,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rank,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dense_rank,

    -- Salary movement insights
    LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS previous_salary,
    LEAD(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS next_salary,

    -- Salary change direction
    CASE 
        WHEN LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) IS NULL THEN 'N/A'
        WHEN salary > LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) THEN '↑ Increased'
        WHEN salary < LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) THEN '↓ Decreased'
        ELSE '→ No Change'
    END AS salary_trend

FROM Salaries
ORDER BY department, salary DESC;