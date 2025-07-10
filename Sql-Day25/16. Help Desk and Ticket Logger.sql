-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS HelpDeskDB;
USE HelpDeskDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Agents (
    agent_id INT PRIMARY KEY AUTO_INCREMENT,
    agent_name VARCHAR(100),
    department VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    agent_id INT,
    issue_description TEXT,
    status VARCHAR(20) DEFAULT 'Open', -- Open, In Progress, Resolved, Closed
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES Agents(agent_id)
);

CREATE TABLE IF NOT EXISTS TicketLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create views

-- View: Open tickets per agent
CREATE OR REPLACE VIEW OpenTicketsPerAgent AS
SELECT 
    a.agent_id,
    a.agent_name,
    COUNT(t.ticket_id) AS open_tickets
FROM Agents a
LEFT JOIN Tickets t ON a.agent_id = t.agent_id AND t.status = 'Open'
GROUP BY a.agent_id, a.agent_name;

-- Secure view: Agent-specific ticket view
CREATE OR REPLACE VIEW AgentTicketView AS
SELECT 
    ticket_id,
    agent_id,
    issue_description,
    status,
    created_at
FROM Tickets
WHERE status IN ('Open', 'In Progress');

-- Step 4: Create function to calculate average resolution time
DELIMITER //
CREATE FUNCTION AvgResolutionTime() RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_time DECIMAL(10,2);
    SELECT AVG(TIMESTAMPDIFF(HOUR, created_at, resolved_at)) INTO avg_time
    FROM Tickets
    WHERE resolved_at IS NOT NULL;
    RETURN IFNULL(avg_time, 0);
END;
//
DELIMITER ;

-- Step 5: Create stored procedure to assign tickets
DELIMITER //
CREATE PROCEDURE AssignTicket(
    IN t_id INT,
    IN a_id INT
)
BEGIN
    UPDATE Tickets
    SET agent_id = a_id, status = 'In Progress'
    WHERE ticket_id = t_id;
END;
//
DELIMITER ;

-- Step 6: Create trigger to log ticket status changes
DELIMITER //
CREATE TRIGGER LogTicketStatusChange
AFTER UPDATE ON Tickets
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO TicketLog(ticket_id, old_status, new_status)
        VALUES (NEW.ticket_id, OLD.status, NEW.status);
    END IF;
END;
//
DELIMITER ;

-- Step 7: Insert sample data

-- Agents
INSERT INTO Agents (agent_name, department) VALUES
('Ramya', 'IT Support'),
('Karthik', 'Network'),
('Diya', 'Software');

-- Customers
INSERT INTO Customers (customer_name, email) VALUES
('Aarav', 'aarav@example.com'),
('Meera', 'meera@example.com'),
('Rohan', 'rohan@example.com');

-- Tickets
INSERT INTO Tickets (customer_id, issue_description) VALUES
(1, 'Cannot connect to VPN'),
(2, 'Email not syncing'),
(3, 'Laptop overheating');