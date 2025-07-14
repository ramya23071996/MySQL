-- 1. Create Database
CREATE DATABASE donation_tracker;
USE donation_tracker;

-- 2. Donors Table
CREATE TABLE donors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Causes Table
CREATE TABLE causes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL
);

-- 4. Donations Table
CREATE TABLE donations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT,
    cause_id INT,
    amount DECIMAL(10,2),
    donated_at DATE,
    FOREIGN KEY (donor_id) REFERENCES donors(id),
    FOREIGN KEY (cause_id) REFERENCES causes(id)
);

-- 5. Sample Donors
INSERT INTO donors (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Sample Causes
INSERT INTO causes (title) VALUES
('Education Fund'), ('Healthcare Drive'), ('Environment Relief'),
('Animal Welfare'), ('Mental Health Awareness');

-- 7. Sample Donations
INSERT INTO donations (donor_id, cause_id, amount, donated_at) VALUES
(1, 1, 5000.00, '2025-07-01'),
(2, 2, 3000.00, '2025-07-02'),
(3, 3, 4500.00, '2025-07-03'),
(4, 1, 2000.00, '2025-07-04'),
(5, 4, 1500.00, '2025-07-05'),
(1, 2, 3500.00, '2025-07-06'),
(2, 3, 2500.00, '2025-07-07'),
(3, 5, 4000.00, '2025-07-08'),
(4, 4, 1000.00, '2025-07-09'),
(5, 5, 3000.00, '2025-07-10');

-- 8. Query: Total Donations by Cause
SELECT 
    c.title AS cause,
    SUM(d.amount) AS total_donated
FROM donations d
JOIN causes c ON d.cause_id = c.id
GROUP BY c.title
ORDER BY total_donated DESC;

-- 9. Query: Donations Made by Ramya
SELECT 
    c.title AS cause,
    d.amount,
    d.donated_at
FROM donations d
JOIN donors r ON d.donor_id = r.id
JOIN causes c ON d.cause_id = c.id
WHERE r.name = 'Ramya';

-- 10. Query: Top 3 Funded Causes
SELECT 
    c.title,
    SUM(d.amount) AS total
FROM donations d
JOIN causes c ON d.cause_id = c.id
GROUP BY c.title
ORDER BY total DESC
LIMIT 3;

-- 11. Query: Donations Made in Last 7 Days
SELECT 
    r.name AS donor,
    c.title AS cause,
    d.amount,
    d.donated_at
FROM donations d
JOIN donors r ON d.donor_id = r.id
JOIN causes c ON d.cause_id = c.id
WHERE d.donated_at >= CURDATE() - INTERVAL 7 DAY
ORDER BY d.donated_at DESC;