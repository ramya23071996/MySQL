-- 1. Create Database
CREATE DATABASE fitness_tracker;
USE fitness_tracker;

-- 2. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Workouts Table
CREATE TABLE workouts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    type ENUM('Cardio', 'Strength', 'Flexibility', 'Balance') NOT NULL
);

-- 4. Workout Logs Table
CREATE TABLE workout_logs (
    user_id INT,
    workout_id INT,
    duration INT, -- in minutes
    log_date DATE,
    PRIMARY KEY (user_id, workout_id, log_date),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (workout_id) REFERENCES workouts(id)
);

-- 5. Sample Users
INSERT INTO users (name) VALUES
('Ramya'), ('Arjun'), ('Sneha');

-- 6. Sample Workouts
INSERT INTO workouts (name, type) VALUES
('Running', 'Cardio'),
('Cycling', 'Cardio'),
('Yoga', 'Flexibility'),
('Push-ups', 'Strength'),
('Squats', 'Strength'),
('Plank', 'Balance');

-- 7. Sample Logs
INSERT INTO workout_logs (user_id, workout_id, duration, log_date) VALUES
(1, 1, 30, '2025-07-21'),
(1, 4, 20, '2025-07-22'),
(1, 3, 40, '2025-07-23'),
(1, 2, 25, '2025-07-24'),
(1, 5, 15, '2025-07-24'),
(2, 1, 45, '2025-07-21'),
(2, 4, 35, '2025-07-22'),
(2, 6, 10, '2025-07-23'),
(3, 3, 50, '2025-07-21'),
(3, 5, 30, '2025-07-24');

-- 8. Weekly Summary Per User
SELECT 
    u.name AS user,
    WEEK(wl.log_date) AS week,
    SUM(wl.duration) AS total_minutes
FROM workout_logs wl
JOIN users u ON wl.user_id = u.id
GROUP BY u.name, WEEK(wl.log_date)
ORDER BY u.name, week;

-- 9. Workout Breakdown by Type
SELECT 
    u.name AS user,
    w.name AS workout,
    w.type,
    wl.duration,
    wl.log_date
FROM workout_logs wl
JOIN users u ON wl.user_id = u.id
JOIN workouts w ON wl.workout_id = w.id
ORDER BY wl.log_date DESC;

-- 10. Total Minutes Per Workout Type
SELECT 
    w.type,
    SUM(wl.duration) AS total_minutes
FROM workout_logs wl
JOIN workouts w ON wl.workout_id = w.id
GROUP BY w.type
ORDER BY total_minutes DESC;