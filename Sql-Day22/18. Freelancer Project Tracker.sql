-- 1. Create the database
CREATE DATABASE IF NOT EXISTS freelance_portal;
USE freelance_portal;

-- 2. Create freelancers table
CREATE TABLE freelancers (
    freelancer_id INT PRIMARY KEY,
    freelancer_name VARCHAR(100)
);

-- 3. Create projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    freelancer_id INT,
    project_name VARCHAR(100),
    earnings DECIMAL(10,2),
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(freelancer_id)
);

-- 4. Insert sample freelancers
INSERT INTO freelancers VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David'),
(5, 'Eva');

-- 5. Insert sample projects
INSERT INTO projects VALUES
(101, 1, 'Website Design', 1200),
(102, 1, 'Logo Design', 800),
(103, 2, 'App Development', 3000),
(104, 2, 'Bug Fixing', 1000),
(105, 3, 'SEO Optimization', 500),
(106, 4, 'Content Writing', 400),
(107, 4, 'Blog Editing', 300),
(108, 5, 'Data Analysis', 2500),
(109, 5, 'Dashboard Creation', 2700);

-- 6. A. Calculate average earnings across all projects
SELECT AVG(earnings) AS overall_avg_earnings FROM projects;

-- 7. B. Compare each project’s earnings to freelancer’s average (correlated subquery)
SELECT 
    p.project_id,
    f.freelancer_name,
    p.project_name,
    p.earnings,
    (
        SELECT AVG(p2.earnings)
        FROM projects p2
        WHERE p2.freelancer_id = p.freelancer_id
    ) AS freelancer_avg,
    CASE 
        WHEN p.earnings > (
            SELECT AVG(p2.earnings)
            FROM projects p2
            WHERE p2.freelancer_id = p.freelancer_id
        ) THEN 'Above Freelancer Avg'
        ELSE 'Below/Equal Freelancer Avg'
    END AS earning_comparison
FROM projects p
JOIN freelancers f ON p.freelancer_id = f.freelancer_id;

-- 8. C. Classify freelancers by total earnings using CASE
SELECT 
    f.freelancer_name,
    SUM(p.earnings) AS total_earnings,
    CASE 
        WHEN SUM(p.earnings) >= 5000 THEN 'Top Earner'
        WHEN SUM(p.earnings) >= 2000 THEN 'Mid Earner'
        ELSE 'Entry Level'
    END AS earning_band
FROM freelancers f
JOIN projects p ON f.freelancer_id = p.freelancer_id
GROUP BY f.freelancer_name;

-- 9. D. Show number of projects completed per freelancer
SELECT 
    f.freelancer_name,
    COUNT(p.project_id) AS projects_completed
FROM freelancers f
JOIN projects p ON f.freelancer_id = p.freelancer_id
GROUP BY f.freelancer_name;