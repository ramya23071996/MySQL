-- Step 1: Create and use the database
CREATE DATABASE IF NOT EXISTS ECommerceDB;
USE ECommerceDB;

-- Step 2: Create tables

CREATE TABLE IF NOT EXISTS Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    discount_percent DECIMAL(5,2),
    stock INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE IF NOT EXISTS ProductLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    old_stock INT,
    new_stock INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Insert sample categories
INSERT INTO Categories (category_name) VALUES
('Electronics'), ('Clothing'), ('Books'), ('Home'), ('Toys');

-- Step 4: Create function to calculate price after discount
DELIMITER //
CREATE FUNCTION GetDiscountedPrice(price DECIMAL(10,2), discount DECIMAL(5,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(price - (price * discount / 100), 2);
END;
//
DELIMITER ;

-- Step 5: Create view to show only available products
CREATE OR REPLACE VIEW AvailableProductsView AS
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    p.discount_percent,
    GetDiscountedPrice(p.price, p.discount_percent) AS final_price,
    p.stock
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE p.stock > 0;

-- Step 6: Create stored procedure to retrieve products by category and price range
DELIMITER //
CREATE PROCEDURE GetProductsByCategoryAndPrice(
    IN cat_name VARCHAR(100),
    IN min_price DECIMAL(10,2),
    IN max_price DECIMAL(10,2)
)
BEGIN
    SELECT 
        p.product_id,
        p.product_name,
        c.category_name,
        p.price,
        p.discount_percent,
        GetDiscountedPrice(p.price, p.discount_percent) AS final_price,
        p.stock
    FROM Products p
    JOIN Categories c ON p.category_id = c.category_id
    WHERE c.category_name = cat_name
      AND GetDiscountedPrice(p.price, p.discount_percent) BETWEEN min_price AND max_price
      AND p.stock > 0;
END;
//
DELIMITER ;

-- Step 7: Create trigger to log product updates
DELIMITER //
CREATE TRIGGER LogProductUpdate
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price OR OLD.stock <> NEW.stock THEN
        INSERT INTO ProductLog(product_id, old_price, new_price, old_stock, new_stock)
        VALUES (NEW.product_id, OLD.price, NEW.price, OLD.stock, NEW.stock);
    END IF;
END;
//
DELIMITER ;

-- Step 8: Insert 50 sample products with varied stock and discounts
INSERT INTO Products (product_name, category_id, price, discount_percent, stock)
SELECT 
    CONCAT('Product_', LPAD(n, 2, '0')),
    CASE 
        WHEN n % 5 = 1 THEN 1
        WHEN n % 5 = 2 THEN 2
        WHEN n % 5 = 3 THEN 3
        WHEN n % 5 = 4 THEN 4
        ELSE 5
    END,
    ROUND(100 + (RAND() * 900), 2),         -- Price between ₹100 and ₹1000
    ROUND(RAND() * 30, 2),                  -- Discount between 0% and 30%
    FLOOR(RAND() * 100)                     -- Stock between 0 and 99
FROM (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
    UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
    UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
    UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL SELECT 25
    UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30
    UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35
    UNION ALL SELECT 36 UNION ALL SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL SELECT 40
    UNION ALL SELECT 41 UNION ALL SELECT 42 UNION ALL SELECT 43 UNION ALL SELECT 44 UNION ALL SELECT 45
    UNION ALL SELECT 46 UNION ALL SELECT 47 UNION ALL SELECT 48 UNION ALL SELECT 49 UNION ALL SELECT 50
) AS numbers;

-- Step 9: Recreate view after discount logic changes (e.g., round to nearest ₹5)
DROP FUNCTION IF EXISTS GetDiscountedPrice;

DELIMITER //
CREATE FUNCTION GetDiscountedPrice(price DECIMAL(10,2), discount DECIMAL(5,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE raw_price DECIMAL(10,2);
    SET raw_price = price - (price * discount / 100);
    RETURN ROUND(raw_price / 5) * 5; -- Round to nearest ₹5
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW AvailableProductsView AS
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    p.discount_percent,
    GetDiscountedPrice(p.price, p.discount_percent) AS final_price,
    p.stock
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE p.stock > 0;