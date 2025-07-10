-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS IdentityDB;
USE IdentityDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) UNIQUE,
    email VARCHAR(100),
    role VARCHAR(20) DEFAULT 'employee'
);

CREATE TABLE IF NOT EXISTS UserSettings (
    setting_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    theme VARCHAR(20) DEFAULT 'light',
    notifications_enabled BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE IF NOT EXISTS RoleAudit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    old_role VARCHAR(20),
    new_role VARCHAR(20),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create views for each role

CREATE OR REPLACE VIEW AdminView AS
SELECT user_id, username, email, role FROM Users WHERE role = 'admin';

CREATE OR REPLACE VIEW ManagerView AS
SELECT user_id, username, role FROM Users WHERE role = 'manager';

CREATE OR REPLACE VIEW EmployeeView AS
SELECT user_id, username FROM Users WHERE role = 'employee';

-- Step 4: Stored procedure to assign role

DELIMITER //
CREATE PROCEDURE AssignUserRole(
    IN uid INT,
    IN new_role VARCHAR(20)
)
BEGIN
    DECLARE current_role VARCHAR(20);
    SELECT role INTO current_role FROM Users WHERE user_id = uid;

    UPDATE Users SET role = new_role WHERE user_id = uid;

    INSERT INTO RoleAudit(user_id, old_role, new_role)
    VALUES (uid, current_role, new_role);
END;
//
DELIMITER ;

-- Step 5: Function to check if user is admin

DELIMITER //
CREATE FUNCTION IsAdmin(uid INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE result BOOLEAN;
    DECLARE r VARCHAR(20);
    SELECT role INTO r FROM Users WHERE user_id = uid;
    SET result = (r = 'admin');
    RETURN result;
END;
//
DELIMITER ;

-- Step 6: Trigger to insert default settings after user creation

DELIMITER //
CREATE TRIGGER InsertDefaultSettings
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO UserSettings(user_id) VALUES (NEW.user_id);
END;
//
DELIMITER ;

-- Step 7: Insert 50 sample users with varied roles

INSERT INTO Users (username, email, role)
SELECT 
    CONCAT('user_', LPAD(n, 2, '0')),
    CONCAT('user_', LPAD(n, 2, '0'), '@company.com'),
    CASE 
        WHEN n % 10 = 0 THEN 'admin'
        WHEN n % 5 = 0 THEN 'manager'
        ELSE 'employee'
    END
FROM (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
    UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
    UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
    UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL SELECT 25
    UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30
    UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35
    UNION ALL SELECT 36 UNION ALL SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL SELECT 40
    UNION ALL SELECT 41 UNION ALL SELECT 42 UNION ALL SELECT 43 UNION ALL SELECT 44 UNION ALL SELECT 45
    UNION ALL SELECT 46 UNION ALL SELECT 47 UNION ALL SELECT 48 UNION ALL SELECT 49 UNION ALL SELECT 50
) AS numbers;