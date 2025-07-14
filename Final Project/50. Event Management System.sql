-- 1. Create Database
CREATE DATABASE event_manager;
USE event_manager;

-- 2. Events Table
CREATE TABLE events (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    max_capacity INT NOT NULL
);

-- 3. Attendees Table
CREATE TABLE attendees (
    event_id INT,
    user_id INT,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES events(id)
);

-- 4. Sample Events
INSERT INTO events (title, max_capacity) VALUES
('Tech Conference 2025', 300),
('SQL Bootcamp', 50),
('AI Summit', 150),
('Community Meetup', 80),
('Product Launch', 200);

-- 5. Sample Attendees
INSERT INTO attendees (event_id, user_id, registered_at) VALUES
(1, 101, '2025-07-28 10:00:00'),
(1, 102, '2025-07-28 10:05:00'),
(2, 103, '2025-07-28 11:00:00'),
(3, 104, '2025-07-28 09:00:00'),
(3, 105, '2025-07-28 09:05:00'),
(3, 106, '2025-07-28 09:10:00'),
(4, 107, '2025-07-28 12:00:00'),
(5, 108, '2025-07-28 13:00:00'),
(5, 109, '2025-07-28 13:10:00');

-- Count of Attendees Per Event
SELECT 
    e.title AS event,
    COUNT(a.user_id) AS attendee_count
FROM events e
LEFT JOIN attendees a ON e.id = a.event_id
GROUP BY e.title
ORDER BY attendee_count DESC;

-- Events That Reached or Exceeded Capacity
SELECT 
    e.title AS event,
    COUNT(a.user_id) AS attendee_count,
    e.max_capacity,
    CASE 
        WHEN COUNT(a.user_id) >= e.max_capacity THEN 'Full or Overbooked'
        ELSE 'Available'
    END AS status
FROM events e
LEFT JOIN attendees a ON e.id = a.event_id
GROUP BY e.id
HAVING attendee_count >= e.max_capacity;

-- Attendee Registration History
SELECT 
    a.user_id,
    e.title AS event,
    a.registered_at
FROM attendees a
JOIN events e ON a.event_id = e.id
ORDER BY a.registered_at;