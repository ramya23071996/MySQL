-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Cashiers;

-- 🏗️ Create Cashiers table
CREATE TABLE Cashiers (
    cashier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 🏗️ Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    barcode VARCHAR(50) UNIQUE NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

-- 🏗️ Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    cashier_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (cashier_id) REFERENCES Cashiers(cashier_id)
);

-- 👤 Insert sample cashiers
INSERT INTO Cashiers (name, email) VALUES
('Sonal Mehta', 'sonal.mehta@store.com'),
('Rakesh Iyer', 'rakesh.iyer@store.com');

-- 📦 Insert sample products
INSERT INTO Products (barcode, product_name, price, stock) VALUES
('B001', 'Shampoo 250ml', 180.00, 100),
('B002', 'Toothpaste 100g', 90.00, 200),
('B003', 'Face Wash 150ml', 220.00, 150);

-- 🧾 Simulate a billing session using transaction and SAVEPOINT
START TRANSACTION;

-- Step 1: First sale
INSERT INTO Sales (product_id, cashier_id, quantity) VALUES (1, 1, 2);
UPDATE Products SET stock = stock - 2 WHERE product_id = 1;
SAVEPOINT after_first_item;

-- Step 2: Second sale
INSERT INTO Sales (product_id, cashier_id, quantity) VALUES (2, 1, 1);
UPDATE Products SET stock = stock - 1 WHERE product_id = 2;
SAVEPOINT after_second_item;

-- Step 3: Simulate error on third item (e.g., out of stock)
-- INSERT INTO Sales (product_id, cashier_id, quantity) VALUES (3, 1, 200); -- Uncomment to test failure
-- UPDATE Products SET stock = stock - 200 WHERE product_id = 3; -- Will fail if stock < 200

-- ❌ Rollback to last successful point if needed
-- ROLLBACK TO after_second_item;

-- ✅ Commit if all successful
COMMIT;

-- ❌ Delete a voided sale (e.g., sale_id = 2)
DELETE FROM Sales WHERE sale_id = 2;

-- ✅ Restore stock for voided sale
UPDATE Products SET stock = stock + 1 WHERE product_id = 2;