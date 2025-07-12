-- Latest purchase per customer
SELECT 
    customer_id,
    MAX(purchase_date) AS last_purchase
FROM 
    sales
GROUP BY 
    customer_id;
    
    -- Customers inactive for 90+ days
SELECT 
    c.customer_id,
    c.last_purchase,
    DATEDIFF(CURRENT_DATE, c.last_purchase) AS days_inactive
FROM (
    SELECT 
        customer_id,
        MAX(purchase_date) AS last_purchase
    FROM 
        sales
    GROUP BY 
        customer_id
) c
WHERE 
    DATEDIFF(CURRENT_DATE, c.last_purchase) >= 90;
    
    -- Insert into churn_candidates
INSERT INTO churn_candidates (customer_id, last_purchase, days_inactive, insert_time)
SELECT 
    customer_id,
    last_purchase,
    DATEDIFF(CURRENT_DATE, last_purchase),
    CURRENT_TIMESTAMP
FROM (
    SELECT 
        customer_id,
        MAX(purchase_date) AS last_purchase
    FROM 
        sales
    GROUP BY 
        customer_id
) c
WHERE 
    DATEDIFF(CURRENT_DATE, c.last_purchase) >= 90;
    
    