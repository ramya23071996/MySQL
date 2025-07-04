-- 1. Create the database
CREATE DATABASE IF NOT EXISTS finance_dashboard;
USE finance_dashboard;

-- 2. Create revenue table
CREATE TABLE monthly_revenue (
    revenue_id INT PRIMARY KEY,
    revenue_date DATE,
    amount DECIMAL(12,2)
);

-- 3. Insert sample data (across 2023 and 2024)
INSERT INTO monthly_revenue VALUES
(1, '2023-01-01', 120000),
(2, '2023-02-01', 110000),
(3, '2023-03-01', 130000),
(4, '2023-04-01', 90000),
(5, '2023-05-01', 95000),
(6, '2023-06-01', 105000),
(7, '2023-07-01', 125000),
(8, '2023-08-01', 115000),
(9, '2023-09-01', 100000),
(10, '2023-10-01', 98000),
(11, '2023-11-01', 102000),
(12, '2023-12-01', 108000),
(13, '2024-01-01', 140000),
(14, '2024-02-01', 135000),
(15, '2024-03-01', 145000),
(16, '2024-04-01', 125000),
(17, '2024-05-01', 130000),
(18, '2024-06-01', 138000);

-- 4. A. Group revenue by year and month
SELECT 
    YEAR(revenue_date) AS revenue_year,
    MONTH(revenue_date) AS revenue_month,
    SUM(amount) AS monthly_revenue
FROM monthly_revenue
GROUP BY YEAR(revenue_date), MONTH(revenue_date)
ORDER BY revenue_year, revenue_month;

-- 5. B. Calculate year-wise average revenue
SELECT 
    YEAR(revenue_date) AS revenue_year,
    AVG(amount) AS avg_yearly_revenue
FROM monthly_revenue
GROUP BY YEAR(revenue_date);

-- 6. C. Highlight months where revenue > year average
SELECT 
    YEAR(mr.revenue_date) AS revenue_year,
    MONTH(mr.revenue_date) AS revenue_month,
    mr.amount AS monthly_revenue,
    (
        SELECT AVG(amount)
        FROM monthly_revenue
        WHERE YEAR(revenue_date) = YEAR(mr.revenue_date)
    ) AS avg_yearly_revenue,
    CASE 
        WHEN mr.amount > (
            SELECT AVG(amount)
            FROM monthly_revenue
            WHERE YEAR(revenue_date) = YEAR(mr.revenue_date)
        ) THEN 'Above Average'
        ELSE 'Below/Equal Average'
    END AS performance_tag
FROM monthly_revenue mr
ORDER BY revenue_year, revenue_month;