-- 🔁 Drop existing tables if they exist
DROP TABLE IF EXISTS Donations;
DROP TABLE IF EXISTS Donors;

-- 👤 Create Donors table
CREATE TABLE Donors (
    donor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    last_donation_date DATE
);

-- 💸 Create Donations table
CREATE TABLE Donations (
    donation_id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    donation_date DATE DEFAULT CURRENT_DATE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    purpose VARCHAR(100),
    FOREIGN KEY (donor_id) REFERENCES Donors(donor_id)
);

-- 👥 Insert sample donors
INSERT INTO Donors (name, email, phone, last_donation_date) VALUES
('Ritika Sen', 'ritika.sen@example.com', '9876543210', '2025-06-01'),
('Arun Das', 'arun.das@example.com', '9123456789', NULL);

-- 🔄 Record a pledge and donation using a transaction
START TRANSACTION;

-- Step 1: Insert donation record for Ritika
INSERT INTO Donations (donor_id, amount, purpose)
VALUES (1, 5000.00, 'Child Education');

-- Step 2: Update last donation date
UPDATE Donors
SET last_donation_date = CURDATE()
WHERE donor_id = 1;

-- ✅ Commit if all successful
COMMIT;

-- ✏️ Update donation purpose or amount
UPDATE Donations
SET purpose = 'Healthcare Support', amount = 5500.00
WHERE donation_id = 1;

-- ❌ Delete old donors (e.g., no donation in last 2 years)
DELETE FROM Donors
WHERE last_donation_date IS NULL OR last_donation_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);