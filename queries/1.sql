SELECT 
    job_industry_category AS industry,
    COUNT(customer_id) AS customer_count
FROM customer
WHERE job_industry_category IS NOT NULL
GROUP BY industry
ORDER BY customer_count DESC;