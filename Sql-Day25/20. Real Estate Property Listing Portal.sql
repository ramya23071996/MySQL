-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS RealEstateDB;
USE RealEstateDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Owners (
    owner_id INT PRIMARY KEY AUTO_INCREMENT,
    owner_name VARCHAR(100),
    contact_info VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Properties (
    property_id INT PRIMARY KEY AUTO_INCREMENT,
    owner_id INT,
    title VARCHAR(100),
    location VARCHAR(100),
    price DECIMAL(12,2),
    status VARCHAR(20) DEFAULT 'Available', -- Available, Sold, Rented
    description TEXT,
    FOREIGN KEY (owner_id) REFERENCES Owners(owner_id)
);

CREATE TABLE IF NOT EXISTS Visits (
    visit_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT,
    client_name VARCHAR(100),
    scheduled_date DATE,
    scheduled_time TIME,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id)
);

CREATE TABLE IF NOT EXISTS ListingAudit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT,
    old_price DECIMAL(12,2),
    new_price DECIMAL(12,2),
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create views

-- View: Available properties for clients
CREATE OR REPLACE VIEW AvailablePropertiesView AS
SELECT 
    p.property_id,
    p.title,
    p.location,
    p.price,
    p.status,
    p.description
FROM Properties p
WHERE p.status = 'Available';

-- View: Public-facing (no owner info)
CREATE OR REPLACE VIEW PublicPropertyView AS
SELECT 
    property_id,
    title,
    location,
    price,
    status,
    description
FROM Properties
WHERE status = 'Available';

-- Step 4: Create function to count listings by location
DELIMITER //
CREATE FUNCTION CountListingsByLocation(loc VARCHAR(100)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Properties
    WHERE location = loc AND status = 'Available';
    RETURN total;
END;
//
DELIMITER ;

-- Step 5: Create stored procedure to schedule property visits
DELIMITER //
CREATE PROCEDURE ScheduleVisit(
    IN prop_id INT,
    IN client VARCHAR(100),
    IN v_date DATE,
    IN v_time TIME
)
BEGIN
    INSERT INTO Visits(property_id, client_name, scheduled_date, scheduled_time)
    VALUES (prop_id, client, v_date, v_time);
END;
//
DELIMITER ;

-- Step 6: Create trigger to log listing changes
DELIMITER //
CREATE TRIGGER LogListingChanges
AFTER UPDATE ON Properties
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price OR OLD.status <> NEW.status THEN
        INSERT INTO ListingAudit(property_id, old_price, new_price, old_status, new_status)
        VALUES (NEW.property_id, OLD.price, NEW.price, OLD.status, NEW.status);
    END IF;
END;
//
DELIMITER ;

-- Step 7: Insert sample data

-- Owners
INSERT INTO Owners (owner_name, contact_info) VALUES
('Aarav', 'aarav@owner.com'),
('Diya', 'diya@owner.com'),
('Rohan', 'rohan@owner.com');

-- Properties
INSERT INTO Properties (owner_id, title, location, price, status, description) VALUES
(1, '2BHK Apartment', 'Chennai', 4500000, 'Available', 'Spacious 2BHK near metro'),
(2, 'Villa with Garden', 'Bangalore', 12000000, 'Available', 'Luxury villa with private garden'),
(3, 'Studio Flat', 'Hyderabad', 3000000, 'Sold', 'Compact studio in IT hub');

-- Visits
CALL ScheduleVisit(1, 'Meera', '2025-08-10', '10:00:00');
CALL ScheduleVisit(2, 'Karthik', '2025-08-11', '15:30:00');