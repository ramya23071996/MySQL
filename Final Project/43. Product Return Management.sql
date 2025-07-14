-- 1. Create Database
CREATE DATABASE product_returns;
USE product_returns;

-- 2. Orders Table
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT
);

-- 3. Returns Table
CREATE TABLE returns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    reason VARCHAR(255),
    status ENUM('Requested', 'Processing', 'Completed', 'Rejected') NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 4. Sample Orders
INSERT INTO orders (user_id, product_id) VALUES
(1, 101),
(2, 102),
(3, 103),
(1, 104),
(4, 105);

-- 5. Sample Returns
INSERT INTO returns (order_id, reason, status) VALUES
(1, 'Wrong size', 'Requested'),
(2, 'Damaged item', 'Processing'),
(3, 'Color mismatch', 'Completed'),
(4, 'Late delivery', 'Rejected');

-- Full Return Log with Order Info
SELECT 
    r.id AS return_id,
    r.status,
    r.reason,
    o.id AS order_id,
    o.user_id,
    o.product_id
FROM returns r
JOIN orders o ON r.order_id = o.id
ORDER BY r.id;

-- Return Request Count by Status
SELECT 
    status,
    COUNT(*) AS total_requests
FROM returns
GROUP BY status;

-- Orders Without Return Requests
SELECT 
    o.id AS order_id,
    o.user_id,
    o.product_id
FROM orders o
LEFT JOIN returns r ON o.id = r.order_id
WHERE r.id IS NULL;
