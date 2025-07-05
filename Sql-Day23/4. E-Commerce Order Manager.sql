-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;

-- 🏗️ Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(50) UNIQUE NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

-- 🏗️ Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE DEFAULT CURRENT_DATE
);

-- 🏗️ Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    payment_status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 🏗️ Create OrderItems table
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 🧾 Insert sample products
INSERT INTO Products (product_code, product_name, price, stock) VALUES
('P1001', 'Wireless Mouse', 799.00, 50),
('P1002', 'Mechanical Keyboard', 2499.00, 30),
('P1003', 'USB-C Charger', 999.00, 40);

-- 🧾 Insert sample customers
INSERT INTO Customers (name, email) VALUES
('Ananya Rao', 'ananya.rao@example.com'),
('Kunal Mehta', 'kunal.mehta@example.com');

-- 🔄 Place an order using a transaction (Atomicity)
START TRANSACTION;

-- Step 1: Create order for customer_id = 1
INSERT INTO Orders (customer_id, payment_status) VALUES (1, 'Completed');
SET @order_id = LAST_INSERT_ID();

-- Step 2: Add items to the order
INSERT INTO OrderItems (order_id, product_id, quantity) VALUES
(@order_id, 1, 2),  -- 2 Wireless Mice
(@order_id, 2, 1);  -- 1 Mechanical Keyboard

-- Step 3: Update product stock
UPDATE Products SET stock = stock - 2 WHERE product_id = 1;
UPDATE Products SET stock = stock - 1 WHERE product_id = 2;

-- Optional: Simulate failure (uncomment to test rollback)
 UPDATE Products SET stock = stock - 100 WHERE product_id = 3; -- Will fail if stock < 0

-- ✅ Commit if all steps succeed
COMMIT;

-- ❌ Delete order if payment fails (simulate for order_id = 2)
 UPDATE Orders SET payment_status = 'Failed' WHERE order_id = 2;
 DELETE FROM OrderItems WHERE order_id = 2;
DELETE FROM Orders WHERE order_id = 2;