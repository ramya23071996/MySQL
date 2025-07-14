-- 1. Create Notification Database
CREATE DATABASE notification_system;
USE notification_system;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Notifications Table
CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message TEXT NOT NULL,
    status ENUM('Unread', 'Read') DEFAULT 'Unread',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 4. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 5. Sample Notifications
INSERT INTO notifications (user_id, message, status, created_at) VALUES
(1, 'Your invoice #1025 is ready.', 'Unread', '2025-07-15 08:00:00'),
(1, 'SQL blog post published successfully.', 'Unread', '2025-07-15 09:30:00'),
(2, 'Your password was changed.', 'Read', '2025-07-15 10:00:00'),
(2, 'New ETL job completed.', 'Unread', '2025-07-15 11:00:00'),
(3, 'Security alert: new login detected.', 'Unread', '2025-07-15 08:45:00'),
(4, 'Dashboard updated with new metrics.', 'Unread', '2025-07-15 09:15:00'),
(5, 'Comment reply received.', 'Read', '2025-07-15 07:45:00'),
(1, 'Meeting scheduled for 4PM.', 'Read', '2025-07-15 07:00:00'),
(3, 'Library records synced.', 'Read', '2025-07-15 06:30:00'),
(2, 'Profile updated.', 'Unread', '2025-07-15 12:00:00');

-- 6. Query: Get Unread Notification Count per User
SELECT 
    u.name AS user,
    COUNT(n.id) AS unread_notifications
FROM notifications n
JOIN users u ON n.user_id = u.id
WHERE n.status = 'Unread'
GROUP BY u.name;

-- 7. Query: List Unread Notifications for Ramya
SELECT 
    n.message,
    n.created_at
FROM notifications n
JOIN users u ON n.user_id = u.id
WHERE u.name = 'Ramya' AND n.status = 'Unread'
ORDER BY n.created_at DESC;

-- 8. Query: Mark Ramya's Notifications as Read
UPDATE notifications
SET status = 'Read'
WHERE user_id = (SELECT id FROM users WHERE name = 'Ramya') AND status = 'Unread';

-- 9. Query: Most Recent Notification for Each User
SELECT 
    u.name AS user,
    n.message,
    n.created_at
FROM notifications n
JOIN users u ON n.user_id = u.id
WHERE n.created_at = (
    SELECT MAX(created_at)
    FROM notifications
    WHERE user_id = n.user_id
)
ORDER BY n.created_at DESC;