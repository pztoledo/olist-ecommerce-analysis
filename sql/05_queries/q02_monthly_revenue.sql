--  Monthly revenue, running total, month-on-month growth

-- monthly total
SELECT MONTH(o.order_purchase_timestamp), SUM(op.payment_value)
FROM orders o
JOIN order_payment op ON o.order_id = op.order_id
GROUP BY MONTH(o.order_purchase_timestamp)
ORDER BY MONTH(o.order_purchase_timestamp);

-- month/year

SELECT date_format(o.order_purchase_timestamp, '%Y-%m') AS yr_month, SUM(op.payment_value) AS revenue
FROM orders o
JOIN order_payment op ON o.order_id = op.order_id
GROUP BY yr_month
ORDER BY yr_month;

-- running revenue
WITH monthly AS (
	SELECT date_format(o.order_purchase_timestamp, '%Y-%m') AS yr_month, SUM(op.payment_value) AS revenue
	FROM orders o
	JOIN order_payment op ON o.order_id = op.order_id
	GROUP BY yr_month
	ORDER BY yr_month
    )
SELECT yr_month, revenue, SUM(revenue) OVER (ORDER BY yr_month) AS running_revenue
FROM monthly
ORDER BY yr_month;

-- month on month growth

WITH monthly AS (
	SELECT date_format(o.order_purchase_timestamp, '%Y-%m') AS yr_month, SUM(op.payment_value) AS revenue
	FROM orders o
	JOIN order_payment op ON o.order_id = op.order_id
	GROUP BY yr_month
	ORDER BY yr_month
    )
SELECT yr_month, revenue, ROUND((revenue - LAG(revenue) OVER (ORDER BY yr_month))/ (LAG(revenue) OVER (ORDER BY yr_month))*100,2) AS mom_growth_pct
FROM monthly
ORDER BY yr_month;