-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS OrderFulfillment;
USE OrderFulfillment;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Customers table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

-- Products table
CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- Orders table
CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- OrderItems table
CREATE TABLE IF NOT EXISTS OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Shipments table
CREATE TABLE IF NOT EXISTS Shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT,
    shipment_status VARCHAR(50),
    dispatch_date DATE,
    delivery_date DATE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Customers
INSERT INTO Customers VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@example.com');

-- Products
INSERT INTO Products VALUES
(101, 'Laptop', 55000),
(102, 'Mouse', 1500),
(103, 'Keyboard', 2000);

-- Orders
INSERT INTO Orders VALUES
(1001, 1, '2024-07-01'),
(1002, 2, '2024-07-02');

-- OrderItems
INSERT INTO OrderItems VALUES
(1, 1001, 101, 1),
(2, 1001, 102, 2),
(3, 1002, 103, 1);

-- Shipments
INSERT INTO Shipments VALUES
(501, 1001, 'Dispatched', '2024-07-03', NULL),
(502, 1002, 'Pending', NULL, NULL);

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_order_date ON Orders(order_date);
CREATE INDEX idx_shipment_status ON Shipments(shipment_status);
CREATE INDEX idx_customer_id ON Orders(customer_id);

-- ============================================
-- 4. OPTIMIZE DISPATCH QUERIES WITH JOIN + EXPLAIN
-- ============================================

EXPLAIN
SELECT o.order_id, c.customer_name, s.shipment_status, s.dispatch_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Shipments s ON o.order_id = s.order_id
WHERE s.shipment_status = 'Dispatched';

-- ============================================
-- 5. DENORMALIZED VIEW FOR DELIVERY DASHBOARD
-- ============================================

CREATE OR REPLACE VIEW DeliveryDashboard AS
SELECT 
    o.order_id,
    c.customer_name,
    p.product_name,
    oi.quantity,
    s.shipment_status,
    s.dispatch_date,
    s.delivery_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Shipments s ON o.order_id = s.order_id;

-- View usage example
SELECT * FROM DeliveryDashboard;

-- ============================================
-- 6. LIMIT TO LOAD ONLY PENDING DELIVERIES
-- ============================================

SELECT * FROM DeliveryDashboard
WHERE shipment_status = 'Pending'
ORDER BY order_id DESC
LIMIT 5;