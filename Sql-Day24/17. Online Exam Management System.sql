-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS ExamSystem;
USE ExamSystem;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Students table
CREATE TABLE IF NOT EXISTS Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    email VARCHAR(100)
);

-- Subjects table
CREATE TABLE IF NOT EXISTS Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100)
);

-- Exams table
CREATE TABLE IF NOT EXISTS Exams (
    exam_id INT PRIMARY KEY,
    subject_id INT,
    exam_date DATE,
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- Scores table
CREATE TABLE IF NOT EXISTS Scores (
    score_id INT PRIMARY KEY,
    student_id INT,
    exam_id INT,
    score INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (exam_id) REFERENCES Exams(exam_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Students
INSERT INTO Students VALUES
(1, 'Alice', 'alice@school.com'),
(2, 'Bob', 'bob@school.com'),
(3, 'Charlie', 'charlie@school.com');

-- Subjects
INSERT INTO Subjects VALUES
(1, 'Mathematics'),
(2, 'Science'),
(3, 'English');

-- Exams
INSERT INTO Exams VALUES
(101, 1, '2024-07-01'),
(102, 2, '2024-07-02'),
(103, 3, '2024-07-03');

-- Scores
INSERT INTO Scores VALUES
(1, 1, 101, 95),
(2, 1, 102, 88),
(3, 2, 101, 76),
(4, 2, 103, 82),
(5, 3, 102, 91),
(6, 3, 103, 85);

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_student_id ON Scores(student_id);
CREATE INDEX idx_exam_date ON Exams(exam_date);
CREATE INDEX idx_score ON Scores(score);

-- ============================================
-- 4. GRADE CATEGORIZATION USING CASE WHEN
-- ============================================

SELECT 
    s.student_name,
    sub.subject_name,
    sc.score,
    CASE 
        WHEN sc.score >= 90 THEN 'A'
        WHEN sc.score >= 80 THEN 'B'
        WHEN sc.score >= 70 THEN 'C'
        WHEN sc.score >= 60 THEN 'D'
        ELSE 'F'
    END AS grade
FROM Scores sc
JOIN Students s ON sc.student_id = s.student_id
JOIN Exams e ON sc.exam_id = e.exam_id
JOIN Subjects sub ON e.subject_id = sub.subject_id;

-- ============================================
-- 5. EXPLAIN JOIN PERFORMANCE
-- ============================================

EXPLAIN
SELECT s.student_name, sub.subject_name, sc.score
FROM Scores sc
JOIN Students s ON sc.student_id = s.student_id
JOIN Exams e ON sc.exam_id = e.exam_id
JOIN Subjects sub ON e.subject_id = sub.subject_id;

-- ============================================
-- 6. DENORMALIZED DASHBOARD VIEW
-- ============================================

CREATE OR REPLACE VIEW StudentScoreDashboard AS
SELECT 
    s.student_name,
    sub.subject_name,
    e.exam_date,
    sc.score,
    CASE 
        WHEN sc.score >= 90 THEN 'A'
        WHEN sc.score >= 80 THEN 'B'
        WHEN sc.score >= 70 THEN 'C'
        WHEN sc.score >= 60 THEN 'D'
        ELSE 'F'
    END AS grade
FROM Scores sc
JOIN Students s ON sc.student_id = s.student_id
JOIN Exams e ON sc.exam_id = e.exam_id
JOIN Subjects sub ON e.subject_id = sub.subject_id;

-- View usage example
SELECT * FROM StudentScoreDashboard;

-- ============================================
-- 7. LIMIT FOR TOP SCORERS
-- ============================================

SELECT * FROM StudentScoreDashboard
ORDER BY score DESC
LIMIT 5;