-- Drop tables if they already exist
DROP TABLE IF EXISTS requests;
DROP TABLE IF EXISTS citizens;
DROP TABLE IF EXISTS departments;

-- 1. Create Tables

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE citizens (
    citizen_id INT PRIMARY KEY,
    citizen_name VARCHAR(100)
);

CREATE TABLE requests (
    request_id INT PRIMARY KEY,
    citizen_id INT,
    dept_id INT,
    request_date DATE,
    description TEXT,
    FOREIGN KEY (citizen_id) REFERENCES citizens(citizen_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 2. Insert Sample Data

-- Departments
INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'Sanitation'),
(2, 'Water Supply'),
(3, 'Road Maintenance'),
(4, 'Electricity');

-- Citizens
INSERT INTO citizens (citizen_id, citizen_name) VALUES
(101, 'Aarav'),
(102, 'Bhavya'),
(103, 'Chirag'),
(104, 'Diya');

-- Requests
INSERT INTO requests (request_id, citizen_id, dept_id, request_date, description) VALUES
(1001, 101, 1, '2025-07-01', 'Garbage not collected'),
(1002, 101, 2, '2025-07-02', 'Water leakage'),
(1003, 102, 1, '2025-07-03', 'Overflowing bins'),
(1004, 103, 3, '2025-07-04', 'Potholes on main road'),
(1005, 101, 3, '2025-07-05', 'Broken streetlight');

-- 3. Count Requests per Citizen
SELECT 
    c.citizen_name,
    COUNT(r.request_id) AS total_requests
FROM citizens c
LEFT JOIN requests r ON c.citizen_id = r.citizen_id
GROUP BY c.citizen_id, c.citizen_name;

-- 4. Count Requests per Department
SELECT 
    d.dept_name,
    COUNT(r.request_id) AS total_requests
FROM departments d
LEFT JOIN requests r ON d.dept_id = r.dept_id
GROUP BY d.dept_id, d.dept_name;

-- 5. Departments with No Requests
SELECT 
    d.dept_name
FROM departments d
LEFT JOIN requests r ON d.dept_id = r.dept_id
WHERE r.request_id IS NULL;

-- 6. Citizens with the Highest Number of Requests
SELECT 
    c.citizen_name,
    COUNT(r.request_id) AS total_requests
FROM citizens c
JOIN requests r ON c.citizen_id = r.citizen_id
GROUP BY c.citizen_id, c.citizen_name
ORDER BY total_requests DESC
LIMIT 1;