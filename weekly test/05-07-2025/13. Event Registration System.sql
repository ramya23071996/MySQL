--  Drop existing tables if they exist
DROP TABLE IF EXISTS Registrations;
DROP TABLE IF EXISTS Participants;
DROP TABLE IF EXISTS Events;

--  Create Events table
CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    location VARCHAR(100)
);

--  Create Participants table
CREATE TABLE Participants (
    participant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(100)
);

--  Create Registrations table
CREATE TABLE Registrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    participant_id INT NOT NULL,
    registration_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (participant_id) REFERENCES Participants(participant_id),
    UNIQUE (event_id, participant_id) -- Prevent duplicate registrations
);

--  Insert sample events
INSERT INTO Events (event_name, event_date, location) VALUES
('Tech Conference 2025', '2025-08-10', 'Bangalore'),
('Startup Pitch Fest', '2025-08-15', 'Mumbai'),
('AI & Data Summit', '2025-08-20', 'Hyderabad');

-- Insert sample participants
INSERT INTO Participants (name, email, city) VALUES
('Aarav Mehta', 'aarav@example.com', 'Delhi'),
('Neha Sharma', 'neha@example.com', 'Mumbai'),
('Rohan Das', 'rohan@example.com', 'Chennai'),
('Sneha Iyer', 'sneha@example.com', 'Bangalore');

-- Insert registrations
INSERT INTO Registrations (event_id, participant_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3),
(3, 1),
(3, 4);

-- JOIN: List participants per event
SELECT 
    e.event_name,
    p.name AS participant_name,
    p.city
FROM Registrations r
JOIN Events e ON r.event_id = e.event_id
JOIN Participants p ON r.participant_id = p.participant_id
ORDER BY e.event_name;

-- DISTINCT: Show all cities participants are from
SELECT DISTINCT city FROM Participants;

-- Subquery: Most popular events (by registration count)
SELECT event_name, total_registrations
FROM (
    SELECT e.event_name, COUNT(r.registration_id) AS total_registrations
    FROM Events e
    JOIN Registrations r ON e.event_id = r.event_id
    GROUP BY e.event_name
) AS event_counts
WHERE total_registrations = (
    SELECT MAX(reg_count)
    FROM (
        SELECT COUNT(*) AS reg_count
        FROM Registrations
        GROUP BY event_id
    ) AS reg_totals
);