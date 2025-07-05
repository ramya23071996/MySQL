-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS ClassBookings;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS MembershipPlans;

-- 🏗️ Create MembershipPlans table
CREATE TABLE MembershipPlans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(50) NOT NULL,
    duration_months INT NOT NULL CHECK (duration_months > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0)
);

-- 🏗️ Create Members table
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    plan_id INT,
    membership_start DATE,
    membership_end DATE,
    status VARCHAR(20) DEFAULT 'Inactive',
    FOREIGN KEY (plan_id) REFERENCES MembershipPlans(plan_id)
);

-- 🏗️ Create ClassBookings table
CREATE TABLE ClassBookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    class_name VARCHAR(100) NOT NULL,
    booking_date DATE NOT NULL,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    CHECK (booking_date >= CURDATE())
);

-- 🧾 Insert sample membership plans
INSERT INTO MembershipPlans (plan_name, duration_months, price) VALUES
('Monthly', 1, 1500.00),
('Quarterly', 3, 4000.00),
('Annual', 12, 15000.00);

-- 🔄 Register a new member and book a class using a transaction
START TRANSACTION;

-- Step 1: Insert new member with plan_id = 2 (Quarterly)
INSERT INTO Members (name, email, plan_id, membership_start, membership_end, status)
VALUES (
    'Nisha Verma',
    'nisha.verma@example.com',
    2,
    '2025-07-10',
    DATE_ADD('2025-07-10', INTERVAL 3 MONTH),
    'Active'
);

-- Step 2: Book a class for the new member
INSERT INTO ClassBookings (member_id, class_name, booking_date)
VALUES (LAST_INSERT_ID(), 'Zumba', '2025-07-12');

-- ✅ Commit if all successful
COMMIT;

-- ✏️ Update membership status manually (e.g., expired)
UPDATE Members
SET status = 'Expired'
WHERE membership_end < CURDATE();

-- ❌ Delete expired memberships
DELETE FROM Members
WHERE status = 'Expired';