-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS RestaurantMonitor;
USE RestaurantMonitor;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Tables (dining tables)
CREATE TABLE IF NOT EXISTS Tables (
    table_id INT PRIMARY KEY,
    table_number VARCHAR(10),
    seating_capacity INT
);

-- Chefs
CREATE TABLE IF NOT EXISTS Chefs (
    chef_id INT PRIMARY KEY,
    chef_name VARCHAR(100),
    specialty VARCHAR(100)
);

-- MenuItems
CREATE TABLE IF NOT EXISTS MenuItems (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- Orders
CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY,
    table_id INT,
    chef_id INT,
    order_time DATETIME,
    order_status VARCHAR(50), -- e.g., 'Pending', 'Preparing', 'Served'
    FOREIGN KEY (table_id) REFERENCES Tables(table_id),
    FOREIGN KEY (chef_id) REFERENCES Chefs(chef_id)
);

-- OrderItems (many-to-many between Orders and MenuItems)
CREATE TABLE IF NOT EXISTS OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Tables
INSERT INTO Tables VALUES
(1, 'T1', 4), (2, 'T2', 2), (3, 'T3', 6);

-- Chefs
INSERT INTO Chefs VALUES
(1, 'Chef Arjun', 'Grill'), (2, 'Chef Meera', 'Pastry');

-- MenuItems
INSERT INTO MenuItems VALUES
(101, 'Grilled Chicken', 350.00),
(102, 'Veg Burger', 200.00),
(103, 'Chocolate Cake', 180.00);

-- Orders
INSERT INTO Orders VALUES
(1001, 1, 1, '2024-07-01 12:00:00', 'Pending'),
(1002, 2, 2, '2024-07-01 12:05:00', 'Preparing'),
(1003, 3, 1, '2024-07-01 12:10:00', 'Pending'),
(1004, 1, 2, '2024-07-01 12:15:00', 'Served'),
(1005, 2, 1, '2024-07-01 12:20:00', 'Pending');

-- OrderItems
INSERT INTO OrderItems VALUES
(1, 1001, 101, 2),
(2, 1001, 103, 1),
(3, 1002, 102, 1),
(4, 1003, 101, 1),
(5, 1004, 103, 2),
(6, 1005, 102, 2);

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_order_status ON Orders(order_status);
CREATE INDEX idx_table_id ON Orders(table_id);
CREATE INDEX idx_order_time ON Orders(order_time);

-- ============================================
-- 4. EXPLAIN TO DETECT PERFORMANCE ISSUES
-- ============================================

EXPLAIN
SELECT o.order_id, o.order_time, o.order_status, t.table_number
FROM Orders o
JOIN Tables t ON o.table_id = t.table_id
WHERE o.order_status = 'Pending'
ORDER BY o.order_time ASC;

-- ============================================
-- 5. DENORMALIZED VIEW FOR KITCHEN DISPLAY
-- ============================================

CREATE OR REPLACE VIEW KitchenDisplay AS
SELECT 
    o.order_id,
    o.order_time,
    o.order_status,
    t.table_number,
    c.chef_name,
    mi.item_name,
    oi.quantity
FROM Orders o
JOIN Tables t ON o.table_id = t.table_id
JOIN Chefs c ON o.chef_id = c.chef_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN MenuItems mi ON oi.item_id = mi.item_id;

-- View usage example
SELECT * FROM KitchenDisplay WHERE order_status = 'Pending';

-- ============================================
-- 6. SHOW ONLY TOP 5 PENDING ORDERS
-- ============================================

SELECT * FROM KitchenDisplay
WHERE order_status = 'Pending'
ORDER BY order_time ASC
LIMIT 5;