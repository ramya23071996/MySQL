CREATE TABLE dw_combined_data (
    customer_id INT,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    order_id INT,
    order_date DATE,
    order_total DECIMAL(10,2),
    product_id INT,
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    product_price DECIMAL(10,2),
    load_date DATE
);

-- Load transformed customer data (CSV-parsed)
INSERT INTO dw_combined_data (customer_id, customer_name, customer_email, load_date)
SELECT 
    customer_id,
    UPPER(customer_name),
    customer_email,
    CURRENT_DATE
FROM 
    stage_customers_csv;
    
    -- Load orders with transformation
INSERT INTO dw_combined_data (order_id, order_date, order_total, customer_id, load_date)
SELECT 
    order_id,
    order_date,
    ROUND(order_total, 2),
    customer_id,
    CURRENT_DATE
FROM 
    stage_orders_mysql;
    
    -- Load API-sourced products
INSERT INTO dw_combined_data (product_id, product_name, product_category, product_price, load_date)
SELECT 
    product_id,
    product_name,
    product_category,
    ROUND(price, 2),
    CURRENT_DATE
FROM 
    stage_products_api;
    
    
    INSERT INTO dw_combined_data (
    customer_id, customer_name, customer_email,
    order_id, order_date, order_total,
    product_id, product_name, product_category, product_price,
    load_date
)
SELECT 
    customer_id, UPPER(customer_name), customer_email,
    order_id, order_date, ROUND(order_total, 2),
    product_id, product_name, product_category, ROUND(product_price, 2),
    CURRENT_DATE
FROM 
    stage_etl_combined;
    
    