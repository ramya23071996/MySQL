-- 1️⃣ Drop and Create Tables
DROP TABLE IF EXISTS Results;
DROP TABLE IF EXISTS Exams;
DROP TABLE IF EXISTS Candidates;

CREATE TABLE Candidates (
    CandidateID INT PRIMARY KEY,
    CandidateName VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE Exams (
    ExamID INT PRIMARY KEY,
    ExamName VARCHAR(100),
    MaxMarks INT
);

CREATE TABLE Results (
    ResultID INT PRIMARY KEY,
    CandidateID INT,
    ExamID INT,
    Score INT,
    FOREIGN KEY (CandidateID) REFERENCES Candidates(CandidateID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);

-- 2️⃣ Insert Sample Data
INSERT INTO Candidates VALUES
(1, 'Ramya', 'ramya@example.com'),
(2, 'Arjun', 'arjun@example.com'),
(3, 'Priya', 'priya@example.com'),
(4, 'Karan', 'karan@example.com');

INSERT INTO Exams VALUES
(101, 'SQL Certification', 100);

INSERT INTO Results VALUES
(1001, 1, 101, 85),
(1002, 2, 101, 70),
(1003, 3, 101, 92),
(1004, 4, 101, 55);

-- 3️⃣ Display Results with JOIN, Pass/Fail, Rank, and Percentile
SELECT 
    c.CandidateID,
    c.CandidateName,
    r.Score,
    e.MaxMarks,
    
    -- Pass/Fail using CASE
    CASE 
        WHEN r.Score >= 60 THEN 'Pass'
        ELSE 'Fail'
    END AS Status,

    -- Percentile using subquery
    ROUND((
        SELECT 100.0 * COUNT(*) / (SELECT COUNT(*) FROM Results r2 WHERE r2.ExamID = 101)
        FROM Results r1
        WHERE r1.Score <= r.Score AND r1.ExamID = r.ExamID
    ), 2) AS Percentile,

    -- Rank using DENSE_RANK
    DENSE_RANK() OVER (ORDER BY r.Score DESC) AS Rank

FROM Results r
JOIN Candidates c ON r.CandidateID = c.CandidateID
JOIN Exams e ON r.ExamID = e.ExamID
WHERE r.ExamID = 101
ORDER BY r.Score DESC;