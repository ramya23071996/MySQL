-- 1. Create Database
CREATE DATABASE complaint_center;
USE complaint_center;

-- 2. Departments Table
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Complaints Table
CREATE TABLE complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    department_id INT,
    status ENUM('Open', 'In Progress', 'Resolved', 'Closed', 'Rejected') NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- 4. Responses Table
CREATE TABLE responses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    complaint_id INT,
    responder_id INT,
    message TEXT NOT NULL,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id)
);

-- Departments
INSERT INTO departments (name) VALUES
('Sanitation'), ('Water Supply'), ('Roads'), ('Electricity'), ('Public Safety');

-- Complaints
INSERT INTO complaints (title, department_id, status) VALUES
('Overflowing garbage in Sector 5', 1, 'Open'),
('No water in Block A', 2, 'In Progress'),
('Potholes on Main Street', 3, 'Resolved'),
('Street lights not working', 4, 'Closed'),
('Noise disturbance after midnight', 5, 'Rejected');

-- Responses
INSERT INTO responses (complaint_id, responder_id, message) VALUES
(1, 101, 'Complaint noted, team will inspect tomorrow.'),
(2, 102, 'Work order issued for valve inspection.'),
(3, 103, 'Potholes repaired as of last Monday.'),
(4, 104, 'New bulbs installed in 3 poles.'),
(5, 105, 'Issue doesn’t fall under public safety jurisdiction.');

-- Complaint Status Summary
SELECT 
    status,
    COUNT(*) AS total_complaints
FROM complaints
GROUP BY status
ORDER BY total_complaints DESC;

-- Department Workload
SELECT 
    d.name AS department,
    COUNT(c.id) AS open_complaints
FROM departments d
JOIN complaints c ON d.id = c.department_id
WHERE c.status IN ('Open', 'In Progress')
GROUP BY d.name
ORDER BY open_complaints DESC;

-- Complaint Response History
SELECT 
    c.title,
    r.message,
    r.responder_id
FROM responses r
JOIN complaints c ON r.complaint_id = c.id
ORDER BY c.id, r.id;