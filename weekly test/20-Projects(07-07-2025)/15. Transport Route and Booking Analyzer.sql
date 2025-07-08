-- 🚌 Create Database and Tables
CREATE DATABASE IF NOT EXISTS TransportDB;
USE TransportDB;

-- Routes table
CREATE TABLE Routes (
    route_id INT PRIMARY KEY,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL
);

-- Buses table
CREATE TABLE Buses (
    bus_id INT PRIMARY KEY,
    route_id INT,
    bus_number VARCHAR(50) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);

-- Bookings table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    bus_id INT,
    passenger_name VARCHAR(100) NOT NULL,
    booking_date DATE NOT NULL,
    FOREIGN KEY (bus_id) REFERENCES Buses(bus_id)
);

-- 📝 Insert Sample Data
INSERT INTO Routes VALUES 
(1, 'Chennai', 'Bangalore'),
(2, 'Chennai', 'Coimbatore'),
(3, 'Bangalore', 'Hyderabad');

INSERT INTO Buses VALUES 
(101, 1, 'TN01AB1234', TRUE),
(102, 2, 'TN02CD5678', TRUE),
(103, 3, 'KA01EF9012', TRUE);

INSERT INTO Bookings VALUES 
(1001, 101, 'Ramya', '2025-07-10'),
(1002, 101, 'Arun', '2025-07-10'),
(1003, 102, 'Priya', '2025-07-11'),
(1004, 101, 'Kiran', '2025-07-12'),
(1005, 103, 'Divya', '2025-07-12');

-- 📊 Route-wise Booking Count
SELECT 
    r.route_id,
    CONCAT(r.origin, ' to ', r.destination) AS route_name,
    COUNT(bk.booking_id) AS total_bookings
FROM Routes r
JOIN Buses b ON r.route_id = b.route_id
JOIN Bookings bk ON b.bus_id = bk.bus_id
GROUP BY r.route_id, r.origin, r.destination;

-- 🏆 Most Booked Route (Using Subquery)
SELECT 
    route_id,
    route_name,
    total_bookings
FROM (
    SELECT 
        r.route_id,
        CONCAT(r.origin, ' to ', r.destination) AS route_name,
        COUNT(bk.booking_id) AS total_bookings
    FROM Routes r
    JOIN Buses b ON r.route_id = b.route_id
    JOIN Bookings bk ON b.bus_id = bk.bus_id
    GROUP BY r.route_id, r.origin, r.destination
) AS route_summary
WHERE total_bookings = (
    SELECT MAX(total_bookings)
    FROM (
        SELECT COUNT(bk.booking_id) AS total_bookings
        FROM Buses b
        JOIN Bookings bk ON b.bus_id = bk.bus_id
        GROUP BY b.route_id
    ) AS counts
);

-- 📋 Full Booking Summary with JOIN
SELECT 
    bk.booking_id,
    bk.passenger_name,
    bk.booking_date,
    b.bus_number,
    CONCAT(r.origin, ' to ', r.destination) AS route
FROM Bookings bk
JOIN Buses b ON bk.bus_id = b.bus_id
JOIN Routes r ON b.route_id = r.route_id
ORDER BY bk.booking_date;

-- ❌ Cancel Trip with DELETE and ROLLBACK if Bus Not Available
-- Example: Cancel booking 1003 (bus_id = 102)

START TRANSACTION;

-- Step 1: Check if bus is available
SELECT is_available FROM Buses WHERE bus_id = 102;

-- Step 2: If available, delete booking
DELETE FROM Bookings WHERE booking_id = 1003;

-- Optional: simulate error
UPDATE Buses SET is_available = 'maybe' WHERE bus_id = 102;

-- If all good
COMMIT;

-- If error occurs
ROLLBACK;