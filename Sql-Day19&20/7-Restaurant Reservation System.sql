CREATE DATABASE RestaurantDB;
USE RestaurantDB;

-- Tables in the restaurant
CREATE TABLE Tables (
    TableID INT PRIMARY KEY,
    Capacity INT
);

-- Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Phone VARCHAR(15)
);

-- Reservations
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    TableID INT,
    CustomerID INT,
    ReservationDate DATE,
    ReservationTime TIME,
    FOREIGN KEY (TableID) REFERENCES Tables(TableID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Tables
INSERT INTO Tables VALUES
(1, 2),
(2, 4),
(3, 4),
(4, 6),
(5, 2);

-- Customers
INSERT INTO Customers VALUES
(101, 'Aarav Mehta', '9876543210'),
(102, 'Diya Sharma', '9123456780'),
(103, 'Rohan Iyer', '9988776655');

-- Reservations
INSERT INTO Reservations (TableID, CustomerID, ReservationDate, ReservationTime) VALUES
(1, 101, '2025-07-05', '19:00:00'),
(2, 102, '2025-07-05', '19:00:00'),
(3, 101, '2025-07-06', '20:00:00'),
(4, 103, '2025-07-05', '21:00:00'),
(2, 101, '2025-07-07', '18:30:00');

SELECT TableID, Capacity
FROM Tables
WHERE TableID NOT IN (
    SELECT TableID
    FROM Reservations
    WHERE ReservationDate = '2025-07-05' AND ReservationTime = '19:00:00'
);

SELECT TableID, Capacity
FROM Tables
WHERE TableID NOT IN (
    SELECT TableID
    FROM Reservations
    WHERE ReservationDate = '2025-07-05' AND ReservationTime = '19:00:00'
);