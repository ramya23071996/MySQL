-- Add fiscal year and month labels
SELECT 
    invoice_id,
    revenue,
    CASE 
        WHEN MONTH(invoice_date) >= 4 THEN CONCAT(YEAR(invoice_date), '-', YEAR(invoice_date) + 1)
        ELSE CONCAT(YEAR(invoice_date) - 1, '-', YEAR(invoice_date))
    END AS fiscal_year,
    MONTH(invoice_date) AS fiscal_month
FROM 
    invoices;
    
    -- Aggregate revenue by fiscal window
SELECT 
    fiscal_year,
    fiscal_month,
    SUM(revenue) AS total_revenue
FROM 
    fiscal_revenue_view
GROUP BY 
    fiscal_year, fiscal_month
ORDER BY 
    fiscal_year, fiscal_month;
    
    -- Trend detection using window functions
SELECT 
    fiscal_year,
    fiscal_month,
    total_revenue,
    total_revenue - LAG(total_revenue) OVER (PARTITION BY fiscal_year ORDER BY fiscal_month) AS revenue_change
FROM 
    monthly_revenue_summary;
    
    