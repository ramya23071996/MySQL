-- 1. Create Database
CREATE DATABASE messaging_system;
USE messaging_system;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Conversations Table
CREATE TABLE conversations (
    id INT PRIMARY KEY AUTO_INCREMENT
);

-- 4. Messages Table
CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT,
    sender_id INT,
    message_text TEXT NOT NULL,
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id),
    FOREIGN KEY (sender_id) REFERENCES users(id)
);

-- 5. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 6. Sample Conversations (each between two users; could be tracked separately if needed)
INSERT INTO conversations (id) VALUES (1), (2), (3);

-- 7. Sample Messages
INSERT INTO messages (conversation_id, sender_id, message_text, sent_at) VALUES
(1, 1, 'Hey Arjun, are you free tomorrow?', '2025-07-15 10:00:00'),
(1, 2, 'Hi Ramya, yes after 3PM.', '2025-07-15 10:02:00'),
(1, 1, 'Perfect! Let’s catch up.', '2025-07-15 10:05:00'),
(2, 3, 'Kiran, did you push the latest code?', '2025-07-15 11:00:00'),
(2, 4, 'Yes Sneha, it’s on the dev branch.', '2025-07-15 11:02:00'),
(2, 3, 'Great, I’ll start testing.', '2025-07-15 11:04:00'),
(3, 5, 'Ramya, loved your new blog post!', '2025-07-15 09:30:00'),
(3, 1, 'Thank you Meera 😊', '2025-07-15 09:32:00'),
(3, 5, 'When’s the next one coming?', '2025-07-15 09:35:00'),
(3, 1, 'Planning one on ETL design this weekend!', '2025-07-15 09:38:00');

-- 8. Query: Messages in a Conversation (Threaded)
SELECT 
    u.name AS sender,
    m.message_text,
    m.sent_at
FROM messages m
JOIN users u ON m.sender_id = u.id
WHERE m.conversation_id = 1
ORDER BY m.sent_at;

-- 9. Query: Most Recent Message Per Conversation (Latest ping)
SELECT 
    m.conversation_id,
    u.name AS sender,
    m.message_text,
    m.sent_at
FROM messages m
JOIN users u ON m.sender_id = u.id
WHERE m.sent_at = (
    SELECT MAX(sent_at)
    FROM messages
    WHERE conversation_id = m.conversation_id
)
ORDER BY m.sent_at DESC;

-- 10. Query: Chat History for Ramya
SELECT 
    m.conversation_id,
    u.name AS sender,
    m.message_text,
    m.sent_at
FROM messages m
JOIN users u ON m.sender_id = u.id
WHERE m.sender_id = 1
ORDER BY m.sent_at DESC;