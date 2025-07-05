--  Drop existing tables if they exist
DROP TABLE IF EXISTS Donations;
DROP TABLE IF EXISTS Donors;
DROP TABLE IF EXISTS Campaigns;

-- Create Donors table
CREATE TABLE Donors (
    donor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Create Campaigns table
CREATE TABLE Campaigns (
    campaign_id INT PRIMARY KEY AUTO_INCREMENT,
    cause_name VARCHAR(100) NOT NULL,
    goal_amount DECIMAL(12,2) NOT NULL CHECK (goal_amount > 0)
);

-- Create Donations table
CREATE TABLE Donations (
    donation_id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    campaign_id INT NOT NULL,
    donation_date DATE DEFAULT CURRENT_DATE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    FOREIGN KEY (donor_id) REFERENCES Donors(donor_id),
    FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)
);

-- Insert sample donors
INSERT INTO Donors (name, email) VALUES
('Aarav Mehta', 'aarav@example.com'),
('Neha Sharma', 'neha@example.com'),
('Rohan Das', 'rohan@example.com');

-- Insert sample campaigns
INSERT INTO Campaigns (cause_name, goal_amount) VALUES
('Child Education', 500000.00),
('Healthcare Support', 300000.00),
('Women Empowerment', 400000.00);

-- Insert sample donations
INSERT INTO Donations (donor_id, campaign_id, donation_date, amount) VALUES
(1, 1, '2025-07-01', 5000.00),
(1, 2, '2025-07-05', 15000.00),
(2, 1, '2025-07-10', 8000.00),
(3, 3, '2025-07-12', 25000.00),
(2, 2, '2025-07-15', 12000.00);

-- Update a donation amount
UPDATE Donations
SET amount = 18000.00
WHERE donation_id = 2;

--  Delete a donation record
DELETE FROM Donations
WHERE donation_id = 5;

-- Total donations per donor
SELECT d.name, SUM(do.amount) AS total_donated
FROM Donors d
JOIN Donations do ON d.donor_id = do.donor_id
GROUP BY d.name;

-- Total donations per campaign
SELECT c.cause_name, SUM(do.amount) AS total_raised
FROM Campaigns c
JOIN Donations do ON c.campaign_id = do.campaign_id
GROUP BY c.cause_name;

--  Tag donation size using CASE
SELECT 
    d.name AS donor_name,
    do.amount,
    CASE 
        WHEN do.amount < 5000 THEN 'Small'
        WHEN do.amount BETWEEN 5000 AND 15000 THEN 'Medium'
        ELSE 'Large'
    END AS donation_size
FROM Donations do
JOIN Donors d ON do.donor_id = d.donor_id;

-- Subquery: Most generous donor (by total amount)
SELECT name, total_donated
FROM (
    SELECT d.name, SUM(do.amount) AS total_donated
    FROM Donors d
    JOIN Donations do ON d.donor_id = do.donor_id
    GROUP BY d.name
) AS donor_totals
WHERE total_donated = (
    SELECT MAX(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM Donations
        GROUP BY donor_id
    ) AS totals
);