-- Aggregate cost and revenue per category
SELECT 
    p.category,
    SUM(p.cost_price * o.quantity) AS total_cost,
    SUM(o.sale_price * o.quantity) AS total_revenue,
    SUM(o.sale_price * o.quantity) - SUM(p.cost_price * o.quantity) AS profit
FROM 
    orders o
JOIN 
    products p ON o.product_id = p.product_id
GROUP BY 
    p.category;
    
    -- Load results into final reporting table
INSERT INTO profit_report (category, total_cost, total_revenue, profit, report_date)
SELECT 
    p.category,
    SUM(p.cost_price * o.quantity),
    SUM(o.sale_price * o.quantity),
    SUM(o.sale_price * o.quantity) - SUM(p.cost_price * o.quantity),
    CURRENT_DATE
FROM 
    orders o
JOIN 
    products p ON o.product_id = p.product_id
GROUP BY 
    p.category;
    
    -- Filter high-profit categories directly
SELECT 
    category,
    total_cost,
    total_revenue,
    profit
FROM 
    profit_report
WHERE 
    report_date = CURRENT_DATE
HAVING 
    profit > 10000;
    
    