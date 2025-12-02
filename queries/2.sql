SELECT
    EXTRACT(YEAR FROM CAST(o.order_date AS DATE)) AS order_year,
    EXTRACT(MONTH FROM CAST(o.order_date AS DATE)) AS order_month,
    c.job_industry_category AS industry,
    CAST(SUM(oi.item_list_price_at_sale * oi.quantity) AS DECIMAL(10,2)) AS total_revenue
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN customer c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Approved'
    AND o.order_date IS NOT NULL
    AND o.order_date != ''
GROUP BY
    EXTRACT(YEAR FROM CAST(o.order_date AS DATE)),
    EXTRACT(MONTH FROM CAST(o.order_date AS DATE)),
    c.job_industry_category
ORDER BY order_year, order_month, industry;