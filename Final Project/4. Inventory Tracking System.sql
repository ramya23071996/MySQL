-- 1. Create Inventory Database
CREATE DATABASE inventory_system;
USE inventory_system;

-- 2. Products Table
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    stock INT DEFAULT 0
);

-- 3. Suppliers Table
CREATE TABLE suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Inventory Logs Table
CREATE TABLE inventory_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    supplier_id INT,
    action ENUM('IN', 'OUT') NOT NULL,
    qty INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

-- 5. Trigger: Auto-Update Stock on Inventory Log
DELIMITER $$

CREATE TRIGGER update_stock_after_log
AFTER INSERT ON inventory_logs
FOR EACH ROW
BEGIN
    IF NEW.action = 'IN' THEN
        UPDATE products
        SET stock = stock + NEW.qty
        WHERE id = NEW.product_id;
    ELSEIF NEW.action = 'OUT' THEN
        UPDATE products
        SET stock = stock - NEW.qty
        WHERE id = NEW.product_id;
    END IF;
END$$

DELIMITER ;

-- 6. Insert Sample Products
INSERT INTO products (name, stock) VALUES
('Monitor', 10),
('Keyboard', 25),
('Mouse', 30),
('Printer', 5),
('Router', 20);

-- 7. Insert Sample Suppliers
INSERT INTO suppliers (name) VALUES
('Tech Supplies Co.'),
('Peripheral World'),
('NetGear Partners');

-- 8. Insert Inventory Logs
INSERT INTO inventory_logs (product_id, supplier_id, action, qty) VALUES
(1, 1, 'IN', 5),
(2, 2, 'OUT', 3),
(3, 2, 'IN', 10),
(4, 3, 'IN', 2),
(5, 1, 'OUT', 5),
(1, 1, 'OUT', 2),
(2, 2, 'IN', 8),
(3, 2, 'OUT', 6),
(4, 3, 'OUT', 1),
(5, 1, 'IN', 7);

-- 9. Query: Stock Status with Reorder Logic
SELECT 
    p.name AS product,
    p.stock,
    CASE 
        WHEN p.stock < 10 THEN 'Reorder Needed'
        ELSE 'Stock Sufficient'
    END AS status
FROM products p;

-- 10. Query: View Inventory History for a Product
SELECT 
    p.name AS product,
    s.name AS supplier,
    il.action,
    il.qty,
    il.timestamp
FROM inventory_logs il
JOIN products p ON il.product_id = p.id
JOIN suppliers s ON il.supplier_id = s.id
WHERE p.name = 'Keyboard'
ORDER BY il.timestamp DESC;