-- 1. Create CRM Database
CREATE DATABASE sales_crm;
USE sales_crm;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Leads Table
CREATE TABLE leads (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    source VARCHAR(100) NOT NULL
);

-- 4. Deals Table
CREATE TABLE deals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    lead_id INT,
    user_id INT,
    stage ENUM('New', 'Contacted', 'Qualified', 'Proposal Sent', 'Closed Won', 'Closed Lost') NOT NULL,
    amount DECIMAL(10,2),
    created_at DATE,
    FOREIGN KEY (lead_id) REFERENCES leads(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. Insert Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha');

-- 6. Insert Leads
INSERT INTO leads (name, source) VALUES
('TechCorp', 'Email'),
('GreenSage', 'Referral'),
('EduNext', 'LinkedIn'),
('HomeLite', 'Website'),
('BizHive', 'Webinar');

-- 7. Insert Deals
INSERT INTO deals (lead_id, user_id, stage, amount, created_at) VALUES
(1, 1, 'New', 50000, '2025-07-01'),
(2, 1, 'Contacted', 30000, '2025-07-02'),
(3, 2, 'Qualified', 40000, '2025-07-03'),
(4, 2, 'Proposal Sent', 25000, '2025-07-04'),
(5, 3, 'Closed Won', 60000, '2025-07-05'),
(1, 3, 'Closed Lost', 45000, '2025-07-06'),
(2, 2, 'Proposal Sent', 15000, '2025-07-07'),
(3, 1, 'Closed Won', 70000, '2025-07-08'),
(4, 3, 'Contacted', 22000, '2025-07-09'),
(5, 1, 'Qualified', 18000, '2025-07-10');

-- 8. Query: Deals Filtered by Stage
SELECT u.name AS owner, l.name AS lead, d.stage, d.amount, d.created_at
FROM deals d
JOIN users u ON d.user_id = u.id
JOIN leads l ON d.lead_id = l.id
WHERE d.stage IN ('Proposal Sent', 'Closed Won');

-- 9. Query: Total Value of Deals per User
SELECT u.name AS owner, SUM(d.amount) AS total_deal_value
FROM deals d
JOIN users u ON d.user_id = u.id
GROUP BY u.name;

-- 10. Query: Deal Progression Using CTE
WITH ranked_deals AS (
    SELECT 
        d.id,
        u.name AS owner,
        l.name AS lead,
        d.stage,
        d.amount,
        d.created_at,
        ROW_NUMBER() OVER (PARTITION BY d.lead_id ORDER BY d.created_at DESC) AS rn
    FROM deals d
    JOIN users u ON d.user_id = u.id
    JOIN leads l ON d.lead_id = l.id
)
SELECT * FROM ranked_deals WHERE rn = 1;

-- 11. Query: Deals Created in Last 7 Days
SELECT u.name AS owner, l.name AS lead, d.stage, d.amount
FROM deals d
JOIN users u ON d.user_id = u.id
JOIN leads l ON d.lead_id = l.id
WHERE d.created_at >= CURDATE() - INTERVAL 7 DAY;