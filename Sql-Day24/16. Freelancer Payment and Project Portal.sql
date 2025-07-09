-- ============================================
-- 0. CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS FreelancerPortal;
USE FreelancerPortal;

-- ============================================
-- 1. CREATE NORMALIZED TABLES (3NF)
-- ============================================

-- Freelancers table
CREATE TABLE IF NOT EXISTS Freelancers (
    freelancer_id INT PRIMARY KEY,
    freelancer_name VARCHAR(100),
    email VARCHAR(100)
);

-- Clients table
CREATE TABLE IF NOT EXISTS Clients (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(100),
    company VARCHAR(100)
);

-- Projects table
CREATE TABLE IF NOT EXISTS Projects (
    project_id INT PRIMARY KEY,
    client_id INT,
    freelancer_id INT,
    project_title VARCHAR(200),
    project_date DATE,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (freelancer_id) REFERENCES Freelancers(freelancer_id)
);

-- Invoices table
CREATE TABLE IF NOT EXISTS Invoices (
    invoice_id INT PRIMARY KEY,
    project_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(50), -- e.g., 'Paid', 'Pending'
    issue_date DATE,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

-- ============================================
-- 2. INSERT SAMPLE DATA
-- ============================================

-- Freelancers
INSERT INTO Freelancers VALUES
(1, 'Alice', 'alice@freelance.com'),
(2, 'Bob', 'bob@freelance.com');

-- Clients
INSERT INTO Clients VALUES
(1, 'Acme Corp', 'Acme Inc.'),
(2, 'Globex', 'Globex Ltd.');

-- Projects
INSERT INTO Projects VALUES
(101, 1, 1, 'Website Redesign', '2024-07-01'),
(102, 2, 2, 'Mobile App UI', '2024-07-03'),
(103, 1, 1, 'SEO Optimization', '2024-07-05');

-- Invoices
INSERT INTO Invoices VALUES
(1001, 101, 5000.00, 'Paid', '2024-07-02'),
(1002, 102, 3000.00, 'Pending', '2024-07-04'),
(1003, 103, 2000.00, 'Paid', '2024-07-06');

-- ============================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_freelancer_id ON Projects(freelancer_id);
CREATE INDEX idx_payment_status ON Invoices(payment_status);
CREATE INDEX idx_project_date ON Projects(project_date);

-- ============================================
-- 4. DENORMALIZED REPORTING VIEW
-- ============================================

CREATE OR REPLACE VIEW InvoiceReport AS
SELECT 
    i.invoice_id,
    f.freelancer_name,
    c.client_name,
    p.project_title,
    p.project_date,
    i.amount,
    i.payment_status,
    i.issue_date
FROM Invoices i
JOIN Projects p ON i.project_id = p.project_id
JOIN Freelancers f ON p.freelancer_id = f.freelancer_id
JOIN Clients c ON p.client_id = c.client_id;

-- View usage example
SELECT * FROM InvoiceReport WHERE payment_status = 'Pending';

-- ============================================
-- 5. SHOW 10 RECENT INVOICES USING LIMIT
-- ============================================

SELECT * FROM InvoiceReport
ORDER BY issue_date DESC
LIMIT 10;