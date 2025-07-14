-- 1. Create Database
CREATE DATABASE voting_system;
USE voting_system;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Polls Table
CREATE TABLE polls (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question TEXT NOT NULL
);

-- 4. Options Table
CREATE TABLE options (
    id INT PRIMARY KEY AUTO_INCREMENT,
    poll_id INT,
    option_text VARCHAR(255),
    FOREIGN KEY (poll_id) REFERENCES polls(id)
);

-- 5. Votes Table
CREATE TABLE votes (
    user_id INT,
    option_id INT,
    voted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, option_id), -- Prevent duplicate vote on same option
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (option_id) REFERENCES options(id)
);

-- 6. Sample Users
INSERT INTO users (name) VALUES 
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 7. Sample Polls
INSERT INTO polls (question) VALUES
('What is your favorite frontend framework?'),
('Which cloud provider do you prefer?');

-- 8. Sample Options
INSERT INTO options (poll_id, option_text) VALUES
(1, 'React'), (1, 'Angular'), (1, 'Vue'), (1, 'Svelte'),
(2, 'AWS'), (2, 'Azure'), (2, 'Google Cloud'), (2, 'IBM Cloud');

-- 9. Sample Votes
INSERT INTO votes (user_id, option_id) VALUES
(1, 1), (2, 3), (3, 2),
(4, 1), (5, 4),
(1, 5), (2, 6), (3, 5),
(4, 7), (5, 6);

-- 10. Query: Count Votes per Option
SELECT 
    p.question,
    o.option_text,
    COUNT(v.user_id) AS vote_count
FROM options o
JOIN polls p ON o.poll_id = p.id
LEFT JOIN votes v ON o.id = v.option_id
GROUP BY p.question, o.option_text
ORDER BY p.question, vote_count DESC;

-- 11. Query: User's Votes
SELECT 
    u.name AS user,
    p.question,
    o.option_text,
    v.voted_at
FROM votes v
JOIN users u ON v.user_id = u.id
JOIN options o ON v.option_id = o.id
JOIN polls p ON o.poll_id = p.id
ORDER BY v.voted_at;