-- Aggregate sales by employee
SELECT 
    sales_rep_id,
    SUM(order_total) AS total_sales,
    COUNT(*) AS order_count
FROM 
    orders
GROUP BY 
    sales_rep_id;
    
    WITH ranked_reps AS (
    SELECT 
        sales_rep_id,
        SUM(order_total) AS total_sales,
        COUNT(*) AS order_count,
        ROW_NUMBER() OVER (ORDER BY SUM(order_total) DESC) AS rank
    FROM 
        orders
    GROUP BY 
        sales_rep_id
)
SELECT * FROM ranked_reps;

INSERT INTO rep_performance (sales_rep_id, total_sales, order_count, rank, report_date)
SELECT 
    sales_rep_id,
    total_sales,
    order_count,
    rank,
    CURRENT_DATE
FROM 
    ranked_reps;
    
    