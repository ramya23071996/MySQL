--  Drop existing tables if they exist
DROP TABLE IF EXISTS SalesItems;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Products;

--  Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

--  Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_date DATE DEFAULT CURRENT_DATE,
    customer_name VARCHAR(100)
);

--  Create SalesItems table
CREATE TABLE SalesItems (
    sale_item_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

--  Insert sample products
INSERT INTO Products (product_name, category, price, stock) VALUES
('LED TV', 'Electronics', 25000.00, 10),
('Bluetooth Speaker', 'Electronics', 3000.00, 25),
('Office Chair', 'Furniture', 7000.00, 15),
('Dining Table', 'Furniture', 15000.00, 5),
('Notebook Pack', 'Stationery', 250.00, 100);

-- Generate a sale invoice using transaction
START TRANSACTION;

-- Step 1: Create a sale
INSERT INTO Sales (sale_date, customer_name) VALUES ('2025-07-15', 'Ravi Kumar');
SET @sale_id = LAST_INSERT_ID();

-- Step 2: Add items to the sale
INSERT INTO SalesItems (sale_id, product_id, quantity) VALUES
(@sale_id, 1, 1),  -- 1 LED TV
(@sale_id, 2, 2);  -- 2 Bluetooth Speakers

-- Step 3: Update stock
UPDATE Products SET stock = stock - 1 WHERE product_id = 1;
UPDATE Products SET stock = stock - 2 WHERE product_id = 2;

--  Commit the invoice
COMMIT;

--  Update stock manually (e.g., restocking)
UPDATE Products SET stock = stock + 10 WHERE product_id = 3;

--  ORDER BY multiple columns: price then category
SELECT * FROM Products
ORDER BY price DESC, category ASC;

--  GROUP BY: Sales by product and category
SELECT 
    p.category,
    p.product_name,
    SUM(si.quantity * p.price) AS total_sales
FROM SalesItems si
JOIN Products p ON si.product_id = p.product_id
GROUP BY p.category, p.product_name;

--  HAVING: Filter categories with total sales > ₹1,00,000
SELECT 
    p.category,
    SUM(si.quantity * p.price) AS category_sales
FROM SalesItems si
JOIN Products p ON si.product_id = p.product_id
GROUP BY p.category
HAVING category_sales > 100000;