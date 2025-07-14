-- 1. Create Blog Database
CREATE DATABASE blog_management;
USE blog_management;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Posts Table
CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(150),
    content TEXT,
    published_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 4. Comments Table
CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    comment_text TEXT,
    commented_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Sample Posts
INSERT INTO posts (user_id, title, content, published_date) VALUES
(1, 'Mastering SQL Joins', 'An in-depth look at INNER, LEFT, RIGHT joins.', '2025-07-15'),
(2, 'React vs Angular', 'Which frontend framework suits your project?', '2025-07-16'),
(3, 'Healthy Eating for Developers', 'Quick meals and nutrition tips.', '2025-07-17'),
(4, 'DevOps Best Practices', 'Tools and workflows for efficient deployment.', '2025-07-18'),
(5, 'UI Design Principles', 'How to design intuitive interfaces.', '2025-07-19');

-- 7. Sample Comments
INSERT INTO comments (post_id, user_id, comment_text) VALUES
(1, 2, 'Loved the clarity on LEFT JOIN!'),
(1, 3, 'Could you add visuals next time?'),
(2, 1, 'I prefer React, but Angular does scale well.'),
(3, 4, 'Great tips, bookmarked it.'),
(4, 5, 'You missed mentioning GitHub Actions.'),
(5, 1, 'Design needs empathy. Well put!'),
(2, 4, 'Can you cover Vue.js soon?'),
(3, 5, 'Smooth read and practical advice.'),
(4, 2, 'Thanks for the YAML examples.'),
(5, 3, 'Would love examples with Figma.');

-- 8. Query: All Comments with Post and User Details
SELECT 
    p.title AS post,
    u.name AS commenter,
    c.comment_text,
    c.commented_at
FROM comments c
JOIN posts p ON c.post_id = p.id
JOIN users u ON c.user_id = u.id
ORDER BY c.commented_at DESC;

-- 9. Query: Posts by 'Ramya'
SELECT 
    p.title,
    p.published_date
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE u.name = 'Ramya';

-- 10. Query: Posts Published After July 16, 2025
SELECT 
    u.name AS author,
    p.title,
    p.published_date
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE p.published_date > '2025-07-16';

-- 11. Query: Comment Count Per Post
SELECT 
    p.title,
    COUNT(c.id) AS total_comments
FROM posts p
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.title;