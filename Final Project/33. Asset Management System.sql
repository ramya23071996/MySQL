-- 1. Create Database
CREATE DATABASE asset_manager;
USE asset_manager;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Assets Table
CREATE TABLE assets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL
);

-- 4. Assignments Table (Tracks usage history)
CREATE TABLE assignments (
    asset_id INT,
    user_id INT,
    assigned_date DATE,
    returned_date DATE,
    PRIMARY KEY (asset_id, assigned_date),
    FOREIGN KEY (asset_id) REFERENCES assets(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Sample Assets
INSERT INTO assets (name, category) VALUES
('Dell Laptop XPS', 'Laptop'),
('HP LaserJet Pro', 'Printer'),
('Logitech Mouse', 'Peripheral'),
('Apple MacBook Air', 'Laptop'),
('Samsung Monitor 27"', 'Display');

-- 7. Sample Assignments
INSERT INTO assignments (asset_id, user_id, assigned_date, returned_date) VALUES
(1, 1, '2025-07-01', '2025-07-10'),
(2, 2, '2025-07-05', NULL),
(3, 3, '2025-07-06', '2025-07-12'),
(4, 4, '2025-07-08', NULL),
(5, 5, '2025-07-09', '2025-07-18'),
(1, 2, '2025-07-11', NULL);

-- 8. Query: Current Assigned Assets
SELECT 
    a.name AS asset,
    a.category,
    u.name AS user,
    asn.assigned_date
FROM assignments asn
JOIN assets a ON asn.asset_id = a.id
JOIN users u ON asn.user_id = u.id
WHERE asn.returned_date IS NULL
ORDER BY asn.assigned_date;

-- 9. Query: Asset Assignment History
SELECT 
    a.name AS asset,
    u.name AS user,
    asn.assigned_date,
    asn.returned_date
FROM assignments asn
JOIN assets a ON asn.asset_id = a.id
JOIN users u ON asn.user_id = u.id
ORDER BY a.name, asn.assigned_date;

-- 10. Query: Available Assets
SELECT a.id, a.name, a.category
FROM assets a
WHERE a.id NOT IN (
    SELECT asset_id FROM assignments WHERE returned_date IS NULL
);

-- 11. Query: Assets Assigned to Ramya (Current Only)
SELECT 
    a.name AS asset,
    a.category,
    asn.assigned_date
FROM assignments asn
JOIN assets a ON asn.asset_id = a.id
JOIN users u ON asn.user_id = u.id
WHERE u.name = 'Ramya' AND asn.returned_date IS NULL;