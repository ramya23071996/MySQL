-- 🛠️ Create Database and Tables
CREATE DATABASE IF NOT EXISTS SupportDB;
USE SupportDB;

-- Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- Tickets table
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    user_id INT,
    subject VARCHAR(255) NOT NULL,
    description TEXT,
    created_at DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Open',
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Responses table
CREATE TABLE Responses (
    response_id INT PRIMARY KEY,
    ticket_id INT,
    responder_name VARCHAR(100),
    response_text TEXT,
    response_time DATETIME NOT NULL,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);

-- 📝 Insert Sample Data
INSERT INTO Users VALUES 
(1, 'Ramya', 'ramya@example.com'),
(2, 'Arun', 'arun@example.com');

INSERT INTO Tickets VALUES 
(101, 1, 'Login Issue', 'Unable to login to my account.', '2025-07-10 09:00:00', 'Open'),
(102, 2, 'Payment Failed', 'Payment not going through.', '2025-07-11 10:30:00', 'Open');

INSERT INTO Responses VALUES 
(201, 101, 'SupportAgent1', 'We are looking into your login issue.', '2025-07-10 10:00:00'),
(202, 102, 'SupportAgent2', 'Please try using a different payment method.', '2025-07-11 11:00:00');

-- 📋 JOIN: View Full Complaint and Resolution History
SELECT 
    t.ticket_id,
    u.user_name,
    t.subject,
    t.description,
    t.created_at,
    r.responder_name,
    r.response_text,
    r.response_time
FROM Tickets t
JOIN Users u ON t.user_id = u.user_id
LEFT JOIN Responses r ON t.ticket_id = r.ticket_id
ORDER BY t.created_at;

-- ⏱️ Filter Tickets by Time Range
SELECT * FROM Tickets
WHERE created_at BETWEEN '2025-07-10 00:00:00' AND '2025-07-11 23:59:59'
ORDER BY created_at;

-- 🔁 Batch Reply Insert with Transaction
START TRANSACTION;

INSERT INTO Responses (response_id, ticket_id, responder_name, response_text, response_time) VALUES
(203, 101, 'SupportAgent1', 'Issue resolved. Please try logging in again.', NOW()),
(204, 102, 'SupportAgent2', 'Payment gateway is now working. Please retry.', NOW());

-- Optional: simulate error
-- UPDATE Tickets SET status = 'Oops' WHERE ticket_id = 999;

-- If all good
COMMIT;

-- If error occurs
-- ROLLBACK;

-- 🏷️ Display Ticket Status with CASE
SELECT 
    ticket_id,
    subject,
    created_at,
    status,
    CASE 
        WHEN status = 'Open' THEN 'Pending'
        WHEN status = 'Closed' THEN 'Resolved'
        ELSE 'Unknown'
    END AS status_label
FROM Tickets;