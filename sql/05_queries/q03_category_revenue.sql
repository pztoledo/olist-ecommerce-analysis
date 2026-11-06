-- | 3 | Revenue and rating by category | 2 CTEs, multi-table JOIN, `RANK()` |

-- REVENUE BY CATEGORY
SELECT p.product_category_name, SUM(op.payment_value) AS revenue
FROM order_payment op 
JOIN order_items oi ON oi.order_id = op.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

-- RATING BY CATEGORY
SELECT p.product_category_name, ROUND(AVG(o.review_score),2) AS avarage_review
FROM order_payment op 
	JOIN order_review o ON o.order_id = op.order_id
	JOIN order_items oi ON oi.order_id = op.order_id
	JOIN products p ON p.product_id = oi.product_id 
GROUP BY p.product_category_name
ORDER BY avarage_review DESC;

-- Revenue and rating by category 

WITH revenue AS (
	SELECT p.product_category_name, SUM(op.payment_value) AS revenue
	FROM order_payment op 
		JOIN order_items oi ON oi.order_id = op.order_id
		JOIN products p ON p.product_id = oi.product_id
	GROUP BY p.product_category_name
	ORDER BY revenue DESC
), ranking AS(
	SELECT p.product_category_name, ROUND(AVG(o.review_score),2) AS avarage_review
	FROM order_payment op 
		JOIN order_review o ON o.order_id = op.order_id
		JOIN order_items oi ON oi.order_id = op.order_id
		JOIN products p ON p.product_id = oi.product_id 
	GROUP BY p.product_category_name
	ORDER BY avarage_review DESC
    )
SELECT r.product_category_name, r.revenue, ra.avarage_review, 
	RANK() OVER (ORDER BY r.revenue DESC) AS revenue_rank
FROM revenue r
	JOIN ranking ra ON r.product_category_name = ra.product_category_name
ORDER BY revenue_rank
;