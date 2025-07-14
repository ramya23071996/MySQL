-- 1. Create IT Support Database
CREATE DATABASE it_support;
USE it_support;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Support Staff Table
CREATE TABLE support_staff (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Tickets Table
CREATE TABLE tickets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    issue VARCHAR(255) NOT NULL,
    status ENUM('Open', 'In Progress', 'Resolved') NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. Assignments Table (Maps tickets to support staff)
CREATE TABLE assignments (
    ticket_id INT,
    staff_id INT,
    PRIMARY KEY (ticket_id, staff_id),
    FOREIGN KEY (ticket_id) REFERENCES tickets(id),
    FOREIGN KEY (staff_id) REFERENCES support_staff(id)
);

-- 6. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 7. Sample Support Staff
INSERT INTO support_staff (name) VALUES
('Alex'), ('Divya'), ('Jay'), ('Neha');

-- 8. Sample Tickets
INSERT INTO tickets (user_id, issue, status, created_at, resolved_at) VALUES
(1, 'Laptop won’t boot', 'Resolved', '2025-07-01 09:00:00', '2025-07-01 12:30:00'),
(2, 'VPN login failure', 'Resolved', '2025-07-01 10:15:00', '2025-07-01 11:00:00'),
(3, 'Email not syncing', 'In Progress', '2025-07-02 08:45:00', NULL),
(4, 'Printer offline', 'Resolved', '2025-07-02 09:30:00', '2025-07-02 10:20:00'),
(5, 'Software installation request', 'Open', '2025-07-03 10:00:00', NULL);

-- 9. Sample Assignments
INSERT INTO assignments VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 1);

-- 10. Query: Average Resolution Time (Resolved Only)
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, created_at, resolved_at)), 2) AS avg_resolution_minutes
FROM tickets
WHERE status = 'Resolved';

-- 11. Query: Ticket Volume by Issue Keyword (Grouped by type)
SELECT 
    issue,
    COUNT(*) AS ticket_count
FROM tickets
GROUP BY issue
ORDER BY ticket_count DESC;

-- 12. Query: Open or In Progress Tickets Assigned to Staff
SELECT 
    ss.name AS staff,
    t.issue,
    t.status,
    t.created_at
FROM assignments a
JOIN support_staff ss ON a.staff_id = ss.id
JOIN tickets t ON a.ticket_id = t.id
WHERE t.status IN ('Open', 'In Progress')
ORDER BY ss.name;

-- 13. Query: Tickets Filed by Ramya
SELECT 
    t.issue,
    t.status,
    t.created_at,
    t.resolved_at
FROM tickets t
JOIN users u ON t.user_id = u.id
WHERE u.name = 'Ramya';