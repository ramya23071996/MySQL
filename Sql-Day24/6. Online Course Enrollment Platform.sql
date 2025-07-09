-- ============================================
--  CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS CoursePlatform;
USE CoursePlatform;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Students table
CREATE TABLE IF NOT EXISTS Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    email VARCHAR(100)
);

-- Courses table
CREATE TABLE IF NOT EXISTS Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    category VARCHAR(50)
);

-- Enrollments table
CREATE TABLE IF NOT EXISTS Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enroll_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Students
INSERT INTO Students VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@example.com'),
(3, 'Charlie', 'charlie@example.com');

-- Courses
INSERT INTO Courses VALUES
(101, 'Python Basics', 'Programming'),
(102, 'Data Science', 'Analytics'),
(103, 'Web Development', 'Development'),
(104, 'Machine Learning', 'AI');

-- Enrollments
INSERT INTO Enrollments VALUES
(1, 1, 101, '2024-07-01'),
(2, 1, 102, '2024-07-05'),
(3, 1, 103, '2024-07-10'),
(4, 2, 101, '2024-07-02'),
(5, 2, 104, '2024-07-06'),
(6, 3, 102, '2024-07-03'),
(7, 3, 103, '2024-07-07'),
(8, 3, 104, '2024-07-08'),
(9, 2, 102, '2024-07-09'),
(10, 1, 104, '2024-07-11');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_student_name ON Students(student_name);
CREATE INDEX idx_course_name ON Courses(course_name);
CREATE INDEX idx_enroll_date ON Enrollments(enroll_date);

-- ============================================
-- 4. JOIN VS SUBQUERY PERFORMANCE (EXPLAIN)
-- ============================================

-- JOIN query
EXPLAIN
SELECT s.student_name, c.course_name, e.enroll_date
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE s.student_name = 'Alice';

-- Subquery version
EXPLAIN
SELECT student_name, course_name, enroll_date
FROM (
    SELECT s.student_name, c.course_name, e.enroll_date
    FROM Students s, Courses c, Enrollments e
    WHERE s.student_id = e.student_id AND c.course_id = e.course_id
) AS sub
WHERE student_name = 'Alice';

-- ============================================
-- 5. DENORMALIZED REPORTING TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS EnrollmentReport (
    enrollment_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course_name VARCHAR(100),
    enroll_date DATE
);

-- Insert denormalized data
INSERT INTO EnrollmentReport
SELECT 
    e.enrollment_id,
    s.student_name,
    c.course_name,
    e.enroll_date
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- View report
SELECT * FROM EnrollmentReport;

-- ============================================
-- 6. LATEST 5 ENROLLMENTS PER STUDENT (LIMIT)
-- ============================================

-- Example: Latest 5 enrollments for Alice
SELECT * FROM EnrollmentReport
WHERE student_name = 'Alice'
ORDER BY enroll_date DESC
LIMIT 5;