-- Step 1: Create ProductCategories Table
CREATE TABLE ProductCategories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100),
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES ProductCategories(category_id)
);

-- Step 2: Insert Sample Categories
INSERT INTO ProductCategories VALUES
(1, 'Electronics', NULL),
(2, 'Mobiles', 1),
(3, 'Smartphones', 2),
(4, 'Feature Phones', 2),
(5, 'Laptops', 1),
(6, 'Gaming Laptops', 5),
(7, 'Ultrabooks', 5),
(8, 'Home Appliances', NULL),
(9, 'Kitchen Appliances', 8),
(10, 'Microwaves', 9),
(11, 'Refrigerators', 9),
(12, 'TVs', 1),
(13, 'LED TVs', 12),
(14, 'Smart TVs', 12);

-- Step 3: Recursive CTE to Build Category Tree
WITH RECURSIVE CategoryTree AS (
    SELECT 
        category_id,
        category_name,
        parent_id,
        1 AS level,
        CAST(category_name AS VARCHAR(1000)) AS path
    FROM ProductCategories
    WHERE parent_id IS NULL

    UNION ALL

    SELECT 
        pc.category_id,
        pc.category_name,
        pc.parent_id,
        ct.level + 1,
        CONCAT(ct.path, ' → ', pc.category_name)
    FROM ProductCategories pc
    JOIN CategoryTree ct ON pc.parent_id = ct.category_id
)

-- Step 4: Final Report - Full Tree with Path and Level
SELECT 
    category_id,
    category_name,
    parent_id,
    level,
    path
FROM CategoryTree
ORDER BY path;