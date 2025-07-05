-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Guests;
DROP TABLE IF EXISTS Rooms;

-- 🏗️ Create Rooms table
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL CHECK (price_per_night > 0),
    is_available BOOLEAN DEFAULT TRUE
);

-- 🏗️ Create Guests table
CREATE TABLE Guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15)
);

-- 🏗️ Create Bookings table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    CHECK (check_out > check_in)
);

-- 🧾 Insert sample rooms
INSERT INTO Rooms (room_type, price_per_night) VALUES
('Single', 2500.00),
('Double', 4000.00),
('Suite', 7500.00);

-- 🧾 Insert sample guests
INSERT INTO Guests (name, email, phone) VALUES
('Ritika Sharma', 'ritika.sharma@example.com', '9876543210'),
('Arjun Menon', 'arjun.menon@example.com', '9123456789');

-- 🔄 Book a room using a transaction
START TRANSACTION;

-- Step 1: Check availability (assume room_id = 1 is available)
-- Step 2: Create booking
INSERT INTO Bookings (guest_id, room_id, check_in, check_out)
VALUES (1, 1, '2025-07-10', '2025-07-12');

-- Step 3: Mark room as unavailable
UPDATE Rooms SET is_available = FALSE WHERE room_id = 1;

-- Optional: Simulate failure (e.g., invalid date)
-- INSERT INTO Bookings (guest_id, room_id, check_in, check_out)
-- VALUES (2, 2, '2025-07-15', '2025-07-14'); -- Will fail due to CHECK constraint

-- ✅ Commit if all successful
COMMIT;

-- ❌ Cancel a booking (e.g., booking_id = 1)
DELETE FROM Bookings WHERE booking_id = 1;

-- ✅ Make room available again
UPDATE Rooms SET is_available = TRUE WHERE room_id = 1;