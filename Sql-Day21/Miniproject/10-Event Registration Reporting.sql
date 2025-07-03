-- Drop tables if they already exist
DROP TABLE IF EXISTS registrations;
DROP TABLE IF EXISTS attendees;
DROP TABLE IF EXISTS events;

-- 1. Create Tables

CREATE TABLE events (
    event_id INT PRIMARY KEY,
    event_name VARCHAR(100),
    event_date DATE
);

CREATE TABLE attendees (
    attendee_id INT PRIMARY KEY,
    attendee_name VARCHAR(100)
);

CREATE TABLE registrations (
    registration_id INT PRIMARY KEY,
    event_id INT,
    attendee_id INT,
    registration_date DATE,
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id)
);

-- 2. Insert Sample Data

-- Events
INSERT INTO events (event_id, event_name, event_date) VALUES
(1, 'Tech Conference', '2025-08-01'),
(2, 'Art Expo', '2025-08-05'),
(3, 'Music Festival', '2025-08-10'),
(4, 'Startup Meetup', '2025-08-15');

-- Attendees
INSERT INTO attendees (attendee_id, attendee_name) VALUES
(101, 'Aarav'),
(102, 'Bhavya'),
(103, 'Charan'),
(104, 'Diya');

-- Registrations
INSERT INTO registrations (registration_id, event_id, attendee_id, registration_date) VALUES
(1001, 1, 101, '2025-07-20'),
(1002, 2, 101, '2025-07-21'),
(1003, 1, 102, '2025-07-22'),
(1004, 3, 103, '2025-07-23'),
(1005, 1, 104, '2025-07-24'),
(1006, 2, 104, '2025-07-25');

-- 3. Count Registrations per Event
SELECT 
    e.event_name,
    COUNT(r.attendee_id) AS total_registrations
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_name;

-- 4. Attendees Who Registered for the Most Events
SELECT 
    a.attendee_name,
    COUNT(DISTINCT r.event_id) AS events_registered
FROM attendees a
JOIN registrations r ON a.attendee_id = r.attendee_id
GROUP BY a.attendee_name
ORDER BY events_registered DESC
LIMIT 1;

-- 5. Events with No Registrations
SELECT 
    e.event_name
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
WHERE r.registration_id IS NULL;