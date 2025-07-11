-- Step 1: Create SupportTickets Table
CREATE TABLE SupportTickets (
    ticket_id INT PRIMARY KEY,
    user_id INT,
    user_name VARCHAR(100),
    support_staff VARCHAR(100),
    ticket_status VARCHAR(20),         -- e.g. Open, Resolved
    ticket_time DATETIME               -- when ticket was created
);

-- Step 2: Insert Sample Ticket Data
INSERT INTO SupportTickets VALUES
(1, 101, 'Ananya', 'Ravi', 'Open', '2025-07-01 09:00'),
(2, 101, 'Ananya', 'Ravi', 'Resolved', '2025-07-01 14:00'),
(3, 102, 'Bharath', 'Meera', 'Open', '2025-07-02 08:30'),
(4, 102, 'Bharath', 'Meera', 'Resolved', '2025-07-03 10:00'),
(5, 103, 'Charu', 'Ravi', 'Open', '2025-07-04 12:15'),
(6, 103, 'Charu', 'Ravi', 'Resolved', '2025-07-06 16:45'),
(7, 104, 'Dev', 'Meera', 'Open', '2025-07-05 11:10'),
(8, 104, 'Dev', 'Meera', 'Resolved', '2025-07-10 13:25');

-- Step 3: Use LEAD() to pair Open → Resolved timestamps
WITH TicketPairs AS (
    SELECT 
        ticket_id,
        user_id,
        user_name,
        support_staff,
        ticket_status,
        ticket_time,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY ticket_time) AS ticket_order,
        LEAD(ticket_time) OVER(PARTITION BY user_id ORDER BY ticket_time) AS resolved_time,
        LEAD(ticket_status) OVER(PARTITION BY user_id ORDER BY ticket_time) AS next_status
    FROM SupportTickets
)

-- Step 4: Filter for true Open→Resolved pairs and calculate resolution time
, ResolutionReport AS (
    SELECT 
        user_id,
        user_name,
        support_staff,
        ticket_time AS opened_at,
        resolved_time AS resolved_at,
        DATEDIFF(MINUTE, ticket_time, resolved_time) AS resolution_minutes
    FROM TicketPairs
    WHERE ticket_status = 'Open' AND next_status = 'Resolved'
)

-- Step 5: Identify Overdue Tickets (e.g., > 240 minutes resolution)
, OverdueTickets AS (
    SELECT * FROM ResolutionReport WHERE resolution_minutes > 240
)

-- Step 6: Final SLA Tracker Report
SELECT 
    support_staff,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolution_minutes > 240 THEN 1 ELSE 0 END) AS overdue_count,
    ROUND(AVG(resolution_minutes), 2) AS avg_resolution_minutes
FROM ResolutionReport
GROUP BY support_staff
ORDER BY avg_resolution_minutes;

-- Optional: Display overdue ticket details
SELECT * FROM OverdueTickets ORDER BY resolved_at;