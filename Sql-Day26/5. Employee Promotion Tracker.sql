-- Step 1: Create EmployeeSalaryHistory table
CREATE TABLE EmployeeSalaryHistory (
    emp_id INT,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    effective_date DATE
);

-- Step 2: Insert sample salary history records
INSERT INTO EmployeeSalaryHistory VALUES
(1, 'Aarav', 'Management', 90000, '2023-01-01'),
(1, 'Aarav', 'Management', 100000, '2025-03-01'),
(2, 'Bhavna', 'Sales', 65000, '2024-06-01'),
(2, 'Bhavna', 'Sales', 80000, '2025-02-15'),
(3, 'Chetan', 'Tech', 72000, '2024-04-01'),
(3, 'Chetan', 'Tech', 85000, '2025-03-10'),
(4, 'Deepa', 'Sales', 45000, '2024-07-01'),
(4, 'Deepa', 'Sales', 45000, '2025-03-20'),
(5, 'Esha', 'Sales', 47000, '2025-04-01'),
(6, 'Farhan', 'Tech', 50000, '2024-10-01'),
(6, 'Farhan', 'Tech', 52000, '2025-03-05');

-- Step 3: CTE to filter salary changes in the current year
WITH CurrentYearChanges AS (
    SELECT 
        emp_id,
        emp_name,
        department,
        salary,
        effective_date,
        LAG(salary) OVER(PARTITION BY emp_id ORDER BY effective_date) AS previous_salary,
        LAG(effective_date) OVER(PARTITION BY emp_id ORDER BY effective_date) AS previous_date
    FROM EmployeeSalaryHistory
    WHERE YEAR(effective_date) = 2025
)

-- Step 4: Final report highlighting raises/promotions
SELECT 
    emp_id,
    emp_name,
    department,
    previous_salary,
    salary AS current_salary,
    previous_date,
    effective_date AS current_date,
    salary - previous_salary AS salary_diff,
    CASE 
        WHEN previous_salary IS NULL THEN 'First record this year'
        WHEN salary > previous_salary THEN '↑ Promoted/Raised'
        WHEN salary = previous_salary THEN '→ No Change'
        ELSE '↓ Possible Downgrade'
    END AS status
FROM CurrentYearChanges
ORDER BY department, emp_name;