-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Results;
DROP TABLE IF EXISTS Exams;
DROP TABLE IF EXISTS Candidates;

-- 🏗️ Create Candidates table
CREATE TABLE Candidates (
    candidate_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 🏗️ Create Exams table
CREATE TABLE Exams (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_name VARCHAR(100) NOT NULL,
    exam_date DATE NOT NULL
);

-- 🏗️ Create Results table
CREATE TABLE Results (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT NOT NULL,
    exam_id INT NOT NULL,
    marks INT NOT NULL CHECK (marks >= 0 AND marks <= 100),
    result_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id),
    FOREIGN KEY (exam_id) REFERENCES Exams(exam_id),
    UNIQUE (candidate_id, exam_id)
);

-- 👤 Insert sample candidates
INSERT INTO Candidates (name, email) VALUES
('Sanya Mehta', 'sanya.mehta@example.com'),
('Rahul Verma', 'rahul.verma@example.com');

-- 📝 Insert sample exams
INSERT INTO Exams (exam_name, exam_date) VALUES
('SQL Fundamentals', '2025-07-10'),
('Python Basics', '2025-07-12');

-- 🧾 Insert result + generate certificate using transaction
START TRANSACTION;

-- Step 1: Insert result
INSERT INTO Results (candidate_id, exam_id, marks)
VALUES (1, 1, 85);

-- Step 2: Simulate certificate generation (log or insert into another table if needed)
-- For now, just simulate with a comment or placeholder
-- INSERT INTO Certificates (candidate_id, exam_id, issue_date) VALUES (1, 1, CURDATE());

-- ✅ Commit if all successful
COMMIT;

-- ✏️ Update marks after re-evaluation
UPDATE Results
SET marks = 90
WHERE candidate_id = 1 AND exam_id = 1;

-- ❌ Delete invalid or duplicate results
-- Example: marks out of range or duplicate entry attempt
DELETE FROM Results
WHERE marks < 0 OR marks > 100;

-- Or delete a specific duplicate/invalid entry
-- DELETE FROM Results WHERE result_id = 5;