-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS MenuItems;

-- 🏗️ Create MenuItems table
CREATE TABLE MenuItems (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    is_available BOOLEAN DEFAULT TRUE
);

-- 🏗️ Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    table_number INT NOT NULL,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    kitchen_status VARCHAR(20) DEFAULT 'Pending' -- e.g., Pending, In Progress, Served
);

-- 🏗️ Create OrderItems table
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

-- 🍲 Insert sample menu items
INSERT INTO MenuItems (item_name, price) VALUES
('Margherita Pizza', 299.00),
('Paneer Tikka', 199.00),
('Cold Coffee', 99.00),
('Veg Biryani', 249.00);

-- 🔄 Place a full meal order using a transaction (atomicity)
START TRANSACTION;

-- Step 1: Create a new order for table 5
INSERT INTO Orders (table_number, kitchen_status) VALUES (5, 'Pending');
SET @order_id = LAST_INSERT_ID();

-- Step 2: Add multiple items to the order
INSERT INTO OrderItems (order_id, item_id, quantity) VALUES
(@order_id, 1, 1),  -- 1 Margherita Pizza
(@order_id, 2, 2),  -- 2 Paneer Tikka
(@order_id, 3, 1);  -- 1 Cold Coffee

-- Optional: Simulate failure (e.g., unavailable item)
-- INSERT INTO OrderItems (order_id, item_id, quantity) VALUES (@order_id, 999, 1); -- Invalid item_id

-- ✅ Commit if all successful
COMMIT;

-- ✏️ Update kitchen status
UPDATE Orders
SET kitchen_status = 'In Progress'
WHERE order_id = @order_id;

-- Later...
UPDATE Orders
SET kitchen_status = 'Served'
WHERE order_id = @order_id;

-- ❌ Delete a cancelled order (e.g., order_id = 2)
DELETE FROM OrderItems WHERE order_id = 2;
DELETE FROM Orders WHERE order_id = 2;