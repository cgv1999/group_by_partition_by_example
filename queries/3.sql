WITH it_orders AS (
    SELECT DISTINCT
        oi.order_id,
        p.brand
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN product p ON oi.product_id = p.product_id
    JOIN customer c ON o.customer_id = c.customer_id
    WHERE 
        o.order_status = 'Approved'
        AND o.online_order = 'True'
        AND c.job_industry_category = 'IT'
)
SELECT 
    p.brand,
    COUNT(DISTINCT io.order_id) AS unique_order_count
FROM product p
LEFT JOIN it_orders io ON p.brand = io.brand
GROUP BY p.brand
ORDER BY p.brand;