-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS TicketBookingSystem;
USE TicketBookingSystem;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Cities table (lookup)
CREATE TABLE IF NOT EXISTS Cities (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(100)
);

-- Routes table
CREATE TABLE IF NOT EXISTS Routes (
    route_id INT PRIMARY KEY,
    origin_city_id INT,
    destination_city_id INT,
    duration_minutes INT,
    FOREIGN KEY (origin_city_id) REFERENCES Cities(city_id),
    FOREIGN KEY (destination_city_id) REFERENCES Cities(city_id)
);

-- Vehicles table
CREATE TABLE IF NOT EXISTS Vehicles (
    vehicle_id INT PRIMARY KEY,
    vehicle_type VARCHAR(50),
    capacity INT
);

-- Passengers table
CREATE TABLE IF NOT EXISTS Passengers (
    passenger_id INT PRIMARY KEY,
    passenger_name VARCHAR(100),
    gender VARCHAR(10)
);

-- Bookings table
CREATE TABLE IF NOT EXISTS Bookings (
    booking_id INT PRIMARY KEY,
    passenger_id INT,
    route_id INT,
    vehicle_id INT,
    booking_date DATE,
    seat_number INT,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Cities
INSERT INTO Cities VALUES
(1, 'Chennai'), (2, 'Bangalore'), (3, 'Hyderabad'), (4, 'Mumbai');

-- Routes
INSERT INTO Routes VALUES
(101, 1, 2, 360), (102, 2, 3, 480), (103, 3, 4, 600);

-- Vehicles
INSERT INTO Vehicles VALUES
(1, 'Bus', 40), (2, 'Train', 100);

-- Passengers
INSERT INTO Passengers VALUES
(1, 'Ramya', 'Female'), (2, 'Arjun', 'Male'), (3, 'Priya', 'Female');

-- Bookings
INSERT INTO Bookings VALUES
(1, 1, 101, 1, '2024-07-01', 5),
(2, 2, 101, 1, '2024-07-01', 6),
(3, 3, 102, 2, '2024-07-02', 10),
(4, 1, 103, 2, '2024-07-03', 15);

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_route_id ON Bookings(route_id);
CREATE INDEX idx_booking_date ON Bookings(booking_date);
CREATE INDEX idx_passenger_name ON Passengers(passenger_name);

-- ============================================
-- 4. EXPLAIN FILTERED QUERY: NEXT AVAILABLE TRIPS
-- ============================================

EXPLAIN
SELECT r.route_id, c1.city_name AS origin, c2.city_name AS destination, r.duration_minutes
FROM Routes r
JOIN Cities c1 ON r.origin_city_id = c1.city_id
JOIN Cities c2 ON r.destination_city_id = c2.city_id
WHERE r.route_id NOT IN (
    SELECT route_id FROM Bookings WHERE booking_date = CURDATE()
);

-- ============================================
-- 5. DENORMALIZED FLAT TABLE FOR SCHEDULE DISPLAY
-- ============================================

CREATE TABLE IF NOT EXISTS ScheduleDisplay (
    booking_id INT PRIMARY KEY,
    passenger_name VARCHAR(100),
    origin VARCHAR(100),
    destination VARCHAR(100),
    vehicle_type VARCHAR(50),
    booking_date DATE,
    seat_number INT
);

-- Insert denormalized data
INSERT INTO ScheduleDisplay
SELECT 
    b.booking_id,
    p.passenger_name,
    c1.city_name AS origin,
    c2.city_name AS destination,
    v.vehicle_type,
    b.booking_date,
    b.seat_number
FROM Bookings b
JOIN Passengers p ON b.passenger_id = p.passenger_id
JOIN Routes r ON b.route_id = r.route_id
JOIN Cities c1 ON r.origin_city_id = c1.city_id
JOIN Cities c2 ON r.destination_city_id = c2.city_id
JOIN Vehicles v ON b.vehicle_id = v.vehicle_id;

-- View schedule
SELECT * FROM ScheduleDisplay;

-- ============================================
-- 6. PAGINATION: AVAILABLE SEATS PER VEHICLE
-- ============================================

-- Example: Show 5 available seats for vehicle_id = 1 on a specific route and date
SELECT seat_number
FROM (
    SELECT seat_number
    FROM Bookings
    WHERE vehicle_id = 1 AND route_id = 101 AND booking_date = '2024-07-01'
) AS booked_seats
RIGHT JOIN (
    SELECT number AS seat_number
    FROM (
        SELECT ROW_NUMBER() OVER () AS number
        FROM information_schema.columns LIMIT 40
    ) AS seats
) AS all_seats ON booked_seats.seat_number = all_seats.seat_number
WHERE booked_seats.seat_number IS NULL
LIMIT 5;