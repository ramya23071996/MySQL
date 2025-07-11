-- Step 1: Create StudentQuizScores Table
CREATE TABLE StudentQuizScores (
    quiz_id INT PRIMARY KEY,
    student_id INT,
    student_name VARCHAR(50),
    quiz_date DATE,
    score INT
);

-- Step 2: Insert Sample Quiz Data
INSERT INTO StudentQuizScores VALUES
(1, 201, 'Ananya', '2025-06-01', 75),
(2, 201, 'Ananya', '2025-06-10', 80),
(3, 201, 'Ananya', '2025-06-20', 85),
(4, 202, 'Bharath', '2025-06-01', 65),
(5, 202, 'Bharath', '2025-06-10', 60),
(6, 202, 'Bharath', '2025-06-20', 60),
(7, 203, 'Charu', '2025-06-01', 88),
(8, 203, 'Charu', '2025-06-10', 90),
(9, 203, 'Charu', '2025-06-20', 85);

-- Step 3: CTE to Track Score Changes per Student
WITH ScoreProgress AS (
    SELECT 
        student_id,
        student_name,
        quiz_date,
        score,
        LAG(score) OVER(PARTITION BY student_id ORDER BY quiz_date) AS previous_score
    FROM StudentQuizScores
),

-- Step 4: CTE to Summarize Improvement per Student
ImprovementSummary AS (
    SELECT 
        student_id,
        student_name,
        COUNT(*) AS quizzes_attempted,
        SUM(
            CASE 
                WHEN score > previous_score THEN 1
                WHEN score < previous_score THEN -1
                ELSE 0
            END
        ) AS net_change
    FROM ScoreProgress
    GROUP BY student_id, student_name
)

-- Step 5: Final Report with Status Label
SELECT 
    student_id,
    student_name,
    quizzes_attempted,
    net_change,
    CASE 
        WHEN net_change > 0 THEN '📈 Improving'
        WHEN net_change < 0 THEN '📉 Declining'
        ELSE '➖ Stagnant'
    END AS progress_status
FROM ImprovementSummary
ORDER BY progress_status DESC, student_name;