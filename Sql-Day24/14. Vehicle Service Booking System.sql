-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS VehicleService;
USE VehicleService;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Customers table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Vehicles table
CREATE TABLE IF NOT EXISTS Vehicles (
    vehicle_id INT PRIMARY KEY,
    customer_id INT,
    license_plate VARCHAR(20),
    model VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Services table
CREATE TABLE IF NOT EXISTS Services (
    service_id INT PRIMARY KEY,
    service_name VARCHAR(100),
    cost DECIMAL(10,2)
);

-- Bookings table
CREATE TABLE IF NOT EXISTS Bookings (
    booking_id INT PRIMARY KEY,
    vehicle_id INT,
    service_id INT,
    service_date DATE,
    notes TEXT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Customers
INSERT INTO Customers VALUES
(1, 'Alice', '9876543210'),
(2, 'Bob', '9123456780');

-- Vehicles
INSERT INTO Vehicles VALUES
(101, 1, 'TN01AB1234', 'Hyundai i20'),
(102, 2, 'KA05CD5678', 'Honda City');

-- Services
INSERT INTO Services VALUES
(1, 'Oil Change', 1500.00),
(2, 'Brake Inspection', 1000.00),
(3, 'Full Service', 3000.00);

-- Bookings
INSERT INTO Bookings VALUES
(1, 101, 1, '2024-07-01', 'Routine oil change'),
(2, 101, 2, '2024-07-10', 'Brake check'),
(3, 101, 3, '2024-07-20', 'Full service'),
(4, 102, 1, '2024-07-05', 'Oil change'),
(5, 102, 3, '2024-07-15', 'Full service');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_vehicle_id ON Bookings(vehicle_id);
CREATE INDEX idx_service_date ON Bookings(service_date);
CREATE INDEX idx_customer_name ON Customers(customer_name);

-- ============================================
-- 4. EXPLAIN + JOIN FOR SERVICE HISTORY
-- ============================================

EXPLAIN
SELECT c.customer_name, v.license_plate, s.service_name, b.service_date
FROM Bookings b
JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
JOIN Customers c ON v.customer_id = c.customer_id
JOIN Services s ON b.service_id = s.service_id
WHERE c.customer_name = 'Alice'
ORDER BY b.service_date DESC;

-- ============================================
-- 5. DENORMALIZED SERVICE HISTORY REPORT
-- ============================================

CREATE OR REPLACE VIEW ServiceHistoryReport AS
SELECT 
    b.booking_id,
    c.customer_name,
    v.license_plate,
    v.model,
    s.service_name,
    b.service_date,
    b.notes
FROM Bookings b
JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
JOIN Customers c ON v.customer_id = c.customer_id
JOIN Services s ON b.service_id = s.service_id;

-- View usage example
SELECT * FROM ServiceHistoryReport WHERE customer_name = 'Bob';

-- ============================================
-- 6. LAST 5 SERVICES PER CUSTOMER USING LIMIT
-- ============================================

-- Example: Last 5 services for Alice
SELECT * FROM ServiceHistoryReport
WHERE customer_name = 'Alice'
ORDER BY service_date DESC
LIMIT 5;