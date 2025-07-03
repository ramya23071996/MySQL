
-- 1. Create Tables

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    purchase_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 2. Insert Sample Data

-- Suppliers
INSERT INTO suppliers (supplier_id, supplier_name) VALUES
(1, 'Global Traders'),
(2, 'Fresh Supplies'),
(3, 'TechSource');

-- Products
INSERT INTO products (product_id, product_name, supplier_id) VALUES
(101, 'LED TV', 3),
(102, 'Washing Machine', 3),
(103, 'Organic Apples', 2),
(104, 'Bananas', 2),
(105, 'Notebook', 1),
(106, 'Pen', 1),
(107, 'Stapler', 1);

-- Purchases
INSERT INTO purchases (purchase_id, product_id, quantity, purchase_date) VALUES
(1001, 101, 10, '2025-07-01'),
(1002, 102, 5, '2025-07-02'),
(1003, 103, 50, '2025-07-03'),
(1004, 105, 100, '2025-07-04'),
(1005, 106, 200, '2025-07-05');

-- 3. Total Stock Purchased per Supplier
SELECT 
    s.supplier_name,
    SUM(pu.quantity) AS total_stock_purchased
FROM purchases pu
JOIN products pr ON pu.product_id = pr.product_id
JOIN suppliers s ON pr.supplier_id = s.supplier_id
GROUP BY s.supplier_name;

-- 4. Products Never Purchased
SELECT 
    pr.product_name
FROM products pr
LEFT JOIN purchases pu ON pr.product_id = pu.product_id
WHERE pu.purchase_id IS NULL;

-- 5. Supplier with the Largest Product Portfolio
SELECT 
    s.supplier_name,
    COUNT(pr.product_id) AS product_count
FROM suppliers s
JOIN products pr ON s.supplier_id = pr.supplier_id
GROUP BY s.supplier_name
ORDER BY product_count DESC
LIMIT 1;