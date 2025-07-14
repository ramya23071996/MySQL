-- 1. Create Feedback Database
CREATE DATABASE course_feedback;
USE course_feedback;

-- 2. Courses Table
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL
);

-- 3. Feedback Table
CREATE TABLE feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    user_id INT,
    rating DECIMAL(2,1), -- Scale of 1.0 to 5.0
    comments TEXT,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- 4. Sample Courses
INSERT INTO courses (title) VALUES
('SQL Essentials'),
('Advanced Database Design'),
('Frontend with React'),
('ETL Concepts and Tools'),
('Analytics Dashboards');

-- 5. Sample Feedback Entries
INSERT INTO feedback (course_id, user_id, rating, comments) VALUES
(1, 101, 4.5, 'Very clear explanations and great pacing.'),
(1, 102, 4.0, 'Good for beginners.'),
(2, 103, 5.0, 'Excellent examples and normalization tips.'),
(2, 104, 4.8, 'Deep coverage of indexing strategies.'),
(3, 105, 3.5, 'Could use better project guidance.'),
(4, 106, 4.9, 'Loved the modular ETL breakdown.'),
(5, 107, 4.2, 'Visualization tools were well explained.'),
(5, 101, 4.4, 'Helped me build real dashboards.');

-- Average Rating Per Course
SELECT 
    c.title,
    ROUND(AVG(f.rating), 2) AS avg_rating,
    COUNT(f.id) AS total_feedbacks
FROM courses c
LEFT JOIN feedback f ON c.id = f.course_id
GROUP BY c.title
ORDER BY avg_rating DESC;

-- Feedback Sentiment Sampler
SELECT 
    c.title,
    f.rating,
    f.comments
FROM feedback f
JOIN courses c ON f.course_id = c.id
ORDER BY f.rating DESC, c.title;

-- Courses With No Feedback Yet
SELECT 
    c.title
FROM courses c
LEFT JOIN feedback f ON c.id = f.course_id
WHERE f.id IS NULL;


