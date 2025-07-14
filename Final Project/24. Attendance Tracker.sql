-- 1. Create Attendance Database
CREATE DATABASE attendance_tracker;
USE attendance_tracker;

-- 2. Students Table
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Courses Table
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Attendance Table
CREATE TABLE attendance (
    student_id INT,
    course_id INT,
    date DATE,
    status ENUM('Present', 'Absent') NOT NULL,
    PRIMARY KEY (student_id, course_id, date),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- 5. Sample Students
INSERT INTO students (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Sample Courses
INSERT INTO courses (name) VALUES
('Database Systems'), ('Web Development'), ('AI Basics');

-- 7. Sample Attendance Records
INSERT INTO attendance (student_id, course_id, date, status) VALUES
(1, 1, '2025-07-20', 'Present'),
(2, 1, '2025-07-20', 'Absent'),
(3, 1, '2025-07-20', 'Present'),
(4, 1, '2025-07-20', 'Present'),
(5, 1, '2025-07-20', 'Absent'),
(1, 2, '2025-07-20', 'Absent'),
(2, 2, '2025-07-20', 'Present'),
(3, 2, '2025-07-20', 'Present'),
(4, 2, '2025-07-20', 'Absent'),
(5, 2, '2025-07-20', 'Present');

-- 8. Query: Daily Attendance for a Course
SELECT s.name AS student, a.date, a.status
FROM attendance a
JOIN students s ON a.student_id = s.id
JOIN courses c ON a.course_id = c.id
WHERE c.name = 'Database Systems' AND a.date = '2025-07-20';

-- 9. Query: Attendance Summary Per Student
SELECT 
    s.name AS student,
    COUNT(*) AS total_sessions,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS sessions_attended,
    ROUND(SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS attendance_percentage
FROM attendance a
JOIN students s ON a.student_id = s.id
GROUP BY s.name;

-- 10. Query: Attendance Summary Per Course
SELECT 
    c.name AS course,
    COUNT(*) AS total_records,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS total_present
FROM attendance a
JOIN courses c ON a.course_id = c.id
GROUP BY c.name;

-- 11. Query: Absent Students on a Specific Date
SELECT s.name AS student, c.name AS course
FROM attendance a
JOIN students s ON a.student_id = s.id
JOIN courses c ON a.course_id = c.id
WHERE a.date = '2025-07-20' AND a.status = 'Absent';