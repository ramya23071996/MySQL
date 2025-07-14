-- 1. Create Database
CREATE DATABASE restaurant_reservation;
USE restaurant_reservation;

-- 2. Tables Table
CREATE TABLE tables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_number VARCHAR(10) NOT NULL UNIQUE,
    capacity INT NOT NULL
);

-- 3. Guests Table
CREATE TABLE guests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Reservations Table
CREATE TABLE reservations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    table_id INT,
    date DATE,
    time_slot TIME,
    FOREIGN KEY (guest_id) REFERENCES guests(id),
    FOREIGN KEY (table_id) REFERENCES tables(id)
);

-- 5. Sample Guests
INSERT INTO guests (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Sample Tables
INSERT INTO tables (table_number, capacity) VALUES
('T1', 4), ('T2', 2), ('T3', 6), ('T4', 4), ('T5', 8);

-- 7. Sample Reservations
INSERT INTO reservations (guest_id, table_id, date, time_slot) VALUES
(1, 1, '2025-07-26', '18:00:00'),
(2, 2, '2025-07-26', '18:30:00'),
(3, 3, '2025-07-26', '18:00:00'),
(4, 1, '2025-07-26', '18:00:00'), -- Overlap with Ramya on T1
(5, 5, '2025-07-26', '19:00:00');

-- Overlap Detection
SELECT 
    t.table_number,
    r.date,
    r.time_slot,
    COUNT(*) AS overlap_count
FROM reservations r
JOIN tables t ON r.table_id = t.id
GROUP BY r.table_id, r.date, r.time_slot
HAVING COUNT(*) > 1;

-- Daily Reservation Summary
SELECT 
    r.date,
    t.table_number,
    COUNT(*) AS total_reservations
FROM reservations r
JOIN tables t ON r.table_id = t.id
GROUP BY r.date, t.table_number
ORDER BY r.date, t.table_number;

-- Guest Reservation History
SELECT 
    g.name AS guest,
    r.date,
    r.time_slot,
    t.table_number
FROM reservations r
JOIN guests g ON r.guest_id = g.id
JOIN tables t ON r.table_id = t.id
ORDER BY g.name, r.date, r.time_slot;