-- 1. Create Hotel Booking Database
CREATE DATABASE hotel_booking;
USE hotel_booking;

-- 2. Rooms Table
CREATE TABLE rooms (
    id INT PRIMARY KEY AUTO_INCREMENT,
    number VARCHAR(10) NOT NULL UNIQUE,
    type ENUM('Single', 'Double', 'Suite') NOT NULL
);

-- 3. Guests Table
CREATE TABLE guests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Bookings Table
CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    room_id INT,
    guest_id INT,
    from_date DATE,
    to_date DATE,
    FOREIGN KEY (room_id) REFERENCES rooms(id),
    FOREIGN KEY (guest_id) REFERENCES guests(id),
    CONSTRAINT chk_dates CHECK (from_date < to_date)
);

-- 5. Sample Rooms
INSERT INTO rooms (number, type) VALUES
('101', 'Single'), ('102', 'Double'), ('103', 'Suite'),
('104', 'Single'), ('105', 'Double');

-- 6. Sample Guests
INSERT INTO guests (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 7. Sample Bookings
INSERT INTO bookings (room_id, guest_id, from_date, to_date) VALUES
(1, 1, '2025-07-15', '2025-07-17'),
(2, 2, '2025-07-16', '2025-07-18'),
(3, 3, '2025-07-15', '2025-07-20'),
(4, 4, '2025-07-17', '2025-07-19'),
(5, 5, '2025-07-16', '2025-07-18');

-- 8. Query: Find Available Rooms for Given Date Range
SELECT r.id, r.number, r.type
FROM rooms r
WHERE r.id NOT IN (
    SELECT room_id
    FROM bookings
    WHERE ('2025-07-16' < to_date AND '2025-07-18' > from_date)
);

-- 9. Query: Booking History for Ramya
SELECT 
    r.number AS room,
    r.type,
    b.from_date,
    b.to_date
FROM bookings b
JOIN rooms r ON b.room_id = r.id
JOIN guests g ON b.guest_id = g.id
WHERE g.name = 'Ramya'
ORDER BY b.from_date;

-- 10. Query: Current Bookings on July 17, 2025
SELECT 
    g.name AS guest,
    r.number AS room,
    b.from_date,
    b.to_date
FROM bookings b
JOIN rooms r ON b.room_id = r.id
JOIN guests g ON b.guest_id = g.id
WHERE '2025-07-17' BETWEEN b.from_date AND b.to_date;