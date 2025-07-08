-- 🏨 Create Database and Tables
CREATE DATABASE IF NOT EXISTS HotelDB;
USE HotelDB;

-- Rooms table
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_type VARCHAR(50),
    price_per_night DECIMAL(10,2)
);

-- Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

-- Bookings table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    room_id INT,
    customer_id INT,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 📝 Insert Sample Data
INSERT INTO Rooms VALUES 
(1, 'Deluxe', 3500.00),
(2, 'Suite', 5000.00),
(3, 'Standard', 2500.00);

INSERT INTO Customers VALUES 
(101, 'Ramya'), (102, 'Arun'), (103, 'Priya');

INSERT INTO Bookings VALUES 
(1001, 1, 101, '2025-07-10', '2025-07-12', 'Confirmed'),
(1002, 2, 102, '2025-07-11', '2025-07-13', 'Confirmed');

-- 📅 Check for Overlapping Bookings (e.g., Room 1, new booking from 2025-07-11 to 2025-07-14)
SELECT * FROM Bookings
WHERE room_id = 1
  AND status = 'Confirmed'
  AND (
    ('2025-07-11' BETWEEN check_in AND check_out)
    OR ('2025-07-14' BETWEEN check_in AND check_out)
    OR (check_in BETWEEN '2025-07-11' AND '2025-07-14')
  );

-- ✅ If no overlap, insert new booking
-- (Assume validation passed)
INSERT INTO Bookings (booking_id, room_id, customer_id, check_in, check_out, status)
VALUES (1003, 1, 103, '2025-07-14', '2025-07-16', 'Confirmed');

-- ❌ Cancel a Booking with DELETE and ROLLBACK (e.g., cancel booking 1002)
START TRANSACTION;

-- Step 1: Delete booking
DELETE FROM Bookings WHERE booking_id = 1002;

-- Optional: simulate error
-- UPDATE Bookings SET status = 'Oops' WHERE booking_id = 9999;

-- If all good
COMMIT;

-- If error occurs
-- ROLLBACK;

-- 🏷️ Tag Booking Status with CASE
SELECT 
    b.booking_id,
    c.customer_name,
    r.room_type,
    b.check_in,
    b.check_out,
    b.status,
    CASE 
        WHEN b.status = 'Confirmed' THEN 'Active Booking'
        WHEN b.status = 'Cancelled' THEN 'Cancelled Booking'
        ELSE 'Unknown Status'
    END AS booking_tag
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Rooms r ON b.room_id = r.room_id;