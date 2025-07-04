-- 1. Create the database
CREATE DATABASE IF NOT EXISTS elearning_dashboard;
USE elearning_dashboard;

-- 2. Create course categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

-- 3. Create courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 4. Create free and paid enrollment tables
CREATE TABLE free_enrollments (
    enrollment_id INT PRIMARY KEY,
    course_id INT,
    student_id INT
);

CREATE TABLE paid_enrollments (
    enrollment_id INT PRIMARY KEY,
    course_id INT,
    student_id INT
);

-- 5. Insert sample categories
INSERT INTO categories VALUES
(1, 'Programming'),
(2, 'Design'),
(3, 'Marketing');

-- 6. Insert sample courses
INSERT INTO courses VALUES
(101, 'Python Basics', 1),
(102, 'Web Design', 2),
(103, 'Digital Marketing', 3),
(104, 'Advanced Python', 1),
(105, 'Graphic Design', 2);

-- 7. Insert sample free enrollments
INSERT INTO free_enrollments VALUES
(1, 101, 1001),
(2, 101, 1002),
(3, 102, 1003),
(4, 103, 1004),
(5, 103, 1005),
(6, 103, 1006);

-- 8. Insert sample paid enrollments
INSERT INTO paid_enrollments VALUES
(7, 101, 1007),
(8, 104, 1008),
(9, 104, 1009),
(10, 105, 1010),
(11, 105, 1011),
(12, 105, 1012);

-- 9. A. Combine enrollments from free and paid platforms using UNION
SELECT course_id, student_id FROM free_enrollments
UNION
SELECT course_id, student_id FROM paid_enrollments;

-- 10. B. Calculate average enrollment per course
SELECT AVG(enrollment_count) AS avg_enrollment
FROM (
    SELECT course_id, COUNT(*) AS enrollment_count
    FROM (
        SELECT course_id FROM free_enrollments
        UNION ALL
        SELECT course_id FROM paid_enrollments
    ) AS all_enrollments
    GROUP BY course_id
) AS course_totals;

-- 11. C & D. Join courses and categories, classify as Popular or Regular
SELECT 
    c.course_name,
    cat.category_name,
    enroll.enrollment_count,
    CASE 
        WHEN enroll.enrollment_count >= (
            SELECT AVG(enrollment_count)
            FROM (
                SELECT course_id, COUNT(*) AS enrollment_count
                FROM (
                    SELECT course_id FROM free_enrollments
                    UNION ALL
                    SELECT course_id FROM paid_enrollments
                ) AS all_enrollments
                GROUP BY course_id
            ) AS avg_calc
        ) THEN 'Popular'
        ELSE 'Regular'
    END AS popularity_status
FROM courses c
JOIN categories cat ON c.category_id = cat.category_id
JOIN (
    SELECT course_id, COUNT(*) AS enrollment_count
    FROM (
        SELECT course_id FROM free_enrollments
        UNION ALL
        SELECT course_id FROM paid_enrollments
    ) AS all_enrollments
    GROUP BY course_id
) AS enroll ON c.course_id = enroll.course_id;