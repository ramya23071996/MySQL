-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS ServiceCenterDB;
USE ServiceCenterDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    contact_info VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Technicians (
    technician_id INT PRIMARY KEY AUTO_INCREMENT,
    technician_name VARCHAR(100),
    specialization VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS ServiceRequests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    technician_id INT,
    service_type VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Open', -- Open, In Progress, Closed
    request_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    completion_time DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (technician_id) REFERENCES Technicians(technician_id)
);

CREATE TABLE IF NOT EXISTS Service_Audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    request_id INT,
    technician_id INT,
    action VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create views

-- View for open vs closed service requests
CREATE OR REPLACE VIEW ServiceStatusView AS
SELECT 
    sr.request_id,
    c.customer_name,
    sr.service_type,
    sr.status,
    sr.request_time,
    sr.completion_time
FROM ServiceRequests sr
JOIN Customers c ON sr.customer_id = c.customer_id;

-- Secure view for customers (no technician or audit info)
CREATE OR REPLACE VIEW CustomerServiceView AS
SELECT 
    request_id,
    customer_id,
    service_type,
    status,
    request_time,
    completion_time
FROM ServiceRequests;

-- Step 4: Create function to calculate time since request logged
DELIMITER //
CREATE FUNCTION TimeSinceRequest(req_id INT) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE duration VARCHAR(100);
    SELECT 
        CONCAT(TIMESTAMPDIFF(HOUR, request_time, NOW()), ' hours') 
    INTO duration
    FROM ServiceRequests
    WHERE request_id = req_id;
    RETURN duration;
END;
//
DELIMITER ;

-- Step 5: Create stored procedure to assign technician
DELIMITER //
CREATE PROCEDURE AssignTechnician(
    IN req_id INT,
    IN tech_id INT
)
BEGIN
    UPDATE ServiceRequests
    SET technician_id = tech_id, status = 'In Progress'
    WHERE request_id = req_id;
END;
//
DELIMITER ;

-- Step 6: Create trigger to log service completion
DELIMITER //
CREATE TRIGGER LogServiceCompletion
AFTER UPDATE ON ServiceRequests
FOR EACH ROW
BEGIN
    IF OLD.status <> 'Closed' AND NEW.status = 'Closed' THEN
        INSERT INTO Service_Audit(request_id, technician_id, action)
        VALUES (NEW.request_id, NEW.technician_id, 'Service Completed');
    END IF;
END;
//
DELIMITER ;

-- Step 7: Insert sample data

-- Insert customers
INSERT INTO Customers (customer_name, contact_info) VALUES
('Aarav', 'aarav@example.com'),
('Diya', 'diya@example.com'),
('Rohan', 'rohan@example.com'),
('Meera', 'meera@example.com'),
('Karthik', 'karthik@example.com');

-- Insert technicians
INSERT INTO Technicians (technician_name, specialization) VALUES
('Karthik', 'Engine Repair'),
('Meera', 'Electrical'),
('Vikram', 'Diagnostics');

-- Insert service requests
INSERT INTO ServiceRequests (customer_id, service_type) VALUES
(1, 'Oil Change'),
(2, 'Battery Replacement'),
(3, 'Brake Inspection'),
(4, 'AC Repair'),
(5, 'Tire Rotation');