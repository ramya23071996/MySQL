SELECT 
    o.order_id,
    o.product_id,
    o.order_total,
    r.return_id,
    r.return_reason,
    r.refund_amount,
    r.return_date
FROM 
    orders o
LEFT JOIN 
    returns r ON o.order_id = r.order_id;
    
    SELECT 
    p.category,
    o.product_id,
    COUNT(r.return_id) AS return_count,
    SUM(r.refund_amount) AS total_refund,
    SUM(o.order_total) AS total_revenue,
    ROUND(SUM(r.refund_amount) / NULLIF(SUM(o.order_total), 0), 2) AS refund_ratio
FROM 
    orders o
JOIN 
    products p ON o.product_id = p.product_id
LEFT JOIN 
    returns r ON o.order_id = r.order_id
GROUP BY 
    p.category, o.product_id;
    
    SELECT 
    product_id,
    category,
    return_count,
    total_refund,
    refund_ratio
FROM 
    return_refund_summary
WHERE 
    return_count >= 10 OR refund_ratio > 0.3;
    
    