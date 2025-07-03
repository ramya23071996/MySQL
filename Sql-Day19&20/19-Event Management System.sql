-- Create the database
CREATE DATABASE IF NOT EXISTS EventDB;
USE EventDB;

-- Drop tables if they already exist
DROP TABLE IF EXISTS Registrations;
DROP TABLE IF EXISTS Attendees;
DROP TABLE IF EXISTS Events;

-- Create Events table
CREATE TABLE Events (
    EventID INT PRIMARY KEY,
    EventName VARCHAR(100),
    EventDate DATE,
    Location VARCHAR(100)
);

-- Create Attendees table
CREATE TABLE Attendees (
    AttendeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

-- Create Registrations table (many-to-many)
CREATE TABLE Registrations (
    RegistrationID INT PRIMARY KEY AUTO_INCREMENT,
    EventID INT,
    AttendeeID INT,
    RegistrationDate DATE,
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    FOREIGN KEY (AttendeeID) REFERENCES Attendees(AttendeeID)
);

-- Insert sample events
INSERT INTO Events VALUES
(1, 'Tech Conference 2025', '2025-08-10', 'Bangalore'),
(2, 'Startup Meetup', '2025-09-05', 'Mumbai'),
(3, 'AI Summit', '2025-10-15', 'Hyderabad');

-- Insert sample attendees
INSERT INTO Attendees VALUES
(101, 'Aarav Mehta', 'aarav@example.com'),
(102, 'Diya Sharma', 'diya@example.com'),
(103, 'Rohan Iyer', 'rohan@example.com'),
(104, 'Sneha Reddy', 'sneha@example.com'),
(105, 'Karan Patel', 'karan@example.com');

-- Insert sample registrations
INSERT INTO Registrations (EventID, AttendeeID, RegistrationDate) VALUES
(1, 101, '2025-07-01'),
(1, 102, '2025-07-02'),
(1, 103, '2025-07-03'),
(1, 104, '2025-07-04'),
(1, 105, '2025-07-05'),
(2, 101, '2025-07-06'),
(2, 102, '2025-07-07'),
(3, 101, '2025-07-08'),
(3, 103, '2025-07-09');

-- Simulate more attendees for Event 1 to exceed 100
-- (for demonstration, we'll add 96 more attendees)
-- You can comment this block out if not needed
SET @id = 106;
WHILE @id <= 200 DO
  INSERT INTO Attendees VALUES (@id, CONCAT('User', @id), CONCAT('user', @id, '@example.com'));
  INSERT INTO Registrations (EventID, AttendeeID, RegistrationDate) VALUES (1, @id, '2025-07-10');
  SET @id = @id + 1;
END WHILE;

-- Query 1: Events with more than 100 attendees
SELECT E.EventName, COUNT(R.AttendeeID) AS TotalAttendees
FROM Events E
JOIN Registrations R ON E.EventID = R.EventID
GROUP BY E.EventID
HAVING TotalAttendees > 100;

-- Query 2: Attendees registered for multiple events
SELECT A.Name, COUNT(DISTINCT R.EventID) AS EventsRegistered
FROM Attendees A
JOIN Registrations R ON A.AttendeeID = R.AttendeeID
GROUP BY A.AttendeeID
HAVING EventsRegistered > 1;