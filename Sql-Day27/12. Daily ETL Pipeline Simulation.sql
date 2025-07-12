SELECT 
    order_id,
    customer_name,
    order_total,
    order_date
FROM 
    orders_raw
WHERE 
    order_date = CURRENT_DATE;  -- Adjust to simulate daily pulls
    
    SELECT 
    order_id,
    UPPER(customer_name) AS customer_name_clean,
    ROUND(order_total, 2) AS order_total_clean,
    order_date
FROM 
    orders_raw
WHERE 
    order_date = CURRENT_DATE;
    
    INSERT INTO dw_orders (order_id, customer_name, order_total, order_date)
SELECT 
    order_id,
    UPPER(customer_name),
    ROUND(order_total, 2),
    order_date
FROM 
    orders_raw
WHERE 
    order_date = CURRENT_DATE;
    
    INSERT INTO etl_logs (job_name, status, run_date, row_count)
SELECT 
    'Daily_Order_ETL',
    'SUCCESS',
    CURRENT_DATE,
    COUNT(*)
FROM 
    orders_raw
WHERE 
    order_date = CURRENT_DATE;
    
    