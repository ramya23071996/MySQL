-- 1. Create Database
CREATE DATABASE online_forum;
USE online_forum;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Threads Table
CREATE TABLE threads (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    user_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 4. Posts Table (Supports threaded replies via self-join)
CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    thread_id INT,
    user_id INT,
    content TEXT NOT NULL,
    parent_post_id INT, -- NULL for top-level post
    posted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (thread_id) REFERENCES threads(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_post_id) REFERENCES posts(id)
);

-- 5. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Sample Threads
INSERT INTO threads (title, user_id) VALUES
('How to optimize SQL joins?', 1),
('React vs Vue: Opinions?', 2),
('Best practices for database schema design', 3);

-- 7. Sample Posts
INSERT INTO posts (thread_id, user_id, content, parent_post_id) VALUES
(1, 1, 'I start with EXPLAIN to trace join paths.', NULL),
(1, 2, 'Indexing keys improved my join speed.', 1),
(1, 3, 'Try CTEs when joins get complex.', 1),
(1, 4, 'Does query planner differ by DB?', 2),
(2, 2, 'React is flexible but Vue’s syntax is cleaner.', NULL),
(2, 5, 'I switched to Vue after React fatigue.', 5),
(3, 3, 'Normalize as far as needed, denormalize for reporting.', NULL),
(3, 1, 'Do you use views or materialized tables?', 7);

-- 8. Threaded Posts in a Thread
SELECT 
    p.id,
    u.name AS author,
    p.content,
    p.parent_post_id,
    p.posted_at
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE p.thread_id = 1
ORDER BY p.posted_at;

-- 9. Reply Chain for Specific Post
SELECT 
    p.id,
    u.name AS responder,
    p.content,
    p.posted_at
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE p.parent_post_id = 1
ORDER BY p.posted_at;

-- 10. Threads with Post Count
SELECT 
    t.title,
    u.name AS thread_owner,
    COUNT(p.id) AS replies
FROM threads t
JOIN users u ON t.user_id = u.id
LEFT JOIN posts p ON t.id = p.thread_id
GROUP BY t.title, u.name
ORDER BY replies DESC;