WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COALESCE(SUM(oi.item_list_price_at_sale * oi.quantity), 0) AS total_spent
    FROM customer c
    LEFT JOIN orders o ON c.customer_id = o.customer_id 
        AND o.order_status = 'Approved'
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
customer_ranks AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        total_spent,
        ROW_NUMBER() OVER (ORDER BY total_spent ASC) AS lowest_rank,
        ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS highest_rank
    FROM customer_spending
)
SELECT 
    customer_id,
    first_name,
    last_name,
    total_spent
FROM customer_ranks
WHERE lowest_rank <= 3 OR highest_rank <= 3
ORDER BY total_spent;