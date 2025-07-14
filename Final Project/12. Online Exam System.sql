-- 1. Create Database
CREATE DATABASE online_exam;
USE online_exam;

-- 2. Courses Table (Referenced in exams)
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    instructor VARCHAR(100)
);

-- 3. Exams Table
CREATE TABLE exams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    date DATE,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- 4. Questions Table
CREATE TABLE questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT,
    text TEXT NOT NULL,
    correct_option CHAR(1),
    FOREIGN KEY (exam_id) REFERENCES exams(id)
);

-- 5. Students Table
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 6. Student Answers Table
CREATE TABLE student_answers (
    student_id INT,
    question_id INT,
    selected_option CHAR(1),
    PRIMARY KEY (student_id, question_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- 7. Sample Courses
INSERT INTO courses (title, instructor) VALUES
('Database Systems', 'Dr. Sharma'),
('Web Development', 'Ms. Reddy');

-- 8. Sample Exams
INSERT INTO exams (course_id, date) VALUES
(1, '2025-07-20'), (2, '2025-07-21');

-- 9. Sample Questions
INSERT INTO questions (exam_id, text, correct_option) VALUES
(1, 'What is the default port for MySQL?', 'C'),
(1, 'Which SQL clause is used to filter results?', 'A'),
(2, 'What does HTML stand for?', 'B'),
(2, 'Which tag is used to insert a line break?', 'C');

-- 10. Sample Students
INSERT INTO students (name, email) VALUES
('Ramya', 'ramya@example.com'),
('Arjun', 'arjun@example.com'),
('Sneha', 'sneha@example.com');

-- 11. Sample Answers
INSERT INTO student_answers (student_id, question_id, selected_option) VALUES
(1, 1, 'C'), (1, 2, 'A'), -- Ramya, correct answers
(2, 1, 'B'), (2, 2, 'A'), -- Arjun, 1 correct
(3, 1, 'D'), (3, 2, 'B'), -- Sneha, none correct
(1, 3, 'B'), (1, 4, 'C'), -- Ramya, correct answers Web Dev
(2, 3, 'C'), (2, 4, 'C'), -- Arjun, 1 correct
(3, 3, 'B'), (3, 4, 'D'); -- Sneha, 1 correct

-- 12. Query: Student Score Summary
SELECT 
    s.name AS student,
    e.id AS exam_id,
    COUNT(*) AS attempted,
    SUM(CASE WHEN sa.selected_option = q.correct_option THEN 1 ELSE 0 END) AS correct_answers
FROM student_answers sa
JOIN questions q ON sa.question_id = q.id
JOIN exams e ON q.exam_id = e.id
JOIN students s ON sa.student_id = s.id
GROUP BY s.name, e.id;

-- 13. Query: Score Breakdown for 'Ramya'
SELECT 
    e.id AS exam_id,
    q.text,
    q.correct_option,
    sa.selected_option,
    CASE WHEN sa.selected_option = q.correct_option THEN 'Correct' ELSE 'Incorrect' END AS result
FROM student_answers sa
JOIN questions q ON sa.question_id = q.id
JOIN exams e ON q.exam_id = e.id
JOIN students s ON sa.student_id = s.id
WHERE s.name = 'Ramya';