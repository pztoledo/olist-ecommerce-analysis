-- | Revenue, delivery time and late % by state | GROUP BY, AVG |

SELECT c.customer_state AS state, ROUND(AVG(datediff(o.order_estimated_delivery_date, o.order_purchase_timestamp)),2) AS 'Average delivery time',
ROUND(AVG(o.order_delivered_customer_date > o.order_estimated_delivery_date) * 100,2) AS '% late' 
FROM customers c 
	JOIN orders o ON o.customer_id = c.customer_id
GROUP BY state
ORDER BY 'Average delivery time';