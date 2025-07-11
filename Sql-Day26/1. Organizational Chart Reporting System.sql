-- Step 1: Create Employees Table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

-- Step 2: Insert Sample Employees
INSERT INTO Employees VALUES
(1, 'Aarav', NULL),          -- CEO
(2, 'Bhavna', 1),            -- Manager under Aarav
(3, 'Chetan', 1),            -- Another Manager under Aarav
(4, 'Deepa', 2),             -- Staff under Bhavna
(5, 'Esha', 2),
(6, 'Farhan', 3),            -- Staff under Chetan
(7, 'Gauri', 3);

-- Step 3: Recursive CTE to List Hierarchy with Depth
WITH RECURSIVE OrgHierarchy AS (
    SELECT 
        emp_id,
        emp_name,
        manager_id,
        1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT 
        e.emp_id,
        e.emp_name,
        e.manager_id,
        oh.level + 1
    FROM Employees e
    INNER JOIN OrgHierarchy oh ON e.manager_id = oh.emp_id
)

-- Step 4: Create View to Abstract Hierarchy Logic
CREATE VIEW OrgHierarchyView AS
SELECT * FROM OrgHierarchy;

-- Step 5: Final Report - Employee, Manager, and Depth
SELECT 
    e.emp_name AS Employee,
    m.emp_name AS Manager,
    oh.level AS Depth
FROM OrgHierarchyView oh
LEFT JOIN Employees e ON oh.emp_id = e.emp_id
LEFT JOIN Employees m ON e.manager_id = m.emp_id
ORDER BY Depth, Manager, Employee;