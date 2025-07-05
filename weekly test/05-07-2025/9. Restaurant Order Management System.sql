--  Drop existing tables if they exist
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS MenuItems;

--  Create MenuItems table
CREATE TABLE MenuItems (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0)
);

--  Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

--  Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

--  Create OrderDetails table
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

--  Insert sample menu items
INSERT INTO MenuItems (item_name, price) VALUES
('Margherita Pizza', 299.00),
('Pasta Alfredo', 349.00),
('Cold Coffee', 99.00),
('Garlic Bread', 149.00);

--  Insert sample customers
INSERT INTO Customers (name, email) VALUES
('Ravi Kapoor', 'ravi.kapoor@example.com'),
('Sneha Iyer', 'sneha.iyer@example.com');

--  Place an order using transaction
START TRANSACTION;

-- Step 1: Create order
INSERT INTO Orders (customer_id) VALUES (1);
SET @order_id = LAST_INSERT_ID();

-- Step 2: Add order details
INSERT INTO OrderDetails (order_id, item_id, quantity) VALUES
(@order_id, 1, 2),  -- 2 Pizzas
(@order_id, 4, 1);  -- 1 Garlic Bread

-- ✅ Commit the order
COMMIT;

-- JOIN: Get full order details
SELECT 
    o.order_id,
    c.name AS customer_name,
    m.item_name,
    od.quantity,
    m.price,
    (od.quantity * m.price) AS item_total
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN MenuItems m ON od.item_id = m.item_id;

-- 💰 Calculate total bill per order
SELECT 
    o.order_id,
    c.name AS customer_name,
    SUM(od.quantity * m.price) AS total_bill
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN MenuItems m ON od.item_id = m.item_id
GROUP BY o.order_id, c.name;

-- 📊 HAVING: Find high-value customers (total bill > ₹500)
SELECT 
    c.customer_id,
    c.name,
    SUM(od.quantity * m.price) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN MenuItems m ON od.item_id = m.item_id
GROUP BY c.customer_id, c.name
HAVING total_spent > 500;

-- Cancel an order using transaction
START TRANSACTION;

-- Step 1: Delete order details
DELETE FROM OrderDetails WHERE order_id = 1;

-- Step 2: Delete the order
DELETE FROM Orders WHERE order_id = 1;

-- Commit cancellation
COMMIT;