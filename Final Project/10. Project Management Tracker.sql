-- 1. Create Database
CREATE DATABASE project_tracker;
USE project_tracker;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Projects Table
CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL
);

-- 4. Tasks Table
CREATE TABLE tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    name VARCHAR(150) NOT NULL,
    status ENUM('Not Started', 'In Progress', 'Completed') DEFAULT 'Not Started',
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

-- 5. Task Assignments Table (User-Task Link)
CREATE TABLE task_assignments (
    task_id INT,
    user_id INT,
    PRIMARY KEY (task_id, user_id),
    FOREIGN KEY (task_id) REFERENCES tasks(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 6. Insert Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 7. Insert Sample Projects
INSERT INTO projects (name) VALUES
('Inventory Tracker'), ('E-Commerce System'), ('CRM Dashboard');

-- 8. Insert Sample Tasks
INSERT INTO tasks (project_id, name, status) VALUES
(1, 'Design schema', 'Completed'),
(1, 'Build ETL flow', 'In Progress'),
(1, 'Create dashboard', 'Not Started'),
(2, 'Set up product table', 'Completed'),
(2, 'Cart logic', 'In Progress'),
(2, 'Discount engine', 'Not Started'),
(3, 'Lead source mapping', 'Completed'),
(3, 'User-based filters', 'In Progress'),
(3, 'Stage progression query', 'Not Started');

-- 9. Assign Tasks to Users
INSERT INTO task_assignments (task_id, user_id) VALUES
(1, 1), (2, 1), (3, 1),
(4, 2), (5, 2),
(6, 5), (7, 3),
(8, 4), (9, 5);

-- 10. Query: Task Summary per Project
SELECT p.name AS project, t.status, COUNT(*) AS total_tasks
FROM tasks t
JOIN projects p ON t.project_id = p.id
GROUP BY p.name, t.status;

-- 11. Query: Tasks Assigned to Ramya
SELECT p.name AS project, t.name AS task, t.status
FROM task_assignments ta
JOIN tasks t ON ta.task_id = t.id
JOIN projects p ON t.project_id = p.id
JOIN users u ON ta.user_id = u.id
WHERE u.name = 'Ramya';

-- 12. Query: Count of Completed Tasks by User
SELECT u.name AS user, COUNT(*) AS completed_tasks
FROM task_assignments ta
JOIN tasks t ON ta.task_id = t.id
JOIN users u ON ta.user_id = u.id
WHERE t.status = 'Completed'
GROUP BY u.name;