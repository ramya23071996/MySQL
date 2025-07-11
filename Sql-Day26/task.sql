CREATE DATABASE OrgAnalytics;
USE OrgAnalytics;

-- Employees Table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT,
    position VARCHAR(50),
    department VARCHAR(50),
    CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES Employees(emp_id),
    CONSTRAINT check_no_cycles CHECK (emp_id != manager_id)
);

-- Salaries Table
CREATE TABLE Salaries (
    emp_id INT,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    order_date DATE,
    region VARCHAR(50)
);

-- Product Categories (for tree structure)
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50),
    parent_id INT
);

-- 1 & 2. Create and insert Employees
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT,
    position VARCHAR(50),
    department VARCHAR(50),
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

INSERT INTO Employees VALUES
(1, 'Aarav', NULL, 'CEO', 'Management'),
(2, 'Bhavna', 1, 'Manager', 'Sales'),
(3, 'Chetan', 1, 'Manager', 'Tech'),
(4, 'Deepa', 2, 'Staff', 'Sales'),
(5, 'Esha', 2, 'Staff', 'Sales'),
(6, 'Farhan', 3, 'Staff', 'Tech'),
(7, 'Gauri', 3, 'Staff', 'Tech');

-- 3. Recursive hierarchy
WITH RECURSIVE OrgTree AS (
    SELECT emp_id, emp_name, manager_id, 1 AS level, position, department
    FROM Employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.emp_name, e.manager_id, ot.level + 1, e.position, e.department
    FROM Employees e JOIN OrgTree ot ON e.manager_id = ot.emp_id
)
SELECT * FROM OrgTree;

-- 4. Sorted by level
SELECT * FROM OrgTree ORDER BY level;

-- 5. Already included position in above query

-- 6. Subordinates of manager_id = 2
WITH RECURSIVE Subordinates AS (
    SELECT * FROM Employees WHERE emp_id = 2
    UNION ALL
    SELECT e.* FROM Employees e JOIN Subordinates s ON e.manager_id = s.emp_id
)
SELECT * FROM Subordinates WHERE emp_id != 2;

-- 7. Cycle prevention constraint (already handled in structure)

-- 8. Create hierarchy view
CREATE VIEW EmployeeHierarchyView AS
SELECT * FROM OrgTree;

-- 9. Filter for level = 3
SELECT * FROM OrgTree WHERE level = 3;

-- 10. Max depth
SELECT MAX(level) AS max_level FROM OrgTree;

-- 11. Manager's immediate team count
SELECT manager_id, COUNT(*) AS team_size
FROM Employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

-- 12. Direct & indirect reports
WITH RECURSIVE Reports AS (
    SELECT emp_id, manager_id FROM Employees
    UNION ALL
    SELECT e.emp_id, r.manager_id FROM Employees e
    JOIN Reports r ON e.manager_id = r.emp_id
)
SELECT manager_id, COUNT(emp_id) AS total_reports
FROM Reports
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

-- 13. Path from CEO
WITH RECURSIVE PathTree AS (
    SELECT emp_id, emp_name, manager_id, CAST(emp_name AS VARCHAR(500)) AS path
    FROM Employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.emp_name, e.manager_id, CONCAT(pt.path, ' -> ', e.emp_name)
    FROM Employees e JOIN PathTree pt ON e.manager_id = pt.emp_id
)
SELECT * FROM PathTree;

-- 14. Hierarchy per department
SELECT * FROM OrgTree ORDER BY department, level;

-- 15. Depth of employee
SELECT emp_id, emp_name, level FROM OrgTree WHERE emp_name = 'Gauri';

-- 16 & 17. Create and insert Salaries
CREATE TABLE Salaries (
    emp_id INT,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

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

-- 18. ROW_NUMBER by salary
SELECT *, ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_num FROM Salaries;

-- 19. RANK by salary
SELECT *, RANK() OVER(ORDER BY salary DESC) AS rank FROM Salaries;

-- 20. DENSE_RANK comparison
SELECT *, DENSE_RANK() OVER(ORDER BY salary DESC) AS dense_rank FROM Salaries;

-- 21. Rank within department
SELECT *, RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dept_rank FROM Salaries;

-- 22. LAG
SELECT *, LAG(salary) OVER(ORDER BY salary DESC) AS prev_salary FROM Salaries;

-- 23. LEAD
SELECT *, LEAD(salary) OVER(ORDER BY salary DESC) AS next_salary FROM Salaries;

-- 24. ROW_NUMBER + LAG
SELECT *, ROW_NUMBER() OVER(ORDER BY salary), LAG(salary) OVER(ORDER BY salary) AS previous_salary FROM Salaries;

-- 25. Salary increase check
SELECT *, CASE WHEN salary > LAG(salary) OVER(ORDER BY salary) THEN 'Increased' ELSE 'Not Increased' END AS change
FROM Salaries;

-- 26. NTILE(3)
SELECT *, NTILE(3) OVER(ORDER BY salary DESC) AS salary_tier FROM Salaries;

-- 27. FIRST and LAST per department
SELECT *, FIRST_VALUE(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS top_salary,
         LAST_VALUE(salary) OVER(PARTITION BY department ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS bottom_salary
FROM Salaries;

-- 28. Distribution
SELECT *, CUME_DIST() OVER(ORDER BY salary DESC) AS dist,
         PERCENT_RANK() OVER(ORDER BY salary DESC) AS percent_rank
FROM Salaries;

-- 29. Moving average
SELECT *, AVG(salary) OVER(ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg FROM Salaries;

-- 30. Salary ranking view
CREATE VIEW SalaryRanking AS
SELECT *, RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dept_rank FROM Salaries;

-- 31. Salary as percentage of dept total
SELECT *, ROUND((salary * 100.0) / SUM(salary) OVER(PARTITION BY department), 2) AS dept_percent
FROM Salaries;

-- 32. Difference from max in dept
SELECT *, MAX(salary) OVER(PARTITION BY department) - salary AS gap
FROM Salaries;

-- 33. Peer comparison
SELECT emp_name, department, salary,
       AVG(salary) OVER(PARTITION BY department) AS avg_salary,
       salary - AVG(salary) OVER(PARTITION BY department) AS diff
FROM Salaries;

-- 34. Less than department average
SELECT * FROM (
  SELECT *, AVG(salary) OVER(PARTITION BY department) AS avg_salary FROM Salaries
) temp WHERE salary < avg_salary;

-- 35. Group and rank
SELECT *, RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank FROM Salaries;

-- 36 & 37. Orders table and inserts
CREATE TABLE Orders (
    order_id INT,
    customer_id INT,
    amount INT,
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO Orders VALUES
(1, 101, 12000, '2025-07-01', 'South'),
(2, 102, 5000, '2025-07-02', 'North'),
(3, 101, 7000, '2025-07-03', 'South'),
-- Add 17 more orders across 5 customers...

-- 38. Orders > ₹10,000
WITH HighValueOrders AS (
    SELECT * FROM Orders WHERE amount > 10000
)
SELECT * FROM HighValueOrders;

-- 39. Total per customer
WITH CustomerTotal AS (
    SELECT customer_id, SUM(amount) AS total_amount FROM Orders GROUP BY customer_id
)
SELECT * FROM CustomerTotal;

-- 40. Customers with >3 orders
WITH OrderCount AS (
    SELECT customer_id, COUNT(*) AS order_count FROM Orders GROUP BY customer_id
)
SELECT * FROM OrderCount WHERE order_count > 3;

-- 41. Two CTEs
WITH TopSpenders AS (
    SELECT customer_id, SUM(amount) AS spend FROM Orders GROUP BY customer_id
),
FrequentBuyers AS (
    SELECT customer_id, COUNT(*) AS count FROM Orders GROUP BY customer_id
)
SELECT ts.customer_id, ts.spend, fb.count
FROM TopSpenders ts JOIN FrequentBuyers fb ON ts.customer_id = fb.customer_id;

-- 42. Product category tree
WITH RECURSIVE

-- 43
WITH RECURSIVE FactorialCTE(n, fact) AS (
    SELECT 1, 1
    UNION ALL
    SELECT n + 1, fact * (n + 1)
    FROM FactorialCTE
    WHERE n < 5  -- You can change 5 to any desired max number
)
SELECT * FROM FactorialCTE;

-- 44
WITH DailySales AS (
    SELECT order_date, SUM(amount) AS total_sales
    FROM Orders
    GROUP BY order_date
)
SELECT order_date, total_sales,
       SUM(total_sales) OVER(ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM DailySales;

-- 45
CREATE VIEW CustomerOrderSummary AS
WITH CustomerTotals AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT * FROM CustomerTotals;

-- 46
WITH C1 AS (
    SELECT customer_id, SUM(amount) AS total_spent FROM Orders GROUP BY customer_id
),
C2 AS (
    SELECT customer_id FROM Orders GROUP BY customer_id HAVING COUNT(*) > 2
),
C3 AS (
    SELECT * FROM C1 WHERE customer_id IN (SELECT customer_id FROM C2)
)
SELECT * FROM C3;

-- 47
WITH RegionalSales AS (
    SELECT region, SUM(amount) AS total_sales FROM Orders GROUP BY region
)
SELECT * FROM RegionalSales WHERE total_sales > 20000;

SELECT region, total_sales
FROM (
    SELECT region, SUM(amount) AS total_sales FROM Orders GROUP BY region
) temp
WHERE total_sales > 20000;

-- 48
WITH RECURSIVE ReportingChain AS (
    SELECT emp_id, emp_name, manager_id FROM Employees WHERE emp_id = 7  -- Gauri, for example
    UNION ALL
    SELECT e.emp_id, e.emp_name, e.manager_id
    FROM Employees e JOIN ReportingChain rc ON rc.manager_id = e.emp_id
)
SELECT * FROM ReportingChain WHERE emp_id != 7;

-- 49
WITH RankedCustomers AS (
    SELECT customer_id, region, SUM(amount) AS total_spent,
           RANK() OVER(PARTITION BY region ORDER BY SUM(amount) DESC) AS rank
    FROM Orders
    GROUP BY customer_id, region
)
SELECT * FROM RankedCustomers WHERE rank <= 5;

-- 50
WITH CustomerTotals AS (
    SELECT customer_id, SUM(amount) AS total_order FROM Orders GROUP BY customer_id
)
SELECT customer_id, total_order,
       RANK() OVER(ORDER BY total_order DESC) AS customer_rank
FROM CustomerTotals;

