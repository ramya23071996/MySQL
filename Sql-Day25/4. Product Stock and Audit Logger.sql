-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS InventoryDB;
USE InventoryDB;

-- Step 2: Create tables

-- Categories table
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100)
);

-- Products table
CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    stock INT,
    supplier_price DECIMAL(10,2),
    selling_price DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Stock Audit table
CREATE TABLE IF NOT EXISTS StockAudit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    action VARCHAR(50),
    stock_snapshot INT,
    audit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Insert categories
INSERT INTO Categories (category_name) VALUES
('Electronics'), ('Stationery'), ('Appliances'), ('Furniture'), ('Toys');

-- Step 4: Stored Procedure to add products
DELIMITER //
CREATE PROCEDURE AddProduct(
    IN pname VARCHAR(100),
    IN cat_id INT,
    IN stk INT,
    IN s_price DECIMAL(10,2),
    IN sell_price DECIMAL(10,2)
)
BEGIN
    INSERT INTO Products(product_name, category_id, stock, supplier_price, selling_price)
    VALUES (pname, cat_id, stk, s_price, sell_price);
END;
//
DELIMITER ;

-- Step 5: Triggers to log inserts and updates
DELIMITER //
CREATE TRIGGER LogProductInsert
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
    INSERT INTO StockAudit(product_id, action, stock_snapshot)
    VALUES (NEW.product_id, 'INSERT', NEW.stock);
END;
//
CREATE TRIGGER LogProductUpdate
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO StockAudit(product_id, action, stock_snapshot)
    VALUES (NEW.product_id, 'UPDATE', NEW.stock);
END;
//
DELIMITER ;

-- Step 6: Function to return total stock per category
DELIMITER //
CREATE FUNCTION TotalStockByCategory(cat_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(stock) INTO total FROM Products WHERE category_id = cat_id;
    RETURN IFNULL(total, 0);
END;
//
DELIMITER ;

-- Step 7: View for low stock items (stock < 50), hiding supplier price
CREATE OR REPLACE VIEW LowStockItems AS
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    p.stock,
    p.selling_price
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE p.stock < 50;

-- Step 8: Insert 50 sample products using the procedure
CALL AddProduct('USB Cable', 1, 20, 50.00, 99.00);
CALL AddProduct('Notebook', 2, 100, 20.00, 40.00);
CALL AddProduct('Electric Kettle', 3, 15, 800.00, 1299.00);
CALL AddProduct('Pen Pack', 2, 45, 10.00, 25.00);
CALL AddProduct('Bluetooth Speaker', 1, 60, 900.00, 1499.00);
CALL AddProduct('Office Chair', 4, 12, 1500.00, 2999.00);
CALL AddProduct('Toy Car', 5, 80, 100.00, 199.00);
CALL AddProduct('LED Monitor', 1, 35, 4000.00, 6999.00);
CALL AddProduct('Stapler', 2, 55, 30.00, 60.00);
CALL AddProduct('Microwave Oven', 3, 25, 3000.00, 4999.00);
CALL AddProduct('Desk Lamp', 4, 40, 500.00, 999.00);
CALL AddProduct('Puzzle Set', 5, 70, 150.00, 299.00);
CALL AddProduct('Keyboard', 1, 48, 600.00, 999.00);
CALL AddProduct('Marker Set', 2, 90, 25.00, 50.00);
CALL AddProduct('Toaster', 3, 30, 1200.00, 1999.00);
CALL AddProduct('Bookshelf', 4, 18, 2000.00, 3499.00);
CALL AddProduct('Action Figure', 5, 65, 250.00, 499.00);
CALL AddProduct('Wireless Mouse', 1, 22, 250.00, 499.00);
CALL AddProduct('Sticky Notes', 2, 110, 5.00, 15.00);
CALL AddProduct('Blender', 3, 28, 1800.00, 2999.00);
CALL AddProduct('Filing Cabinet', 4, 10, 3000.00, 4999.00);
CALL AddProduct('Board Game', 5, 75, 350.00, 699.00);
CALL AddProduct('HDMI Cable', 1, 33, 150.00, 299.00);
CALL AddProduct('Eraser Pack', 2, 95, 3.00, 10.00);
CALL AddProduct('Rice Cooker', 3, 20, 2500.00, 3999.00);
CALL AddProduct('Study Table', 4, 14, 2500.00, 4499.00);
CALL AddProduct('Doll House', 5, 60, 500.00, 999.00);
CALL AddProduct('Webcam', 1, 38, 1200.00, 1999.00);
CALL AddProduct('Glue Stick', 2, 85, 8.00, 20.00);
CALL AddProduct('Air Fryer', 3, 18, 3500.00, 5999.00);
CALL AddProduct('Sofa Set', 4, 8, 7000.00, 12999.00);
CALL AddProduct('Building Blocks', 5, 90, 200.00, 399.00);
CALL AddProduct('Router', 1, 42, 1800.00, 2999.00);
CALL AddProduct('Scissors', 2, 75, 15.00, 30.00);
CALL AddProduct('Iron Box', 3, 27, 1500.00, 2499.00);
CALL AddProduct('Cupboard', 4, 11, 4000.00, 7499.00);
CALL AddProduct('Remote Car', 5, 55, 300.00, 599.00);
CALL AddProduct('Power Bank', 1, 36, 900.00, 1499.00);
CALL AddProduct('Highlighter Set', 2, 88, 20.00, 45.00);
CALL AddProduct('Water Purifier', 3, 19, 5000.00, 7999.00);
CALL AddProduct('TV Stand', 4, 13, 1800.00, 2999.00);
CALL AddProduct('Toy Train', 5, 68, 400.00, 799.00);
CALL AddProduct('Smartwatch', 1, 29, 2500.00, 4499.00);
CALL AddProduct('Binder Clips', 2, 92, 6.00, 12.00);
CALL AddProduct('Vacuum Cleaner', 3, 21, 3200.00, 5499.00);
CALL AddProduct('Recliner', 4, 9, 8500.00, 14999.00);
CALL AddProduct('Stuffed Animal', 5, 73, 300.00, 599.00);
CALL AddProduct('Graphics Tablet', 1, 26, 3500.00, 5999.00);
CALL AddProduct('Correction Tape', 2, 78, 10.00, 25.00);