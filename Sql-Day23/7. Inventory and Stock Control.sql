-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS PurchaseOrders;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Suppliers;

-- 🏗️ Create Suppliers table
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) UNIQUE NOT NULL
);

-- 🏗️ Create Inventory table
CREATE TABLE Inventory (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    reorder_level INT NOT NULL CHECK (reorder_level >= 0),
    supplier_id INT,
    is_discontinued BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- 🏗️ Create PurchaseOrders table
CREATE TABLE PurchaseOrders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    supplier_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    quantity_ordered INT NOT NULL CHECK (quantity_ordered > 0),
    FOREIGN KEY (item_id) REFERENCES Inventory(item_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- 🧾 Insert sample suppliers
INSERT INTO Suppliers (name, contact_email) VALUES
('Global Supplies Co.', 'contact@globalsupplies.com'),
('TechParts Ltd.', 'sales@techparts.com');

-- 🧾 Insert stock items
INSERT INTO Inventory (item_name, quantity, reorder_level, supplier_id) VALUES
('Laptop Battery', 100, 20, 1),
('HDMI Cable', 250, 50, 2),
('Wireless Mouse', 75, 30, 2);

-- ✏️ Update quantities and reorder levels
UPDATE Inventory
SET quantity = quantity - 10
WHERE item_id = 1;

UPDATE Inventory
SET reorder_level = 25
WHERE item_id = 3;

-- ❌ Delete discontinued items
UPDATE Inventory
SET is_discontinued = TRUE
WHERE item_id = 2;

DELETE FROM Inventory
WHERE is_discontinued = TRUE;

-- 🔄 Batch inventory update using transaction
START TRANSACTION;

-- Step 1: Receive new stock
UPDATE Inventory SET quantity = quantity + 50 WHERE item_id = 1;
UPDATE Inventory SET quantity = quantity + 100 WHERE item_id = 3;

-- Step 2: Record purchase orders
INSERT INTO PurchaseOrders (item_id, supplier_id, quantity_ordered)
VALUES (1, 1, 50);

INSERT INTO PurchaseOrders (item_id, supplier_id, quantity_ordered)
VALUES (3, 2, 100);

-- Optional: Simulate failure
-- UPDATE Inventory SET quantity = -10 WHERE item_id = 1; -- Will fail due to CHECK

-- ✅ Commit if all successful
COMMIT;

-- ❌ Rollback if any step fails
-- ROLLBACK;