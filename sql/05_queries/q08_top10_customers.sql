-- | 8 | Top 10 customers by spend | CTE, `DENSE_RANK()` |

SELECT c.customer_unique_id AS Customer, SUM(op.payment_value) AS 'total spent',
DENSE_RANK() OVER (ORDER BY SUM(op.payment_value) DESC) AS spend_rank
FROM customers c
	JOIN orders o ON o.customer_id=c.customer_id
    JOIN order_payment op ON op.order_id=o.order_id
GROUP BY c.customer_unique_id;