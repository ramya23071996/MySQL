-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS NGODatabase;
USE NGODatabase;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Donors (
    donor_id INT PRIMARY KEY AUTO_INCREMENT,
    donor_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Campaigns (
    campaign_id INT PRIMARY KEY AUTO_INCREMENT,
    campaign_name VARCHAR(100),
    goal_amount DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS Donations (
    donation_id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT,
    campaign_id INT,
    amount DECIMAL(10,2),
    donation_date DATE DEFAULT CURDATE(),
    FOREIGN KEY (donor_id) REFERENCES Donors(donor_id),
    FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)
);

CREATE TABLE IF NOT EXISTS DonationAudit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    donation_id INT,
    donor_id INT,
    campaign_id INT,
    amount DECIMAL(10,2),
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create views

-- Public view: campaign donation totals
CREATE OR REPLACE VIEW CampaignDonationSummary AS
SELECT 
    c.campaign_name,
    SUM(d.amount) AS total_donated
FROM Donations d
JOIN Campaigns c ON d.campaign_id = c.campaign_id
GROUP BY c.campaign_name;

-- Secure view: donor info without contact details
CREATE OR REPLACE VIEW PublicDonorView AS
SELECT 
    donor_id,
    donor_name
FROM Donors;

-- Step 4: Create function to calculate total donation per donor
DELIMITER //
CREATE FUNCTION GetTotalDonation(d_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(amount) INTO total FROM Donations WHERE donor_id = d_id;
    RETURN IFNULL(total, 0);
END;
//
DELIMITER ;

-- Step 5: Create stored procedure to register donations
DELIMITER //
CREATE PROCEDURE RegisterDonation(
    IN d_id INT,
    IN c_id INT,
    IN amt DECIMAL(10,2)
)
BEGIN
    INSERT INTO Donations(donor_id, campaign_id, amount)
    VALUES (d_id, c_id, amt);
END;
//
DELIMITER ;

-- Step 6: Create trigger to log every donation
DELIMITER //
CREATE TRIGGER LogDonation
AFTER INSERT ON Donations
FOR EACH ROW
BEGIN
    INSERT INTO DonationAudit(donation_id, donor_id, campaign_id, amount)
    VALUES (NEW.donation_id, NEW.donor_id, NEW.campaign_id, NEW.amount);
END;
//
DELIMITER ;

-- Step 7: Insert sample campaigns
INSERT INTO Campaigns (campaign_name, goal_amount) VALUES
('Education for All', 100000),
('Clean Water Project', 75000),
('Healthcare Access', 120000),
('Women Empowerment', 90000),
('Disaster Relief Fund', 150000);

-- Step 8: Insert 10 donors
INSERT INTO Donors (donor_name, email, phone) VALUES
('Aarav', 'aarav@example.com', '9876543210'),
('Diya', 'diya@example.com', '9876543211'),
('Rohan', 'rohan@example.com', '9876543212'),
('Meera', 'meera@example.com', '9876543213'),
('Karthik', 'karthik@example.com', '9876543214'),
('Sneha', 'sneha@example.com', '9876543215'),
('Vikram', 'vikram@example.com', '9876543216'),
('Anjali', 'anjali@example.com', '9876543217'),
('Rahul', 'rahul@example.com', '9876543218'),
('Priya', 'priya@example.com', '9876543219');

-- Step 9: Insert 50 donations using the procedure
CALL RegisterDonation(1, 1, 5000);
CALL RegisterDonation(2, 1, 3000);
CALL RegisterDonation(3, 2, 7000);
CALL RegisterDonation(4, 3, 10000);
CALL RegisterDonation(5, 2, 2500);
CALL RegisterDonation(6, 4, 4000);
CALL RegisterDonation(7, 5, 6000);
CALL RegisterDonation(8, 3, 3500);
CALL RegisterDonation(9, 1, 4500);
CALL RegisterDonation(10, 4, 2000);
CALL RegisterDonation(1, 2, 1500);
CALL RegisterDonation(2, 3, 1800);
CALL RegisterDonation(3, 4, 2200);
CALL RegisterDonation(4, 5, 2700);
CALL RegisterDonation(5, 1, 3200);
CALL RegisterDonation(6, 2, 2900);
CALL RegisterDonation(7, 3, 3100);
CALL RegisterDonation(8, 4, 3300);
CALL RegisterDonation(9, 5, 3600);
CALL RegisterDonation(10, 1, 3900);
CALL RegisterDonation(1, 3, 4100);
CALL RegisterDonation(2, 4, 4300);
CALL RegisterDonation(3, 5, 4600);
CALL RegisterDonation(4, 1, 4800);
CALL RegisterDonation(5, 2, 5000);
CALL RegisterDonation(6, 3, 5200);
CALL RegisterDonation(7, 4, 5400);
CALL RegisterDonation(8, 5, 5600);
CALL RegisterDonation(9, 1, 5800);
CALL RegisterDonation(10, 2, 6000);
CALL RegisterDonation(1, 4, 6200);
CALL RegisterDonation(2, 5, 6400);
CALL RegisterDonation(3, 1, 6600);
CALL RegisterDonation(4, 2, 6800);
CALL RegisterDonation(5, 3, 7000);
CALL RegisterDonation(6, 4, 7200);
CALL RegisterDonation(7, 5, 7400);
CALL RegisterDonation(8, 1, 7600);
CALL RegisterDonation(9, 2, 7800);
CALL RegisterDonation(10, 3, 8000);
CALL RegisterDonation(1, 5, 8200);
CALL RegisterDonation(2, 1, 8400);
CALL RegisterDonation(3, 2, 8600);
CALL RegisterDonation(4, 3, 8800);
CALL RegisterDonation(5, 4, 9000);
CALL RegisterDonation(6, 5, 9200);
CALL RegisterDonation(7, 1, 9400);
CALL RegisterDonation(8, 2, 9600);
CALL RegisterDonation(9, 3, 9800);
CALL RegisterDonation(10, 4, 10000);