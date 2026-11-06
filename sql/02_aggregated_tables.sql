CREATE TABLE payment_agg AS
SELECT order_id, SUM(payment_value) AS payment_value
FROM order_payment
GROUP BY order_id;

CREATE TABLE items_agg AS
SELECT order_id, COUNT(product_id) AS total_items
FROM order_items
GROUP BY order_id;

CREATE TABLE review_agg AS
SELECT order_id, ROUND(AVG(review_score), 2) AS review
FROM order_review
GROUP BY order_id;

ALTER TABLE payment_agg ADD PRIMARY KEY (order_id(32));
ALTER TABLE items_agg   ADD PRIMARY KEY (order_id(32));
ALTER TABLE review_agg  ADD PRIMARY KEY (order_id(32));