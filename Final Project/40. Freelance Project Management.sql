-- 1. Create Database
CREATE DATABASE freelance_hub;
USE freelance_hub;

-- 2. Freelancers Table
CREATE TABLE freelancers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    skill VARCHAR(100) NOT NULL
);

-- 3. Projects Table
CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100) NOT NULL,
    title VARCHAR(150) NOT NULL
);

-- 4. Proposals Table
CREATE TABLE proposals (
    freelancer_id INT,
    project_id INT,
    bid_amount DECIMAL(10, 2),
    status ENUM('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending',
    PRIMARY KEY (freelancer_id, project_id),
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

-- 5. Sample Freelancers
INSERT INTO freelancers (name, skill) VALUES
('Ramya', 'SQL Development'),
('Arjun', 'React Frontend'),
('Sneha', 'Data Visualization'),
('Kiran', 'Backend API'),
('Meera', 'UX Design');

-- 6. Sample Projects
INSERT INTO projects (client_name, title) VALUES
('TechNova', 'Build Sales Dashboard'),
('GreenByte', 'Redesign Landing Page'),
('UrbanStack', 'ETL Pipeline Setup'),
('CodeNest', 'Create RESTful APIs'),
('PixelWorks', 'Design User Onboarding Flow');

-- 7. Sample Proposals
INSERT INTO proposals (freelancer_id, project_id, bid_amount, status) VALUES
(1, 1, 3000.00, 'Accepted'),
(2, 2, 2500.00, 'Pending'),
(3, 1, 3200.00, 'Rejected'),
(4, 3, 2800.00, 'Accepted'),
(5, 2, 2600.00, 'Accepted'),
(1, 4, 2900.00, 'Pending'),
(2, 5, 2700.00, 'Accepted'),
(5, 5, 2400.00, 'Rejected');

-- 8. Query: Accepted Projects with Freelancer and Client Info
SELECT 
    f.name AS freelancer,
    f.skill,
    pr.title AS project,
    pr.client_name,
    p.bid_amount
FROM proposals p
JOIN freelancers f ON p.freelancer_id = f.id
JOIN projects pr ON p.project_id = pr.id
WHERE p.status = 'Accepted';

-- 9. Query: Count of Proposals Per Freelancer
SELECT 
    f.name AS freelancer,
    COUNT(p.project_id) AS total_proposals
FROM freelancers f
LEFT JOIN proposals p ON f.id = p.freelancer_id
GROUP BY f.name
ORDER BY total_proposals DESC;

-- 10. Query: Average Bid Per Project
SELECT 
    pr.title,
    ROUND(AVG(p.bid_amount), 2) AS avg_bid
FROM proposals p
JOIN projects pr ON p.project_id = pr.id
GROUP BY pr.title;

-- 11. Query: Freelancers with Accepted Projects
SELECT 
    f.name,
    COUNT(*) AS accepted_projects
FROM proposals p
JOIN freelancers f ON p.freelancer_id = f.id
WHERE p.status = 'Accepted'
GROUP BY f.name
ORDER BY accepted_projects DESC;