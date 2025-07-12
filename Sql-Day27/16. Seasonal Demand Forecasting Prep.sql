SELECT 
    product_id,
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    SUM(quantity) AS monthly_demand
FROM 
    orders
GROUP BY 
    product_id, DATE_FORMAT(order_date, '%Y-%m');
    
    WITH monthly_trends AS (
    SELECT 
        product_id,
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        SUM(quantity) AS monthly_demand
    FROM 
        orders
    GROUP BY 
        product_id, DATE_FORMAT(order_date, '%Y-%m')
)
SELECT 
    product_id,
    order_month,
    monthly_demand,
    monthly_demand - LAG(monthly_demand) OVER (PARTITION BY product_id ORDER BY order_month) AS demand_change
FROM 
    monthly_trends;
    
    -- Example: Insert into trending_products where demand increased this month
INSERT INTO trending_products (product_id, order_month, monthly_demand, demand_change, insert_date)
SELECT 
    product_id,
    order_month,
    monthly_demand,
    monthly_demand - LAG(monthly_demand) OVER (PARTITION BY product_id ORDER BY order_month),
    CURRENT_DATE
FROM 
    monthly_trends
HAVING 
    demand_change > 0;
    
    