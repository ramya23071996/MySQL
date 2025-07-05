-- Drop existing tables if they exist
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Plans;

-- Create Plans table
CREATE TABLE Plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(50) NOT NULL,
    duration_months INT NOT NULL CHECK (duration_months > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0)
);

-- Create Members table
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    plan_id INT,
    registration_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (plan_id) REFERENCES Plans(plan_id),
    UNIQUE (email, plan_id) -- Prevent duplicate memberships for same plan
);

--  Create Bookings table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    class_name VARCHAR(100) NOT NULL,
    booking_date DATE NOT NULL,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

--  Insert sample plans
INSERT INTO Plans (plan_name, duration_months, price) VALUES
('Monthly', 1, 1500.00),
('Quarterly', 3, 4000.00),
('Annual', 12, 15000.00);

-- Insert sample members
INSERT INTO Members (name, email, plan_id, registration_date) VALUES
('Aarav Mehta', 'aarav@example.com', 3, '2025-07-01'),
('Neha Sharma', 'neha@example.com', 2, '2025-07-05'),
('Rohan Das', 'rohan@example.com', NULL, NULL); -- Incomplete registration

-- Insert class bookings
INSERT INTO Bookings (member_id, class_name, booking_date) VALUES
(1, 'Yoga', '2025-07-10'),
(2, 'Zumba', '2025-07-12');

-- GROUP BY: Plan-wise member count
SELECT p.plan_name, COUNT(m.member_id) AS member_count
FROM Plans p
LEFT JOIN Members m ON p.plan_id = m.plan_id
GROUP BY p.plan_name;

-- LIKE: Filter members by name
SELECT * FROM Members
WHERE name LIKE '%sharma%';

-- IS NULL: Find incomplete registrations
SELECT * FROM Members
WHERE plan_id IS NULL OR registration_date IS NULL;

-- Subquery: Highest paying member
SELECT name, price AS plan_price
FROM Members m
JOIN Plans p ON m.plan_id = p.plan_id
WHERE price = (
    SELECT MAX(price)
    FROM Members m2
    JOIN Plans p2 ON m2.plan_id = p2.plan_id
);