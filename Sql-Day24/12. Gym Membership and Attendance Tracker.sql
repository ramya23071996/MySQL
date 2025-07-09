-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS GymTracker;
USE GymTracker;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Trainers table
CREATE TABLE IF NOT EXISTS Trainers (
    trainer_id INT PRIMARY KEY,
    trainer_name VARCHAR(100),
    specialization VARCHAR(100)
);

-- Plans table
CREATE TABLE IF NOT EXISTS Plans (
    plan_id INT PRIMARY KEY,
    plan_type VARCHAR(50),
    duration_months INT,
    price DECIMAL(10,2)
);

-- Members table
CREATE TABLE IF NOT EXISTS Members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(100),
    email VARCHAR(100),
    plan_id INT,
    trainer_id INT,
    FOREIGN KEY (plan_id) REFERENCES Plans(plan_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id)
);

-- CheckIns table
CREATE TABLE IF NOT EXISTS CheckIns (
    checkin_id INT PRIMARY KEY,
    member_id INT,
    checkin_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Trainers
INSERT INTO Trainers VALUES
(1, 'Ravi', 'Strength'),
(2, 'Anita', 'Cardio'),
(3, 'Karan', 'Yoga');

-- Plans
INSERT INTO Plans VALUES
(1, 'Basic', 1, 1000.00),
(2, 'Standard', 3, 2500.00),
(3, 'Premium', 6, 4500.00);

-- Members
INSERT INTO Members VALUES
(1, 'Alice', 'alice@gym.com', 2, 1),
(2, 'Bob', 'bob@gym.com', 1, 2),
(3, 'Charlie', 'charlie@gym.com', 3, 3);

-- CheckIns
INSERT INTO CheckIns VALUES
(1, 1, '2024-07-01'),
(2, 2, '2024-07-01'),
(3, 1, '2024-07-02'),
(4, 3, '2024-07-02'),
(5, 2, '2024-07-03'),
(6, 1, '2024-07-03');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_member_name ON Members(member_name);
CREATE INDEX idx_checkin_date ON CheckIns(checkin_date);
CREATE INDEX idx_plan_type ON Plans(plan_type);

-- ============================================
-- 4. DENORMALIZED TRAINER DASHBOARD VIEW
-- ============================================

CREATE OR REPLACE VIEW TrainerDashboard AS
SELECT 
    m.member_id,
    m.member_name,
    t.trainer_name,
    p.plan_type,
    c.checkin_date
FROM Members m
JOIN Trainers t ON m.trainer_id = t.trainer_id
JOIN Plans p ON m.plan_id = p.plan_id
LEFT JOIN CheckIns c ON m.member_id = c.member_id;

-- View usage example
SELECT * FROM TrainerDashboard WHERE trainer_name = 'Ravi';

-- ============================================
-- 5. RECENT CHECK-INS WITH LIMIT AND ORDER BY
-- ============================================

SELECT m.member_name, c.checkin_date
FROM CheckIns c
JOIN Members m ON c.member_id = m.member_id
ORDER BY c.checkin_date DESC
LIMIT 5;