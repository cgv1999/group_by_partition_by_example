WITH order_differences AS (
    SELECT
        o.customer_id,
        c.first_name,
        c.last_name,
        c.job_title,
        o.order_date,
        LEAD(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS next_date,
        (LEAD(o.order_date::DATE) OVER (PARTITION BY o.customer_id ORDER BY o.order_date::DATE) - o.order_date::DATE) AS day_gap
    FROM orders o
    JOIN customer c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'Approved'
)
SELECT
    customer_id,
    first_name,
    last_name,
    job_title,
    MAX(day_gap) AS max_days_between_orders
FROM order_differences
WHERE day_gap IS NOT NULL
GROUP BY customer_id, first_name, last_name, job_title
HAVING COUNT(*) > 0
ORDER BY max_days_between_orders DESC;