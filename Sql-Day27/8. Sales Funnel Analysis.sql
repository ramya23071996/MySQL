CREATE TABLE funnel_events (
  event_id INT PRIMARY KEY,
  customer_id INT,
  event_type VARCHAR(20),   -- 'Lead', 'Converted', 'Repeat'
  event_date DATE
);

INSERT INTO funnel_events VALUES
(1, 101, 'Lead', '2025-06-01'),
(2, 102, 'Lead', '2025-06-01'),
(3, 101, 'Converted', '2025-06-10'),
(4, 103, 'Lead', '2025-06-05'),
(5, 101, 'Repeat', '2025-07-01'),
(6, 102, 'Converted', '2025-06-12'),
(7, 104, 'Lead', '2025-06-15'),
(8, 102, 'Repeat', '2025-07-10'),
(9, 105, 'Lead', '2025-06-20'),
(10, 105, 'Converted', '2025-07-01');

WITH
leads AS (
  SELECT DISTINCT customer_id FROM funnel_events WHERE event_type = 'Lead'
),
converted AS (
  SELECT DISTINCT customer_id FROM funnel_events WHERE event_type = 'Converted'
),
repeat_customers AS (
  SELECT DISTINCT customer_id FROM funnel_events WHERE event_type = 'Repeat'
)

SELECT
  (SELECT COUNT(*) FROM leads) AS total_leads,
  (SELECT COUNT(*) FROM converted) AS total_converted,
  (SELECT COUNT(*) FROM repeat_customers) AS total_repeat;
  
  WITH
lead_set AS (
  SELECT customer_id FROM funnel_events WHERE event_type = 'Lead'
),
convert_set AS (
  SELECT customer_id FROM funnel_events WHERE event_type = 'Converted'
),
repeat_set AS (
  SELECT customer_id FROM funnel_events WHERE event_type = 'Repeat'
)

SELECT
  COUNT(DISTINCT lead_set.customer_id) AS leads,
  COUNT(DISTINCT convert_set.customer_id) AS converted,
  COUNT(DISTINCT repeat_set.customer_id) AS repeat,
  ROUND(COUNT(DISTINCT convert_set.customer_id) * 100.0 / COUNT(DISTINCT lead_set.customer_id), 2) AS conversion_rate_pct,
  ROUND(COUNT(DISTINCT repeat_set.customer_id) * 100.0 / COUNT(DISTINCT convert_set.customer_id), 2) AS retention_rate_pct;
  
  