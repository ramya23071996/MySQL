-- 1. Create Database
CREATE DATABASE qr_entry_log;
USE qr_entry_log;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Locations Table
CREATE TABLE locations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Entry Logs Table
CREATE TABLE entry_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    location_id INT,
    entry_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
);

-- 5. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Sample Locations
INSERT INTO locations (name) VALUES
('Main Office'), ('IT Lab'), ('Conference Room'), ('Cafeteria'), ('Reception');

-- 7. Sample Entry Logs
INSERT INTO entry_logs (user_id, location_id, entry_time) VALUES
(1, 1, '2025-07-21 08:50:00'),
(2, 2, '2025-07-21 09:10:00'),
(3, 3, '2025-07-21 09:30:00'),
(1, 4, '2025-07-21 12:15:00'),
(4, 1, '2025-07-21 13:00:00'),
(5, 2, '2025-07-21 14:20:00'),
(1, 1, '2025-07-22 08:45:00'),
(2, 3, '2025-07-22 09:25:00'),
(3, 2, '2025-07-22 10:10:00'),
(5, 5, '2025-07-22 11:55:00');

-- 8. Query: Count of Entries Per Location
SELECT 
    l.name AS location,
    COUNT(e.id) AS entry_count
FROM entry_logs e
JOIN locations l ON e.location_id = l.id
GROUP BY l.name
ORDER BY entry_count DESC;

-- 9. Query: Entries on Specific Date (e.g., July 21)
SELECT 
    u.name AS user,
    l.name AS location,
    e.entry_time
FROM entry_logs e
JOIN users u ON e.user_id = u.id
JOIN locations l ON e.location_id = l.id
WHERE DATE(e.entry_time) = '2025-07-21'
ORDER BY e.entry_time;

-- 10. Query: Entry History for User 'Ramya'
SELECT 
    l.name AS location,
    e.entry_time
FROM entry_logs e
JOIN users u ON e.user_id = u.id
JOIN locations l ON e.location_id = l.id
WHERE u.name = 'Ramya'
ORDER BY e.entry_time DESC;