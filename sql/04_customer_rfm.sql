-- view for SQL with customer, n of buys and total spent

CREATE OR REPLACE VIEW customer_rfm AS
SELECT c.customer_unique_id AS Customer, SUM(p.payment_value) AS total_spent, 
COUNT(o.order_id) AS order_count, MAX(c.customer_state),
CASE 
	WHEN COUNT(o.order_id) = 1 THEN 0
    ELSE 1
END AS is_repeat,
MAX(o.order_purchase_timestamp) AS last_order_day,
MIN(datediff('2018-10-17 17:30:18', o.order_purchase_timestamp)) AS recency
FROM customers c
	LEFT JOIN orders o ON o.customer_id=c.customer_id
    LEFT JOIN payment_agg p ON p.order_id=o.order_id
GROUP BY Customer;
