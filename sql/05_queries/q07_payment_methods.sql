-- | 7 | Payment methods and share of value | CTE, `SUM(SUM()) OVER ()` |
SELECT payment_type, SUM(payment_value) AS total
FROM order_payment
GROUP BY payment_type;

--
WITH p_type AS (
	SELECT payment_type, SUM(payment_value) AS total
	FROM order_payment
	GROUP BY payment_type
    )
SELECT payment_type, total,
 ROUND(total/SUM(total) OVER()*100,2) AS 'share of value %'
FROM p_type 
ORDER BY total DESC;
