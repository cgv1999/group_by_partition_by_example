WITH customer_transactions AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id 
            ORDER BY o.order_date ASC
        ) AS purchase_number
    FROM orders o
    WHERE o.order_status = 'Approved'
)
SELECT
    ct.order_id,
    ct.customer_id,
    ct.order_date,
    c.first_name,
    c.last_name
FROM customer_transactions ct
INNER JOIN customer c ON ct.customer_id = c.customer_id
WHERE ct.purchase_number = 2;