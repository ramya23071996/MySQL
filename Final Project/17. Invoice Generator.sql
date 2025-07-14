-- 1. Create Database
CREATE DATABASE invoice_system;
USE invoice_system;

-- 2. Clients Table
CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- 3. Invoices Table
CREATE TABLE invoices (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    date DATE,
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

-- 4. Invoice Items Table
CREATE TABLE invoice_items (
    invoice_id INT,
    description VARCHAR(255),
    quantity INT,
    rate DECIMAL(10,2),
    PRIMARY KEY (invoice_id, description),
    FOREIGN KEY (invoice_id) REFERENCES invoices(id)
);

-- 5. Insert Sample Clients
INSERT INTO clients (name) VALUES
('TechNova Solutions'),
('GreenByte Labs'),
('UrbanCore Systems'),
('PixelWorks'),
('CodeNest');

-- 6. Insert Sample Invoices
INSERT INTO invoices (client_id, date) VALUES
(1, '2025-07-10'),
(2, '2025-07-11'),
(3, '2025-07-12'),
(1, '2025-07-13'),
(4, '2025-07-14');

-- 7. Insert Sample Invoice Items
INSERT INTO invoice_items (invoice_id, description, quantity, rate) VALUES
(1, 'Backend API Development', 10, 2500.00),
(1, 'Database Optimization', 5, 1800.00),
(2, 'UI/UX Design', 8, 1500.00),
(2, 'Accessibility Audit', 4, 1200.00),
(3, 'SEO Services', 6, 1000.00),
(3, 'Content Strategy', 3, 2200.00),
(4, 'Maintenance Package', 1, 5000.00),
(4, 'Error Monitoring Setup', 2, 1300.00),
(5, 'Cloud Migration', 7, 3000.00),
(5, 'Security Review', 2, 2700.00);

-- 8. Query: Invoice Summary with Subtotal per Line Item and Total per Invoice
SELECT 
    i.id AS invoice_id,
    c.name AS client,
    i.date,
    ii.description,
    ii.quantity,
    ii.rate,
    (ii.quantity * ii.rate) AS line_subtotal
FROM invoices i
JOIN clients c ON i.client_id = c.id
JOIN invoice_items ii ON i.id = ii.invoice_id
ORDER BY i.id;

-- 9. Query: Total Amount per Invoice
SELECT 
    i.id AS invoice_id,
    c.name AS client,
    i.date,
    SUM(ii.quantity * ii.rate) AS invoice_total
FROM invoices i
JOIN clients c ON i.client_id = c.id
JOIN invoice_items ii ON i.id = ii.invoice_id
GROUP BY i.id, c.name, i.date;