-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS WarehouseOptimizer;
USE WarehouseOptimizer;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- ItemCategories table
CREATE TABLE IF NOT EXISTS ItemCategories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

-- Items table
CREATE TABLE IF NOT EXISTS Items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES ItemCategories(category_id)
);

-- Warehouses table
CREATE TABLE IF NOT EXISTS Warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(100),
    location VARCHAR(100)
);

-- StockMovementTypes table
CREATE TABLE IF NOT EXISTS StockMovementTypes (
    movement_type_id INT PRIMARY KEY,
    movement_type_name VARCHAR(50) -- e.g., 'IN', 'OUT'
);

-- StockMovements table
CREATE TABLE IF NOT EXISTS StockMovements (
    movement_id INT PRIMARY KEY,
    item_id INT,
    warehouse_id INT,
    movement_type_id INT,
    quantity INT,
    movement_date DATE,
    FOREIGN KEY (item_id) REFERENCES Items(item_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (movement_type_id) REFERENCES StockMovementTypes(movement_type_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Item Categories
INSERT INTO ItemCategories VALUES
(1, 'Electronics'), (2, 'Furniture'), (3, 'Stationery');

-- Items
INSERT INTO Items VALUES
(101, 'Laptop', 1), (102, 'Desk', 2), (103, 'Notebook', 3);

-- Warehouses
INSERT INTO Warehouses VALUES
(1, 'Central Depot', 'Chennai'),
(2, 'North Hub', 'Delhi');

-- Stock Movement Types
INSERT INTO StockMovementTypes VALUES
(1, 'IN'), (2, 'OUT');

-- Stock Movements
INSERT INTO StockMovements VALUES
(1, 101, 1, 1, 50, '2024-07-01'),
(2, 101, 1, 2, 10, '2024-07-02'),
(3, 102, 2, 1, 20, '2024-07-03'),
(4, 103, 1, 1, 100, '2024-07-04'),
(5, 103, 1, 2, 95, '2024-07-05');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_item_name ON Items(item_name);
CREATE INDEX idx_warehouse_id ON StockMovements(warehouse_id);
CREATE INDEX idx_movement_date ON StockMovements(movement_date);

-- ============================================
-- 4. EXPLAIN + ORDER BY ON INDEXED COLUMNS
-- ============================================

EXPLAIN
SELECT * FROM StockMovements
WHERE warehouse_id = 1
ORDER BY movement_date DESC;

-- ============================================
-- 5. DENORMALIZED SUMMARY TABLE FOR STOCK LEVELS
-- ============================================

CREATE TABLE IF NOT EXISTS StockSummary (
    item_id INT,
    item_name VARCHAR(100),
    warehouse_id INT,
    warehouse_name VARCHAR(100),
    current_stock INT,
    PRIMARY KEY (item_id, warehouse_id)
);

-- Insert summarized stock levels
INSERT INTO StockSummary
SELECT 
    i.item_id,
    i.item_name,
    w.warehouse_id,
    w.warehouse_name,
    SUM(CASE WHEN smt.movement_type_name = 'IN' THEN sm.quantity ELSE -sm.quantity END) AS current_stock
FROM StockMovements sm
JOIN Items i ON sm.item_id = i.item_id
JOIN Warehouses w ON sm.warehouse_id = w.warehouse_id
JOIN StockMovementTypes smt ON sm.movement_type_id = smt.movement_type_id
GROUP BY i.item_id, i.item_name, w.warehouse_id, w.warehouse_name;

-- View stock summary
SELECT * FROM StockSummary;

-- ============================================
-- 6. LOW STOCK ALERTS WITH LIMIT
-- ============================================

SELECT * FROM StockSummary
WHERE current_stock < 10
ORDER BY current_stock ASC
LIMIT 5;