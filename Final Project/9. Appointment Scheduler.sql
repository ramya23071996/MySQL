-- 1. Create Database
CREATE DATABASE appointment_scheduler;
USE appointment_scheduler;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Services Table
CREATE TABLE services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Appointments Table
CREATE TABLE appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    service_id INT,
    appointment_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (service_id) REFERENCES services(id),
    UNIQUE (service_id, appointment_time) -- Prevent clash per service
);

-- 5. Insert Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Insert Sample Services
INSERT INTO services (name) VALUES
('Haircut'), ('Dental Checkup'), ('Therapy Session'), ('Consultation'), ('Yoga Class');

-- 7. Insert Sample Appointments
INSERT INTO appointments (user_id, service_id, appointment_time) VALUES
(1, 1, '2025-07-15 10:00:00'),
(2, 2, '2025-07-15 11:30:00'),
(3, 3, '2025-07-15 09:00:00'),
(4, 4, '2025-07-15 14:00:00'),
(5, 5, '2025-07-15 16:00:00'),
(1, 2, '2025-07-16 10:30:00'),
(2, 1, '2025-07-16 12:00:00'),
(3, 5, '2025-07-16 08:00:00'),
(4, 3, '2025-07-16 13:30:00'),
(5, 4, '2025-07-16 15:00:00');

-- 8. Query: Appointments by Date
SELECT u.name AS user, s.name AS service, a.appointment_time
FROM appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
WHERE DATE(a.appointment_time) = '2025-07-15';

-- 9. Query: Appointments for a Specific Service
SELECT u.name AS user, s.name AS service, a.appointment_time
FROM appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
WHERE s.name = 'Dental Checkup';

-- 10. Query: Check for Time Conflict
SELECT *
FROM appointments
WHERE service_id = 2 AND appointment_time = '2025-07-16 10:30:00';
-- If this returns a row, it's a clash

-- 11. Optional: Find Available Time Slots (Example logic placeholder)
-- You can define working hours and JOIN with a time table to find gaps