SELECT 
    payment_method,
    COUNT(*) AS total_orders,
    SUM(order_total) AS total_sales
FROM 
    orders
GROUP BY 
    payment_method;
    
		SELECT 
    payment_method,
    COUNT(*) AS total_orders,
    SUM(order_total) AS total_sales,
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM 
    orders
GROUP BY 
    payment_method;
    
    INSERT INTO payment_effectiveness_report (payment_method, total_orders, total_sales, avg_order_value, report_date)
SELECT 
    payment_method,
    COUNT(*),
    SUM(order_total),
    ROUND(AVG(order_total), 2),
    CURRENT_DATE
FROM 
    orders
GROUP BY 
    payment_method;