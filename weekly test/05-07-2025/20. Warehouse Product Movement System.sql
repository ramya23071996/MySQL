--  Drop existing tables if they exist
DROP TABLE IF EXISTS Outward;
DROP TABLE IF EXISTS Inward;
DROP TABLE IF EXISTS StockLevels;
DROP TABLE IF EXISTS Products;

--  Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50)
);

--  Create StockLevels table
CREATE TABLE StockLevels (
    stock_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse VARCHAR(100) NOT NULL,
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    UNIQUE (product_id, warehouse)
);

--  Create Inward table
CREATE TABLE Inward (
    inward_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse VARCHAR(100) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    movement_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

--  Create Outward table
CREATE TABLE Outward (
    outward_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse VARCHAR(100) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    movement_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

--  Insert sample products
INSERT INTO Products (product_name, category) VALUES
('Steel Rods', 'Construction'),
('Plastic Sheets', 'Packaging'),
('Copper Wires', 'Electronics');

-- Initialize stock levels
INSERT INTO StockLevels (product_id, warehouse, quantity) VALUES
(1, 'Warehouse A', 100),
(2, 'Warehouse A', 200),
(3, 'Warehouse B', 150);

--  Record a large delivery using transaction
START TRANSACTION;

-- Step 1: Inward movement
INSERT INTO Inward (product_id, warehouse, quantity) VALUES (1, 'Warehouse A', 50);
UPDATE StockLevels SET quantity = quantity + 50 WHERE product_id = 1 AND warehouse = 'Warehouse A';

INSERT INTO Inward (product_id, warehouse, quantity) VALUES (3, 'Warehouse B', 30);
UPDATE StockLevels SET quantity = quantity + 30 WHERE product_id = 3 AND warehouse = 'Warehouse B';

--  Commit delivery
COMMIT;

--  Record outward movement
START TRANSACTION;

INSERT INTO Outward (product_id, warehouse, quantity) VALUES (2, 'Warehouse A', 40);
UPDATE StockLevels SET quantity = quantity - 40 WHERE product_id = 2 AND warehouse = 'Warehouse A';

COMMIT;

-- GROUP BY: Warehouse-level stock report
SELECT 
    s.warehouse,
    p.product_name,
    s.quantity
FROM StockLevels s
JOIN Products p ON s.product_id = p.product_id
ORDER BY s.warehouse, p.product_name;

-- Subquery: Most moved products (inward + outward)
SELECT 
    p.product_name,
    total_moved
FROM Products p
JOIN (
    SELECT product_id, SUM(quantity) AS total_moved
    FROM (
        SELECT product_id, quantity FROM Inward
        UNION ALL
        SELECT product_id, quantity FROM Outward
    ) AS movements
    GROUP BY product_id
) AS totals ON p.product_id = totals.product_id
WHERE total_moved = (
    SELECT MAX(total_sum) FROM (
        SELECT product_id, SUM(quantity) AS total_sum
        FROM (
            SELECT product_id, quantity FROM Inward
            UNION ALL
            SELECT product_id, quantity FROM Outward
        ) AS all_movements
        GROUP BY product_id
    ) AS max_totals
);