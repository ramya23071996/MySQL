-- 1. Create Database
CREATE DATABASE course_progress;
USE course_progress;

-- 2. Courses Table
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Lessons Table
CREATE TABLE lessons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(150) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- 4. Progress Table
CREATE TABLE progress (
    student_id INT,
    lesson_id INT,
    completed_at DATE,
    PRIMARY KEY (student_id, lesson_id),
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

-- 5. Students Table (Optional: for better traceability)
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 6. Sample Students
INSERT INTO students (name) VALUES
('Ramya'), ('Arjun'), ('Sneha');

-- 7. Sample Courses
INSERT INTO courses (name) VALUES
('SQL Mastery'), ('Frontend Fundamentals');

-- 8. Sample Lessons
INSERT INTO lessons (course_id, title) VALUES
(1, 'Intro to SQL'), (1, 'Basic Queries'), (1, 'Joins & Subqueries'),
(1, 'Aggregation & GROUP BY'), (1, 'Indexes & Optimization'),
(2, 'HTML Basics'), (2, 'CSS Styling'), (2, 'JS DOM Manipulation'),
(2, 'React Components'), (2, 'Responsive Design');

-- 9. Sample Progress
INSERT INTO progress (student_id, lesson_id, completed_at) VALUES
(1, 1, '2025-07-10'), (1, 2, '2025-07-11'), (1, 3, '2025-07-12'),
(1, 4, '2025-07-14'), (2, 1, '2025-07-10'), (2, 2, '2025-07-11'),
(2, 3, '2025-07-12'), (2, 5, '2025-07-13'), (3, 6, '2025-07-10'),
(3, 7, '2025-07-11'), (3, 8, '2025-07-12'), (3, 9, '2025-07-13'),
(3, 10, '2025-07-14');

-- 10. Query: Completion % per Student per Course
SELECT 
    s.name AS student,
    c.name AS course,
    COUNT(DISTINCT p.lesson_id) AS lessons_completed,
    COUNT(DISTINCT l.id) AS total_lessons,
    ROUND(COUNT(DISTINCT p.lesson_id) / COUNT(DISTINCT l.id) * 100, 2) AS completion_percent
FROM students s
JOIN progress p ON s.id = p.student_id
JOIN lessons l ON p.lesson_id = l.id
JOIN courses c ON l.course_id = c.id
GROUP BY s.name, c.name;

-- 11. Query: Lessons Completed by Ramya in SQL Mastery
SELECT 
    l.title,
    p.completed_at
FROM progress p
JOIN lessons l ON p.lesson_id = l.id
JOIN courses c ON l.course_id = c.id
JOIN students s ON p.student_id = s.id
WHERE s.name = 'Ramya' AND c.name = 'SQL Mastery'
ORDER BY p.completed_at;

-- 12. Query: Students Who Completed All Lessons in a Course
SELECT s.name, c.name AS course
FROM students s
JOIN progress p ON s.id = p.student_id
JOIN lessons l ON p.lesson_id = l.id
JOIN courses c ON l.course_id = c.id
GROUP BY s.id, c.id
HAVING COUNT(DISTINCT p.lesson_id) = (
    SELECT COUNT(*) FROM lessons WHERE course_id = c.id
);