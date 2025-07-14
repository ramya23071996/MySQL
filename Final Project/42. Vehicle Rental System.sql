-- 1. Create Database
CREATE DATABASE vehicle_rental;
USE vehicle_rental;

-- 2. Vehicles Table
CREATE TABLE vehicles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type ENUM('Car', 'Bike', 'Van', 'Truck') NOT NULL,
    plate_number VARCHAR(20) UNIQUE NOT NULL
);

-- 3. Customers Table
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 4. Rentals Table
CREATE TABLE rentals (
    vehicle_id INT,
    customer_id INT,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (vehicle_id, customer_id, start_date),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- 5. Sample Vehicles
INSERT INTO vehicles (type, plate_number) VALUES
('Car', 'TN01AB1234'),
('Bike', 'TN02XY5678'),
('Van', 'TN03CD9012'),
('Truck', 'TN04EF3456'),
('Car', 'TN05GH7890');

-- 6. Sample Customers
INSERT INTO customers (name) VALUES
('Ramya'), ('Arjun'), ('Sneha'), ('Kiran'), ('Meera');

-- 7. Sample Rentals
INSERT INTO rentals (vehicle_id, customer_id, start_date, end_date) VALUES
(1, 1, '2025-07-20', '2025-07-22'),
(2, 2, '2025-07-20', '2025-07-20'),
(3, 3, '2025-07-21', '2025-07-25'),
(4, 4, '2025-07-22', '2025-07-24'),
(1, 5, '2025-07-25', '2025-07-27');

-- Vehicle Availability on Specific Date
SELECT v.id, v.type, v.plate_number
FROM vehicles v
WHERE v.id NOT IN (
    SELECT vehicle_id FROM rentals
    WHERE '2025-07-22' BETWEEN start_date AND end_date
);

-- Rental Duration & Charges
SELECT 
    c.name AS customer,
    v.plate_number,
    v.type,
    DATEDIFF(r.end_date, r.start_date) + 1 AS rental_days,
    CASE v.type
        WHEN 'Car' THEN (DATEDIFF(r.end_date, r.start_date) + 1) * 500
        WHEN 'Bike' THEN (DATEDIFF(r.end_date, r.start_date) + 1) * 200
        WHEN 'Van' THEN (DATEDIFF(r.end_date, r.start_date) + 1) * 700
        WHEN 'Truck' THEN (DATEDIFF(r.end_date, r.start_date) + 1) * 1000
    END AS estimated_charge
FROM rentals r
JOIN vehicles v ON r.vehicle_id = v.id
JOIN customers c ON r.customer_id = c.id;

-- Upcoming Reservations
SELECT 
    v.plate_number,
    r.start_date,
    r.end_date,
    c.name AS customer
FROM rentals r
JOIN vehicles v ON r.vehicle_id = v.id
JOIN customers c ON r.customer_id = c.id
WHERE r.start_date >= CURDATE()
ORDER BY r.start_date;

