-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS EventDB;
USE EventDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(100),
    event_date DATE,
    location VARCHAR(100),
    internal_notes TEXT
);

CREATE TABLE IF NOT EXISTS Participants (
    participant_id INT PRIMARY KEY AUTO_INCREMENT,
    participant_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS EventRegistrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    participant_id INT,
    registration_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (participant_id) REFERENCES Participants(participant_id)
);

CREATE TABLE IF NOT EXISTS RegistrationAudit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    registration_id INT,
    event_id INT,
    participant_id INT,
    action VARCHAR(50),
    audit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create views

-- Public view: event schedule without internal notes
CREATE OR REPLACE VIEW PublicEventSchedule AS
SELECT 
    event_id,
    event_name,
    event_date,
    location
FROM Events;

-- Secure view: public-facing event info only
CREATE OR REPLACE VIEW SecureEventView AS
SELECT 
    event_id,
    event_name,
    event_date,
    location
FROM Events;

-- Step 4: Create function to return total attendees
DELIMITER //
CREATE FUNCTION GetTotalAttendees(e_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM EventRegistrations WHERE event_id = e_id;
    RETURN total;
END;
//
DELIMITER ;

-- Step 5: Create stored procedure to register participants
DELIMITER //
CREATE PROCEDURE RegisterParticipant(
    IN e_id INT,
    IN p_id INT
)
BEGIN
    INSERT INTO EventRegistrations(event_id, participant_id)
    VALUES (e_id, p_id);
END;
//
DELIMITER ;

-- Step 6: Create trigger to log registration
DELIMITER //
CREATE TRIGGER LogRegistration
AFTER INSERT ON EventRegistrations
FOR EACH ROW
BEGIN
    INSERT INTO RegistrationAudit(registration_id, event_id, participant_id, action)
    VALUES (NEW.registration_id, NEW.event_id, NEW.participant_id, 'Registered');
END;
//
DELIMITER ;

-- Step 7: Insert sample events
INSERT INTO Events (event_name, event_date, location, internal_notes) VALUES
('Tech Conference 2025', '2025-08-10', 'Auditorium A', 'VIP seating required'),
('Cultural Fest', '2025-08-15', 'Open Grounds', 'Stage setup at 6 AM'),
('Startup Pitch Day', '2025-08-20', 'Hall B', 'Investor panel confirmed');

-- Step 8: Insert sample participants
INSERT INTO Participants (participant_name, email) VALUES
('Aarav', 'aarav@example.com'),
('Diya', 'diya@example.com'),
('Rohan', 'rohan@example.com'),
('Meera', 'meera@example.com'),
('Karthik', 'karthik@example.com');

-- Step 9: Register participants
CALL RegisterParticipant(1, 1);
CALL RegisterParticipant(1, 2);
CALL RegisterParticipant(2, 3);
CALL RegisterParticipant(3, 4);
CALL RegisterParticipant(2, 5);