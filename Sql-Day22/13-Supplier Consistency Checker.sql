-- 1. Create the database
CREATE DATABASE IF NOT EXISTS supply_chain_dashboard;
USE supply_chain_dashboard;

-- 2. Create supplier delivery tables for Q1 and Q2
CREATE TABLE supplier_q1 (
    supplier_id INT,
    supplier_name VARCHAR(100),
    delivery_time INT  -- in days
);

CREATE TABLE supplier_q2 (
    supplier_id INT,
    supplier_name VARCHAR(100),
    delivery_time INT
);

-- 3. Insert sample data
INSERT INTO supplier_q1 VALUES
(1, 'Alpha Supplies', 5),
(2, 'Beta Traders', 7),
(3, 'Gamma Corp', 6),
(4, 'Delta Logistics', 8);

INSERT INTO supplier_q2 VALUES
(1, 'Alpha Supplies', 4),
(2, 'Beta Traders', 9),
(3, 'Gamma Corp', 5),
(5, 'Epsilon Exports', 6);

-- 4. A. Suppliers present in both Q1 and Q2 (INTERSECT simulation)
SELECT supplier_name
FROM supplier_q1
WHERE supplier_name IN (
    SELECT supplier_name FROM supplier_q2
);

-- 5. B. Suppliers in Q1 but missing in Q2 (EXCEPT simulation)
SELECT supplier_name
FROM supplier_q1
WHERE supplier_name NOT IN (
    SELECT supplier_name FROM supplier_q2
);

-- 6. C & D. Compare average delivery time and tag status
SELECT 
    q1.supplier_name,
    q1.delivery_time AS q1_delivery,
    q2.delivery_time AS q2_delivery,
    CASE 
        WHEN q2.delivery_time < q1.delivery_time THEN 'Improved'
        WHEN q2.delivery_time = q1.delivery_time THEN 'Consistent'
        WHEN q2.delivery_time > q1.delivery_time THEN 'Worsened'
        ELSE 'No Data'
    END AS delivery_status,
    CASE 
        WHEN q2.delivery_time <= (
            SELECT AVG(delivery_time) FROM supplier_q2
        ) THEN 'Reliable'
        ELSE 'Needs Attention'
    END AS supplier_tag
FROM supplier_q1 q1
LEFT JOIN supplier_q2 q2 ON q1.supplier_id = q2.supplier_id;