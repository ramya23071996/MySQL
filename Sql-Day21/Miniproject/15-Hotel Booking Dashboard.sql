-- Drop tables if they already exist
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS guests;
DROP TABLE IF EXISTS rooms;

-- 1. Create Tables

CREATE TABLE rooms (
    room_id INT PRIMARY KEY,
    room_number VARCHAR(10),
    room_type VARCHAR(50)
);

CREATE TABLE guests (
    guest_id INT PRIMARY KEY,
    guest_name VARCHAR(100)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    room_id INT,
    guest_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id)
);

-- 2. Insert Sample Data

-- Rooms
INSERT INTO rooms (room_id, room_number, room_type) VALUES
(1, '101', 'Deluxe'),
(2, '102', 'Standard'),
(3, '103', 'Suite'),
(4, '104', 'Standard');

-- Guests
INSERT INTO guests (guest_id, guest_name) VALUES
(201, 'Aarav'),
(202, 'Bhavya'),
(203, 'Chirag');

-- Bookings
INSERT INTO bookings (booking_id, room_id, guest_id, check_in, check_out) VALUES
(1001, 1, 201, '2025-07-01', '2025-07-03'),
(1002, 2, 202, '2025-07-02', '2025-07-05'),
(1003, 1, 203, '2025-07-06', '2025-07-08'),
(1004, 2, 201, '2025-07-10', '2025-07-12');

-- 3. Calculate Occupancy Rates per Room
-- Assuming July 2025 has 31 days
SELECT 
    r.room_number,
    r.room_type,
    SUM(DATEDIFF(b.check_out, b.check_in)) AS total_days_booked,
    ROUND(SUM(DATEDIFF(b.check_out, b.check_in)) / 31 * 100, 2) AS occupancy_rate_percent
FROM rooms r
LEFT JOIN bookings b ON r.room_id = b.room_id
GROUP BY r.room_id, r.room_number, r.room_type;

-- 4. Find Guests with Multiple Bookings
SELECT 
    g.guest_name,
    COUNT(b.booking_id) AS booking_count
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.guest_name
HAVING booking_count > 1;

-- 5. List Rooms Never Booked
SELECT 
    r.room_number,
    r.room_type
FROM rooms r
LEFT JOIN bookings b ON r.room_id = b.room_id
WHERE b.booking_id IS NULL;