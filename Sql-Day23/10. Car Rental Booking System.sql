-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Cars;

-- 🏗️ Create Cars table
CREATE TABLE Cars (
    car_id INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    daily_rate DECIMAL(10,2) NOT NULL CHECK (daily_rate > 0),
    is_available BOOLEAN DEFAULT TRUE
);

-- 🏗️ Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15)
);

-- 🏗️ Create Bookings table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    car_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (car_id) REFERENCES Cars(car_id),
    CHECK (end_date > start_date)
);

-- 🚘 Insert sample cars
INSERT INTO Cars (model, license_plate, daily_rate) VALUES
('Toyota Innova', 'TN01AB1234', 2500.00),
('Hyundai i20', 'TN02CD5678', 1800.00),
('Honda City', 'TN03EF9012', 2200.00);

-- 👤 Insert sample customers
INSERT INTO Customers (name, email, phone) VALUES
('Karthik Ramesh', 'karthik.r@example.com', '9876543210'),
('Divya Nair', 'divya.n@example.com', '9123456789');

-- 🔄 Book a car using a transaction (multi-day booking)
START TRANSACTION;

-- Step 1: Insert booking
INSERT INTO Bookings (customer_id, car_id, start_date, end_date)
VALUES (1, 1, '2025-07-10', '2025-07-13');

-- Step 2: Update car availability
UPDATE Cars SET is_available = FALSE WHERE car_id = 1;

-- Optional: Simulate failure (e.g., invalid date)
-- INSERT INTO Bookings (customer_id, car_id, start_date, end_date)
-- VALUES (2, 2, '2025-07-15', '2025-07-14'); -- Will fail due to CHECK constraint

-- ✅ Commit if all successful
COMMIT;

-- ❌ Delete expired bookings (before today)
DELETE FROM Bookings
WHERE end_date < CURDATE();

-- ✅ Make cars available again if booking expired
UPDATE Cars
SET is_available = TRUE
WHERE car_id NOT IN (SELECT DISTINCT car_id FROM Bookings WHERE end_date >= CURDATE());