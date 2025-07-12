WITH sales_periods AS (
    SELECT 
        order_id,
        order_total,
        order_date,
        CASE 
            WHEN order_date BETWEEN '2025-07-07' AND '2025-07-09' THEN 'Before'
            WHEN order_date BETWEEN '2025-07-10' AND '2025-07-12' THEN 'During'
            WHEN order_date BETWEEN '2025-07-13' AND '2025-07-15' THEN 'After'
            ELSE 'Outside'
        END AS sale_phase
    FROM 
        orders
    WHERE 
        order_date BETWEEN '2025-07-07' AND '2025-07-15'
)

SELECT 
    sale_phase,
    COUNT(*) AS total_orders,
    SUM(order_total) AS total_revenue,
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM 
    sales_periods
GROUP BY 
    sale_phase;
    
    INSERT INTO flash_sale_summary (sale_phase, total_orders, total_revenue, avg_order_value, report_date)
SELECT 
    sale_phase,
    COUNT(*),
    SUM(order_total),
    ROUND(AVG(order_total), 2),
    CURRENT_DATE
FROM 
    sales_periods
GROUP BY 
    sale_phase;
    
    