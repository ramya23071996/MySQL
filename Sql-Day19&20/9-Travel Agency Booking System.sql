CREATE DATABASE TravelAgencyDB;
USE TravelAgencyDB;

-- Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

-- Trips table
CREATE TABLE Trips (
    TripID INT PRIMARY KEY,
    Destination VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    Price DECIMAL(10,2)
);

-- Bookings table
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    TripID INT,
    BookingDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TripID) REFERENCES Trips(TripID)
);

-- Customers
INSERT INTO Customers VALUES
(1, 'Aarav Mehta', 'aarav@example.com'),
(2, 'Diya Sharma', 'diya@example.com'),
(3, 'Rohan Iyer', 'rohan@example.com');

-- Trips
INSERT INTO Trips VALUES
(101, 'Paris', '2025-08-01', '2025-08-10', 1200.00),
(102, 'Tokyo', '2025-09-15', '2025-09-25', 1500.00),
(103, 'New York', '2025-10-05', '2025-10-15', 1300.00),
(104, 'Sydney', '2025-11-01', '2025-11-12', 1800.00);

-- Bookings
INSERT INTO Bookings (CustomerID, TripID, BookingDate) VALUES
(1, 101, '2025-06-01'),
(2, 102, '2025-06-15'),
(1, 103, '2025-06-20');

SELECT C.Name, T.Destination, T.StartDate, T.EndDate
FROM Bookings B
JOIN Customers C ON B.CustomerID = C.CustomerID
JOIN Trips T ON B.TripID = T.TripID
WHERE C.Name = 'Aarav Mehta';

SELECT T.Destination, T.StartDate, T.EndDate
FROM Trips T
WHERE T.TripID NOT IN (
    SELECT DISTINCT TripID FROM Bookings
);