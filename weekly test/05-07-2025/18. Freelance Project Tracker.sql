--  Drop existing tables if they exist
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Freelancers;

-- Create Freelancers table
CREATE TABLE Freelancers (
    freelancer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    skillset VARCHAR(100)
);

--  Create Projects table
CREATE TABLE Projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    freelancer_id INT NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (freelancer_id) REFERENCES Freelancers(freelancer_id)
);

--  Create Payments table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

--  Insert sample freelancers
INSERT INTO Freelancers (name, email, skillset) VALUES
('Aarav Mehta', 'aarav@example.com', 'Web Development'),
('Neha Sharma', 'neha@example.com', 'Graphic Design'),
('Rohan Das', 'rohan@example.com', 'Content Writing');

--  Insert sample projects
INSERT INTO Projects (freelancer_id, project_name, start_date, end_date) VALUES
(1, 'E-Commerce Website', '2025-07-01', '2025-07-20'),
(2, 'Logo Design', '2025-07-05', NULL),
(1, 'Portfolio Site', '2025-07-10', '2025-07-18'),
(3, 'Blog Articles', '2025-07-12', '2025-07-25');

--  Insert sample payments
INSERT INTO Payments (project_id, amount, payment_date) VALUES
(1, 15000.00, '2025-07-21'),
(3, 8000.00, '2025-07-19'),
(4, 5000.00, '2025-07-26');

-- Use CASE to classify project status
SELECT 
    p.project_name,
    f.name AS freelancer_name,
    p.start_date,
    p.end_date,
    CASE 
        WHEN p.end_date IS NULL THEN 'Pending'
        ELSE 'Completed'
    END AS project_status
FROM Projects p
JOIN Freelancers f ON p.freelancer_id = f.freelancer_id;

--  Use SUM() to track earnings per freelancer
SELECT 
    f.name,
    SUM(pay.amount) AS total_earnings
FROM Freelancers f
JOIN Projects p ON f.freelancer_id = p.freelancer_id
JOIN Payments pay ON p.project_id = pay.project_id
GROUP BY f.name;

--  Subquery: Find most paid freelancer
SELECT name, total_earnings
FROM (
    SELECT 
        f.name,
        SUM(pay.amount) AS total_earnings
    FROM Freelancers f
    JOIN Projects p ON f.freelancer_id = p.freelancer_id
    JOIN Payments pay ON p.project_id = pay.project_id
    GROUP BY f.name
) AS earnings
WHERE total_earnings = (
    SELECT MAX(total)
    FROM (
        SELECT SUM(pay.amount) AS total
        FROM Projects p
        JOIN Payments pay ON p.project_id = pay.project_id
        GROUP BY p.freelancer_id
    ) AS totals
);