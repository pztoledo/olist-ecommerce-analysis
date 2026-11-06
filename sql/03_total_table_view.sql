    
-- compare Explain table with the non working one, that is why agg tables were created

CREATE OR REPLACE VIEW total_table AS
SELECT o.order_id, o.customer_id, o.order_status,
       p.payment_value, i.total_items, r.review,
       CASE
           WHEN o.order_delivered_customer_date IS NULL THEN 'not delivered'
           WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'on time'
           ELSE 'late'
       END AS delivery,
       DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS delivery_time,
		CASE
			WHEN o.order_delivered_customer_date IS NULL THEN NULL
            WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 0
            ELSE 1
		END AS is_late
FROM orders o
    LEFT JOIN payment_agg p ON o.order_id = p.order_id
    LEFT JOIN items_agg   i ON o.order_id = i.order_id
    LEFT JOIN review_agg  r ON o.order_id = r.order_id;
    
    SELECT * FROM total_table