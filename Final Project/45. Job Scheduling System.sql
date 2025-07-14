-- 1. Create Database
CREATE DATABASE job_scheduler;
USE job_scheduler;

-- 2. Jobs Table (stores recurring jobs and their frequency)
CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    frequency ENUM('Daily', 'Weekly', 'Hourly') NOT NULL
);

-- 3. Job Logs Table (tracks execution of jobs)
CREATE TABLE job_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT,
    run_time DATETIME,
    status ENUM('Success', 'Failed', 'Pending') NOT NULL,
    FOREIGN KEY (job_id) REFERENCES jobs(id)
);

-- 4. Sample Jobs
INSERT INTO jobs (name, frequency) VALUES
('Backup Database', 'Daily'),
('Send Weekly Report', 'Weekly'),
('Cleanup Temp Files', 'Hourly'),
('Sync External API', 'Hourly'),
('Generate Analytics Summary', 'Daily');

-- 5. Sample Job Logs
INSERT INTO job_logs (job_id, run_time, status) VALUES
(1, '2025-07-25 02:00:00', 'Success'),
(2, '2025-07-21 09:00:00', 'Failed'),
(3, '2025-07-25 10:00:00', 'Success'),
(4, '2025-07-25 10:05:00', 'Pending'),
(5, '2025-07-24 04:30:00', 'Success'),
(1, '2025-07-26 02:00:00', 'Success'),
(2, '2025-07-28 09:00:00', 'Success'),
(3, '2025-07-26 10:00:00', 'Failed'),
(5, '2025-07-26 04:30:00', 'Pending'),
(4, '2025-07-26 10:05:00', 'Success');

-- Last Run Per Job
SELECT 
    j.name AS job,
    MAX(l.run_time) AS last_run
FROM jobs j
JOIN job_logs l ON j.id = l.job_id
GROUP BY j.name;

-- Next Run Estimation (Based on frequency + last run)
SELECT 
    j.name AS job,
    MAX(l.run_time) AS last_run,
    CASE j.frequency
        WHEN 'Daily' THEN DATE_ADD(MAX(l.run_time), INTERVAL 1 DAY)
        WHEN 'Weekly' THEN DATE_ADD(MAX(l.run_time), INTERVAL 1 WEEK)
        WHEN 'Hourly' THEN DATE_ADD(MAX(l.run_time), INTERVAL 1 HOUR)
    END AS expected_next_run
FROM jobs j
JOIN job_logs l ON j.id = l.job_id
GROUP BY j.name, j.frequency;

-- Status Count Per Job
SELECT 
    j.name AS job,
    l.status,
    COUNT(*) AS status_count
FROM jobs j
JOIN job_logs l ON j.id = l.job_id
GROUP BY j.name, l.status
ORDER BY j.name, status_count DESC;

