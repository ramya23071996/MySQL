-- Summarize revenue by location
SELECT 
    customer_state,
    customer_city,
    SUM(order_total) AS total_revenue
FROM 
    orders
GROUP BY 
    customer_state, customer_city;
    
    -- ETL load into data warehouse
INSERT INTO dw_sales_by_region (region_level, region_name, total_revenue, load_date)
SELECT 
    'city',  -- or 'state' depending on grouping
    customer_city,
    SUM(order_total),
    CURRENT_DATE
FROM 
    orders
GROUP BY 
    customer_city;
    
    -- API-ready output
SELECT 
    region_name AS location,
    total_revenue,
    CASE 
        WHEN total_revenue > 100000 THEN 'High'
        WHEN total_revenue > 50000 THEN 'Medium'
        ELSE 'Low'
    END AS intensity
FROM 
    dw_sales_by_region
WHERE 
    load_date = CURRENT_DATE;
    
    