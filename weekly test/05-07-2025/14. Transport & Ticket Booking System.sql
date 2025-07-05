--  Drop existing tables if they exist
DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS Seats;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Routes;

-- ️ Create Routes table
CREATE TABLE Routes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    departure_time DATETIME NOT NULL
);

--  Create Passengers table
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

--  Create Seats table
CREATE TABLE Seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT NOT NULL,
    seat_number INT NOT NULL CHECK (seat_number BETWEEN 1 AND 60),
    passenger_id INT,
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    UNIQUE (route_id, seat_number)
);

-- ️ Create Tickets table
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT NOT NULL,
    route_id INT NOT NULL,
    seat_id INT NOT NULL,
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);

-- Insert sample routes
INSERT INTO Routes (origin, destination, departure_time) VALUES
('Chennai', 'Bangalore', '2025-08-01 08:00:00'),
('Mumbai', 'Pune', '2025-08-01 09:30:00');

--  Insert sample passengers
INSERT INTO Passengers (name, email) VALUES
('Aarav Mehta', 'aarav@example.com'),
('Neha Sharma', 'neha@example.com');

--  Insert seats for route 1 (Chennai → Bangalore)
INSERT INTO Seats (route_id, seat_number) 
SELECT 1, seq
FROM (
  SELECT @row := @row + 1 AS seq FROM 
  (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 
   UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 
   UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
  (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 
   UNION ALL SELECT 4 UNION ALL SELECT