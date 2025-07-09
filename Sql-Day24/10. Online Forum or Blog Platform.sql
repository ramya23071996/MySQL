-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS BlogPlatform;
USE BlogPlatform;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Users table
CREATE TABLE IF NOT EXISTS Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(100)
);

-- Posts table
CREATE TABLE IF NOT EXISTS Posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    post_title VARCHAR(200),
    post_content TEXT,
    post_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Comments table
CREATE TABLE IF NOT EXISTS Comments (
    comment_id INT PRIMARY KEY,
    post_id INT,
    user_id INT,
    comment_text TEXT,
    comment_date DATE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Users
INSERT INTO Users VALUES
(1, 'alice', 'alice@example.com'),
(2, 'bob', 'bob@example.com'),
(3, 'charlie', 'charlie@example.com');

-- Posts
INSERT INTO Posts VALUES
(101, 1, 'Welcome to the Blog', 'This is the first post.', '2024-07-01'),
(102, 2, 'Tech Trends 2024', 'Let’s explore the future.', '2024-07-02');

-- Comments
INSERT INTO Comments VALUES
(1, 101, 2, 'Great start!', '2024-07-01'),
(2, 101, 3, 'Looking forward to more.', '2024-07-01'),
(3, 102, 1, 'Interesting insights.', '2024-07-02');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_user_id ON Users(user_id);
CREATE INDEX idx_post_date ON Posts(post_date);
CREATE INDEX idx_post_title ON Posts(post_title);

-- ============================================
-- 4. EXPLAIN: OPTIMIZE COMMENT FETCHING PER POST
-- ============================================

EXPLAIN
SELECT c.comment_text, c.comment_date, u.username
FROM Comments c
JOIN Users u ON c.user_id = u.user_id
WHERE c.post_id = 101
ORDER BY c.comment_date DESC;

-- ============================================
-- 5. DENORMALIZED VIEW: POST + COMMENT + AUTHOR
-- ============================================

CREATE OR REPLACE VIEW PostCommentAuthorView AS
SELECT 
    p.post_id,
    p.post_title,
    p.post_date,
    p.post_content,
    u1.username AS post_author,
    c.comment_id,
    c.comment_text,
    c.comment_date,
    u2.username AS comment_author
FROM Posts p
JOIN Users u1 ON p.user_id = u1.user_id
LEFT JOIN Comments c ON p.post_id = c.post_id
LEFT JOIN Users u2 ON c.user_id = u2.user_id;

-- View usage example
SELECT * FROM PostCommentAuthorView
WHERE post_id = 101
ORDER BY comment_date DESC;