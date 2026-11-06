-- | 10 | Top 10 sellers | 4-table JOIN, LIMIT |

SELECT s.seller_id, SUM(op.payment_value) AS revenue
FROM sellers s
	JOIN order_items oi ON oi.seller_id = s.seller_id
    JOIN order_payment op ON op.order_id=oi.order_id
GROUP BY s.seller_id
ORDER BY SUM(op.payment_value) DESC
LIMIT 10;