--  Drop existing tables if they exist
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Rooms;

-- ️ Create Rooms table
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL CHECK (price_per_night > 0),
    is_available BOOLEAN DEFAULT TRUE
);

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15)
);

-- Create Bookings table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    CHECK (check_out > check_in)
);

-- Insert sample rooms
INSERT INTO Rooms (room_number, room_type, price_per_night) VALUES
('101', 'Deluxe', 3500.00),
('102', 'Standard', 2500.00),
('201', 'Suite', 5000.00);

-- Insert sample customers
INSERT INTO Customers (name, email, phone) VALUES
('Aarav Mehta', 'aarav@example.com', '9876543210'),
('Neha Sharma', 'neha@example.com', '9123456789');

-- Insert new booking and update room availability
START TRANSACTION;

-- Step 1: Insert booking
INSERT INTO Bookings (customer_id, room_id, check_in, check_out)
VALUES (1, 1, '2025-08-01', '2025-08-05');

-- Step 2: Mark room as unavailable
UPDATE Rooms SET is_available = FALSE WHERE room_id = 1;

-- Commit booking
COMMIT;

-- Use BETWEEN to filter bookings in August 2025
SELECT * FROM Bookings
WHERE check_in BETWEEN '2025-08-01' AND '2025-08-31';

--  Subquery: Check which rooms are currently booked
SELECT room_number
FROM Rooms
WHERE room_id IN (
    SELECT room_id FROM Bookings
    WHERE CURDATE() BETWEEN check_in AND check_out
);

-- ORDER BY check-in date
SELECT b.booking_id, c.name AS customer_name, r.room_number, b.check_in, b.check_out
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Rooms r ON b.room_id = r.room_id
ORDER BY b.check_in ASC;