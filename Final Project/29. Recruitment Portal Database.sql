-- 1. Create Database
CREATE DATABASE recruitment_portal;
USE recruitment_portal;

-- 2. Jobs Table
CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    company VARCHAR(100) NOT NULL
);

-- 3. Candidates Table
CREATE TABLE candidates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Applications Table
CREATE TABLE applications (
    job_id INT,
    candidate_id INT,
    status ENUM('Applied', 'Interviewing', 'Hired', 'Rejected') NOT NULL,
    applied_at DATE,
    PRIMARY KEY (job_id, candidate_id),
    FOREIGN KEY (job_id) REFERENCES jobs(id),
    FOREIGN KEY (candidate_id) REFERENCES candidates(id)
);

-- 5. Sample Jobs
INSERT INTO jobs (title, company) VALUES
('Backend Developer', 'TechNova'),
('Frontend Developer', 'PixelWorks'),
('Data Analyst', 'GreenByte'),
('DevOps Engineer', 'UrbanStack'),
('UI Designer', 'CodeNest');

-- 6. Sample Candidates
INSERT INTO candidates (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 7. Sample Applications
INSERT INTO applications (job_id, candidate_id, status, applied_at) VALUES
(1, 1, 'Applied', '2025-07-01'),
(2, 2, 'Interviewing', '2025-07-02'),
(3, 3, 'Rejected', '2025-07-03'),
(4, 4, 'Hired', '2025-07-04'),
(5, 5, 'Applied', '2025-07-05'),
(1, 2, 'Interviewing', '2025-07-06'),
(2, 3, 'Applied', '2025-07-07'),
(3, 1, 'Rejected', '2025-07-08'),
(4, 5, 'Hired', '2025-07-09'),
(5, 4, 'Interviewing', '2025-07-10');

-- 8. Query: Applications by Status ('Interviewing')
SELECT 
    c.name AS candidate,
    j.title AS job,
    a.status,
    a.applied_at
FROM applications a
JOIN candidates c ON a.candidate_id = c.id
JOIN jobs j ON a.job_id = j.id
WHERE a.status = 'Interviewing'
ORDER BY a.applied_at;

-- 9. Query: Count of Candidates per Job
SELECT 
    j.title AS job,
    j.company,
    COUNT(a.candidate_id) AS applicant_count
FROM jobs j
LEFT JOIN applications a ON j.id = a.job_id
GROUP BY j.title, j.company;

-- 10. Query: Applications by Candidate 'Ramya'
SELECT 
    j.title AS job,
    j.company,
    a.status,
    a.applied_at
FROM applications a
JOIN jobs j ON a.job_id = j.id
JOIN candidates c ON a.candidate_id = c.id
WHERE c.name = 'Ramya';

-- 11. Query: Candidates Hired for Each Job
SELECT 
    j.title,
    c.name AS candidate,
    a.applied_at
FROM applications a
JOIN jobs j ON a.job_id = j.id
JOIN candidates c ON a.candidate_id = c.id
WHERE a.status = 'Hired'
ORDER BY j.title;