-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS RealEstatePlatform;
USE RealEstatePlatform;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Agents table
CREATE TABLE IF NOT EXISTS Agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(100),
    contact_info VARCHAR(100)
);

-- Clients table
CREATE TABLE IF NOT EXISTS Clients (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(100),
    email VARCHAR(100)
);

-- Properties table
CREATE TABLE IF NOT EXISTS Properties (
    property_id INT PRIMARY KEY,
    agent_id INT,
    location VARCHAR(100),
    price DECIMAL(12,2),
    property_type VARCHAR(50), -- e.g., Apartment, Villa
    description TEXT,
    FOREIGN KEY (agent_id) REFERENCES Agents(agent_id)
);

-- Bookings table
CREATE TABLE IF NOT EXISTS Bookings (
    booking_id INT PRIMARY KEY,
    client_id INT,
    property_id INT,
    booking_date DATE,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Agents
INSERT INTO Agents VALUES
(1, 'Ravi Kumar', 'ravi@realestate.com'),
(2, 'Anita Sharma', 'anita@realestate.com');

-- Clients
INSERT INTO Clients VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@example.com');

-- Properties
INSERT INTO Properties VALUES
(101, 1, 'Chennai', 7500000.00, 'Apartment', '2BHK near beach'),
(102, 2, 'Bangalore', 9500000.00, 'Villa', 'Luxury villa with garden'),
(103, 1, 'Hyderabad', 6500000.00, 'Apartment', 'City center apartment'),
(104, 2, 'Mumbai', 12000000.00, 'Penthouse', 'Sea view penthouse');

-- Bookings
INSERT INTO Bookings VALUES
(1, 1, 101, '2024-07-01'),
(2, 2, 102, '2024-07-02');

-- ============================================
-- 3. CREATE INDEXES FOR SEARCH OPTIMIZATION
-- ============================================

CREATE INDEX idx_location ON Properties(location);
CREATE INDEX idx_price ON Properties(price);
CREATE INDEX idx_property_type ON Properties(property_type);

-- ============================================
-- 4. DENORMALIZED VIEW FOR PUBLIC LISTINGS
-- ============================================

CREATE OR REPLACE VIEW PublicPropertyListings AS
SELECT 
    p.property_id,
    p.location,
    p.price,
    p.property_type,
    p.description,
    a.agent_name,
    a.contact_info
FROM Properties p
JOIN Agents a ON p.agent_id = a.agent_id;

-- View usage example
SELECT * FROM PublicPropertyListings WHERE location = 'Chennai';

-- ============================================
-- 5. FEATURED LISTINGS WITH LIMIT AND ORDER BY
-- ============================================

SELECT * FROM PublicPropertyListings
ORDER BY price DESC
LIMIT 5;