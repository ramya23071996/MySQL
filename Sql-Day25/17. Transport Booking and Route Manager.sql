-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS TransportDB;
USE TransportDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Routes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    origin VARCHAR(100),
    destination VARCHAR(100),
    departure_time DATETIME,
    total_seats INT,
    internal_notes TEXT
);

CREATE TABLE IF NOT EXISTS Vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_number VARCHAR(20),
    capacity INT
);

CREATE TABLE IF NOT EXISTS Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT,
    customer_name VARCHAR(100),
    seats_booked INT,
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);

CREATE TABLE IF NOT EXISTS SeatStatus (
    route_id INT PRIMARY KEY,
    seats_booked INT DEFAULT 0,
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);

-- Step 3: Create views

-- View for customers to see available routes
CREATE OR REPLACE VIEW AvailableRoutesView AS
SELECT 
    r.route_id,
    r.origin,
    r.destination,
    r.departure_time,
    r.total_seats - IFNULL(s.seats_booked, 0) AS seats_available
FROM Routes r
LEFT JOIN SeatStatus s ON r.route_id = s.route_id
WHERE r.departure_time > NOW();

-- Abstracted view hiding internal notes
CREATE OR REPLACE VIEW PublicRouteView AS
SELECT 
    route_id,
    origin,
    destination,
    departure_time
FROM Routes;

-- Step 4: Create function to return seat availability
DELIMITER //
CREATE FUNCTION GetSeatAvailability(r_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE available INT;
    SELECT total_seats - IFNULL(seats_booked, 0)
    INTO available
    FROM Routes r
    LEFT JOIN SeatStatus s ON r.route_id = s.route_id
    WHERE r.route_id = r_id;
    RETURN IFNULL(available, 0);
END;
//
DELIMITER ;

-- Step 5: Create stored procedure to book seats
DELIMITER //
CREATE PROCEDURE BookSeats(
    IN r_id INT,
    IN cust_name VARCHAR(100),
    IN seats INT
)
BEGIN
    DECLARE available INT;
    SET available = GetSeatAvailability(r_id);

    IF available >= seats THEN
        INSERT INTO Bookings(route_id, customer_name, seats_booked)
        VALUES (r_id, cust_name, seats);

        UPDATE SeatStatus
        SET seats_booked = seats_booked + seats
        WHERE route_id = r_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough seats available.';
    END IF;
END;
//
DELIMITER ;

-- Step 6: Trigger to initialize seat status on route creation
DELIMITER //
CREATE TRIGGER InitSeatStatus
AFTER INSERT ON Routes
FOR EACH ROW
BEGIN
    INSERT INTO SeatStatus(route_id, seats_booked)
    VALUES (NEW.route_id, 0);
END;
//
DELIMITER ;

-- Step 7: Insert sample data

-- Insert routes
INSERT INTO Routes (origin, destination, departure_time, total_seats, internal_notes) VALUES
('Chennai', 'Bangalore', '2025-08-01 08:00:00', 40, 'Avoid toll route'),
('Hyderabad', 'Pune', '2025-08-02 09:30:00', 35, 'Fuel stop at Solapur'),
('Delhi', 'Jaipur', '2025-08-03 07:00:00', 50, 'Expressway preferred');

-- Insert vehicles
INSERT INTO Vehicles (vehicle_number, capacity) VALUES
('TN01AB1234', 40),
('AP09XY5678', 35),
('DL05PQ7890', 50);

-- Book seats
CALL BookSeats(1, 'Aarav', 3);
CALL BookSeats(2, 'Diya', 2);
CALL BookSeats(3, 'Rohan', 5);