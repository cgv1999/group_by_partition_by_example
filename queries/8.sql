WITH customer_spending_by_segment AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.wealth_segment,
        COALESCE(SUM(oi.item_list_price_at_sale * oi.quantity), 0) AS total_spent
    FROM customer c
    LEFT JOIN orders o ON c.customer_id = o.customer_id 
        AND o.order_status = 'Approved'
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.wealth_segment
),
ranked_spenders AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        wealth_segment,
        total_spent,
        ROW_NUMBER() OVER (
            PARTITION BY wealth_segment 
            ORDER BY total_spent DESC, last_name, first_name
        ) AS rank_in_segment
    FROM customer_spending_by_segment
)
SELECT
    first_name,
    last_name,
    wealth_segment,
    total_spent
FROM ranked_spenders
WHERE rank_in_segment <= 5
ORDER BY wealth_segment, total_spent DESC, last_name, first_name;