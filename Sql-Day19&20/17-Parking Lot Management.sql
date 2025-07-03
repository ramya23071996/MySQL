-- Create the database
CREATE DATABASE IF NOT EXISTS ParkingDB;
USE ParkingDB;

-- Drop tables if they already exist
DROP TABLE IF EXISTS ParkingRecords;
DROP TABLE IF EXISTS Vehicles;
DROP TABLE IF EXISTS Lots;

-- Create Lots table
CREATE TABLE Lots (
    LotID INT PRIMARY KEY,
    LotName VARCHAR(100),
    Capacity INT
);

-- Create Vehicles table
CREATE TABLE Vehicles (
    VehicleID INT PRIMARY KEY,
    LicensePlate VARCHAR(20),
    OwnerName VARCHAR(100)
);

-- Create ParkingRecords table
CREATE TABLE ParkingRecords (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleID INT,
    LotID INT,
    EntryTime DATETIME,
    ExitTime DATETIME,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
    FOREIGN KEY (LotID) REFERENCES Lots(LotID)
);

-- Insert sample lots
INSERT INTO Lots VALUES
(1, 'Lot A', 2),
(2, 'Lot B', 3),
(3, 'Lot C', 1);

-- Insert sample vehicles
INSERT INTO Vehicles VALUES
(101, 'TN01AB1234', 'Aarav Mehta'),
(102, 'KA05CD5678', 'Diya Sharma'),
(103, 'MH12EF9012', 'Rohan Iyer'),
(104, 'DL08GH3456', 'Sneha Reddy');

-- Insert sample parking records
INSERT INTO ParkingRecords (VehicleID, LotID, EntryTime, ExitTime) VALUES
(101, 1, '2025-07-01 08:00:00', NULL),
(102, 1, '2025-07-01 08:30:00', NULL),
(103, 2, '2025-07-01 09:00:00', '2025-07-01 11:00:00'),
(104, 3, '2025-07-01 09:15:00', NULL);

-- Query 1: Find currently parked vehicles (no ExitTime)
SELECT V.LicensePlate, V.OwnerName, L.LotName, PR.EntryTime
FROM ParkingRecords PR
JOIN Vehicles V ON PR.VehicleID = V.VehicleID
JOIN Lots L ON PR.LotID = L.LotID
WHERE PR.ExitTime IS NULL;

-- Query 2: List lots that are full (current occupancy = capacity)
SELECT L.LotID, L.LotName, L.Capacity, COUNT(PR.RecordID) AS CurrentOccupancy
FROM Lots L
JOIN ParkingRecords PR ON L.LotID = PR.LotID
WHERE PR.ExitTime IS NULL
GROUP BY L.LotID, L.LotName, L.Capacity
HAVING CurrentOccupancy >= L.Capacity;