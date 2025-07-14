-- 1. Create Database
CREATE DATABASE survey_data;
USE survey_data;

-- 2. Surveys Table
CREATE TABLE surveys (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL
);

-- 3. Questions Table
CREATE TABLE questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    survey_id INT,
    question_text TEXT NOT NULL,
    FOREIGN KEY (survey_id) REFERENCES surveys(id)
);

-- 4. Responses Table
CREATE TABLE responses (
    user_id INT,
    question_id INT,
    answer_text VARCHAR(255),
    PRIMARY KEY (user_id, question_id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- 5. Sample Surveys
INSERT INTO surveys (title) VALUES
('Developer Habits Survey'),
('Tech Stack Preferences');

-- 6. Sample Questions
INSERT INTO questions (survey_id, question_text) VALUES
(1, 'How many hours do you code daily?'),
(1, 'Do you prefer early morning coding?'),
(1, 'Which editor do you use?'),
(2, 'Favorite front-end framework?'),
(2, 'Preferred back-end language?');

-- 7. Sample Responses
INSERT INTO responses (user_id, question_id, answer_text) VALUES
(1, 1, '4–6 hours'),
(1, 2, 'Yes'),
(1, 3, 'VS Code'),
(2, 1, '8+ hours'),
(2, 2, 'No'),
(2, 3, 'IntelliJ'),
(3, 1, '2–4 hours'),
(3, 2, 'Yes'),
(3, 3, 'VS Code'),
(1, 4, 'React'),
(1, 5, 'Python'),
(2, 4, 'Vue'),
(2, 5, 'Java'),
(3, 4, 'React'),
(3, 5, 'Node.js');

-- 8. Query: Response Count Per Question
SELECT 
    s.title AS survey,
    q.question_text,
    COUNT(r.user_id) AS total_responses
FROM surveys s
JOIN questions q ON s.id = q.survey_id
LEFT JOIN responses r ON q.id = r.question_id
GROUP BY s.title, q.question_text;

-- 9. Query: Distribution of Editor Usage
SELECT 
    q.question_text,
    r.answer_text,
    COUNT(*) AS count
FROM questions q
JOIN responses r ON q.id = r.question_id
WHERE q.question_text = 'Which editor do you use?'
GROUP BY r.answer_text;

-- 10. Query: Pivot-style Summary (MySQL GROUP_CONCAT)
SELECT 
    q.question_text,
    GROUP_CONCAT(CONCAT('User ', r.user_id, ': ', r.answer_text) SEPARATOR '; ') AS responses_summary
FROM questions q
JOIN responses r ON q.id = r.question_id
GROUP BY q.question_text;