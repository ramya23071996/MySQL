-- Example: Calculate stock left
SELECT 
    p.product_id,
    p.product_name,
    p.initial_stock - COALESCE(s.total_sold, 0) AS stock_left
FROM 
    products p
LEFT JOIN (
    SELECT 
        product_id,
        SUM(quantity) AS total_sold
    FROM 
        sales
    GROUP BY 
        product_id
) s ON p.product_id = s.product_id;

-- Example: Filter for low stock
SELECT 
    product_id,
    product_name,
    stock_left
FROM 
    product_stock_view
WHERE 
    stock_left < 10;
    
    -- Example: Insert stock alerts
INSERT INTO warehouse_alerts (product_id, alert_message, alert_time)
SELECT 
    product_id,
    CONCAT(product_name, ' has low stock: ', stock_left),
    CURRENT_TIMESTAMP
FROM 
    product_stock_view
WHERE 
    stock_left < 10;
    
    