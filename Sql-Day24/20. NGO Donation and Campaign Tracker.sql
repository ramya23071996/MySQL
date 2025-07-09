-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS NGODonationTracker;
USE NGODonationTracker;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Donors table
CREATE TABLE IF NOT EXISTS Donors (
    donor_id INT PRIMARY KEY,
    donor_name VARCHAR(100),
    email VARCHAR(100)
);

-- Campaigns table
CREATE TABLE IF NOT EXISTS Campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100),
    goal_amount DECIMAL(12,2),
    start_date DATE,
    end_date DATE
);

-- Donations table
CREATE TABLE IF NOT EXISTS Donations (
    donation_id INT PRIMARY KEY,
    donor_id INT,
    campaign_id INT,
    donation_amount DECIMAL(10,2),
    donation_date DATE,
    FOREIGN KEY (donor_id) REFERENCES Donors(donor_id),
    FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Donors
INSERT INTO Donors VALUES
(1, 'Alice', 'alice@ngo.org'),
(2, 'Bob', 'bob@ngo.org'),
(3, 'Charlie', 'charlie@ngo.org');

-- Campaigns
INSERT INTO Campaigns VALUES
(101, 'Clean Water Project', 100000.00, '2024-06-01', '2024-08-31'),
(102, 'Education for All', 150000.00, '2024-07-01', '2024-09-30');

-- Donations
INSERT INTO Donations VALUES
(1, 1, 101, 5000.00, '2024-07-01'),
(2, 2, 101, 3000.00, '2024-07-02'),
(3, 3, 102, 7000.00, '2024-07-03'),
(4, 1, 102, 2000.00, '2024-07-04'),
(5, 2, 101, 1500.00, '2024-07-05');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_campaign_id ON Donations(campaign_id);
CREATE INDEX idx_donor_name ON Donors(donor_name);
CREATE INDEX idx_donation_date ON Donations(donation_date);

-- ============================================
-- 4. DENORMALIZED VIEW FOR CAMPAIGN-WISE SUMMARIES
-- ============================================

CREATE OR REPLACE VIEW CampaignDonationSummary AS
SELECT 
    c.campaign_name,
    c.goal_amount,
    SUM(d.donation_amount) AS total_raised,
    COUNT(d.donation_id) AS total_donations
FROM Donations d
JOIN Campaigns c ON d.campaign_id = c.campaign_id
GROUP BY c.campaign_id, c.campaign_name, c.goal_amount;

-- View usage example
SELECT * FROM CampaignDonationSummary;

-- ============================================
-- 5. EXPLAIN TO OPTIMIZE GROUP AGGREGATIONS
-- ============================================

EXPLAIN
SELECT c.campaign_name, SUM(d.donation_amount) AS total_raised
FROM Donations d
JOIN Campaigns c ON d.campaign_id = c.campaign_id
GROUP BY c.campaign_name;

-- ============================================
-- 6. LIMIT FOR LATEST DONATIONS
-- ============================================

SELECT d.donation_id, dn.donor_name, c.campaign_name, d.donation_amount, d.donation_date
FROM Donations d
JOIN Donors dn ON d.donor_id = dn.donor_id
JOIN Campaigns c ON d.campaign_id = c.campaign_id
ORDER BY d.donation_date DESC
LIMIT 5;