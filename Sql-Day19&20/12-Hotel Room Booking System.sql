-- Create the database
CREATE DATABASE IF NOT EXISTS HotelDB;
USE HotelDB;

-- Drop tables if they already exist (for reusability)
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Guests;
DROP TABLE IF EXISTS Rooms;

-- Create Rooms table
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY,
    RoomType VARCHAR(50),
    Capacity INT,
    PricePerNight DECIMAL(10,2)
);

-- Create Guests table
CREATE TABLE Guests (
    GuestID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

-- Create Bookings table
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    RoomID INT,
    GuestID INT,
    CheckInDate DATE,
    CheckOutDate DATE,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID)
);

-- Insert sample rooms
INSERT INTO Rooms VALUES
(1, 'Single', 1, 50.00),
(2, 'Double', 2, 80.00),
(3, 'Suite', 4, 150.00),
(4, 'Deluxe', 3, 120.00);

-- Insert sample guests
INSERT INTO Guests VALUES
(101, 'Aarav Mehta', 'aarav@example.com'),
(102, 'Diya Sharma', 'diya@example.com'),
(103, 'Rohan Iyer', 'rohan@example.com');

-- Insert sample bookings
INSERT INTO Bookings (RoomID, GuestID, CheckInDate, CheckOutDate) VALUES
(1, 101, '2025-07-01', '2025-07-03'),
(2, 102, '2025-07-02', '2025-07-05'),
(3, 101, '2025-07-10', '2025-07-12'),
(1, 103, '2025-07-05', '2025-07-07'),
(2, 101, '2025-07-15', '2025-07-18'),
(4, 101, '2025-07-20', '2025-07-22');

-- Query 1: Find available rooms for a given date (e.g., 2025-07-02)
SELECT RoomID, RoomType, Capacity, PricePerNight
FROM Rooms
WHERE RoomID NOT IN (
    SELECT RoomID
    FROM Bookings
    WHERE '2025-07-02' BETWEEN CheckInDate AND DATE_SUB(CheckOutDate, INTERVAL 1 DAY)
);

-- Query 2: List guests with more than 3 bookings
SELECT G.Name, COUNT(*) AS TotalBookings
FROM Bookings B
JOIN Guests G ON B.GuestID = G.GuestID
GROUP BY B.GuestID
HAVING TotalBookings > 3;