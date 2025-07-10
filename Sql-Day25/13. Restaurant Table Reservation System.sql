-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS RestaurantDB;
USE RestaurantDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Tables (
    table_id INT PRIMARY KEY AUTO_INCREMENT,
    table_number VARCHAR(10),
    capacity INT,
    status VARCHAR(20) DEFAULT 'Available' -- Available, Reserved
);

CREATE TABLE IF NOT EXISTS Reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    table_id INT,
    customer_name VARCHAR(100),
    reservation_date DATE,
    reservation_time TIME,
    status VARCHAR(20) DEFAULT 'Booked', -- Booked, Cancelled
    FOREIGN KEY (table_id) REFERENCES Tables(table_id)
);

CREATE TABLE IF NOT EXISTS Reservation_Audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT,
    table_id INT,
    action VARCHAR(20),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Create view to show available tables
CREATE OR REPLACE VIEW AvailableTablesView AS
SELECT 
    t.table_id,
    t.table_number,
    t.capacity
FROM Tables t
WHERE t.status = 'Available';

-- Step 4: Create function to check availability
DELIMITER //
CREATE FUNCTION IsTableAvailable(t_id INT, res_date DATE, res_time TIME) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE count_res INT;
    SELECT COUNT(*) INTO count_res
    FROM Reservations
    WHERE table_id = t_id AND reservation_date = res_date AND reservation_time = res_time AND status = 'Booked';
    RETURN count_res = 0;
END;
//
DELIMITER ;

-- Step 5: Create stored procedure to reserve a table
DELIMITER //
CREATE PROCEDURE ReserveTable(
    IN t_id INT,
    IN cust_name VARCHAR(100),
    IN res_date DATE,
    IN res_time TIME
)
BEGIN
    IF IsTableAvailable(t_id, res_date, res_time) THEN
        INSERT INTO Reservations(table_id, customer_name, reservation_date, reservation_time)
        VALUES (t_id, cust_name, res_date, res_time);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Table is not available at the selected time.';
    END IF;
END;
//
DELIMITER ;

-- Step 6: Trigger to update table status after reservation
DELIMITER //
CREATE TRIGGER UpdateTableStatusAfterReservation
AFTER INSERT ON Reservations
FOR EACH ROW
BEGIN
    UPDATE Tables
    SET status = 'Reserved'
    WHERE table_id = NEW.table_id;
END;
//
DELIMITER ;

-- Step 7: Trigger to log cancellations and free table
DELIMITER //
CREATE TRIGGER LogReservationCancellation
AFTER UPDATE ON Reservations
FOR EACH ROW
BEGIN
    IF OLD.status = 'Booked' AND NEW.status = 'Cancelled' THEN
        INSERT INTO Reservation_Audit(reservation_id, table_id, action)
        VALUES (NEW.reservation_id, NEW.table_id, 'Cancelled');

        UPDATE Tables
        SET status = 'Available'
        WHERE table_id = NEW.table_id;
    END IF;
END;
//
DELIMITER ;

-- Step 8: Insert sample tables
INSERT INTO Tables (table_number, capacity) VALUES
('T1', 2), ('T2', 4), ('T3', 4), ('T4', 6), ('T5', 2);

-- Step 9: Insert 50 reservations
-- We'll simulate 50 reservations across 5 tables and multiple time slots
SET @i = 1;
WHILE @i <= 50 DO
  SET @table_id = 1 + MOD(@i, 5);
  SET @cust = CONCAT('Customer_', LPAD(@i, 2, '0'));
  SET @date = CURDATE() + INTERVAL FLOOR(RAND() * 5) DAY;
  SET @time = MAKETIME(18 + FLOOR(RAND() * 4), 0, 0); -- Between 18:00 and 21:00
  CALL ReserveTable(@table_id, @cust, @date, @time);
  SET @i = @i + 1;
END WHILE;