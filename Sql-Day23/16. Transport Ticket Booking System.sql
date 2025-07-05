-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Routes;

-- 🛣️ Create Routes table
CREATE TABLE Routes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    total_seats INT NOT NULL CHECK (total_seats > 0),
    seats_available INT NOT NULL CHECK (seats_available >= 0)
);

-- 👤 Create Passengers table
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15)
);

-- 🎟️ Create Tickets table
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT NOT NULL,
    route_id INT NOT NULL,
    seat_number INT NOT NULL CHECK (seat_number BETWEEN 1 AND 60),
    booking_date DATE DEFAULT CURRENT_DATE,
    payment_status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    UNIQUE (route_id, seat_number) -- Prevent double-booking same seat
);

-- 🧾 Insert sample routes
INSERT INTO Routes (origin, destination, total_seats, seats_available) VALUES
('Chennai', 'Bangalore', 60, 60),
('Mumbai', 'Pune', 40, 40);

-- 👤 Insert sample passengers
INSERT INTO Passengers (name, email, phone) VALUES
('Ravi Menon', 'ravi.menon@example.com', '9876543210'),
('Sneha Pillai', 'sneha.pillai@example.com', '9123456789');

-- 🔄 Book a ticket using SAVEPOINT and rollback on payment failure
START TRANSACTION;

-- Step 1: Insert ticket for Ravi on Chennai–Bangalore route
INSERT INTO Tickets (passenger_id, route_id, seat_number, payment_status)
VALUES (1, 1, 12, 'Pending');
SAVEPOINT after_ticket_insert;

-- Step 2: Update seat availability
UPDATE Routes SET seats_available = seats_available - 1 WHERE route_id = 1;

-- Step 3: Simulate payment failure (uncomment to test rollback)
-- ROLLBACK TO after_ticket_insert;

-- Step 4: If payment succeeds, update status
UPDATE Tickets SET payment_status = 'Confirmed' WHERE passenger_id = 1 AND route_id = 1;

-- ✅ Commit if all successful
COMMIT;

-- ❌ Delete cancelled ticket (e.g., ticket_id = 1)
DELETE FROM Tickets WHERE ticket_id = 1;

-- ✅ Restore seat after cancellation
UPDATE Routes SET seats_available = seats_available + 1 WHERE route_id = 1;