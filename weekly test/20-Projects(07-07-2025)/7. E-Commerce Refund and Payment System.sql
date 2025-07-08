-- 🛍️ Create Database and Tables
CREATE DATABASE IF NOT EXISTS ECommerceDB;
USE ECommerceDB;

-- Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Completed'
);

-- Payments table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Refunds table
CREATE TABLE Refunds (
    refund_id INT PRIMARY KEY,
    order_id INT,
    refund_date DATE NOT NULL,
    refund_amount DECIMAL(10,2) NOT NULL,
    reason VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- 📝 Insert Sample Data
INSERT INTO Orders VALUES 
(1001, 'Ramya', '2025-07-01', 1500.00, 'Completed'),
(1002, 'Arun', '2025-07-02', 2500.00, 'Completed'),
(1003, 'Priya', '2025-07-03', 1800.00, 'Completed');

INSERT INTO Payments VALUES 
(201, 1001, '2025-07-01', 'Credit Card'),
(202, 1002, '2025-07-02', 'UPI'),
(203, 1003, '2025-07-03', 'Net Banking');

-- 🔍 Subquery: Check Refund Eligibility (e.g., within 7 days)
SELECT * FROM Orders
WHERE order_date >= CURDATE() - INTERVAL 7 DAY
AND status = 'Completed';

-- 🔁 Cancel Order and Insert Refund in One Transaction
-- Example: Cancel Order 1002

START TRANSACTION;

-- Step 1: Insert into Refunds
INSERT INTO Refunds (refund_id, order_id, refund_date, refund_amount, reason)
VALUES (301, 1002, CURDATE(), 2500.00, 'Customer Request');

-- Step 2: Delete the order (or update status)
DELETE FROM Orders WHERE order_id = 1002;

-- Optional: Simulate error
-- UPDATE Orders SET amount = 'invalid' WHERE order_id = 1001;

-- If all good
COMMIT;

-- If error occurs
-- ROLLBACK;

-- 📋 JOIN: Complete Refund Summaries
SELECT r.refund_id, o.customer_name, r.refund_amount, r.refund_date, p.payment_method,
  CASE 
    WHEN r.reason LIKE '%delay%' THEN 'Logistics Issue'
    WHEN r.reason LIKE '%defect%' THEN 'Product Issue'
    WHEN r.reason LIKE '%request%' THEN 'Customer Request'
    ELSE 'Other'
  END AS refund_category
FROM Refunds r
JOIN Orders o ON r.order_id = o.order_id
JOIN Payments p ON r.order_id = p.order_id;
