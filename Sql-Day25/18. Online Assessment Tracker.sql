-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS AssessmentDB;
USE AssessmentDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Assessments (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    max_score INT,
    grading_deadline DATE
);

CREATE TABLE IF NOT EXISTS Submissions (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    assessment_id INT,
    score INT,
    answer_text TEXT,
    instructor_remarks TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (assessment_id) REFERENCES Assessments(assessment_id)
);

-- Step 3: Create views

-- Student view: scores only
CREATE OR REPLACE VIEW StudentScoreView AS
SELECT 
    s.student_id,
    s.student_name,
    a.title AS assessment_title,
    sub.score
FROM Submissions sub
JOIN Students s ON sub.student_id = s.student_id
JOIN Assessments a ON sub.assessment_id = a.assessment_id;

-- Instructor view: full submission details
CREATE OR REPLACE VIEW InstructorSubmissionView AS
SELECT 
    sub.submission_id,
    s.student_name,
    a.title AS assessment_title,
    sub.score,
    sub.answer_text,
    sub.instructor_remarks,
    sub.submitted_at
FROM Submissions sub
JOIN Students s ON sub.student_id = s.student_id
JOIN Assessments a ON sub.assessment_id = a.assessment_id;

-- Step 4: Create function to calculate grade
DELIMITER //
CREATE FUNCTION CalculateGrade(score INT) RETURNS CHAR(2)
DETERMINISTIC
BEGIN
    DECLARE grade CHAR(2);
    IF score >= 90 THEN SET grade = 'A+';
    ELSEIF score >= 80 THEN SET grade = 'A';
    ELSEIF score >= 70 THEN SET grade = 'B';
    ELSEIF score >= 60 THEN SET grade = 'C';
    ELSEIF score >= 50 THEN SET grade = 'D';
    ELSE SET grade = 'F';
    END IF;
    RETURN grade;
END;
//
DELIMITER ;

-- Step 5: Create stored procedure to insert assessment record
DELIMITER //
CREATE PROCEDURE SubmitAssessment(
    IN stu_id INT,
    IN assess_id INT,
    IN marks INT,
    IN answer TEXT
)
BEGIN
    INSERT INTO Submissions(student_id, assessment_id, score, answer_text)
    VALUES (stu_id, assess_id, marks, answer);
END;
//
DELIMITER ;

-- Step 6: Create trigger to block updates after grading deadline
DELIMITER //
CREATE TRIGGER PreventLateUpdate
BEFORE UPDATE ON Submissions
FOR EACH ROW
BEGIN
    DECLARE deadline DATE;
    SELECT grading_deadline INTO deadline
    FROM Assessments
    WHERE assessment_id = NEW.assessment_id;

    IF CURDATE() > deadline THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot modify submission after grading deadline.';
    END IF;
END;
//
DELIMITER ;

-- Step 7: Insert sample data

-- Students
INSERT INTO Students (student_name, email) VALUES
('Aarav', 'aarav@example.com'),
('Diya', 'diya@example.com'),
('Rohan', 'rohan@example.com');

-- Assessments
INSERT INTO Assessments (title, max_score, grading_deadline) VALUES
('Math Quiz 1', 100, '2025-08-10'),
('Science Test', 100, '2025-08-15');

-- Submissions
CALL SubmitAssessment(1, 1, 85, 'Answer to math quiz');
CALL SubmitAssessment(2, 1, 92, 'Answer to math quiz');
CALL SubmitAssessment(3, 2, 78, 'Answer to science test');