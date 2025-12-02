WITH customer_order_stats AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        o.order_id,
        SUM(oi.item_list_price_at_sale * oi.quantity) AS order_value
    FROM customer c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
        AND o.order_status = 'Approved'
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name, o.order_id
),
customer_summary AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        COALESCE(SUM(order_value), 0) AS total_revenue,
        COALESCE(MAX(order_value), 0) AS max_order_amount,
        COALESCE(MIN(order_value), 0) AS min_order_amount,
        COUNT(order_id) AS order_count,
        COALESCE(AVG(order_value), 0) AS avg_order_value
    FROM customer_order_stats
    GROUP BY customer_id, first_name, last_name
)
SELECT *
FROM customer_summary
ORDER BY total_revenue DESC, order_count DESC;