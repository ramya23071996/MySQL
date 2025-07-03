-- Create the database
CREATE DATABASE IF NOT EXISTS VehicleServiceDB;
USE VehicleServiceDB;

-- Drop tables if they already exist
DROP TABLE IF EXISTS ServiceRecords;
DROP TABLE IF EXISTS Services;
DROP TABLE IF EXISTS Vehicles;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Phone VARCHAR(15)
);

-- Create Vehicles table
CREATE TABLE Vehicles (
    VehicleID INT PRIMARY KEY,
    CustomerID INT,
    LicensePlate VARCHAR(20),
    Model VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create Services table
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100),
    Cost DECIMAL(10,2)
);

-- Create ServiceRecords table
CREATE TABLE ServiceRecords (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleID INT,
    ServiceID INT,
    ServiceDate DATE,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

-- Insert sample customers
INSERT INTO Customers VALUES
(1, 'Aarav Mehta', '9876543210'),
(2, 'Diya Sharma', '9123456780'),
(3, 'Rohan Iyer', '9988776655');

-- Insert sample vehicles
INSERT INTO Vehicles VALUES
(101, 1, 'TN01AB1234', 'Hyundai i20'),
(102, 2, 'KA05CD5678', 'Honda City'),
(103, 3, 'MH12EF9012', 'Toyota Innova');

-- Insert sample services
INSERT INTO Services VALUES
(1, 'Oil Change', 500.00),
(2, 'Brake Inspection', 300.00),
(3, 'Engine Tuning', 1200.00),
(4, 'Tire Rotation', 400.00);

-- Insert sample service records
INSERT INTO ServiceRecords (VehicleID, ServiceID, ServiceDate) VALUES
(101, 1, '2025-06-01'),
(101, 2, '2025-06-15'),
(101, 3, '2025-07-01'),
(102, 1, '2025-06-20'),
(102, 4, '2025-07-02'),
(103, 2, '2025-05-10'),
(103, 3, '2025-07-01'),
(103, 1, '2025-07-03');

-- Query 1: Vehicles serviced in the last month
SELECT V.LicensePlate, V.Model, SR.ServiceDate, S.ServiceName
FROM ServiceRecords SR
JOIN Vehicles V ON SR.VehicleID = V.VehicleID
JOIN Services S ON SR.ServiceID = S.ServiceID
WHERE SR.ServiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- Query 2: Customers with more than 2 services in the current year
SELECT C.Name, COUNT(*) AS ServiceCount
FROM ServiceRecords SR
JOIN Vehicles V ON SR.VehicleID = V.VehicleID
JOIN Customers C ON V.CustomerID = C.CustomerID
WHERE YEAR(SR.ServiceDate) = YEAR(CURDATE())
GROUP BY C.CustomerID
HAVING ServiceCount > 2;