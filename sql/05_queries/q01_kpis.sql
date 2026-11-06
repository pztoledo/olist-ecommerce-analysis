-- total order:

SELECT COUNT(DISTINCT order_id) FROM orders;

-- total revenue:
SELECT SUM(payment_value) FROM order_payment;

-- Avarege order value
SELECT ROUND(AVG(payment_value),2) FROM order_payment;

-- Unique customers
SELECT COUNT(DISTINCT customer_unique_id) FROM customers;

-- Average review score
SELECT ROUND(AVG(review_score),2) FROM order_review;

-- Average delivery time / % late
SELECT AVG(datediff(order_estimated_delivery_date, order_purchase_timestamp)) AS 'Average delivery time',
ROUND(AVG(order_delivered_customer_date > order_estimated_delivery_date) * 100,2) AS '% late' 
FROM orders;

