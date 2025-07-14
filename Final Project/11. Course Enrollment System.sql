-- 1. Create Database
CREATE DATABASE course_enrollment;
USE course_enrollment;

-- 2. Courses Table
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    instructor VARCHAR(100) NOT NULL
);

-- 3. Students Table
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 4. Enrollments Table (Many-to-Many Relationship)
CREATE TABLE enrollments (
    course_id INT,
    student_id INT,
    enroll_date DATE,
    PRIMARY KEY (course_id, student_id),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (student_id) REFERENCES students(id)
);

-- 5. Insert Sample Courses
INSERT INTO courses (title, instructor) VALUES
('Database Systems', 'Dr. Sharma'),
('Web Development', 'Ms. Reddy'),
('Machine Learning', 'Dr. Kumar'),
('Software Testing', 'Mr. Mehta'),
('Cloud Computing', 'Ms. Singh');

-- 6. Insert Sample Students
INSERT INTO students (name, email) VALUES
('Ramya', 'ramya@example.com'),
('Arjun', 'arjun@example.com'),
('Sneha', 'sneha@example.com'),
('Kiran', 'kiran@example.com'),
('Meera', 'meera@example.com');

-- 7. Insert Sample Enrollments
INSERT INTO enrollments (course_id, student_id, enroll_date) VALUES
(1, 1, '2025-07-10'),
(2, 1, '2025-07-11'),
(3, 2, '2025-07-10'),
(4, 2, '2025-07-12'),
(2, 3, '2025-07-10'),
(5, 3, '2025-07-13'),
(1, 4, '2025-07-10'),
(3, 4, '2025-07-14'),
(4, 5, '2025-07-10'),
(5, 5, '2025-07-15');

-- 8. Query: Students per Course
SELECT c.title AS course, s.name AS student, e.enroll_date
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN courses c ON e.course_id = c.id
ORDER BY c.title, e.enroll_date;

-- 9. Query: Count Enrolled Students per Course
SELECT c.title AS course, COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e ON c.id = e.course_id
GROUP BY c.title;

-- 10. Query: Courses Enrolled by Ramya
SELECT c.title, c.instructor, e.enroll_date
FROM enrollments e
JOIN courses c ON e.course_id = c.id
JOIN students s ON e.student_id = s.id
WHERE s.name = 'Ramya';