-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS LoyaltyDB;
USE LoyaltyDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    loyalty_points INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS LoyaltyLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    old_points INT,
    new_points INT,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create function to calculate loyalty level
DELIMITER //
CREATE FUNCTION GetLoyaltyLevel(points INT) RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE level VARCHAR(20);
    IF points >= 1000 THEN SET level = 'Platinum';
    ELSEIF points >= 500 THEN SET level = 'Gold';
    ELSEIF points >= 250 THEN SET level = 'Silver';
    ELSE SET level = 'Bronze';
    END IF;
    RETURN level;
END;
//
DELIMITER ;

-- Step 4: Create view to show customer points and levels
CREATE OR REPLACE VIEW CustomerLoyaltyView AS
SELECT 
    customer_id,
    customer_name,
    loyalty_points,
    GetLoyaltyLevel(loyalty_points) AS loyalty_level
FROM Customers;

-- Step 5: Create stored procedure to update loyalty points
DELIMITER //
CREATE PROCEDURE UpdateLoyaltyPoints(
    IN cust_id INT,
    IN purchase_amount DECIMAL(10,2)
)
BEGIN
    DECLARE current_points INT;
    DECLARE new_points INT;

    SELECT loyalty_points INTO current_points FROM Customers WHERE customer_id = cust_id;
    SET new_points = current_points + FLOOR(purchase_amount / 10); -- 1 point per ₹10 spent

    UPDATE Customers SET loyalty_points = new_points WHERE customer_id = cust_id;
END;
//
DELIMITER ;

-- Step 6: Create trigger to log loyalty updates
DELIMITER //
CREATE TRIGGER LogLoyaltyUpdate
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
    IF OLD.loyalty_points <> NEW.loyalty_points THEN
        INSERT INTO LoyaltyLog(customer_id, old_points, new_points)
        VALUES (NEW.customer_id, OLD.loyalty_points, NEW.loyalty_points);
    END IF;
END;
//
DELIMITER ;

-- Step 7: Insert 50 sample customers with random points
INSERT INTO Customers (customer_name, loyalty_points)
SELECT CONCAT('Customer_', LPAD(n, 2, '0')), FLOOR(RAND() * 1200)
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

-- Step 8: Drop and recreate view after new level rules (example: Platinum now at 1200)
DROP VIEW IF EXISTS CustomerLoyaltyView;

DELIMITER //
CREATE FUNCTION GetLoyaltyLevel(points INT) RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE level VARCHAR(20);
    IF points >= 1200 THEN SET level = 'Platinum';
    ELSEIF points >= 600 THEN SET level = 'Gold';
    ELSEIF points >= 300 THEN SET level = 'Silver';
    ELSE SET level = 'Bronze';
    END IF;
    RETURN level;
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW CustomerLoyaltyView AS
SELECT 
    customer_id,
    customer_name,
    loyalty_points,
    GetLoyaltyLevel(loyalty_points) AS loyalty_level
FROM Customers;