-- 1. Create the database
CREATE DATABASE IF NOT EXISTS education_dashboard;
USE education_dashboard;

-- 2. Create tables
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE scores (
    score_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- 3. Insert sample students
INSERT INTO students VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David'),
(5, 'Eva');

-- 4. Insert sample courses
INSERT INTO courses VALUES
(101, 'Mathematics'),
(102, 'Science'),
(103, 'English');

-- 5. Insert sample scores
INSERT INTO scores VALUES
(1, 1, 101, 85),
(2, 1, 102, 78),
(3, 1, 103, 90),
(4, 2, 101, 60),
(5, 2, 102, 55),
(6, 2, 103, 65),
(7, 3, 101, 95),
(8, 3, 102, 88),
(9, 3, 103, 92),
(10, 4, 101, 40),
(11, 4, 102, 45),
(12, 4, 103, 50),
(13, 5, 101, 70),
(14, 5, 102, 75),
(15, 5, 103, 80);

-- 6. A. Subject-wise average marks
SELECT 
    c.course_name,
    AVG(s.marks) AS average_marks
FROM scores s
JOIN courses c ON s.course_id = c.course_id
GROUP BY c.course_name;

-- 7. B. Overall average marks
SELECT AVG(marks) AS overall_average FROM scores;

-- 8. C. Student performance classification using CASE
SELECT 
    st.student_name,
    AVG(sc.marks) AS average_score,
    CASE 
        WHEN AVG(sc.marks) >= 85 THEN 'Distinction'
        WHEN AVG(sc.marks) >= 60 THEN 'Merit'
        WHEN AVG(sc.marks) >= 40 THEN 'Pass'
        ELSE 'Fail'
    END AS performance_level
FROM students st
JOIN scores sc ON st.student_id = sc.student_id
GROUP BY st.student_name;

-- 9. D. Filter students scoring above overall average
SELECT 
    st.student_name,
    AVG(sc.marks) AS average_score
FROM students st
JOIN scores sc ON st.student_id = sc.student_id
GROUP BY st.student_name
HAVING AVG(sc.marks) > (
    SELECT AVG(marks) FROM scores
);