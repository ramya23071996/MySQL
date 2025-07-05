-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Outward;
DROP TABLE IF EXISTS Inward;
DROP TABLE IF EXISTS Items;

-- 📦 Create Items table
CREATE TABLE Items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    expiry_date DATE
);

-- 📥 Create Inward table
CREATE TABLE Inward (
    inward_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    received_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (item_id) REFERENCES Items(item_id)
);

-- 📤 Create Outward table
CREATE TABLE Outward (
    outward_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dispatched_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (item_id) REFERENCES Items(item_id)
);

-- 🧾 Insert sample items
INSERT INTO Items (item_name, stock, expiry_date) VALUES
('Steel Rods', 100, '2026-12-31'),
('Plastic Sheets', 200, '2025-11-30'),
('Copper Wires', 150, '2027-01-15');

-- 🔄 Batch stock update using transaction
START TRANSACTION;

-- Step 1: Inward movement
INSERT INTO Inward (item_id, quantity) VALUES (1, 50);
UPDATE Items SET stock = stock + 50 WHERE item_id = 1;

INSERT INTO Inward (item_id, quantity) VALUES (2, 30);
UPDATE Items SET stock = stock + 30 WHERE item_id = 2;

-- Step 2: Outward movement
INSERT INTO Outward (item_id, quantity) VALUES (3, 20);
UPDATE Items SET stock = stock - 20 WHERE item_id = 3;

-- Optional: Simulate failure
UPDATE Items SET stock = -10 WHERE item_id = 1; -- Will fail CHECK

-- ✅ Commit if all successful
COMMIT;

-- ❌ Delete damaged or expired stock
DELETE FROM Items
WHERE expiry_date < CURDATE();

-- Optionally, delete items with zero or negative stock (if allowed)
 DELETE FROM Items WHERE stock <= 0;