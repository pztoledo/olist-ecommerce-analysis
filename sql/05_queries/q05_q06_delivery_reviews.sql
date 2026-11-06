-- | 5 | Late vs on-time delivery reviews | CASE WHEN |

SELECT AVG(r.review_score) AS 'Average review score',  
CASE 
	WHEN o.order_delivered_customer_date IS NULL THEN 'not delivered'
	WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'on time'
	ELSE 'late'
END AS Delivery
FROM order_review r 
	JOIN orders o ON o.order_id = r.order_id
GROUP BY Delivery;


-- | 6 | Review score by delivery-time bucket | CASE WHEN buckets |
SELECT ROUND(AVG(r.review_score),2) AS 'Average review score',  
CASE 
	WHEN datediff(o.order_delivered_customer_date,o.order_purchase_timestamp) <= 7  THEN '0-7 days'
	WHEN datediff(o.order_delivered_customer_date,o.order_purchase_timestamp) <= 14  THEN '8-14 days'
	WHEN datediff(o.order_delivered_customer_date,o.order_purchase_timestamp) <= 25  THEN '15-25 days'
	WHEN datediff(o.order_delivered_customer_date,o.order_purchase_timestamp) <= 50 THEN '25-50 days'
	WHEN datediff(o.order_delivered_customer_date,o.order_purchase_timestamp) <= 100 THEN '50-100 days'
	ELSE '100+ days'
END AS Delivery,
COUNT(r.review_id) AS 'nr reviews'
FROM order_review r 
	JOIN orders o ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY Delivery;

CREATE OR REPLACE VIEW delivery_days AS
WITH delivery AS (
    SELECT r.review_score,
           DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS days
    FROM order_review r
    JOIN orders o ON o.order_id = r.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
)
SELECT CASE
           WHEN days <= 7   THEN '0-7 days'
           WHEN days <= 14  THEN '8-14 days'
           WHEN days <= 25  THEN '15-25 days'
           WHEN days <= 50  THEN '26-50 days'
           WHEN days <= 100 THEN '51-100 days'
           ELSE '100+ days'
       END AS delivery_bucket,
       ROUND(AVG(review_score), 2) AS avg_review_score,
       COUNT(*) AS nr_reviews
FROM delivery
GROUP BY delivery_bucket
ORDER BY MIN(days);