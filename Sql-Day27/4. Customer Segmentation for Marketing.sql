CREATE TABLE customer_segments (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  total_spent DECIMAL(12,2),
  segment VARCHAR(20)
);

INSERT INTO customer_segments (customer_id, customer_name, total_spent, segment)
SELECT 
  c.customer_id,
  c.customer_name,
  SUM(o.total_amount) AS total_spent,
  CASE
    WHEN SUM(o.total_amount) > 30000 THEN 'Gold'
    WHEN SUM(o.total_amount) BETWEEN 15000 AND 30000 THEN 'Silver'
    ELSE 'Bronze'
  END AS segment
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT * FROM customer_segments ORDER BY total_spent DESC;
