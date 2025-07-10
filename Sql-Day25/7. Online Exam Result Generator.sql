-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS ExamDB;
USE ExamDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Exams (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_name VARCHAR(100),
    max_marks INT
);

CREATE TABLE IF NOT EXISTS Results (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    exam_id INT,
    marks_obtained INT,
    grade CHAR(2),
    published BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (exam_id) REFERENCES Exams(exam_id)
);

CREATE TABLE IF NOT EXISTS ScoreAudit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    result_id INT,
    old_marks INT,
    new_marks INT,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create view to show secure result summaries
CREATE OR REPLACE VIEW ResultSummary AS
SELECT 
    r.result_id,
    s.student_name,
    e.exam_name,
    r.marks_obtained,
    r.grade
FROM Results r
JOIN Students s ON r.student_id = s.student_id
JOIN Exams e ON r.exam_id = e.exam_id
WHERE r.published = TRUE;

-- Step 4: Create function to return grade
DELIMITER //
CREATE FUNCTION GetGrade(score INT) RETURNS CHAR(2)
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

-- Step 5: Create stored procedure to assign grades
DELIMITER //
CREATE PROCEDURE AssignGrades()
BEGIN
    UPDATE Results
    SET grade = GetGrade(marks_obtained)
    WHERE grade IS NULL;
END;
//
DELIMITER ;

-- Step 6: Trigger to prevent score updates after publishing
DELIMITER //
CREATE TRIGGER PreventScoreUpdate
BEFORE UPDATE ON Results
FOR EACH ROW
BEGIN
    IF OLD.published = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update marks after results are published';
    END IF;
END;
//
DELIMITER ;

-- Step 7: Trigger to log score modifications
DELIMITER //
CREATE TRIGGER LogScoreChange
AFTER UPDATE ON Results
FOR EACH ROW
BEGIN
    IF OLD.marks_obtained <> NEW.marks_obtained THEN
        INSERT INTO ScoreAudit(result_id, old_marks, new_marks)
        VALUES (NEW.result_id, OLD.marks_obtained, NEW.marks_obtained);
    END IF;
END;
//
DELIMITER ;

-- Step 8: Insert 50 students
INSERT INTO Students (student_name)
SELECT CONCAT('Student_', LPAD(n, 2, '0')) FROM (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
    UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
    UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
    UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL SELECT 25
    UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30
    UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35
    UNION ALL SELECT 36 UNION ALL SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL SELECT 40
    UNION ALL SELECT 41 UNION ALL SELECT 42 UNION ALL SELECT 43 UNION ALL SELECT 44 UNION ALL SELECT 45
    UNION ALL SELECT 46 UNION ALL SELECT 47 UNION ALL SELECT 48 UNION ALL SELECT 49 UNION ALL SELECT 50
) AS numbers;

-- Step 9: Insert one exam
INSERT INTO Exams (exam_name, max_marks) VALUES ('Final Exam', 100);

-- Step 10: Insert 50 results with random marks
INSERT INTO Results (student_id, exam_id, marks_obtained)
SELECT student_id, 1, FLOOR(RAND() * 51 + 50)  -- Random marks between 50 and 100
FROM Students;

-- Step 11: Assign grades
CALL AssignGrades();

-- Step 12: Publish results
UPDATE Results SET published = TRUE;