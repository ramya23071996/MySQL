-- Step 1: Create Mentors Table (self-referencing)
CREATE TABLE Mentors (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    mentor_id INT,
    class_level VARCHAR(50),
    FOREIGN KEY (mentor_id) REFERENCES Mentors(student_id)
);

-- Step 2: Insert Sample Data
INSERT INTO Mentors VALUES
(1, 'Prof. Arjun', NULL, 'Senior Mentor'),
(2, 'Dr. Bhavna', 1, 'Mentor'),
(3, 'Mr. Chetan', 1, 'Mentor'),
(4, 'Deepa', 2, 'Student'),
(5, 'Esha', 2, 'Student'),
(6, 'Farhan', 3, 'Student'),
(7, 'Gauri', 3, 'Student'),
(8, 'Harsh', 4, 'Junior Assistant');

-- Step 3: Recursive CTE for Hierarchy & Depth
WITH RECURSIVE ClassHierarchy AS (
    SELECT 
        student_id,
        student_name,
        mentor_id,
        class_level,
        1 AS depth_level,
        CAST(student_name AS VARCHAR(1000)) AS mentor_path
    FROM Mentors
    WHERE mentor_id IS NULL

    UNION ALL

    SELECT 
        m.student_id,
        m.student_name,
        m.mentor_id,
        m.class_level,
        ch.depth_level + 1,
        CONCAT(ch.mentor_path, ' → ', m.student_name)
    FROM Mentors m
    INNER JOIN ClassHierarchy ch ON m.mentor_id = ch.student_id
)

-- Step 4: Create View for Mentor Teams
CREATE VIEW MentorTeamView AS
SELECT 
    student_id,
    student_name,
    mentor_id,
    class_level,
    depth_level,
    mentor_path
FROM ClassHierarchy;

-- Step 5: Final Report - Display Sorted Mentorship Tree
SELECT 
    student_id,
    student_name,
    class_level,
    depth_level,
    mentor_path
FROM MentorTeamView
ORDER BY mentor_path;