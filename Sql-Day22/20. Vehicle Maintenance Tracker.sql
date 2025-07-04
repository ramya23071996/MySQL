-- 1. Create the database
CREATE DATABASE IF NOT EXISTS transportation_dashboard;
USE transportation_dashboard;

-- 2. Create vehicle table
CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY,
    vehicle_type VARCHAR(50),
    model VARCHAR(100),
    last_service_date DATE,
    next_service_date DATE
);

-- 3. Create maintenance records table
CREATE TABLE maintenance (
    maintenance_id INT PRIMARY KEY,
    vehicle_id INT,
    service_date DATE,
    service_cost DECIMAL(10,2),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- 4. Insert sample vehicles
INSERT INTO vehicles VALUES
(1, 'Truck', 'Volvo FH', '2024-05-01', '2024-08-01'),
(2, 'Bus', 'Mercedes Sprinter', '2024-06-15', '2024-07-20'),
(3, 'Van', 'Ford Transit', '2024-04-10', '2024-07-10'),
(4, 'Truck', 'Tata LPT', '2024-03-05', '2024-07-05'),
(5, 'Bus', 'Ashok Leyland', '2024-05-20', '2024-09-01');

-- 5. Insert sample maintenance records
INSERT INTO maintenance VALUES
(101, 1, '2024-05-01', 15000),
(102, 2, '2024-06-15', 8000),
(103, 3, '2024-04-10', 5000),
(104, 4, '2024-03-05', 18000),
(105, 5, '2024-05-20', 7000);

-- 6. A. Vehicles due for service in the next 30 days
SELECT *
FROM vehicles
WHERE next_service_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-- 7. B. Vehicles with the highest service cost (subquery)
SELECT 
    v.vehicle_id,
    v.model,
    m.service_cost
FROM vehicles v
JOIN maintenance m ON v.vehicle_id = m.vehicle_id
WHERE m.service_cost = (
    SELECT MAX(service_cost) FROM maintenance
);

-- 8. C. Label urgency using CASE
SELECT 
    vehicle_id,
    model,
    next_service_date,
    CASE 
        WHEN next_service_date <= CURDATE() THEN 'High'
        WHEN next_service_date <= DATE_ADD(CURDATE(), INTERVAL 15 DAY) THEN 'Medium'
        WHEN next_service_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 'Low'
        ELSE 'Scheduled'
    END AS urgency_level
FROM vehicles;

-- 9. D. Total maintenance cost per vehicle type
SELECT 
    v.vehicle_type,
    SUM(m.service_cost) AS total_maintenance_cost
FROM vehicles v
JOIN maintenance m ON v.vehicle_id = m.vehicle_id
GROUP BY v.vehicle_type;