-- Drop tables if they already exist
DROP TABLE IF EXISTS completions;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS courses;

-- 1. Create Tables

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    user_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE completions (
    completion_id INT PRIMARY KEY,
    user_id INT,
    course_id INT,
    completion_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- 2. Insert Sample Data

-- Courses
INSERT INTO courses (course_id, course_name) VALUES
(1, 'SQL Basics'),
(2, 'Advanced Python'),
(3, 'Data Structures'),
(4, 'Machine Learning');

-- Users
INSERT INTO users (user_id, user_name) VALUES
(101, 'Aarav'),
(102, 'Bhavya'),
(103, 'Chirag'),
(104, 'Diya');

-- Enrollments
INSERT INTO enrollments (enrollment_id, user_id, course_id, enrollment_date) VALUES
(1001, 101, 1, '2025-07-01'),
(1002, 101, 2, '2025-07-02'),
(1003, 102, 1, '2025-07-03'),
(1004, 103, 3, '2025-07-04'),
(1005, 104, 4, '2025-07-05');

-- Completions
INSERT INTO completions (completion_id, user_id, course_id, completion_date) VALUES
(2001, 101, 1, '2025-07-10'),
(2002, 102, 1, '2025-07-12'),
(2003, 103, 3, '2025-07-15');

-- 3. Count Course Completions per User
SELECT 
    u.user_name,
    COUNT(c.completion_id) AS total_completions
FROM users u
LEFT JOIN completions c ON u.user_id = c.user_id
GROUP BY u.user_id, u.user_name;

-- 4. List Courses with Less Than 5 Completions
SELECT 
    cr.course_name,
    COUNT(c.completion_id) AS completion_count
FROM courses cr
LEFT JOIN completions c ON cr.course_id = c.course_id
GROUP BY cr.course_id, cr.course_name
HAVING completion_count < 5;

-- 5. Identify Users Enrolled but Never Completed Any Course
SELECT 
    u.user_name
FROM users u
JOIN enrollments e ON u.user_id = e.user_id
LEFT JOIN completions c ON u.user_id = c.user_id AND e.course_id = c.course_id
GROUP BY u.user_id, u.user_name
HAVING COUNT(c.completion_id) = 0;